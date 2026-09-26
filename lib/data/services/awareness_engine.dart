import 'dart:math' as math;

import '../../models/road_segment.dart';
import '../../models/route_option.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';
import '../mock/bahawalpur_geo.dart';

/// Deterministic, explainable route-awareness engine.
///
/// This is real logic, not a mock: the same Dart runs unchanged once reports
/// come from a live backend. No AI is involved in scoring — the blueprint is
/// explicit that Gemini classifies text and nothing more.
///
/// Segment score:  R_s = 0.35·C_s + 0.25·L_s + 0.20·D_s + 0.10·B_s + 0.10·U_s
/// Route score:    length-weighted mean of segment scores.
abstract final class AwarenessEngine {
  static const double wCaution = 0.35;
  static const double wLighting = 0.25;
  static const double wDamage = 0.20;
  static const double wBlockage = 0.10;
  static const double wUncertainty = 0.10;

  /// Evening travel is the product's core moment, so a dark segment counts for
  /// more after sunset. Daytime lighting reports still matter, just less.
  static double lightingTimeFactor(DateTime now) {
    final h = now.hour;
    if (h >= 20 || h < 5) return 1.0; // night
    if (h >= 18 || h < 7) return 0.75; // dusk / dawn
    return 0.35; // daylight
  }

  static SegmentAwareness scoreSegment(
    RoadSegment segment,
    List<SafetyReport> allReports, {
    DateTime? now,
  }) {
    final at = now ?? DateTime.now();
    final reports = allReports
        .where((r) => r.roadSegmentId == segment.id && r.isLive)
        .toList();

    // C_s — recent safety / caution reports.
    var caution = 0.0;
    // L_s — lighting: starts from the static baseline, worsened by reports.
    var lightingFromReports = 0.0;
    // D_s — damage, seepage, flooding, surface condition.
    var damage = 0.0;
    // B_s — blockage and traffic hazards.
    var blockage = 0.0;

    var hardBlock = false;
    var extraMinutes = 0.0;

    for (final r in reports) {
      final w = r.effectiveWeight;
      switch (r.category) {
        case ReportCategory.safetyConcern:
          caution += w;
        case ReportCategory.lightingProblem:
          lightingFromReports += w;
        case ReportCategory.roadCondition:
        case ReportCategory.waterOrDrainage:
          damage += w;
        case ReportCategory.blockageOrClosure:
        case ReportCategory.trafficHazard:
          blockage += w;
        case ReportCategory.other:
        case ReportCategory.invalid:
          break;
      }

      if (r.specificType == SpecificType.roadBlockage ||
          r.specificType == SpecificType.roadClosed) {
        hardBlock = true;
      }
      extraMinutes += _delayMinutes(r);
    }

    // Static baselines contribute even with zero reports: a lane that is dark
    // and isolated by design should not read as "all clear" just because
    // nobody reported it tonight.
    final baseLighting = (1.0 - segment.baseLightingScore) *
        lightingTimeFactor(at) *
        0.55;
    final baseIsolation = (1.0 - segment.activityScore) * 0.22;
    final baseCondition = (1.0 - segment.baseConditionScore) * 0.40;

    final cautionScore = _saturate(caution * 0.8 + baseIsolation);
    final lightingScore = _saturate(
      baseLighting + lightingFromReports * lightingTimeFactor(at) * 0.9,
    );
    final damageScore = _saturate(baseCondition + damage * 0.75);
    final blockageScore = _saturate(blockage * 0.85);

    // U_s — uncertainty. High when we have little or low-confidence data.
    final uncertainty = _uncertainty(reports);

    final score = (wCaution * cautionScore +
            wLighting * lightingScore +
            wDamage * damageScore +
            wBlockage * blockageScore +
            wUncertainty * uncertainty)
        .clamp(0.0, 1.0);

    return SegmentAwareness(
      segment: segment,
      cautionScore: cautionScore,
      lightingScore: lightingScore,
      damageScore: damageScore,
      blockageScore: blockageScore,
      uncertaintyScore: uncertainty,
      score: score,
      reportCount: reports.length,
      hasHardBlock: hardBlock,
      extraMinutes: extraMinutes,
    );
  }

  /// Length-weighted route score, per the blueprint's route formula.
  static double scoreRoute(List<SegmentAwareness> parts) {
    if (parts.isEmpty) return 0;
    var weighted = 0.0;
    var total = 0.0;
    for (final p in parts) {
      weighted += p.score * p.segment.lengthKm;
      total += p.segment.lengthKm;
    }
    return total == 0 ? 0 : weighted / total;
  }

  /// Build a scored [RouteOption] from a sequence of segment ids.
  static RouteOption buildRoute({
    required String id,
    required RouteFlavour flavour,
    required List<String> segmentIds,
    required List<SafetyReport> allReports,
    DateTime? now,
  }) {
    final at = now ?? DateTime.now();
    final segments = segmentIds.map(BwpGeo.segment).toList();
    final awareness = [
      for (final s in segments) scoreSegment(s, allReports, now: at),
    ];

    final distanceKm = segments.fold<double>(0, (a, s) => a + s.lengthKm);
    final baseMinutes = segments.fold<double>(0, (a, s) => a + s.baseMinutes);
    final extra = awareness.fold<double>(0, (a, p) => a + p.extraMinutes);
    final routeScore = scoreRoute(awareness);

    final reports = allReports
        .where((r) => r.isLive && segmentIds.contains(r.roadSegmentId))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final avoidsBlockage = !awareness.any((p) => p.hasHardBlock);

    return RouteOption(
      id: id,
      flavour: flavour,
      segments: segments,
      awareness: awareness,
      distanceKm: distanceKm,
      baseMinutes: baseMinutes,
      totalMinutes: baseMinutes + extra,
      routeScore: routeScore,
      reports: reports,
      explanation: '',
      highlights: const [],
      avoidsBlockage: avoidsBlockage,
    );
  }

  /// Extra travel time a report implies. Kept modest and deterministic.
  static double _delayMinutes(SafetyReport r) {
    final decay = r.effectiveWeight / math.max(r.specificType.riskWeight, 0.01);
    final base = switch (r.specificType) {
      SpecificType.roadBlockage => 9.0,
      SpecificType.roadClosed => 11.0,
      SpecificType.accident => 8.0,
      SpecificType.flooding => 7.0,
      SpecificType.heavyTraffic => 6.0,
      SpecificType.construction => 4.0,
      SpecificType.standingWater => 3.0,
      SpecificType.seepage => 2.5,
      SpecificType.roadDamage => 2.0,
      SpecificType.vehicleBreakdown => 2.0,
      SpecificType.debris => 1.5,
      SpecificType.pothole => 1.0,
      _ => 0.0,
    };
    return base * decay.clamp(0.0, 1.2);
  }

  static double _uncertainty(List<SafetyReport> reports) {
    if (reports.isEmpty) return 0.85; // no data is itself a caveat
    final avgConfidence =
        reports.map((r) => r.confidence).reduce((a, b) => a + b) /
            reports.length;
    final corroborated =
        reports.where((r) => r.status == ReportStatus.corroborated).length;
    final disputed =
        reports.where((r) => r.status == ReportStatus.disputed).length;
    var u = 1.0 - avgConfidence;
    u -= corroborated * 0.12;
    u += disputed * 0.18;
    // A single report is thinner evidence than several agreeing ones.
    if (reports.length == 1) u += 0.10;
    return u.clamp(0.0, 1.0);
  }

  /// Soft saturation so three reports do not simply triple the score.
  static double _saturate(double x) => (1 - math.exp(-1.6 * x)).clamp(0.0, 1.0);
}
