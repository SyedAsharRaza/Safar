import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Top-level report groups shown in the UI. Mirrors the blueprint's
/// `category` field exactly so a real Gemini response drops straight in.
enum ReportCategory {
  safetyConcern('safety_concern', 'Safety concern', 'Mahfooz-mahol ki report'),
  lightingProblem('lighting_problem', 'Lighting', 'Roshni ka masla'),
  roadCondition('road_condition', 'Road condition', 'Road ki halat'),
  waterOrDrainage('water_or_drainage', 'Water / drainage', 'Pani ya seepage'),
  blockageOrClosure('blockage_or_closure', 'Blockage', 'Rasta band'),
  trafficHazard('traffic_hazard', 'Traffic hazard', 'Traffic ka masla'),
  other('other', 'Other', 'Deegar'),
  invalid('invalid_or_insufficient', 'Not enough detail', 'Tafseel kam hai');

  const ReportCategory(this.wire, this.label, this.labelRoman);

  final String wire;
  final String label;
  final String labelRoman;

  /// The four buckets offered on the report screen. `other` and `invalid`
  /// are outcomes of classification, not things a user picks up front.
  static const List<ReportCategory> pickable = [
    ReportCategory.safetyConcern,
    ReportCategory.lightingProblem,
    ReportCategory.roadCondition,
    ReportCategory.waterOrDrainage,
    ReportCategory.blockageOrClosure,
    ReportCategory.trafficHazard,
  ];

  static ReportCategory fromWire(String w) => values.firstWhere(
        (e) => e.wire == w,
        orElse: () => ReportCategory.other,
      );

  IconData get icon => switch (this) {
        ReportCategory.safetyConcern => Icons.shield_outlined,
        ReportCategory.lightingProblem => Icons.lightbulb_outline,
        ReportCategory.roadCondition => Icons.dangerous_outlined,
        ReportCategory.waterOrDrainage => Icons.water_drop_outlined,
        ReportCategory.blockageOrClosure => Icons.block_outlined,
        ReportCategory.trafficHazard => Icons.traffic_outlined,
        ReportCategory.other => Icons.more_horiz,
        ReportCategory.invalid => Icons.help_outline,
      };

  Color get color => switch (this) {
        ReportCategory.safetyConcern => const Color(0xFF8B5CF6),
        ReportCategory.lightingProblem => const Color(0xFFE2A014),
        ReportCategory.roadCondition => const Color(0xFFDE5B33),
        ReportCategory.waterOrDrainage => const Color(0xFF2196C9),
        ReportCategory.blockageOrClosure => const Color(0xFFD4342B),
        ReportCategory.trafficHazard => const Color(0xFF0E9594),
        ReportCategory.other => AppColors.awarenessUnknown,
        ReportCategory.invalid => AppColors.awarenessUnknown,
      };

  String get helper => switch (this) {
        ReportCategory.safetyConcern =>
          'Snatching, suspicious activity, or an uncomfortable public space.',
        ReportCategory.lightingProblem =>
          'Broken streetlight, very dark stretch, poor visibility.',
        ReportCategory.roadCondition =>
          'Damaged surface, potholes, debris, slippery road.',
        ReportCategory.waterOrDrainage =>
          'Seepage, standing water, or flooding on the road.',
        ReportCategory.blockageOrClosure =>
          'Street blocked, road closed, or construction in the way.',
        ReportCategory.trafficHazard =>
          'Accident, heavy traffic, or a broken-down vehicle.',
        ReportCategory.other => 'Something else worth telling travellers.',
        ReportCategory.invalid => 'We could not tell what the report meant.',
      };
}

/// Specific report types, kept internal in the blueprint but surfaced here as
/// the second step of the report flow.
enum SpecificType {
  mobileSnatching('mobile_snatching', 'Mobile snatching',
      'Mobile snatching hui hai', ReportCategory.safetyConcern, 1.00),
  vehicleSnatching('vehicle_snatching', 'Vehicle snatching',
      'Bike ya gaari snatch hui', ReportCategory.safetyConcern, 1.00),
  suspiciousActivity('suspicious_activity', 'Suspicious activity',
      'Mashkook harkat dekhi', ReportCategory.safetyConcern, 0.70),
  poorLighting('poor_lighting', 'Streetlight not working',
      'Streetlight band hai', ReportCategory.lightingProblem, 0.55),
  roadDamage('road_damage', 'Road damaged', 'Road kharab hai',
      ReportCategory.roadCondition, 0.60),
  pothole('pothole', 'Pothole', 'Gaddha hai', ReportCategory.roadCondition, 0.35),
  debris('debris', 'Debris on road', 'Malba para hua hai',
      ReportCategory.roadCondition, 0.40),
  seepage('seepage', 'Seepage', 'Seepage hai',
      ReportCategory.waterOrDrainage, 0.80),
  standingWater('standing_water', 'Standing water', 'Road par pani khara hai',
      ReportCategory.waterOrDrainage, 0.70),
  flooding('flooding', 'Flooding', 'Road par sailab jaisa pani',
      ReportCategory.waterOrDrainage, 0.90),
  roadBlockage('road_blockage', 'Street blocked', 'Aagay gali band hai',
      ReportCategory.blockageOrClosure, 1.00),
  roadClosed('road_closed', 'Road closed', 'Road band kar di gayi hai',
      ReportCategory.blockageOrClosure, 1.00),
  construction('construction', 'Construction', 'Construction chal rahi hai',
      ReportCategory.blockageOrClosure, 0.50),
  accident('accident', 'Accident', 'Accident hua hai',
      ReportCategory.trafficHazard, 0.95),
  heavyTraffic('heavy_traffic', 'Heavy traffic', 'Bohat rush hai',
      ReportCategory.trafficHazard, 0.40),
  vehicleBreakdown('vehicle_breakdown', 'Vehicle breakdown',
      'Gaari kharab ho gayi hai', ReportCategory.trafficHazard, 0.45),
  lowActivity('low_activity', 'Very quiet / isolated',
      'Yahan bohat sunsaan hai', ReportCategory.safetyConcern, 0.35),
  other('other', 'Something else', 'Koi aur baat',
      ReportCategory.other, 0.30),
  invalid('invalid_or_insufficient', 'Not enough detail', 'Tafseel kam hai',
      ReportCategory.invalid, 0.0);

  const SpecificType(
    this.wire,
    this.label,
    this.labelRoman,
    this.category,
    this.riskWeight,
  );

  final String wire;
  final String label;

  /// Roman Urdu phrasing — the way people actually report in Bahawalpur.
  final String labelRoman;
  final ReportCategory category;

  /// Prototype weights from the blueprint. Not validated probabilities.
  final double riskWeight;

  static SpecificType fromWire(String w) => values.firstWhere(
        (e) => e.wire == w,
        orElse: () => SpecificType.other,
      );

  static List<SpecificType> forCategory(ReportCategory c) =>
      values.where((e) => e.category == c && e != SpecificType.invalid).toList();

  IconData get icon => switch (this) {
        SpecificType.mobileSnatching => Icons.phonelink_erase_outlined,
        SpecificType.vehicleSnatching => Icons.no_transfer_outlined,
        SpecificType.suspiciousActivity => Icons.visibility_outlined,
        SpecificType.poorLighting => Icons.lightbulb_outline,
        SpecificType.roadDamage => Icons.broken_image_outlined,
        SpecificType.pothole => Icons.blur_circular_outlined,
        SpecificType.debris => Icons.scatter_plot_outlined,
        SpecificType.seepage => Icons.opacity_outlined,
        SpecificType.standingWater => Icons.water_outlined,
        SpecificType.flooding => Icons.flood_outlined,
        SpecificType.roadBlockage => Icons.block_outlined,
        SpecificType.roadClosed => Icons.do_not_disturb_on_outlined,
        SpecificType.construction => Icons.construction_outlined,
        SpecificType.accident => Icons.car_crash_outlined,
        SpecificType.heavyTraffic => Icons.traffic_outlined,
        SpecificType.vehicleBreakdown => Icons.car_repair_outlined,
        SpecificType.lowActivity => Icons.nightlight_outlined,
        SpecificType.other => Icons.more_horiz,
        SpecificType.invalid => Icons.help_outline,
      };

  /// How this report type should influence routing, in plain words.
  /// Straight from the blueprint's "route behaviour" table.
  String get routeEffect => switch (this) {
        SpecificType.roadBlockage => 'Segment avoided where possible',
        SpecificType.roadClosed => 'Segment avoided where possible',
        SpecificType.accident => 'Strong temporary penalty',
        SpecificType.flooding => 'Strong penalty',
        SpecificType.seepage => 'Medium to strong penalty',
        SpecificType.mobileSnatching => 'Caution penalty',
        SpecificType.vehicleSnatching => 'Caution penalty',
        SpecificType.suspiciousActivity => 'Temporary caution penalty',
        SpecificType.poorLighting => 'Awareness penalty',
        SpecificType.roadDamage => 'Medium penalty',
        SpecificType.construction => 'Medium penalty',
        SpecificType.heavyTraffic => 'Time penalty',
        SpecificType.standingWater => 'Medium penalty',
        SpecificType.pothole => 'Small penalty',
        SpecificType.debris => 'Small penalty',
        SpecificType.vehicleBreakdown => 'Small time penalty',
        SpecificType.lowActivity => 'Awareness penalty',
        _ => 'No route change',
      };
}

enum Severity {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High');

  const Severity(this.wire, this.label);
  final String wire;
  final String label;

  static Severity fromWire(String w) =>
      values.firstWhere((e) => e.wire == w, orElse: () => Severity.medium);

  Color get color => switch (this) {
        Severity.low => AppColors.awarenessLow,
        Severity.medium => AppColors.awarenessModerate,
        Severity.high => AppColors.awarenessElevated,
      };

  double get multiplier => switch (this) {
        Severity.low => 0.6,
        Severity.medium => 1.0,
        Severity.high => 1.35,
      };
}

enum ReportStatus {
  unverified('unverified', 'Unverified'),
  corroborated('corroborated', 'Confirmed by community'),
  disputed('disputed', 'Disputed'),
  expired('expired', 'Expired'),
  withheld('withheld', 'Not published');

  const ReportStatus(this.wire, this.label);
  final String wire;
  final String label;

  Color get color => switch (this) {
        ReportStatus.unverified => AppColors.awarenessModerate,
        ReportStatus.corroborated => AppColors.awarenessLow,
        ReportStatus.disputed => AppColors.awarenessElevated,
        ReportStatus.expired => AppColors.awarenessUnknown,
        ReportStatus.withheld => AppColors.awarenessUnknown,
      };

  IconData get icon => switch (this) {
        ReportStatus.unverified => Icons.schedule_outlined,
        ReportStatus.corroborated => Icons.verified_outlined,
        ReportStatus.disputed => Icons.gpp_maybe_outlined,
        ReportStatus.expired => Icons.history_toggle_off_outlined,
        ReportStatus.withheld => Icons.visibility_off_outlined,
      };
}

/// Route awareness bands. Deliberately descriptive — never a percentage.
enum AwarenessLevel {
  low('Low reported caution'),
  moderate('Moderate reported caution'),
  elevated('Elevated caution'),
  limited('Limited data available');

  const AwarenessLevel(this.label);
  final String label;

  /// Short form for chips and map legends.
  String get shortLabel => switch (this) {
        AwarenessLevel.low => 'Low caution',
        AwarenessLevel.moderate => 'Moderate',
        AwarenessLevel.elevated => 'Elevated',
        AwarenessLevel.limited => 'Limited data',
      };

  Color get color => switch (this) {
        AwarenessLevel.low => AppColors.awarenessLow,
        AwarenessLevel.moderate => AppColors.awarenessModerate,
        AwarenessLevel.elevated => AppColors.awarenessElevated,
        AwarenessLevel.limited => AppColors.awarenessUnknown,
      };

  Color get softColor => switch (this) {
        AwarenessLevel.low => AppColors.awarenessLowSoft,
        AwarenessLevel.moderate => AppColors.awarenessModerateSoft,
        AwarenessLevel.elevated => AppColors.awarenessElevatedSoft,
        AwarenessLevel.limited => AppColors.awarenessUnknownSoft,
      };

  IconData get icon => switch (this) {
        AwarenessLevel.low => Icons.check_circle_outline,
        AwarenessLevel.moderate => Icons.info_outline,
        AwarenessLevel.elevated => Icons.warning_amber_rounded,
        AwarenessLevel.limited => Icons.help_outline,
      };

  static AwarenessLevel fromScore(double score, {bool hasData = true}) {
    if (!hasData) return AwarenessLevel.limited;
    if (score < 0.28) return AwarenessLevel.low;
    if (score < 0.55) return AwarenessLevel.moderate;
    return AwarenessLevel.elevated;
  }
}

enum ReportLanguage {
  english('english', 'English', 'English'),
  urdu('urdu', 'Urdu', 'اردو'),
  romanUrdu('roman_urdu', 'Roman Urdu', 'Roman Urdu'),
  punjabi('punjabi', 'Punjabi', 'پنجابی'),
  unknown('unknown', 'Unknown', 'Unknown');

  const ReportLanguage(this.wire, this.label, this.nativeLabel);
  final String wire;
  final String label;
  final String nativeLabel;

  static ReportLanguage fromWire(String w) =>
      values.firstWhere((e) => e.wire == w, orElse: () => ReportLanguage.unknown);

  /// Languages a user can pick for the interface. `unknown` is a
  /// classification outcome, not something anyone chooses.
  static const List<ReportLanguage> selectable = [
    ReportLanguage.english,
    ReportLanguage.urdu,
    ReportLanguage.romanUrdu,
    ReportLanguage.punjabi,
  ];

  /// Urdu and Punjabi are written right-to-left in Pakistan; Roman Urdu uses
  /// Latin script and reads left-to-right.
  bool get isRtl =>
      this == ReportLanguage.urdu || this == ReportLanguage.punjabi;

  Locale get locale => switch (this) {
        ReportLanguage.urdu => const Locale('ur'),
        ReportLanguage.punjabi => const Locale('pa'),
        ReportLanguage.romanUrdu =>
          const Locale.fromSubtags(languageCode: 'ur', scriptCode: 'Latn'),
        _ => const Locale('en'),
      };
}

/// Confidence banding so the UI never prints a raw probability as a claim.
enum ConfidenceBand {
  high('High confidence'),
  moderate('Moderate confidence'),
  low('Low confidence');

  const ConfidenceBand(this.label);
  final String label;

  static ConfidenceBand fromValue(double v) {
    if (v >= 0.8) return ConfidenceBand.high;
    if (v >= 0.55) return ConfidenceBand.moderate;
    return ConfidenceBand.low;
  }

  Color get color => switch (this) {
        ConfidenceBand.high => AppColors.awarenessLow,
        ConfidenceBand.moderate => AppColors.awarenessModerate,
        ConfidenceBand.low => AppColors.awarenessElevated,
      };
}
