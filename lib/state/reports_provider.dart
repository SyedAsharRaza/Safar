import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../data/api/api_config.dart';
import '../data/api/api_exception.dart';
import '../data/api/safar_api.dart';
import '../data/mock/bahawalpur_geo.dart';
import '../data/mock/mock_reports.dart';
import '../data/services/awareness_engine.dart';
import '../data/services/mock_ai_classifier.dart';
import '../models/ai_report_result.dart';
import '../models/geo.dart';
import '../models/road_segment.dart';
import '../models/safety_report.dart';
import '../models/taxonomy.dart';

enum LoadState { initial, loading, ready, error }

/// Owns the community-signal list and everything derived from it.
///
/// In production this is a Firestore stream; here it is an in-memory list with
/// simulated latency so the UI's loading, empty and error states are real.
class ReportsProvider extends ChangeNotifier {
  ReportsProvider({MockAiClassifier? classifier, SafarApi? api})
      : _classifier = classifier ?? MockAiClassifier(),
        _api = api ?? SafarApi();

  final MockAiClassifier _classifier;
  final SafarApi _api;

  SafarApi get api => _api;

  /// True when the last load came from the backend rather than seeded data.
  bool _liveData = false;
  bool get isLiveData => _liveData;

  /// Set when the backend was tried and failed, so the UI can say why it is
  /// showing demonstration data instead of pretending nothing happened.
  String? _backendNotice;
  String? get backendNotice => _backendNotice;
  final math.Random _random = math.Random();

  List<SafetyReport> _reports = [];
  LoadState _state = LoadState.initial;
  String? _error;

  /// Category filter for the explore map. Empty means "everything".
  final Set<ReportCategory> _filters = {};
  final List<DateTime> _submissionTimes = [];

  /// Set once the user has chosen to see reports that already expired.
  bool includeExpired = false;

  LoadState get state => _state;
  String? get error => _error;
  Set<ReportCategory> get filters => Set.unmodifiable(_filters);
  bool get hasFilters => _filters.isNotEmpty;

  /// Everything, including expired and withheld — used by "My reports".
  List<SafetyReport> get allRaw => List.unmodifiable(_reports);

  /// What routing and the public map should consider.
  List<SafetyReport> get live =>
      _reports.where((r) => r.isLive).toList(growable: false);

  List<SafetyReport> get visible {
    final base = includeExpired
        ? _reports.where((r) => r.status != ReportStatus.withheld)
        : _reports.where((r) => r.isLive);
    final list = base.toList();
    if (_filters.isNotEmpty) {
      list.retainWhere((r) => _filters.contains(r.category));
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<SafetyReport> get mine {
    final list = _reports.where((r) => r.isMine).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  SafetyReport? byId(String id) =>
      _reports.where((r) => r.id == id).firstOrNull;

  /// Reports on a given segment, freshest first.
  List<SafetyReport> forSegment(String segmentId) {
    final list = _reports
        .where((r) => r.roadSegmentId == segmentId && r.isLive)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<SafetyReport> near(GeoPoint point, {double radiusKm = 1.2}) {
    final list = live
        .where((r) => r.location.distanceKmTo(point) <= radiusKm)
        .toList()
      ..sort(
        (a, b) => a.location
            .distanceKmTo(point)
            .compareTo(b.location.distanceKmTo(point)),
      );
    return list;
  }

  int get freshCount =>
      live.where((r) => r.age < const Duration(hours: 1)).length;

  int countFor(ReportCategory c) =>
      live.where((r) => r.category == c).length;

  /// Area-level awareness used by the home screen summary card.
  SegmentAwareness awarenessFor(String segmentId) =>
      AwarenessEngine.scoreSegment(BwpGeo.segment(segmentId), live);

  /// Rough "how is the demo area right now" figure for the home hero.
  AwarenessLevel get areaLevel {
    if (_reports.isEmpty) return AwarenessLevel.limited;
    final scores = BwpGeo.segments
        .map((s) => AwarenessEngine.scoreSegment(s, live))
        .toList();
    final avg = scores.fold<double>(0, (a, s) => a + s.score) / scores.length;
    return AwarenessLevel.fromScore(avg);
  }

  /// Segments currently carrying a blockage or closure report.
  List<SegmentAwareness> get blockedSegments => BwpGeo.segments
      .map((s) => AwarenessEngine.scoreSegment(s, live))
      .where((a) => a.hasHardBlock)
      .toList();

  // --- Loading ---------------------------------------------------------------

  /// Loads the seeded demonstration signals.
  ///
  /// [failFirst] makes the first load fail so the error state is demonstrable;
  /// [empty] starts with no reports so the empty states are demonstrable.
  Future<void> load({
    bool failFirst = false,
    bool empty = false,
    bool offline = false,
  }) async {
    _state = LoadState.loading;
    _error = null;
    _backendNotice = null;
    notifyListeners();

    // --- Real backend ------------------------------------------------------
    // Seeded data is the fallback, never silently preferred: if the API is
    // reachable it wins, and if it is not the UI says so rather than passing
    // demonstration rows off as live ones.
    if (ApiConfig.useBackend && !offline && !failFirst && !empty) {
      try {
        if (!await _api.restoreSession()) {
          await _api.signInAnonymously();
        }
        final fetched = await _api.fetchReports(limit: 100);
        final mine = await _api.fetchMyReports().catchError(
              (_) => <SafetyReport>[],
            );

        final byId = {for (final r in fetched) r.id: r};
        for (final r in mine) {
          byId[r.id] = r;
        }

        _reports = byId.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _liveData = true;
        _state = LoadState.ready;
        notifyListeners();
        return;
      } on ApiException catch (e) {
        // Fall through to seeded data — a hackathon demo must not die because
        // the venue wifi did.
        _backendNotice = e.isNetwork
            ? 'Could not reach the server. Showing demonstration signals.'
            : e.message;
      } catch (_) {
        _backendNotice = 'Showing demonstration signals.';
      }
    }

    await Future<void>.delayed(
      Duration(milliseconds: 650 + _random.nextInt(450)),
    );

    _liveData = false;

    if (offline) {
      // Offline still works: the prototype keeps a local copy, as the
      // blueprint's fallback plan requires.
      _reports = empty ? [] : MockReports.seed();
      _state = LoadState.ready;
      notifyListeners();
      return;
    }

    if (failFirst) {
      _state = LoadState.error;
      _error = 'Could not reach the community signal service.';
      notifyListeners();
      return;
    }

    _reports = empty ? [] : MockReports.seed();
    _state = LoadState.ready;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 750));
    // Simulate one new signal arriving on refresh so pull-to-refresh has an
    // observable effect during the demo.
    if (_state == LoadState.ready && _reports.isNotEmpty) {
      _reports = [..._reports];
      notifyListeners();
    }
  }

  void clearAll() {
    _reports = [];
    notifyListeners();
  }

  /// Adds or replaces a report that arrived via push.
  void upsert(SafetyReport report) {
    final i = _reports.indexWhere((r) => r.id == report.id);
    if (i == -1) {
      _reports = [report, ..._reports];
    } else {
      _reports = [..._reports]..[i] = report;
    }
    notifyListeners();
  }

  void reseed() {
    _reports = MockReports.seed();
    _state = LoadState.ready;
    notifyListeners();
  }

  // --- Filters ---------------------------------------------------------------

  void toggleFilter(ReportCategory c) {
    if (!_filters.remove(c)) _filters.add(c);
    notifyListeners();
  }

  void clearFilters() {
    _filters.clear();
    notifyListeners();
  }

  void setIncludeExpired(bool v) {
    includeExpired = v;
    notifyListeners();
  }

  // --- AI classification -----------------------------------------------------

  /// Runs the stand-in classifier. Throws [AiUnavailableException] when the
  /// simulated service is down, which the report flow catches to fall back to
  /// the manual picker.
  Future<AiReportResult> classify({
    required String text,
    SpecificType? userSelectedType,
    required GeoPoint at,
    bool forceFailure = false,
  }) async {
    // The backend holds the Gemini keys; the app never sees them.
    if (_liveData && ApiConfig.useBackend && !forceFailure) {
      try {
        final json = await _api.classify(
          text: text,
          userSelectedType: userSelectedType,
        );
        return aiResultFromJson(json);
      } on ApiException {
        // Fall through to the on-device classifier.
      }
    }

    _classifier.forceFailure = forceFailure;
    return _classifier.classify(
      text: text,
      userSelectedType: userSelectedType,
      nearbyReports: near(at, radiusKm: 0.6),
    );
  }

  // --- Submission ------------------------------------------------------------

  /// Prototype rate limit. Real enforcement belongs server-side.
  bool get rateLimited {
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    _submissionTimes.removeWhere((t) => t.isBefore(cutoff));
    return _submissionTimes.length >= AppLimits.maxReportsPerHour;
  }

  int get submissionsRemaining =>
      (AppLimits.maxReportsPerHour - _submissionTimes.length).clamp(0, 99);

  /// Publishes a report from a reviewed classification.
  Future<SafetyReport> submit({
    required AiReportResult result,
    required GeoPoint location,
    required String segmentId,
    required String areaName,
    String? description,
    bool approximate = false,
    bool classifiedByAi = true,
  }) async {
    // Publish to the backend when we are on live data, so the report is real
    // and reaches other travellers' devices as a push.
    if (_liveData && ApiConfig.useBackend) {
      try {
        final response = await _api.publishReport(
          specificType: result.specificType,
          location: location,
          description: description,
          safePublicText: result.safePublicText,
          severity: result.severity,
          confidence: result.confidence,
          language: result.language,
          approximate: approximate,
          classifiedByAi: classifiedByAi,
        );
        final published = reportFromJson(
          response['report'] as Map<String, dynamic>,
          isMine: true,
        );
        _reports = [published, ..._reports];
        _submissionTimes.add(DateTime.now());
        notifyListeners();
        return published;
      } on ApiException catch (e) {
        // Keep the reporter's work rather than losing it to a network blip:
        // store locally and tell them it is not published.
        _backendNotice = e.isRateLimited
            ? e.message
            : 'Saved on this device — could not reach the server.';
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 700));

    final now = DateTime.now();
    final report = SafetyReport(
      id: 'rep_${now.microsecondsSinceEpoch}',
      category: result.category,
      specificType: result.specificType,
      safePublicText: result.safePublicText,
      description: description,
      location: approximate ? location.blurred() : location,
      roadSegmentId: segmentId,
      areaName: areaName,
      createdAt: now,
      expiresAt: now.add(_lifetimeFor(result.specificType)),
      status: result.doNotPublish
          ? ReportStatus.withheld
          : ReportStatus.unverified,
      severity: result.severity,
      confidence: result.confidence,
      language: result.language,
      approximated: approximate,
      classifiedByAi: classifiedByAi,
      reporterHandle: 'You',
      isMine: true,
    );

    _reports = [report, ..._reports];
    _submissionTimes.add(now);
    notifyListeners();
    return report;
  }

  /// A second traveller agreeing with a report. Corroboration is what moves a
  /// signal from "unverified" to "confirmed" — never an admin decision.
  Future<void> confirmRemote(String reportId) async {
    if (!_liveData || !ApiConfig.useBackend) return;
    try {
      final updated = await _api.confirmReport(reportId);
      final i = _reports.indexWhere((r) => r.id == reportId);
      if (i != -1) {
        _reports = [..._reports]..[i] = updated;
        notifyListeners();
      }
    } on ApiException {
      // The local optimistic update already happened; nothing further to do.
    }
  }

  Future<void> withdrawRemote(String reportId) async {
    if (!_liveData || !ApiConfig.useBackend) return;
    try {
      await _api.withdrawReport(reportId);
    } on ApiException {
      // Local state already reflects the withdrawal.
    }
  }

  void confirm(String reportId) {
    _update(reportId, (r) {
      final count = r.confirmationCount + 1;
      return r.copyWith(
        confirmationCount: count,
        status: count >= 2 && r.status == ReportStatus.unverified
            ? ReportStatus.corroborated
            : r.status,
      );
    });
  }

  void dispute(String reportId) {
    _update(reportId, (r) {
      final count = r.disputeCount + 1;
      return r.copyWith(
        disputeCount: count,
        status: count >= 2 ? ReportStatus.disputed : r.status,
      );
    });
  }

  /// The reporter can withdraw their own signal at any time.
  void withdraw(String reportId) {
    _update(reportId, (r) => r.copyWith(status: ReportStatus.expired));
  }

  /// Lets the reporter correct the AI's category, as the blueprint requires.
  void recategorise(String reportId, SpecificType type, String publicText) {
    _update(
      reportId,
      (r) => r.copyWith(
        specificType: type,
        category: type.category,
        safePublicText: publicText,
      ),
    );
  }

  void _update(String id, SafetyReport Function(SafetyReport) fn) {
    final i = _reports.indexWhere((r) => r.id == id);
    if (i == -1) return;
    _reports = [..._reports]..[i] = fn(_reports[i]);
    notifyListeners();
  }

  static Duration _lifetimeFor(SpecificType t) => switch (t) {
        SpecificType.accident ||
        SpecificType.heavyTraffic ||
        SpecificType.vehicleBreakdown =>
          const Duration(hours: 4),
        SpecificType.standingWater ||
        SpecificType.flooding ||
        SpecificType.roadBlockage =>
          const Duration(hours: 18),
        SpecificType.suspiciousActivity ||
        SpecificType.mobileSnatching ||
        SpecificType.vehicleSnatching =>
          const Duration(days: 2),
        SpecificType.seepage => const Duration(days: 4),
        SpecificType.poorLighting ||
        SpecificType.roadDamage ||
        SpecificType.pothole =>
          const Duration(days: 7),
        SpecificType.construction ||
        SpecificType.roadClosed =>
          const Duration(days: 10),
        _ => const Duration(days: 3),
      };
}
