import 'geo.dart';
import 'road_segment.dart';
import 'safety_report.dart';
import 'taxonomy.dart';

enum RouteFlavour {
  fastest('Fastest route', 'Sab se tez rasta', 'bolt'),
  betterLit('Better-lit route', 'Zyada roshni wala rasta', 'light'),
  fewerHazards('Fewer hazards', 'Kam rukawatein', 'shield');

  const RouteFlavour(this.label, this.labelRoman, this.iconKey);
  final String label;
  final String labelRoman;
  final String iconKey;
}

/// One candidate route, plus everything needed to explain it.
class RouteOption {
  const RouteOption({
    required this.id,
    required this.flavour,
    required this.segments,
    required this.awareness,
    required this.distanceKm,
    required this.baseMinutes,
    required this.totalMinutes,
    required this.routeScore,
    required this.reports,
    required this.explanation,
    required this.highlights,
    this.isRecommended = false,
    this.avoidsBlockage = false,
  });

  final String id;
  final RouteFlavour flavour;
  final List<RoadSegment> segments;
  final List<SegmentAwareness> awareness;
  final double distanceKm;
  final double baseMinutes;

  /// Base travel time plus delay implied by current reports.
  final double totalMinutes;
  final double routeScore;

  /// Live community signals sitting on this route.
  final List<SafetyReport> reports;

  /// One-sentence plain-language tradeoff, e.g. "Adds 6 minutes but avoids…".
  final String explanation;

  /// Short bullet facts for the route card.
  final List<String> highlights;
  final bool isRecommended;
  final bool avoidsBlockage;

  AwarenessLevel get level => AwarenessLevel.fromScore(
        routeScore,
        hasData: reports.isNotEmpty || routeScore > 0.05,
      );

  ConfidenceBand get confidence {
    if (reports.isEmpty) return ConfidenceBand.low;
    final avg =
        reports.map((r) => r.confidence).reduce((a, b) => a + b) / reports.length;
    final corroborated =
        reports.where((r) => r.status == ReportStatus.corroborated).length;
    return ConfidenceBand.fromValue(
      (avg + (corroborated / reports.length) * 0.15).clamp(0.0, 1.0),
    );
  }

  int get minutes => totalMinutes.round();

  List<GeoPoint> get polyline =>
      [for (final s in segments) ...s.path];

  int get blockageCount => reports
      .where((r) => r.category == ReportCategory.blockageOrClosure)
      .length;

  int get lightingCount =>
      reports.where((r) => r.category == ReportCategory.lightingProblem).length;

  int get waterCount =>
      reports.where((r) => r.category == ReportCategory.waterOrDrainage).length;

  int get safetyCount =>
      reports.where((r) => r.category == ReportCategory.safetyConcern).length;
}
