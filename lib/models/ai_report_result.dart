import 'taxonomy.dart';

/// Mirrors the strict JSON contract the blueprint defines for Gemini.
/// In this prototype it is produced by a local mock classifier.
class AiReportResult {
  const AiReportResult({
    required this.category,
    required this.specificType,
    required this.summary,
    required this.language,
    required this.severity,
    required this.urgency,
    required this.confidence,
    required this.safePublicText,
    required this.needsConfirmation,
    required this.doNotPublish,
    this.withheldReason,
    this.duplicateOfReportId,
  });

  final ReportCategory category;
  final SpecificType specificType;
  final String summary;
  final ReportLanguage language;
  final Severity severity;
  final Severity urgency;
  final double confidence;
  final String safePublicText;
  final bool needsConfirmation;

  /// Set when the text names or accuses an identifiable person.
  final bool doNotPublish;
  final String? withheldReason;

  /// Set when an equivalent fresh report already exists nearby.
  final String? duplicateOfReportId;

  ConfidenceBand get band => ConfidenceBand.fromValue(confidence);

  bool get isUsable =>
      !doNotPublish && category != ReportCategory.invalid;

  /// Exact JSON shape, shown verbatim in the "what the model returned" sheet.
  Map<String, Object?> toJson() => {
        'category': category.wire,
        'specificType': specificType.wire,
        'summary': summary,
        'language': language.wire,
        'severity': severity.wire,
        'urgency': urgency.wire,
        'confidence': double.parse(confidence.toStringAsFixed(2)),
        'safePublicText': safePublicText,
        'needsConfirmation': needsConfirmation,
        'doNotPublish': doNotPublish,
      };

  AiReportResult copyWith({
    ReportCategory? category,
    SpecificType? specificType,
    String? safePublicText,
    double? confidence,
  }) =>
      AiReportResult(
        category: category ?? this.category,
        specificType: specificType ?? this.specificType,
        summary: summary,
        language: language,
        severity: severity,
        urgency: urgency,
        confidence: confidence ?? this.confidence,
        safePublicText: safePublicText ?? this.safePublicText,
        needsConfirmation: needsConfirmation,
        doNotPublish: doNotPublish,
        withheldReason: withheldReason,
        duplicateOfReportId: duplicateOfReportId,
      );
}

/// What the report screen is currently doing. Drives the AI review UI states.
enum AiReviewState { idle, thinking, done, failed }
