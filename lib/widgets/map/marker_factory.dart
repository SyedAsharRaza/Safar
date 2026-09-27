import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';

/// Renders Google Maps marker bitmaps that match the in-app pin design.
///
/// The Maps SDK only accepts images, so each pin is drawn once on a canvas and
/// cached by category. Without this the map would fall back to generic red
/// teardrops and the categories would be unreadable.
abstract final class MarkerFactory {
  static final Map<String, BitmapDescriptor> _cache = {};

  static String _key(SpecificType type, bool selected, bool expired) =>
      '${type.wire}_${selected ? 's' : 'n'}_${expired ? 'e' : 'l'}';

  /// Clears the cache when the device pixel ratio changes between screens.
  static void clear() => _cache.clear();

  static Future<BitmapDescriptor> forReport(
    SafetyReport report, {
    required double pixelRatio,
    bool selected = false,
  }) async {
    final expired = report.isExpired;
    final key = _key(report.specificType, selected, expired);
    final cached = _cache[key];
    if (cached != null) return cached;

    final descriptor = await _draw(
      icon: report.specificType.icon,
      colour: expired ? const Color(0xFF7A8899) : report.category.color,
      pixelRatio: pixelRatio,
      selected: selected,
    );
    _cache[key] = descriptor;
    return descriptor;
  }

  static Future<BitmapDescriptor> endpoint({
    required bool isOrigin,
    required double pixelRatio,
  }) async {
    final key = isOrigin ? 'endpoint_origin' : 'endpoint_destination';
    final cached = _cache[key];
    if (cached != null) return cached;

    final descriptor = await _draw(
      icon: isOrigin ? Icons.my_location : Icons.flag_rounded,
      colour: isOrigin ? const Color(0xFF0E9594) : const Color(0xFF111A28),
      pixelRatio: pixelRatio,
      selected: false,
      diameter: 30,
    );
    _cache[key] = descriptor;
    return descriptor;
  }

  /// Draws a circular pin with a white ring, a drop shadow and the category
  /// glyph, then a small stem so it reads as attached to a point.
  static Future<BitmapDescriptor> _draw({
    required IconData icon,
    required Color colour,
    required double pixelRatio,
    required bool selected,
    double diameter = 34,
  }) async {
    final scale = pixelRatio.clamp(1.0, 3.5);
    final d = (selected ? diameter * 1.18 : diameter) * scale;
    const stemRatio = 0.22;
    final stem = d * stemRatio;
    final pad = 3.0 * scale;
    final width = d + pad * 2;
    final height = d + stem + pad * 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final centre = Offset(width / 2, pad + d / 2);
    final radius = d / 2;

    // Shadow.
    canvas.drawCircle(
      centre.translate(0, 1.5 * scale),
      radius,
      Paint()
        ..color = colour.withValues(alpha: 0.34)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.5 * scale),
    );

    // Stem.
    final stemPath = Path()
      ..moveTo(centre.dx - stem * 0.52, centre.dy + radius * 0.68)
      ..lineTo(centre.dx, centre.dy + radius + stem)
      ..lineTo(centre.dx + stem * 0.52, centre.dy + radius * 0.68)
      ..close();
    canvas.drawPath(stemPath, Paint()..color = colour);

    // Body and ring.
    canvas.drawCircle(centre, radius, Paint()..color = Colors.white);
    canvas.drawCircle(
      centre,
      radius - (selected ? 3.0 : 2.2) * scale,
      Paint()..color = colour,
    );

    // Glyph. Material icons are a font, so the icon is painted as text.
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: radius * 1.05,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, centre - Offset(tp.width / 2, tp.height / 2));

    final image = await recorder.endRecording().toImage(
          width.ceil(),
          height.ceil(),
        );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (bytes == null) {
      return BitmapDescriptor.defaultMarkerWithHue(_hueFor(colour));
    }
    return BitmapDescriptor.bytes(
      bytes.buffer.asUint8List(),
      width: width / scale,
      height: height / scale,
    );
  }

  /// Fallback hue if canvas rasterisation ever fails.
  static double _hueFor(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.hue.clamp(0.0, 360.0);
  }

  /// Anchor so the stem tip sits on the coordinate, not the circle centre.
  static const Offset pinAnchor = Offset(0.5, 0.94);
}

/// Pleasant dark styling for the Google map, tuned to the app's night palette.
const String kDarkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0e1826"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#7e8da1"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#0e1826"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#243447"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f7f94"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#14261d"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#243447"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#16222f"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a97a8"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#34404f"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1c2a3b"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#1a2839"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#122b3d"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d5a70"}]}
]
''';

/// Light styling: quiet POIs so community pins are the loudest thing on screen.
const String kLightMapStyle = '''
[
  {"featureType":"poi.business","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.attraction","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"transit","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#d7e7ce"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#c5ddeb"}]}
]
''';

/// Converts the app's [GeoBounds]-free point list into Maps bounds.
LatLngBounds latLngBoundsFor(List<LatLng> points) {
  var south = points.first.latitude;
  var north = points.first.latitude;
  var west = points.first.longitude;
  var east = points.first.longitude;
  for (final p in points) {
    south = math.min(south, p.latitude);
    north = math.max(north, p.latitude);
    west = math.min(west, p.longitude);
    east = math.max(east, p.longitude);
  }
  // Google rejects degenerate bounds, so keep a floor on the span.
  const minSpan = 0.004;
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
  return LatLngBounds(
    southwest: LatLng(south, west),
    northeast: LatLng(north, east),
  );
}
