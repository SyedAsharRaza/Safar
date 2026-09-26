import 'dart:math' as math;

/// Minimal lat/lng pair. Kept local so the prototype does not depend on a
/// maps SDK; swapping in `google_maps_flutter`'s LatLng later is mechanical.
class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;

  /// Great-circle distance in kilometres.
  double distanceKmTo(GeoPoint other) {
    const earthRadiusKm = 6371.0;
    final dLat = _rad(other.lat - lat);
    final dLng = _rad(other.lng - lng);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat)) *
            math.cos(_rad(other.lat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _rad(double deg) => deg * math.pi / 180.0;

  GeoPoint lerpTo(GeoPoint other, double t) =>
      GeoPoint(lat + (other.lat - lat) * t, lng + (other.lng - lng) * t);

  /// Rounds to ~250 m so sensitive reports are not pinned to a doorstep.
  GeoPoint blurred() => GeoPoint(
        (lat * 400).round() / 400,
        (lng * 400).round() / 400,
      );

  @override
  String toString() => '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';

  @override
  bool operator ==(Object other) =>
      other is GeoPoint && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);
}

/// Rectangular bounds used to project geo coordinates onto the mock map canvas.
class GeoBounds {
  const GeoBounds({
    required this.south,
    required this.west,
    required this.north,
    required this.east,
  });

  final double south;
  final double west;
  final double north;
  final double east;

  double get latSpan => north - south;
  double get lngSpan => east - west;

  GeoPoint get center => GeoPoint((north + south) / 2, (east + west) / 2);

  bool contains(GeoPoint p) =>
      p.lat >= south && p.lat <= north && p.lng >= west && p.lng <= east;

  /// Normalised 0..1 position, origin at top-left (north-west).
  ({double x, double y}) normalise(GeoPoint p) => (
        x: ((p.lng - west) / lngSpan).clamp(-0.5, 1.5),
        y: ((north - p.lat) / latSpan).clamp(-0.5, 1.5),
      );
}
