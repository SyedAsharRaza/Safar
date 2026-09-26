import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/mock_ai_classifier.dart';
import '../../models/ai_report_result.dart';
import '../../models/geo.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/notifications_provider.dart';
import '../../models/app_notification.dart';
import '../../state/reports_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import 'report_success_screen.dart';

/// "We understood this as…" — the review gate before anything is published.
///
/// Four outcomes are all handled here, because all four happen in practice:
///  * a confident classification the user confirms,
///  * a low-confidence one they correct,
///  * text that identifies a person, which is blocked outright,
///  * and the classifier being unavailable, which falls back to manual choice.
class ReportReviewScreen extends StatefulWidget {
  const ReportReviewScreen({
    super.key,
    required this.description,
    required this.userSelectedType,
    required this.location,
    required this.segmentId,
    required this.areaName,
    required this.approximate,
  });

  final String description;
  final SpecificType? userSelectedType;
  final GeoPoint location;
  final String segmentId;
  final String areaName;
  final bool approximate;

  @override
  State<ReportReviewScreen> createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  AiReviewState _state = AiReviewState.thinking;
  AiReportResult? _result;
  String? _failureReason;
  bool _submitting = false;

  /// True when the user overrode the suggested category.
  bool _corrected = false;

  @override
  void initState() {
    super.initState();
    _classify();
  }

  Future<void> _classify() async {
    setState(() {
      _state = AiReviewState.thinking;
      _failureReason = null;
    });

    final reports = context.read<ReportsProvider>();
    final app = context.read<AppState>();

    try {
      final result = await reports.classify(
        text: widget.description,
        userSelectedType: widget.userSelectedType,
        at: widget.location,
        forceFailure: app.simulateAiFailure,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _state = AiReviewState.done;
      });
    } on AiUnavailableException catch (e) {
      if (!mounted) return;
      // The blueprint is explicit: the app must keep working without Gemini.
      setState(() {
        _state = AiReviewState.failed;
        _failureReason = e.reason;
        _result = _manualFallback();
      });
    }
  }

  /// Builds a result from the user's own choices when the classifier is down.
  AiReportResult _manualFallback() {
    final type = widget.userSelectedType ?? SpecificType.other;
    return AiReportResult(
      category: type.category,
      specificType: type,
      summary: 'Categorised manually by the reporter.',
      language: ReportLanguage.unknown,
      severity: Severity.medium,
      urgency: Severity.medium,
      confidence: 0.5,
      safePublicText:
          'Community report: ${_plainTextFor(type)}',
      needsConfirmation: true,
      doNotPublish: false,
    );
  }

  static String _plainTextFor(SpecificType t) =>
      '${t.label.toLowerCase()} reported at this location.';

  void _changeCategory() {
    showSafarSheet<void>(
      context,
      title: 'Choose the right category',
      subtitle:
          'Your correction is what gets published. Corrections also help us '
          'see where the classifier is weak.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final category in ReportCategory.pickable) ...[
            Padding(
              padding: const EdgeInsets.only(top: Gap.md, bottom: Gap.sm),
              child: Row(
                children: [
                  Icon(category.icon, size: 15, color: category.color),
                  const SizedBox(width: Gap.sm),
                  Text(
                    category.label,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: category.color),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: [
                for (final type in SpecificType.forCategory(category))
                  SelectableChip(
                    label: type.label,
                    icon: type.icon,
                    accent: category.color,
                    selected: _result?.specificType == type,
                    onTap: () {
                      setState(() {
                        _corrected = true;
                        _result = _result?.copyWith(
                          category: type.category,
                          specificType: type,
                          safePublicText:
                              'Community report: ${_plainTextFor(type)}',
                          // A human correction is more reliable than a guess.
                          confidence: 0.95,
                        );
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    final result = _result;
    if (result == null) return;

    setState(() => _submitting = true);

    final reports = context.read<ReportsProvider>();
    final routes = context.read<RoutesProvider>();
    final app = context.read<AppState>();
    final notifications = context.read<NotificationsProvider>();

    final report = await reports.submit(
      result: result,
      location: widget.location,
      segmentId: widget.segmentId,
      areaName: widget.areaName,
      description: widget.description.isEmpty ? null : widget.description,
      approximate: widget.approximate,
      classifiedByAi: _state == AiReviewState.done && !_corrected,
    );

    app.recordReportSubmitted();

    // Re-score any routes currently on screen, which is the moment the demo is
    // built around: a new report changes the route cards immediately.
    routes.rescore(reports.live);

    if (result.doNotPublish) {
      notifications.push(
        AppNotification(
          id: 'nt_${DateTime.now().microsecondsSinceEpoch}',
          kind: NotificationKind.reportWithheld,
          title: 'Your report was not published',
          body:
              'It appeared to identify a specific person. Reports about '
              'identifiable individuals are never published.',
          createdAt: DateTime.now(),
          reportId: report.id,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      FadeScaleRoute(
        child: ReportSuccessScreen(
          reportId: report.id,
          withheld: result.doNotPublish,
          withheldReason: result.withheldReason,
        ),
      ),
    );
  }

  Future<void> _cancel() async {
    final ok = await confirmAction(
      context,
      title: 'Cancel this report?',
      message: 'Nothing will be published and your text will not be saved.',
      confirmLabel: 'Cancel report',
      cancelLabel: 'Keep it',
      destructive: true,
      icon: Icons.close_rounded,
    );
    if (ok && mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review before publishing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: switch (_state) {
        AiReviewState.idle || AiReviewState.thinking => _Thinking(
            text: widget.description,
          ),
        _ => _review(context, gutter),
      },
      bottomNavigationBar: _state == AiReviewState.thinking
          ? null
          : _actions(context),
    );
  }

  // --- Review body ------------------------------------------------------------

  Widget _review(BuildContext context, double gutter) {
    final result = _result!;
    final blocked = result.doNotPublish;
    final invalid = result.category == ReportCategory.invalid;
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.xxl),
      children: [
        // --- Classifier unavailable -------------------------------------------
        if (_state == AiReviewState.failed) ...[
          InfoPanel(
            title: 'Automatic reading unavailable',
            text:
                '$_failureReason The app has fallen back to the category you '
                'picked, and route awareness still updates normally.',
            icon: Icons.cloud_off_rounded,
            tone: AppColors.awarenessModerate,
            action: TextButton(
              onPressed: _classify,
              child: const Text('Try reading it again'),
            ),
          ),
          const SizedBox(height: Gap.lg),
        ],

        // --- Blocked: identifies a person --------------------------------------
        if (blocked) ...[
          _BlockedCard(reason: result.withheldReason ?? ''),
          const SizedBox(height: Gap.lg),
        ]
        // --- Too vague ----------------------------------------------------------
        else if (invalid) ...[
          InfoPanel(
            title: 'Not enough detail to publish',
            text:
                'We could not tell what this report is about. Add a few more '
                'words, or pick the category yourself.',
            icon: Icons.help_outline_rounded,
            tone: AppColors.awarenessModerate,
            action: TextButton(
              onPressed: _changeCategory,
              child: const Text('Choose a category myself'),
            ),
          ),
          const SizedBox(height: Gap.lg),
        ]
        // --- The normal path ----------------------------------------------------
        else ...[
          Text(
            'We understood this as',
            style: t.bodyMedium?.copyWith(color: context.tokens.textSecondary),
          ),
          const SizedBox(height: Gap.sm),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: result.category.color
                      .withValues(alpha: context.isDark ? 0.22 : 0.11),
                  borderRadius: Radii.allMd,
                ),
                child: Icon(
                  result.specificType.icon,
                  size: 22,
                  color: result.category.color,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.specificType.label, style: t.headlineSmall),
                    Text(
                      result.category.label,
                      style: t.labelMedium
                          ?.copyWith(color: context.tokens.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),

          // Low-confidence readings say so, loudly.
          if (result.band == ConfidenceBand.low)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.lg),
              child: InfoPanel(
                title: 'Low confidence',
                text:
                    'We are not sure this is right. Please check the category '
                    'before publishing.',
                icon: Icons.priority_high_rounded,
                tone: AppColors.awarenessElevated,
              ),
            ),

          if (result.duplicateOfReportId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.lg),
              child: InfoPanel(
                title: 'Someone may have reported this already',
                text:
                    'A very similar report was submitted nearby in the last '
                    '45 minutes. Publishing yours will count as a confirmation, '
                    'which makes the signal stronger.',
                icon: Icons.copy_all_outlined,
                tone: AppColors.brand,
              ),
            ),

          // --- What others will see --------------------------------------------
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: context.tokens.textSecondary,
                    ),
                    const SizedBox(width: Gap.sm),
                    Text('What other travellers will see', style: t.titleSmall),
                  ],
                ),
                const SizedBox(height: Gap.md),
                Text(result.safePublicText, style: t.bodyLarge),
                const SizedBox(height: Gap.md),
                Wrap(
                  spacing: Gap.sm - 2,
                  runSpacing: Gap.sm - 3,
                  children: [
                    ConfidenceChip(band: result.band, dense: true),
                    Pill(
                      label: 'Severity ${result.severity.label.toLowerCase()}',
                      icon: Icons.speed_rounded,
                      color: result.severity.color,
                      dense: true,
                    ),
                    Pill(
                      label: result.language.label,
                      icon: Icons.translate_rounded,
                      color: context.tokens.textSecondary,
                      dense: true,
                    ),
                    if (_corrected)
                      Pill(
                        label: 'You corrected this',
                        icon: Icons.edit_outlined,
                        color: context.scheme.primary,
                        dense: true,
                      ),
                    Pill(
                      label: 'Unverified until confirmed',
                      icon: Icons.schedule_outlined,
                      color: AppColors.awarenessModerate,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),

          // --- Route effect ------------------------------------------------------
          SafarCard(
            padding: const EdgeInsets.all(Gap.md),
            child: Row(
              children: [
                Icon(
                  Icons.alt_route_rounded,
                  size: 18,
                  color: context.scheme.primary,
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Effect on routing', style: t.titleSmall),
                      const SizedBox(height: 1),
                      Text(
                        '${result.specificType.routeEffect} on ${widget.areaName}',
                        style: t.labelMedium?.copyWith(
                          color: context.tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // --- Your original words ------------------------------------------------
        if (widget.description.isNotEmpty) ...[
          const SizedBox(height: Gap.md),
          SafarCard(
            elevated: false,
            color: context.tokens.surfaceAlt,
            padding: const EdgeInsets.all(Gap.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What you wrote', style: t.labelSmall),
                const SizedBox(height: Gap.sm - 2),
                Text('"${widget.description}"', style: t.bodySmall),
                const SizedBox(height: Gap.sm),
                Text(
                  'Only you can see your original wording. Others see the '
                  'neutral summary above.',
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textTertiary),
                ),
              ],
            ),
          ),
        ],

        // --- The raw JSON, for the judges ----------------------------------------
        if (!blocked) ...[
          const SizedBox(height: Gap.md),
          _JsonPeek(result: _result!),
        ],

        const SizedBox(height: Gap.md),
        InfoPanel(
          text: widget.approximate
              ? 'This report will be published at an approximate location.'
              : 'This report will be published anonymously.',
          icon: widget.approximate
              ? Icons.blur_on_rounded
              : Icons.lock_outline_rounded,
          dense: true,
        ),
      ],
    );
  }

  // --- Actions ----------------------------------------------------------------

  Widget _actions(BuildContext context) {
    final result = _result;
    final blocked = result?.doNotPublish ?? false;
    final invalid = result?.category == ReportCategory.invalid;

    if (blocked) {
      return StickyActionBar(
        note: 'Nothing about an identifiable person will be published.',
        primary: FilledButton(
          onPressed: _submitting ? null : _confirm,
          child: const Text('I understand — go back'),
        ),
        secondary: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Edit my description'),
        ),
      );
    }

    return StickyActionBar(
      note: invalid ? 'Pick a category to publish this report.' : null,
      primary: FilledButton.icon(
        onPressed: _submitting || invalid ? null : _confirm,
        icon: _submitting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_rounded, size: 19),
        label: Text(_submitting ? 'Publishing…' : 'Confirm and publish'),
      ),
      secondary: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _submitting ? null : _changeCategory,
              child: const Text('Change category'),
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: OutlinedButton(
              onPressed: _submitting ? null : _cancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.scheme.error,
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Thinking extends StatelessWidget {
  const _Thinking({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.x3l, gutter, Gap.xxl),
      children: [
        Center(
          child: _PulsingIcon(
            icon: Icons.auto_awesome_rounded,
            colour: context.scheme.primary,
          ),
        ),
        const SizedBox(height: Gap.xl),
        Text(
          'Reading your report…',
          textAlign: TextAlign.center,
          style: t.headlineSmall,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          text.isEmpty
              ? 'Checking the issue you selected and the location.'
              : 'Working out the category, severity and a neutral public summary.',
          textAlign: TextAlign.center,
          style: t.bodyMedium?.copyWith(color: context.tokens.textSecondary),
        ),
        const SizedBox(height: Gap.x3l),
        if (text.isNotEmpty)
          SafarCard(
            elevated: false,
            color: context.tokens.surfaceAlt,
            child: Text('"$text"', style: t.bodyMedium),
          ),
        const SizedBox(height: Gap.xl),
        const LoadingList(count: 2),
      ],
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.icon, required this.colour});

  final IconData icon;
  final Color colour;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_c.value);
        return Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.colour.withValues(alpha: 0.08 + 0.10 * t),
          ),
          child: Center(
            child: Transform.scale(
              scale: 0.92 + 0.14 * t,
              child: Icon(widget.icon, size: 32, color: widget.colour),
            ),
          ),
        );
      },
    );
  }
}

class _BlockedCard extends StatelessWidget {
  const _BlockedCard({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafarCard(
      borderColor: context.scheme.error.withValues(alpha: 0.4),
      color: context.scheme.error.withValues(alpha: context.isDark ? 0.12 : 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.scheme.error.withValues(alpha: 0.14),
                  borderRadius: Radii.allMd,
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  color: context.scheme.error,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Text(
                  'This report cannot be published',
                  style: t.titleLarge?.copyWith(color: context.scheme.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          Text(reason, style: t.bodyMedium?.copyWith(height: 1.5)),
          const SizedBox(height: Gap.md),
          Text(
            'You can still report the condition itself — for example "this lane '
            'feels unsafe at night" — without describing a person.',
            style: t.bodySmall?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Collapsible view of the exact JSON the classifier returned. Useful during a
/// demo, and it keeps the contract honest: this is what a real Gemini response
/// has to look like.
class _JsonPeek extends StatefulWidget {
  const _JsonPeek({required this.result});

  final AiReportResult result;

  @override
  State<_JsonPeek> createState() => _JsonPeekState();
}

class _JsonPeekState extends State<_JsonPeek> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final json = widget.result.toJson();

    return SafarCard(
      padding: const EdgeInsets.all(Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: Radii.allSm,
            child: Row(
              children: [
                Icon(
                  Icons.data_object_rounded,
                  size: 16,
                  color: context.tokens.textSecondary,
                ),
                const SizedBox(width: Gap.sm),
                Expanded(
                  child: Text(
                    'Structured output',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: Motion.base,
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 19,
                    color: context.tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Motion.base,
            curve: Motion.emphasized,
            alignment: Alignment.topCenter,
            child: _open
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: Gap.md),
                    padding: const EdgeInsets.all(Gap.md),
                    decoration: BoxDecoration(
                      color: context.tokens.isDark
                          ? const Color(0xFF060C16)
                          : const Color(0xFF111A28),
                      borderRadius: Radii.allSm,
                    ),
                    child: Text(
                      _pretty(json),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        height: 1.55,
                        color: Color(0xFFC9D6E5),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  static String _pretty(Map<String, Object?> json) {
    final buffer = StringBuffer('{\n');
    final entries = json.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final value = entries[i].value;
      final rendered = value is String ? '"$value"' : '$value';
      buffer.write('  "${entries[i].key}": $rendered');
      buffer.write(i == entries.length - 1 ? '\n' : ',\n');
    }
    buffer.write('}');
    return buffer.toString();
  }
}
