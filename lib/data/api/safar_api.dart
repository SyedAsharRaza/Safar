import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ai_report_result.dart';
import '../../models/geo.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';
import 'api_client.dart';

/// Typed access to the backend, mapping JSON onto the app's existing models.
///
/// Parsing lives here rather than in the widgets so a change to the wire
/// format touches one file.
class SafarApi {
  SafarApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  static const _tokenKey = 'safar_session_token';
  static const _deviceKey = 'safar_device_id';

  bool get hasSession => _client.hasSession;

  // --- Session ---------------------------------------------------------------

  /// Signs in anonymously, reusing the stored device id so the same traveller
  /// keeps their reports across launches.
  Future<Map<String, dynamic>> signInAnonymously() async {
    final prefs = await SharedPreferences.getInstance();

    var deviceId = prefs.getString(_deviceKey);
    if (deviceId == null) {
      // Opaque and app-generated — deliberately not a hardware identifier.
      deviceId =
          'bwp-${DateTime.now().microsecondsSinceEpoch}-${DateTime.now().hashCode.abs()}';
      await prefs.setString(_deviceKey, deviceId);
    }

    final result = await _client.post(
      '/auth/anonymous',
      body: {'deviceId': deviceId},
    );
    final data = result['data'] as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token != null) {
      _client.setToken(token);
      await prefs.setString(_tokenKey, token);
    }
    return data['user'] as Map<String, dynamic>? ?? const {};
  }

  /// Restores a saved session without a round trip. Returns false if none.
  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) return false;
    _client.setToken(token);
    return true;
  }

  /// Creates an account, upgrading this device's anonymous user in place so
  /// the reports already filed from this phone are kept.
  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    String? displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await _client.post('/auth/register', body: {
      'phone': phone,
      'password': password,
      if (displayName != null && displayName.isNotEmpty)
        'displayName': displayName,
      if (prefs.getString(_deviceKey) != null)
        'deviceId': prefs.getString(_deviceKey),
    });
    final data = result['data'] as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token != null) {
      _client.setToken(token);
      await prefs.setString(_tokenKey, token);
    }
    return data['user'] as Map<String, dynamic>? ?? const {};
  }

  /// Signs in to an existing account, from any device.
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final result = await _client.post('/auth/login', body: {
      'phone': phone,
      'password': password,
    });
    final data = result['data'] as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token != null) {
      _client.setToken(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }
    return data['user'] as Map<String, dynamic>? ?? const {};
  }

  /// Current account, or null when the session is gone.
  Future<Map<String, dynamic>?> currentUser() async {
    try {
      final result = await _client.get('/auth/me');
      final data = result['data'] as Map<String, dynamic>;
      return data['user'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  /// Reverse geocodes a point into a human address.
  Future<Map<String, dynamic>?> reverseGeocode(GeoPoint point) async {
    try {
      final result = await _client.get('/geocode/reverse', query: {
        'lat': point.lat,
        'lng': point.lng,
      });
      final data = result['data'] as Map<String, dynamic>;
      return data['address'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  /// Searches places, blending curated landmarks with live geocoding.
  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    final result = await _client.get('/places', query: {'q': query});
    final data = result['data'] as Map<String, dynamic>;
    return (data['places'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _client.setToken(null);
  }

  // --- Health ----------------------------------------------------------------

  Future<Map<String, dynamic>> health() async {
    final result = await _client.get('/health');
    return result['data'] as Map<String, dynamic>;
  }

  // --- Reports ---------------------------------------------------------------

  Future<List<SafetyReport>> fetchReports({
    ReportCategory? category,
    bool includeExpired = false,
    int limit = 100,
  }) async {
    final result = await _client.get('/reports', query: {
      if (category != null) 'category': category.wire,
      'includeExpired': includeExpired,
      'limit': limit,
    });
    final data = result['data'] as Map<String, dynamic>;
    final list = (data['reports'] as List<dynamic>? ?? const []);
    return list
        .map((e) => reportFromJson(e as Map<String, dynamic>))
        .where(isPlausibleLocation)
        .toList(growable: false);
  }

  Future<List<SafetyReport>> fetchMyReports() async {
    final result = await _client.get('/reports/mine');
    final data = result['data'] as Map<String, dynamic>;
    final list = (data['reports'] as List<dynamic>? ?? const []);
    return list
        .map((e) => reportFromJson(e as Map<String, dynamic>, isMine: true))
        .where(isPlausibleLocation)
        .toList(growable: false);
  }

  /// Classifies free text without storing anything.
  Future<Map<String, dynamic>> classify({
    required String text,
    SpecificType? userSelectedType,
  }) async {
    final result = await _client.post('/reports/classify', body: {
      'text': text,
      if (userSelectedType != null) 'userSelectedType': userSelectedType.wire,
    });
    final data = result['data'] as Map<String, dynamic>;
    return data['classification'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> publishReport({
    required SpecificType specificType,
    required GeoPoint location,
    String? description,
    String? safePublicText,
    Severity severity = Severity.medium,
    double confidence = 0.5,
    ReportLanguage language = ReportLanguage.unknown,
    bool approximate = false,
    bool classifiedByAi = false,
  }) async {
    final result = await _client.post('/reports', body: {
      'specificType': specificType.wire,
      'location': {'lat': location.lat, 'lng': location.lng},
      if (description != null && description.isNotEmpty)
        'description': description,
      if (safePublicText != null && safePublicText.isNotEmpty)
        'safePublicText': safePublicText,
      'severity': severity.wire,
      'confidence': confidence,
      'language': language.wire,
      'approximate': approximate,
      'classifiedByAi': classifiedByAi,
    });
    return result['data'] as Map<String, dynamic>;
  }

  Future<SafetyReport> confirmReport(String id) async {
    final result = await _client.post('/reports/$id/confirm');
    final data = result['data'] as Map<String, dynamic>;
    return reportFromJson(data['report'] as Map<String, dynamic>);
  }

  Future<SafetyReport> disputeReport(String id) async {
    final result = await _client.post('/reports/$id/dispute');
    final data = result['data'] as Map<String, dynamic>;
    return reportFromJson(data['report'] as Map<String, dynamic>);
  }

  Future<void> withdrawReport(String id) => _client.delete('/reports/$id');

  // --- Routes ----------------------------------------------------------------

  Future<Map<String, dynamic>> planRoutes({
    required GeoPoint origin,
    required GeoPoint destination,
  }) async {
    final result = await _client.post('/routes/plan', body: {
      'origin': {'lat': origin.lat, 'lng': origin.lng},
      'destination': {'lat': destination.lat, 'lng': destination.lng},
    });
    return result['data'] as Map<String, dynamic>;
  }

  // --- Area ------------------------------------------------------------------

  Future<Map<String, dynamic>> areaSummary() async {
    final result = await _client.get('/area/summary');
    return result['data'] as Map<String, dynamic>;
  }

  /// Fires a test push to the topic. Used by the demo panel so a presenter can
  /// prove notifications work without staging a second device.
  Future<void> sendTestNotification() => _client.post(
        '/notifications/test',
        body: {
          'title': 'Safar',
          'body': 'Test notification — community signals are live.',
        },
      );

  void dispose() => _client.dispose();
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

/// Builds a [SafetyReport] from the API's JSON.
///
/// Tolerant by design: a missing or unexpected field falls back to a sensible
/// default rather than throwing, so one malformed row cannot blank the map.
SafetyReport reportFromJson(Map<String, dynamic> json, {bool isMine = false}) {
  final location = json['location'] as Map<String, dynamic>? ?? const {};
  final type = SpecificType.fromWire(json['specificType'] as String? ?? 'other');

  return SafetyReport(
    id: json['id'] as String? ?? json['_id'] as String? ?? '',
    category: ReportCategory.fromWire(
      json['category'] as String? ?? type.category.wire,
    ),
    specificType: type,
    safePublicText: json['safePublicText'] as String? ?? '',
    description: json['description'] as String?,
    location: GeoPoint(
      (location['lat'] as num?)?.toDouble() ?? 0,
      (location['lng'] as num?)?.toDouble() ?? 0,
    ),
    roadSegmentId: json['roadSegmentId'] as String? ?? '',
    areaName: json['areaName'] as String? ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.now(),
    expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
    status: _statusFromWire(json['status'] as String?),
    severity: Severity.fromWire(json['severity'] as String? ?? 'medium'),
    confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
    language: ReportLanguage.fromWire(json['language'] as String? ?? 'unknown'),
    confirmationCount: (json['confirmationCount'] as num?)?.toInt() ?? 0,
    disputeCount: (json['disputeCount'] as num?)?.toInt() ?? 0,
    approximated: json['approximated'] as bool? ?? false,
    classifiedByAi: json['classifiedByAi'] as bool? ?? false,
    isMine: isMine || (json['isMine'] as bool? ?? false),
    reporterHandle: isMine ? 'You' : 'Anonymous resident',
  );
}

/// Guards against a report landing far outside the covered area.
///
/// The server rejects these on submission now, but older rows may exist and a
/// future client could get it wrong. Dropping them here means one bad record
/// cannot skew the map for everyone.
bool isPlausibleLocation(SafetyReport r) =>
    r.location.lat >= 28.6 &&
    r.location.lat <= 30.2 &&
    r.location.lng >= 70.6 &&
    r.location.lng <= 72.8;

ReportStatus _statusFromWire(String? wire) => switch (wire) {
      'corroborated' => ReportStatus.corroborated,
      'disputed' => ReportStatus.disputed,
      'expired' => ReportStatus.expired,
      'withheld' => ReportStatus.withheld,
      _ => ReportStatus.unverified,
    };

/// Builds an [AiReportResult] from the backend's classification JSON.
///
/// The wire contract is identical to the on-device classifier's output, so the
/// review screen cannot tell which produced a given result — which is what
/// makes the offline fallback invisible to the user.
AiReportResult aiResultFromJson(Map<String, dynamic> json) {
  final type = SpecificType.fromWire(json['specificType'] as String? ?? 'other');
  return AiReportResult(
    category: ReportCategory.fromWire(
      json['category'] as String? ?? type.category.wire,
    ),
    specificType: type,
    summary: json['summary'] as String? ?? '',
    language: ReportLanguage.fromWire(json['language'] as String? ?? 'unknown'),
    severity: Severity.fromWire(json['severity'] as String? ?? 'medium'),
    urgency: Severity.fromWire(json['urgency'] as String? ?? 'medium'),
    confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
    safePublicText: json['safePublicText'] as String? ?? '',
    needsConfirmation: json['needsConfirmation'] as bool? ?? true,
    doNotPublish: json['doNotPublish'] as bool? ?? false,
    withheldReason: json['withheldReason'] as String?,
  );
}

