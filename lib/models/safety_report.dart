import 'dart:math' as math;

import 'geo.dart';
import 'taxonomy.dart';

/// A single community signal. Field names mirror the Firestore document in the
/// blueprint so a real `fromJson` is a drop-in later.
class SafetyReport {
  SafetyReport({
    required this.id,
    required this.category,
    required this.specificType,
    required this.safePublicText,
    required this.location,
    required this.roadSegmentId,
    required this.createdAt,
    required this.status,
    required this.severity,
    required this.confidence,
    required this.language,
    this.description,
    this.areaName = '',
    this.confirmationCount = 0,
    this.disputeCount = 0,
    this.expiresAt,
    this.anonymous = true,
    this.approximated = false,
    this.classifiedByAi = true,
    this.reporterHandle = 'Anonymous resident',
    this.isMine = false,
  });

  final String id;
  final ReportCategory category;
  final SpecificType specificType;

  /// What other travellers see — neutral, never accusatory.
  final String safePublicText;

  /// What the reporter originally typed. Only shown to the reporter.
  final String? description;
  final GeoPoint location;
  final String roadSegmentId;
  final String areaName;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final ReportStatus status;
  final Severity severity;
  final double confidence;
  final ReportLanguage language;
  final int confirmationCount;
  final int disputeCount;
  final bool anonymous;

  /// True when the pin was deliberately coarsened (sensitive categories).
  final bool approximated;
  final bool classifiedByAi;
  final String reporterHandle;
  final bool isMine;

  ConfidenceBand get confidenceBand => ConfidenceBand.fromValue(confidence);

  Duration get age => DateTime.now().difference(createdAt);

  bool get isExpired =>
      status == ReportStatus.expired ||
      (expiresAt != null && DateTime.now().isAfter(expiresAt!));

  bool get isLive => !isExpired && status != ReportStatus.withheld;

  /// Time-decayed weight: W = W0 * exp(-age / tau). Fresh reports matter more.
  double get decayedWeight {
    final tauHours = _tauHoursFor(specificType);
    final ageHours = age.inMinutes / 60.0;
    final decay = math.exp(-ageHours / tauHours);
    return specificType.riskWeight * severity.multiplier * decay;
  }

  /// A report that two independent users confirmed carries more weight.
  double get corroborationBoost =>
      1.0 + (confirmationCount.clamp(0, 4) * 0.12) - (disputeCount * 0.15);

  double get effectiveWeight =>
      (decayedWeight * corroborationBoost).clamp(0.0, 1.6);

  SafetyReport copyWith({
    ReportStatus? status,
    int? confirmationCount,
    int? disputeCount,
    ReportCategory? category,
    SpecificType? specificType,
    String? safePublicText,
  }) =>
      SafetyReport(
        id: id,
        category: category ?? this.category,
        specificType: specificType ?? this.specificType,
        safePublicText: safePublicText ?? this.safePublicText,
        description: description,
        location: location,
        roadSegmentId: roadSegmentId,
        areaName: areaName,
        createdAt: createdAt,
        expiresAt: expiresAt,
        status: status ?? this.status,
        severity: severity,
        confidence: confidence,
        language: language,
        confirmationCount: confirmationCount ?? this.confirmationCount,
        disputeCount: disputeCount ?? this.disputeCount,
        anonymous: anonymous,
        approximated: approximated,
        classifiedByAi: classifiedByAi,
        reporterHandle: reporterHandle,
        isMine: isMine,
      );

  static double _tauHoursFor(SpecificType t) => switch (t) {
        // Transient hazards fade quickly.
        SpecificType.accident => 3,
        SpecificType.heavyTraffic => 2,
        SpecificType.vehicleBreakdown => 2,
        SpecificType.suspiciousActivity => 8,
        SpecificType.standingWater => 12,
        SpecificType.flooding => 18,
        SpecificType.roadBlockage => 24,
        SpecificType.mobileSnatching => 36,
        SpecificType.vehicleSnatching => 36,
        // Structural problems persist.
        SpecificType.seepage => 72,
        SpecificType.roadDamage => 120,
        SpecificType.pothole => 168,
        SpecificType.poorLighting => 168,
        SpecificType.construction => 240,
        SpecificType.roadClosed => 240,
        _ => 48,
      };

}
