import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../models/geo.dart';
import '../../models/road_segment.dart';
import 'map_projection.dart';

/// A route line to draw over the base map.
class MapRouteLine {
  const MapRouteLine({
    required this.points,
    required this.color,
    required this.selected,
    this.dashed = false,
  });

  final List<GeoPoint> points;
  final Color color;
  final bool selected;

  /// Used for the "avoided" variant so a rejected option still reads as a road.
  final bool dashed;
}

/// A segment to tint because its awareness score is elevated.
class MapSegmentTint {
  const MapSegmentTint({
    required this.segmentId,
    required this.color,
    this.strong = false,
  });

  final String segmentId;
  final Color color;
  final bool strong;
}

/// Paints the base city: blocks, green areas, the canal, and the road network.
///
/// The blueprint explicitly allows a designed map instead of a live Maps SDK, and
/// prefers it to a broken API integration. Everything here is drawn from the
/// seeded geography in [BwpGeo].
class BaseMapPainter extends CustomPainter {
  BaseMapPainter({
    required this.bounds,
    required this.tokens,
    required this.showLabels,
    required this.tints,
    this.detail = 1.0,
  });

  final GeoBounds bounds;
  final SafarTokens tokens;
  final bool showLabels;
  final List<MapSegmentTint> tints;

  /// 0..1 — how much incidental detail to draw. Small map previews use less.
  final double detail;

  /// City blocks are generated once from a fixed seed, so the map looks the
  /// same every time the app runs.
  static final List<_Block> _blocks = _generateBlocks();

  @override
  void paint(Canvas canvas, Size size) {
    final proj = MapProjection(bounds: bounds, size: size);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = tokens.mapLand,
    );

    _paintBlocks(canvas, size, proj);
    _paintGreen(canvas, proj);
    _paintCanal(canvas, proj);
    _paintRoads(canvas, proj);
    _paintTints(canvas, proj);
    if (showLabels) _paintLabels(canvas, size, proj);
  }

  void _paintBlocks(Canvas canvas, Size size, MapProjection proj) {
    if (detail < 0.4) return;
    final fill = Paint()..color = tokens.mapBlock;
    final view = Offset.zero & size;
    for (final b in _blocks) {
      final tl = proj.toOffset(GeoPoint(b.north, b.west));
      final br = proj.toOffset(GeoPoint(b.south, b.east));
      final rect = Rect.fromPoints(tl, br);
      if (!view.overlaps(rect)) continue;
      if (rect.width < 1.2 || rect.height < 1.2) continue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.5)),
        fill,
      );
    }
  }

  void _paintGreen(Canvas canvas, MapProjection proj) {
    final fill = Paint()..color = tokens.mapGreen;
    for (final area in BwpGeo.greenAreas) {
      canvas.drawPath(proj.pathFor(area.ring, close: true), fill);
    }
  }

  void _paintCanal(Canvas canvas, MapProjection proj) {
    final path = proj.smoothPathFor(BwpGeo.canal);
    canvas.drawPath(
      path,
      Paint()
        ..color = tokens.mapWater
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(4.0, proj.pixelsPerKm * 0.16)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintRoads(Canvas canvas, MapProjection proj) {
    // Casing first for every road, then fills, so junctions merge cleanly
    // instead of showing seams.
    for (final pass in [0, 1]) {
      for (final seg in BwpGeo.segments) {
        final widths = _widthFor(seg.roadClass, proj);
        if (pass == 0 && widths.casing <= 0) continue;
        final isArterial = seg.roadClass == RoadClass.arterial;
        final paint = Paint()
          ..color = pass == 0
              ? tokens.mapRoadCasing
              : (isArterial ? tokens.mapArterial : tokens.mapRoad)
          ..style = PaintingStyle.stroke
          ..strokeWidth = pass == 0 ? widths.casing : widths.fill
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(proj.smoothPathFor(seg.path), paint);
      }
    }
  }

  /// Tints segments that currently carry elevated awareness, so the map itself
  /// communicates where the reports are — not just the pins.
  void _paintTints(Canvas canvas, MapProjection proj) {
    for (final t in tints) {
      final seg = BwpGeo.segmentsById[t.segmentId];
      if (seg == null) continue;
      final w = _widthFor(seg.roadClass, proj);
      canvas.drawPath(
        proj.smoothPathFor(seg.path),
        Paint()
          ..color = t.color.withValues(alpha: t.strong ? 0.55 : 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w.fill + 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  void _paintLabels(Canvas canvas, Size size, MapProjection proj) {
    final view = Offset.zero & size;
    for (final label in BwpGeo.areaLabels) {
      final at = proj.toOffset(label.at);
      if (!view.contains(at)) continue;
      final tp = TextPainter(
        text: TextSpan(
          text: label.label,
          style: TextStyle(
            fontFamily: 'Jakarta',
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: tokens.mapLabel,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
    }
  }

  ({double casing, double fill}) _widthFor(RoadClass c, MapProjection proj) {
    // Widths scale gently with the map's zoom so roads stay legible when the
    // view is tight and do not become ribbons when it is wide.
    final k = (proj.pixelsPerKm / 22).clamp(0.55, 1.9);
    return switch (c) {
      RoadClass.arterial => (casing: 8.5 * k, fill: 6.0 * k),
      RoadClass.collector => (casing: 6.2 * k, fill: 4.0 * k),
      RoadClass.local => (casing: 4.4 * k, fill: 2.6 * k),
      RoadClass.lane => (casing: 3.2 * k, fill: 1.7 * k),
    };
  }

  /// Deterministic city texture. Blocks sit under the road network, which reads
  /// as built-up land between the roads.
  static List<_Block> _generateBlocks() {
    final rng = math.Random(20260926);
    final b = BwpGeo.bounds;
    final out = <_Block>[];
    const cols = 26;
    const rows = 20;
    final cellLat = b.latSpan / rows;
    final cellLng = b.lngSpan / cols;
    final centre = b.center;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final south = b.south + r * cellLat;
        final west = b.west + c * cellLng;
        final cLat = south + cellLat / 2;
        final cLng = west + cellLng / 2;

        // Density falls off away from the city centre, like a real city edge.
        final dist = GeoPoint(cLat, cLng).distanceKmTo(centre);
        final density = (1.25 - dist / 7.0).clamp(0.05, 0.95);
        if (rng.nextDouble() > density) continue;

        // Blocks are inset by a random gutter so the texture is not a grid.
        final insetLat = cellLat * (0.16 + rng.nextDouble() * 0.26);
        final insetLng = cellLng * (0.16 + rng.nextDouble() * 0.26);
        out.add(
          _Block(
            south: south + insetLat,
            north: south + cellLat - insetLat,
            west: west + insetLng,
            east: west + cellLng - insetLng,
          ),
        );
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(BaseMapPainter old) =>
      old.bounds != bounds ||
      old.tokens.isDark != tokens.isDark ||
      old.showLabels != showLabels ||
      old.detail != detail ||
      old.tints.length != tints.length;
}

class _Block {
  const _Block({
    required this.south,
    required this.north,
    required this.west,
    required this.east,
  });
  final double south;
  final double north;
  final double west;
  final double east;
}

/// Paints the route lines above the base map.
class RouteLinePainter extends CustomPainter {
  RouteLinePainter({
    required this.bounds,
    required this.lines,
    required this.tokens,
    this.progress = 1.0,
  });

  final GeoBounds bounds;
  final List<MapRouteLine> lines;
  final SafarTokens tokens;

  /// 0..1 draw-on animation, so a planned route traces itself into view.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final proj = MapProjection(bounds: bounds, size: size);

    // Unselected first so the chosen route always sits on top.
    final ordered = [
      ...lines.where((l) => !l.selected),
      ...lines.where((l) => l.selected),
    ];

    for (final line in ordered) {
      if (line.points.length < 2) continue;
      var path = proj.smoothPathFor(line.points);
      if (line.selected && progress < 1.0) {
        path = _trim(path, progress);
      }
      final width = line.selected ? 7.0 : 4.5;

      if (line.selected) {
        // Soft glow under the active route.
        canvas.drawPath(
          path,
          Paint()
            ..color = line.color.withValues(alpha: 0.22)
            ..style = PaintingStyle.stroke
            ..strokeWidth = width + 8
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
      }

      // White casing keeps the line readable over roads and parks alike.
      canvas.drawPath(
        path,
        Paint()
          ..color = (tokens.isDark ? Colors.black : Colors.white)
              .withValues(alpha: line.selected ? 0.85 : 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width + 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      final paint = Paint()
        ..color = line.color.withValues(alpha: line.selected ? 1.0 : 0.62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (line.dashed) {
        _drawDashed(canvas, path, paint);
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = math.min(d + 9, metric.length);
        canvas.drawPath(metric.extractPath(d, next), paint);
        d = next + 7;
      }
    }
  }

  Path _trim(Path path, double t) {
    final out = Path();
    for (final metric in path.computeMetrics()) {
      out.addPath(
        metric.extractPath(0, metric.length * t.clamp(0.0, 1.0)),
        Offset.zero,
      );
    }
    return out;
  }

  @override
  bool shouldRepaint(RouteLinePainter old) =>
      old.progress != progress ||
      old.bounds != bounds ||
      old.lines.length != lines.length ||
      !_sameSelection(old.lines, lines);

  static bool _sameSelection(List<MapRouteLine> a, List<MapRouteLine> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].selected != b[i].selected || a[i].color != b[i].color) {
        return false;
      }
    }
    return true;
  }
}

/// Draws the pulsing "you are here" dot.
class UserDotPainter extends CustomPainter {
  UserDotPainter({
    required this.bounds,
    required this.at,
    required this.pulse,
    required this.color,
  });

  final GeoBounds bounds;
  final GeoPoint at;
  final double pulse;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final proj = MapProjection(bounds: bounds, size: size);
    final o = proj.toOffset(at);
    canvas.drawCircle(
      o,
      10 + pulse * 16,
      Paint()..color = color.withValues(alpha: 0.18 * (1 - pulse)),
    );
    canvas.drawCircle(o, 9, Paint()..color = Colors.white);
    canvas.drawCircle(o, 6.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(UserDotPainter old) =>
      old.pulse != pulse || old.at != at || old.bounds != bounds;
}

/// Shared helper so overlay widgets and painters agree on positions.
ui.Offset projectPoint(GeoPoint p, GeoBounds bounds, Size size) =>
    MapProjection(bounds: bounds, size: size).toOffset(p);
