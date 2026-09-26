import 'dart:math' as math;
import 'dart:ui';

import '../../models/geo.dart';

/// Projects lat/lng into canvas space for the mock map.
///
/// The prototype uses a plain equirectangular fit with a cos(lat) correction on
/// longitude, which is accurate enough over a single city and keeps the map free
/// of any SDK dependency.
class MapProjection {
  MapProjection({required this.bounds, required this.size, this.padding = 0}) {
    final latSpan = math.max(bounds.latSpan, 1e-6);
    final lngSpan = math.max(bounds.lngSpan, 1e-6);
    // Longitude degrees are shorter than latitude degrees away from the
    // equator; without this the city looks stretched east-west.
    final lngCorrection = math.cos(bounds.center.lat * math.pi / 180);
    final worldW = lngSpan * lngCorrection;
    final worldH = latSpan;

    final availW = math.max(size.width - padding * 2, 1.0);
    final availH = math.max(size.height - padding * 2, 1.0);

    // Contain: the whole demo area stays visible at rest.
    _scale = math.min(availW / worldW, availH / worldH);
    _offsetX = padding + (availW - worldW * _scale) / 2;
    _offsetY = padding + (availH - worldH * _scale) / 2;
    _lngCorrection = lngCorrection;
  }

  final GeoBounds bounds;
  final Size size;
  final double padding;

  late final double _scale;
  late final double _offsetX;
  late final double _offsetY;
  late final double _lngCorrection;

  /// Pixels per kilometre, for anything that should stay geographic in size.
  double get pixelsPerKm => _scale / 111.0;

  Offset toOffset(GeoPoint p) => Offset(
        _offsetX + (p.lng - bounds.west) * _lngCorrection * _scale,
        _offsetY + (bounds.north - p.lat) * _scale,
      );

  GeoPoint toGeo(Offset o) => GeoPoint(
        bounds.north - (o.dy - _offsetY) / _scale,
        bounds.west + (o.dx - _offsetX) / (_lngCorrection * _scale),
      );

  Path pathFor(List<GeoPoint> points, {bool close = false}) {
    final path = Path();
    if (points.isEmpty) return path;
    final first = toOffset(points.first);
    path.moveTo(first.dx, first.dy);
    for (var i = 1; i < points.length; i++) {
      final o = toOffset(points[i]);
      path.lineTo(o.dx, o.dy);
    }
    if (close) path.close();
    return path;
  }

  /// Smoothed polyline, so roads read as drawn rather than plotted.
  Path smoothPathFor(List<GeoPoint> points) {
    if (points.length < 3) return pathFor(points);
    final pts = points.map(toOffset).toList();
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final current = pts[i];
      final next = pts[i + 1];
      final mid = Offset((current.dx + next.dx) / 2, (current.dy + next.dy) / 2);
      if (i == 0) {
        path.lineTo(mid.dx, mid.dy);
      } else {
        path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
      }
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }
}

/// Bounds that comfortably contain a set of points, with a margin.
GeoBounds boundsFor(List<GeoPoint> points, {double marginFactor = 0.22}) {
  if (points.isEmpty) {
    return const GeoBounds(
      south: 29.3520,
      west: 71.6320,
      north: 29.4320,
      east: 71.7520,
    );
  }
  var south = points.first.lat;
  var north = points.first.lat;
  var west = points.first.lng;
  var east = points.first.lng;
  for (final p in points) {
    south = math.min(south, p.lat);
    north = math.max(north, p.lat);
    west = math.min(west, p.lng);
    east = math.max(east, p.lng);
  }
  // Keep a minimum span so a short trip does not zoom to the rooftops.
  const minSpan = 0.014;
  if (north - south < minSpan) {
    final c = (north + south) / 2;
    south = c - minSpan / 2;
    north = c + minSpan / 2;
  }
  if (east - west < minSpan) {
    final c = (east + west) / 2;
    west = c - minSpan / 2;
    east = c + minSpan / 2;
  }
  final latMargin = (north - south) * marginFactor;
  final lngMargin = (east - west) * marginFactor;
  return GeoBounds(
    south: south - latMargin,
    west: west - lngMargin,
    north: north + latMargin,
    east: east + lngMargin,
  );
}
