import 'geo.dart';
import 'taxonomy.dart';

enum RoadClass { arterial, collector, local, lane }

/// A stretch of road that reports attach to and that routes are built from.
class RoadSegment {
  const RoadSegment({
    required this.id,
    required this.name,
    required this.path,
    required this.lengthKm,
    required this.roadClass,
    required this.baseLightingScore,
    required this.activityScore,
    required this.baseConditionScore,
    this.area = '',
  });

  final String id;
  final String name;
  final List<GeoPoint> path;
  final double lengthKm;
  final RoadClass roadClass;

  /// 0 = pitch dark, 1 = well lit. Static baseline before community reports.
  final double baseLightingScore;

  /// 0 = isolated, 1 = busy with people and shops.
  final double activityScore;

  /// 0 = badly broken surface, 1 = smooth.
  final double baseConditionScore;
  final String area;

  GeoPoint get midpoint {
    if (path.isEmpty) return const GeoPoint(29.3956, 71.6836);
    return path[path.length ~/ 2];
  }

  /// Minutes to traverse at a typical city speed for this road class.
  double get baseMinutes {
    final kmh = switch (roadClass) {
      RoadClass.arterial => 38.0,
      RoadClass.collector => 28.0,
      RoadClass.local => 20.0,
      RoadClass.lane => 14.0,
    };
    return lengthKm / kmh * 60;
  }
}

/// The result of scoring one segment against the current report set.
/// Every term is kept so the UI can *explain* the number instead of asserting it.
class SegmentAwareness {
  const SegmentAwareness({
    required this.segment,
    required this.cautionScore,
    required this.lightingScore,
    required this.damageScore,
    required this.blockageScore,
    required this.uncertaintyScore,
    required this.score,
    required this.reportCount,
    required this.hasHardBlock,
    required this.extraMinutes,
  });

  final RoadSegment segment;
  final double cautionScore; // C_s
  final double lightingScore; // L_s
  final double damageScore; // D_s
  final double blockageScore; // B_s
  final double uncertaintyScore; // U_s
  final double score; // R_s
  final int reportCount;

  /// A closure or blockage that routing should treat as near-impassable.
  final bool hasHardBlock;

  /// Delay the reports imply, in minutes.
  final double extraMinutes;

  AwarenessLevel get level =>
      AwarenessLevel.fromScore(score, hasData: reportCount > 0 || score > 0.05);

  /// The weighted contributions, for the explainability breakdown UI.
  List<({String label, double weight, double raw, double contribution})>
      get breakdown => [
            (
              label: 'Recent caution reports',
              weight: 0.35,
              raw: cautionScore,
              contribution: 0.35 * cautionScore
            ),
            (
              label: 'Lighting',
              weight: 0.25,
              raw: lightingScore,
              contribution: 0.25 * lightingScore
            ),
            (
              label: 'Road & water condition',
              weight: 0.20,
              raw: damageScore,
              contribution: 0.20 * damageScore
            ),
            (
              label: 'Blockage & traffic',
              weight: 0.10,
              raw: blockageScore,
              contribution: 0.10 * blockageScore
            ),
            (
              label: 'Uncertainty',
              weight: 0.10,
              raw: uncertaintyScore,
              contribution: 0.10 * uncertaintyScore
            ),
          ];
}
