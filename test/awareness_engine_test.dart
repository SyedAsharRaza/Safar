import 'package:bahawalpur_safar/data/mock/bahawalpur_geo.dart';
import 'package:bahawalpur_safar/data/mock/mock_places.dart';
import 'package:bahawalpur_safar/data/mock/mock_reports.dart';
import 'package:bahawalpur_safar/data/services/awareness_engine.dart';
import 'package:bahawalpur_safar/data/services/route_planner.dart';
import 'package:bahawalpur_safar/models/geo.dart';
import 'package:bahawalpur_safar/models/safety_report.dart';
import 'package:bahawalpur_safar/models/taxonomy.dart';
import 'package:flutter_test/flutter_test.dart';

SafetyReport _report({
  required SpecificType type,
  required String segmentId,
  Duration age = const Duration(minutes: 5),
  Severity severity = Severity.medium,
  ReportStatus status = ReportStatus.unverified,
  int confirmations = 0,
}) {
  final now = DateTime.now();
  return SafetyReport(
    id: 'test_${type.wire}_$segmentId',
    category: type.category,
    specificType: type,
    safePublicText: 'test',
    location: BwpGeo.segment(segmentId).midpoint,
    roadSegmentId: segmentId,
    createdAt: now.subtract(age),
    expiresAt: now.add(const Duration(days: 1)),
    status: status,
    severity: severity,
    confidence: 0.9,
    language: ReportLanguage.romanUrdu,
    confirmationCount: confirmations,
  );
}

void main() {
  group('report weighting', () {
    test('a fresh report outweighs an old one of the same kind', () {
      final fresh = _report(
        type: SpecificType.roadDamage,
        segmentId: 'seg_ghalla_mandi',
        age: const Duration(minutes: 2),
      );
      final old = _report(
        type: SpecificType.roadDamage,
        segmentId: 'seg_ghalla_mandi',
        age: const Duration(days: 4),
      );
      expect(fresh.effectiveWeight, greaterThan(old.effectiveWeight));
    });

    test('corroboration raises weight', () {
      final plain = _report(
        type: SpecificType.seepage,
        segmentId: 'seg_railway_road',
      );
      final confirmed = _report(
        type: SpecificType.seepage,
        segmentId: 'seg_railway_road',
        status: ReportStatus.corroborated,
        confirmations: 3,
      );
      expect(confirmed.effectiveWeight, greaterThan(plain.effectiveWeight));
    });

    test('expired reports are excluded from the live set', () {
      final expired = SafetyReport(
        id: 'expired',
        category: ReportCategory.roadCondition,
        specificType: SpecificType.pothole,
        safePublicText: 'test',
        location: const GeoPoint(29.39, 71.68),
        roadSegmentId: 'seg_trust_colony',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: ReportStatus.expired,
        severity: Severity.low,
        confidence: 0.5,
        language: ReportLanguage.english,
      );
      expect(expired.isLive, isFalse);
    });
  });

  group('segment scoring', () {
    test('a blockage report marks the segment as hard-blocked', () {
      final result = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_shahi_bazaar'),
        [
          _report(
            type: SpecificType.roadBlockage,
            segmentId: 'seg_shahi_bazaar',
            severity: Severity.high,
          ),
        ],
      );
      expect(result.hasHardBlock, isTrue);
      expect(result.extraMinutes, greaterThan(0));
    });

    test('scores stay within 0..1 even with many stacked reports', () {
      final many = [
        for (var i = 0; i < 12; i++)
          _report(
            type: SpecificType.flooding,
            segmentId: 'seg_yazman_road',
            severity: Severity.high,
          ),
      ];
      final result =
          AwarenessEngine.scoreSegment(BwpGeo.segment('seg_yazman_road'), many);
      expect(result.score, inInclusiveRange(0.0, 1.0));
    });

    test('a segment with no reports reports high uncertainty', () {
      final result = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_model_town_road'),
        const [],
      );
      expect(result.reportCount, 0);
      expect(result.uncertaintyScore, greaterThan(0.5));
    });

    test('a dark isolated lane scores worse than a lit busy arterial', () {
      final lane = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_university_service_lane'),
        const [],
        now: DateTime(2026, 9, 27, 22),
      );
      final arterial = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_multan_road'),
        const [],
        now: DateTime(2026, 9, 27, 22),
      );
      expect(lane.score, greaterThan(arterial.score));
    });

    test('lighting matters more after dark than at midday', () {
      final report = _report(
        type: SpecificType.poorLighting,
        segmentId: 'seg_cantt_bazaar_lane',
      );
      final night = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_cantt_bazaar_lane'),
        [report],
        now: DateTime(2026, 9, 27, 22),
      );
      final noon = AwarenessEngine.scoreSegment(
        BwpGeo.segment('seg_cantt_bazaar_lane'),
        [report],
        now: DateTime(2026, 9, 27, 12),
      );
      expect(night.lightingScore, greaterThan(noon.lightingScore));
    });
  });

  group('route planning', () {
    test('plans at least one route between two connected places', () {
      final routes = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_model_town_a'),
        destination: MockPlaces.byId('pl_iub'),
        reports: MockReports.seed(),
      );
      expect(routes, isNotEmpty);
      for (final r in routes) {
        expect(r.segments, isNotEmpty);
        expect(r.explanation, isNotEmpty);
        expect(r.totalMinutes, greaterThan(0));
        expect(r.distanceKm, greaterThan(0));
      }
    });

    test('no route explanation makes a forbidden safety claim', () {
      final routes = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_railway'),
        destination: MockPlaces.byId('pl_cantt'),
        reports: MockReports.seed(),
      );
      for (final r in routes) {
        final text = '${r.explanation} ${r.highlights.join(' ')}'.toLowerCase();
        expect(text.contains('% safe'), isFalse);
        expect(text.contains('guarantee'), isFalse);
        expect(text.contains('crime score'), isFalse);
      }
    });

    test('routes are distinct where the network offers alternatives', () {
      final routes = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_fawara'),
        destination: MockPlaces.byId('pl_iub'),
        reports: MockReports.seed(),
      );
      final signatures =
          routes.map((r) => r.segments.map((s) => s.id).join('>')).toSet();
      expect(signatures.length, routes.length);
    });

    test('at least one option avoids the seeded blockage', () {
      final routes = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_farid_gate'),
        destination: MockPlaces.byId('pl_dring'),
        reports: MockReports.seed(),
      );
      expect(routes.any((r) => r.avoidsBlockage), isTrue);
    });

    test('planning is deterministic', () {
      final reports = MockReports.seed();
      final a = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_bvh'),
        destination: MockPlaces.byId('pl_model_town_c'),
        reports: reports,
      );
      final b = RoutePlanner.plan(
        origin: MockPlaces.byId('pl_bvh'),
        destination: MockPlaces.byId('pl_model_town_c'),
        reports: reports,
      );
      expect(
        a.map((r) => r.segments.map((s) => s.id).join()).toList(),
        b.map((r) => r.segments.map((s) => s.id).join()).toList(),
      );
    });

    test('every seeded place can reach every other seeded place', () {
      // Guards against a dead end in the demo: no destination pair should
      // leave the user with nowhere to go.
      final failures = <String>[];
      for (final origin in MockPlaces.all) {
        for (final destination in MockPlaces.all) {
          if (origin.id == destination.id) continue;
          final routes = RoutePlanner.plan(
            origin: origin,
            destination: destination,
            reports: const [],
          );
          if (routes.isEmpty) {
            failures.add('${origin.name} -> ${destination.name}');
          }
        }
      }
      expect(failures, isEmpty, reason: 'Unreachable pairs: $failures');
    });
  });

  group('awareness bands', () {
    test('no data maps to the limited band, never to low caution', () {
      expect(
        AwarenessLevel.fromScore(0.0, hasData: false),
        AwarenessLevel.limited,
      );
    });

    test('bands increase with score', () {
      expect(AwarenessLevel.fromScore(0.1), AwarenessLevel.low);
      expect(AwarenessLevel.fromScore(0.4), AwarenessLevel.moderate);
      expect(AwarenessLevel.fromScore(0.8), AwarenessLevel.elevated);
    });
  });
}
