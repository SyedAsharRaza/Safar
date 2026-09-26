import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/safety_checkin.dart';
import '../../state/checkin_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../info/emergency_sheet.dart';

/// The running check-in: countdown, contacts, and the two ways out.
class CheckinActiveScreen extends StatelessWidget {
  const CheckinActiveScreen({super.key});

  Future<void> _arrived(BuildContext context) async {
    context.read<CheckinProvider>().arrived();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    Toast.show(
      context,
      'Marked as arrived. Your contacts would be told you are safe.',
      tone: ToastTone.success,
      icon: Icons.check_circle_outline,
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final ok = await confirmAction(
      context,
      title: 'Cancel the check-in?',
      message:
          'The timer stops and your contacts will not be notified either way. '
          'You can start a new one whenever you like.',
      confirmLabel: 'Cancel check-in',
      cancelLabel: 'Keep it running',
      destructive: true,
      icon: Icons.timer_off_outlined,
    );
    if (!ok || !context.mounted) return;
    context.read<CheckinProvider>().cancel();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    Toast.show(context, 'Check-in cancelled.');
  }

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final active = checkin.active;
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    if (active == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: EmptyState(
          icon: Icons.timer_off_outlined,
          title: 'No check-in running',
          message:
              'This check-in has already finished. Start a new one from the home '
              'screen when you next set off.',
          primaryLabel: 'Back',
          onPrimary: () => Navigator.of(context).pop(),
        ),
      );
    }

    final overdue = active.status == CheckinStatus.overdue;
    final tone = overdue ? AppColors.danger : AppColors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Emergency numbers',
            onPressed: () => showEmergencySheet(context),
            icon: const Icon(Icons.emergency_outlined, size: 21),
          ),
          SizedBox(width: gutter - Gap.md),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.xl, gutter, Gap.xxl),
        children: [
          Center(
            child: _CountdownRing(
              progress: active.progress,
              tone: tone,
              overdue: overdue,
              label: overdue
                  ? TimeUtils.clock(active.overdueBy)
                  : TimeUtils.clock(active.remaining),
              caption: overdue ? 'overdue by' : 'remaining',
            ),
          ),
          const SizedBox(height: Gap.xxl),

          if (overdue)
            InfoPanel(
              title: 'Your check-in window has passed',
              text:
                  'In the full product your contacts would have been reminded to '
                  'check on you by now. Let them know you are safe, or extend the '
                  'timer if you are still on the way.',
              icon: Icons.notification_important_rounded,
              tone: AppColors.danger,
            )
          else
            InfoPanel(
              text:
                  'Notifying contacts is simulated in this UI build — no message '
                  'is actually sent.',
              icon: Icons.info_outline,
              dense: true,
            ),

          const SizedBox(height: Gap.xl),

          // --- Trip -------------------------------------------------------------
          SafarCard(
            child: Column(
              children: [
                _Row(
                  icon: Icons.place_outlined,
                  label: 'Destination',
                  value: active.destinationName.isEmpty
                      ? 'Not set'
                      : active.destinationName,
                ),
                _Row(
                  icon: Icons.alt_route_rounded,
                  label: 'Route',
                  value: active.routeName.isEmpty ? 'Not set' : active.routeName,
                ),
                _Row(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Started',
                  value: TimeUtils.timeOfDay(active.startedAt),
                ),
                _Row(
                  icon: Icons.flag_outlined,
                  label: 'Due by',
                  value: TimeUtils.timeOfDay(active.dueAt),
                ),
                _Row(
                  icon: Icons.share_location_rounded,
                  label: 'Live position',
                  value: active.shareLiveLocation
                      ? 'Shared (simulated)'
                      : 'Not shared',
                  last: true,
                ),
              ],
            ),
          ),

          // --- Contacts -----------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SectionHeader(
            title: active.contacts.isEmpty
                ? 'No contacts on this check-in'
                : 'Watching out for you',
            padding: const EdgeInsets.only(bottom: Gap.md),
          ),
          if (active.contacts.isEmpty)
            const InfoPanel(
              text:
                  'You started this check-in without a contact, so the timer is '
                  'just for you. Adding someone makes it far more useful.',
              icon: Icons.person_off_outlined,
              dense: true,
            )
          else
            for (final c in active.contacts)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.sm),
                child: SafarCard(
                  padding: const EdgeInsets.all(Gap.md),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: tone.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(c.initials, style: t.titleSmall),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(c.name, style: t.titleMedium),
                            Text(
                              '${c.relation} · ${c.maskedPhone}',
                              style: t.labelMedium?.copyWith(
                                color: context.tokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pill(
                        label: overdue ? 'Would be alerted' : 'Standing by',
                        color: tone,
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),

          const SizedBox(height: Gap.xl),
          OutlinedButton.icon(
            onPressed: () {
              context.read<CheckinProvider>().extend(
                    const Duration(minutes: 10),
                  );
              Toast.show(context, 'Added 10 minutes to your check-in.');
            },
            icon: const Icon(Icons.more_time_rounded, size: 18),
            label: const Text('Need 10 more minutes'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyActionBar(
        primary: FilledButton.icon(
          onPressed: () => _arrived(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.awarenessLow,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.check_circle_outline, size: 20),
          label: const Text('I arrived safely'),
        ),
        secondary: OutlinedButton(
          onPressed: () => _cancel(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.scheme.error,
          ),
          child: const Text('Cancel check-in'),
        ),
      ),
    );
  }
}

/// Circular countdown. Sweeps down as the window closes, and pulses when overdue.
class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    required this.progress,
    required this.tone,
    required this.overdue,
    required this.label,
    required this.caption,
  });

  final double progress;
  final Color tone;
  final bool overdue;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212,
      height: 212,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(212),
            painter: _RingPainter(
              progress: overdue ? 1 : progress,
              tone: tone,
              track: context.tokens.isDark
                  ? context.tokens.surfaceAlt
                  : const Color(0xFFE6EAF1),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 40, color: tone),
              ),
              const SizedBox(height: Gap.xs),
              Text(
                caption,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.tone,
    required this.track,
  });

  final double progress;
  final Color tone;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 13.0;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = tone
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.tone != tone;
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Gap.md),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.tokens.textTertiary),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.tokens.textSecondary,
                  ),
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
