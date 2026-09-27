import 'dart:math' as math;

import '../../models/ai_report_result.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';

/// Thrown when the simulated Gemini call fails, so the UI can exercise its
/// manual-fallback path exactly as it would on a real quota error.
class AiUnavailableException implements Exception {
  const AiUnavailableException(this.reason);
  final String reason;

  @override
  String toString() => reason;
}

/// Stand-in for the Gemini Flash classification call described in the
/// blueprint.
///
/// It is a local keyword matcher, not a language model. It exists so the report
/// flow, the review screen, the privacy block and the quota-failure fallback are
/// all demonstrable without a backend or an API key. The output shape is the
/// exact strict-JSON contract Gemini is asked for, so swapping this class for a
/// Cloud Function call touches nothing else.
class MockAiClassifier {
  MockAiClassifier({math.Random? random}) : _random = random ?? math.Random();

  final math.Random _random;

  /// When true the next call throws, for demonstrating the fallback path.
  bool forceFailure = false;

  /// Roman Urdu, Urdu and English keyword sets per specific type.
  ///
  /// Matching prefers the highest `priority`, then the *longest* matching
  /// keyword, rather than the first rule in the list. Two things fall out of
  /// that:
  ///
  ///  * a specific phrase beats a generic one, so "streetlight band hai" reads
  ///    as a lighting problem rather than a blockage, and
  ///  * an outcome beats its cause, so "gali band hai, construction ka saman
  ///    para hua hai" reads as a blockage. The blocked road is what routing
  ///    must act on; the construction is only why. Reading it the other way
  ///    would under-state the route penalty.
  static const List<({SpecificType type, List<String> keys, int priority})>
      _rules = [
    (
      type: SpecificType.roadClosed,
      keys: [
        'road closed',
        'road band kar',
        'band kar di',
        'closed for traffic',
      ],
      priority: 2,
    ),
    (
      type: SpecificType.roadBlockage,
      // Deliberately no bare 'band hai': it also matches "streetlight band
      // hai", "batti band hai" and similar, which are lighting reports.
      keys: [
        'gali band',
        'rasta band',
        'raasta band',
        'road band',
        'blocked',
        'blockage',
        'راستہ بند',
        'saman para',
      ],
      priority: 2,
    ),
    (
      type: SpecificType.construction,
      keys: ['construction', 'tameer', 'marammat', 'repair work', 'khudai', 'dig']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.accident,
      keys: ['accident', 'takkar', 'crash', 'haadsa', 'حادثہ']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.flooding,
      keys: ['flood', 'sailab', 'sailaab', 'bohat pani', 'zyada pani']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.standingWater,
      keys: [
        'pani khara',
        'pani jama',
        'standing water',
        'water on road',
        'pani bhar',
        'پانی',
      ]
    ,
      priority: 0,
    ),
    (
      type: SpecificType.seepage,
      keys: ['seepage', 'sipage', 'seep', 'rista', 'leakage', 'sewerage']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.poorLighting,
      keys: [
        'streetlight',
        'street light',
        'light band',
        'lights band',
        'batti band',
        'andhera',
        'dark',
        'roshni nahi',
        'no light',
        'بتی',
      ]
    ,
      priority: 0,
    ),
    (
      type: SpecificType.pothole,
      keys: ['pothole', 'gaddha', 'gadda', 'ghadda', 'khadda']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.roadDamage,
      keys: [
        'road kharab',
        'road toot',
        'road tut',
        'damaged road',
        'road damage',
        'sarak kharab',
        'khraab road',
        'خراب',
      ]
    ,
      priority: 0,
    ),
    (
      type: SpecificType.debris,
      keys: ['debris', 'malba', 'kachra', 'rubble', 'garbage on road']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.mobileSnatching,
      keys: ['mobile snatch', 'phone snatch', 'mobile chin', 'phone chin']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.vehicleSnatching,
      keys: [
        'bike snatch',
        'bike chin',
        'car snatch',
        'gaari chin',
        'moto snatch',
        'chori ho gayi',
      ]
    ,
      priority: 0,
    ),
    (
      type: SpecificType.suspiciousActivity,
      keys: [
        'suspicious',
        'mashkook',
        'mushkook',
        'shakki',
        'follow kar raha',
        'harassment',
        'tang kar',
        'chhero',
      ]
    ,
      priority: 0,
    ),
    (
      type: SpecificType.heavyTraffic,
      keys: ['traffic', 'rush', 'jam', 'jaam', 'bheer', 'ٹریفک']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.vehicleBreakdown,
      keys: ['breakdown', 'gaari kharab', 'truck khara', 'bus kharab', 'puncture']
    ,
      priority: 0,
    ),
    (
      type: SpecificType.lowActivity,
      keys: ['sunsaan', 'sensaan', 'isolated', 'koi nahi hota', 'veeran', 'quiet']
    ,
      priority: 0,
    ),
  ];

  /// Phrases that suggest the report identifies a person. The real system asks
  /// Gemini for this; here a conservative keyword check stands in.
  static const List<String> _personalIdentifiers = [
    'uska naam',
    'us ka naam',
    'naam hai',
    'phone number',
    'number hai',
    'mobile number',
    'plate',
    'number plate',
    'rehta hai',
    'ghar hai',
    'his name',
    'her name',
    'lives at',
    'address hai',
  ];

  /// Classify free text. Mirrors a network call: async, can fail, can be slow.
  Future<AiReportResult> classify({
    required String text,
    SpecificType? userSelectedType,
    List<SafetyReport> nearbyReports = const [],
  }) async {
    // Realistic-feeling latency for a Flash-class model.
    await Future<void>.delayed(
      Duration(milliseconds: 900 + _random.nextInt(700)),
    );

    if (forceFailure) {
      forceFailure = false;
      throw const AiUnavailableException(
        'Gemini did not respond (simulated quota error).',
      );
    }

    final raw = text.trim();
    final lower = raw.toLowerCase();
    final language = _detectLanguage(raw);

    // Too little to work with — the blueprint's invalid_or_insufficient case.
    if (raw.replaceAll(RegExp(r'[^\w؀-ۿ]'), '').length < 4 &&
        userSelectedType == null) {
      return AiReportResult(
        category: ReportCategory.invalid,
        specificType: SpecificType.invalid,
        summary: 'The report does not contain enough detail to classify.',
        language: language,
        severity: Severity.low,
        urgency: Severity.low,
        confidence: 0.22,
        safePublicText: '',
        needsConfirmation: true,
        doNotPublish: false,
        withheldReason: 'Not enough detail to publish a useful signal.',
      );
    }

    // Privacy guard: never publish text that points at an identifiable person.
    if (_personalIdentifiers.any(lower.contains)) {
      return AiReportResult(
        category: ReportCategory.safetyConcern,
        specificType: userSelectedType ?? SpecificType.suspiciousActivity,
        summary: 'Report appears to identify a specific person.',
        language: language,
        severity: Severity.medium,
        urgency: Severity.medium,
        confidence: 0.66,
        safePublicText: '',
        needsConfirmation: true,
        doNotPublish: true,
        withheldReason:
            'This report names or identifies a person. Safar does not '
            'publish reports about identifiable individuals.',
      );
    }

    final matched = _match(lower);
    final type = matched ?? userSelectedType ?? SpecificType.other;

    // Agreement between what the user picked and what the text says raises
    // confidence; disagreement lowers it and asks for confirmation.
    var confidence = matched == null ? 0.48 : 0.86;
    if (matched != null && userSelectedType != null) {
      confidence = matched == userSelectedType ? 0.94 : 0.62;
    }
    if (raw.length > 40) confidence = math.min(0.96, confidence + 0.03);
    if (raw.split(RegExp(r'\s+')).length < 3) confidence -= 0.08;
    confidence = confidence.clamp(0.15, 0.97);

    final severity = _severityFor(type, lower);
    final duplicate = _findDuplicate(type, nearbyReports);

    return AiReportResult(
      category: type.category,
      specificType: type,
      summary: _summaryFor(type),
      language: language,
      severity: severity,
      urgency: _urgencyFor(type),
      confidence: confidence,
      safePublicText: 'Community report: ${_publicTextFor(type)}',
      needsConfirmation: confidence < 0.9,
      doNotPublish: false,
      duplicateOfReportId: duplicate?.id,
    );
  }

  SpecificType? _match(String lower) {
    SpecificType? best;
    var bestPriority = -1;
    var bestLength = 0;
    for (final rule in _rules) {
      for (final key in rule.keys) {
        if (!lower.contains(key)) continue;
        final wins = rule.priority > bestPriority ||
            (rule.priority == bestPriority && key.length > bestLength);
        if (wins) {
          best = rule.type;
          bestPriority = rule.priority;
          bestLength = key.length;
        }
      }
    }
    return best;
  }

  ReportLanguage _detectLanguage(String raw) {
    if (RegExp(r'[؀-ۿ]').hasMatch(raw)) return ReportLanguage.urdu;
    final lower = raw.toLowerCase();
    const romanMarkers = [
      'hai',
      'hain',
      'nahi',
      'kharab',
      'gali',
      'rasta',
      'raasta',
      'pani',
      'band',
      'yahan',
      'aagay',
      'agay',
      'bohat',
      'mein',
      'ka ',
      'ki ',
      'ho ',
      'gaya',
      'wala',
      'andhera',
      'batti',
    ];
    final hits = romanMarkers.where(lower.contains).length;
    if (hits >= 2) return ReportLanguage.romanUrdu;
    if (hits == 1 && raw.split(RegExp(r'\s+')).length <= 6) {
      return ReportLanguage.romanUrdu;
    }
    if (RegExp(r'^[\x00-\x7F\s]+$').hasMatch(raw)) return ReportLanguage.english;
    return ReportLanguage.unknown;
  }

  Severity _severityFor(SpecificType t, String lower) {
    var base = switch (t) {
      SpecificType.roadBlockage ||
      SpecificType.roadClosed ||
      SpecificType.accident ||
      SpecificType.flooding ||
      SpecificType.mobileSnatching ||
      SpecificType.vehicleSnatching =>
        Severity.high,
      SpecificType.pothole ||
      SpecificType.debris ||
      SpecificType.heavyTraffic ||
      SpecificType.lowActivity ||
      SpecificType.vehicleBreakdown =>
        Severity.low,
      _ => Severity.medium,
    };
    // Intensifiers people actually use.
    const strong = ['bohat', 'bahut', 'zyada', 'very', 'severe', 'buri tarah'];
    if (strong.any(lower.contains) && base == Severity.medium) {
      base = Severity.high;
    }
    const mild = ['thora', 'thoda', 'slight', 'minor', 'kam'];
    if (mild.any(lower.contains) && base == Severity.high) {
      base = Severity.medium;
    }
    return base;
  }

  Severity _urgencyFor(SpecificType t) => switch (t) {
        SpecificType.accident ||
        SpecificType.flooding ||
        SpecificType.roadBlockage ||
        SpecificType.roadClosed =>
          Severity.high,
        SpecificType.pothole ||
        SpecificType.poorLighting ||
        SpecificType.roadDamage ||
        SpecificType.lowActivity =>
          Severity.low,
        _ => Severity.medium,
      };

  /// Duplicate-like detection: same type already reported very recently.
  SafetyReport? _findDuplicate(
    SpecificType type,
    List<SafetyReport> nearby,
  ) {
    for (final r in nearby) {
      if (r.specificType == type &&
          r.isLive &&
          r.age < const Duration(minutes: 45)) {
        return r;
      }
    }
    return null;
  }

  static String _summaryFor(SpecificType t) => switch (t) {
        SpecificType.roadBlockage => 'The road ahead may be blocked.',
        SpecificType.roadClosed => 'The road appears to be closed to traffic.',
        SpecificType.construction =>
          'Construction work may be narrowing the road.',
        SpecificType.accident => 'An accident was reported on this road.',
        SpecificType.flooding => 'Flooding may be affecting this road.',
        SpecificType.standingWater =>
          'Standing water may make the road difficult for motorcycles.',
        SpecificType.seepage => 'Seepage may be affecting the road surface.',
        SpecificType.poorLighting =>
          'Lighting on this stretch is reported as poor.',
        SpecificType.pothole => 'Potholes were reported on this road.',
        SpecificType.roadDamage => 'The road surface is significantly damaged.',
        SpecificType.debris => 'Debris was reported on the road.',
        SpecificType.mobileSnatching =>
          'A mobile snatching was reported in this area.',
        SpecificType.vehicleSnatching =>
          'A vehicle snatching was reported in this area.',
        SpecificType.suspiciousActivity =>
          'A traveller reported activity that felt unsafe.',
        SpecificType.heavyTraffic => 'Heavy traffic was reported here.',
        SpecificType.vehicleBreakdown =>
          'A broken-down vehicle is reported to be obstructing traffic.',
        SpecificType.lowActivity => 'This stretch is reported as very quiet.',
        _ => 'A community report was submitted for this location.',
      };

  static String _publicTextFor(SpecificType t) => switch (t) {
        SpecificType.roadBlockage => 'the road ahead may be blocked.',
        SpecificType.roadClosed => 'this road may be closed to traffic.',
        SpecificType.construction => 'construction may be narrowing this road.',
        SpecificType.accident => 'an accident was reported here. Expect delays.',
        SpecificType.flooding => 'flooding may be affecting this road.',
        SpecificType.standingWater =>
          'standing water may affect motorcycle travel here.',
        SpecificType.seepage => 'seepage may be affecting this road.',
        SpecificType.poorLighting =>
          'lighting on this stretch is reported as poor.',
        SpecificType.pothole => 'potholes were reported along this road.',
        SpecificType.roadDamage =>
          'the road surface is significantly damaged.',
        SpecificType.debris => 'debris was reported on this road.',
        SpecificType.mobileSnatching =>
          'a mobile snatching was reported in this area. Location is approximate.',
        SpecificType.vehicleSnatching =>
          'a vehicle snatching was reported in this area. Location is approximate.',
        SpecificType.suspiciousActivity =>
          'a traveller reported feeling unsafe in this area.',
        SpecificType.heavyTraffic => 'heavy traffic was reported here.',
        SpecificType.vehicleBreakdown =>
          'a broken-down vehicle may be obstructing traffic.',
        SpecificType.lowActivity => 'this stretch is reported as very quiet.',
        _ => 'a condition was reported at this location.',
      };
}
