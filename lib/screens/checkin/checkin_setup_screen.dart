import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/trusted_contact.dart';
import '../../state/checkin_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import 'checkin_active_screen.dart';
import 'contacts_screen.dart';
import '../../l10n/app_localizations.dart';

/// Set up a safety check-in: how long, and who to notify.
class CheckinSetupScreen extends StatefulWidget {
  const CheckinSetupScreen({
    super.key,
    this.destinationName = '',
    this.routeName = '',
    this.suggestedMinutes,
  });

  final String destinationName;
  final String routeName;

  /// Pre-selects the closest duration to the planned route time.
  final int? suggestedMinutes;

  @override
  State<CheckinSetupScreen> createState() => _CheckinSetupScreenState();
}

class _CheckinSetupScreenState extends State<CheckinSetupScreen> {
  late Duration _duration = _initialDuration();
  late Set<String> _selected = {};
  bool _shareLocation = true;

  Duration _initialDuration() {
    final target = widget.suggestedMinutes;
    if (target == null) return const Duration(minutes: 20);
    // Pick the shortest option that still covers the journey, plus slack.
    return AppLimits.checkinDurations.firstWhere(
      (d) => d.inMinutes >= target + 5,
      orElse: () => AppLimits.checkinDurations.last,
    );
  }

  @override
  void initState() {
    super.initState();
    final primary = context.read<CheckinProvider>().primaryContact;
    if (primary != null) _selected = {primary.id};
  }

  Future<void> _start() async {
    final checkin = context.read<CheckinProvider>();

    if (checkin.hasActive) {
      // Repeating an action that is already running: offer to open it instead
      // of quietly starting a second timer.
      final open = await confirmAction(
        context,
        title: L.of(context).checkAlreadyRunning,
        message:
            L.of(context).onlyOneCheckTimeOpen,
        confirmLabel: L.of(context).open2,
        cancelLabel: L.of(context).stayHere,
        icon: Icons.timer_rounded,
      );
      if (open && mounted) {
        Navigator.of(context).pushReplacement(
          SlideUpRoute(child: const CheckinActiveScreen()),
        );
      }
      return;
    }

    final contacts =
        checkin.contacts.where((c) => _selected.contains(c.id)).toList();

    if (contacts.isEmpty) {
      final proceed = await confirmAction(
        context,
        title: L.of(context).startWithoutContact,
        message:
            L.of(context).nobodyWillToldIfDo,
        confirmLabel: L.of(context).startAnyway,
        cancelLabel: L.of(context).chooseContact,
        icon: Icons.person_off_outlined,
      );
      if (!proceed || !mounted) return;
    }

    checkin.start(
      duration: _duration,
      notify: contacts,
      destinationName: widget.destinationName,
      routeName: widget.routeName,
      shareLocation: _shareLocation,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      SlideUpRoute(child: const CheckinActiveScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).safetyCheckin),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.xxl),
        children: [
          Text(
            widget.destinationName.isEmpty
                ? 'Tell someone you are travelling'
                : 'Heading to ${widget.destinationName}',
            style: t.headlineMedium,
          ),
          const SizedBox(height: Gap.sm),
          Text(
            L.of(context).setTimerIfDoConfirm,
            style: t.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: Gap.xl),

          // --- Duration ---------------------------------------------------------
          Text(L.of(context).howLongDoExpectTake, style: t.titleMedium),
          const SizedBox(height: Gap.md),
          Wrap(
            spacing: Gap.sm,
            runSpacing: Gap.sm,
            children: [
              for (final d in AppLimits.checkinDurations)
                SelectableChip(
                  label: '${d.inMinutes} min',
                  selected: _duration == d,
                  onTap: () => setState(() => _duration = d),
                ),
            ],
          ),
          if (widget.suggestedMinutes != null) ...[
            const SizedBox(height: Gap.md),
            Row(
              children: [
                Pill(
                  label:
                      '${widget.routeName} is about ${widget.suggestedMinutes} min',
                  icon: Icons.alt_route_rounded,
                  color: context.scheme.primary,
                  dense: true,
                ),
              ],
            ),
          ],
          const SizedBox(height: Gap.xl),

          // --- Contacts -----------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: Text(L.of(context).whoShouldNotified, style: t.titleMedium),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context)
                    .push(SlideRoute(child: const ContactsScreen())),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(L.of(context).manage),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),

          if (!checkin.hasContacts)
            SafarCard(
              child: EmptyState(
                compact: true,
                icon: Icons.person_add_alt_1_outlined,
                title: L.of(context).noTrustedContactsYet,
                message:
                    L.of(context).addSomeoneWouldWantKnow,
                primaryLabel: L.of(context).addContact,
                onPrimary: () => Navigator.of(context)
                    .push(SlideRoute(child: const ContactsScreen())),
              ),
            )
          else
            for (final c in checkin.contacts)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.sm),
                child: _ContactRow(
                  contact: c,
                  selected: _selected.contains(c.id),
                  onToggle: () => setState(() {
                    if (!_selected.remove(c.id)) _selected.add(c.id);
                  }),
                ),
              ),

          const SizedBox(height: Gap.lg),

          // --- Options -------------------------------------------------------------
          SettingGroup(
            children: [
              SettingRow(
                title: L.of(context).shareMyLivePosition,
                subtitle:
                    L.of(context).simulatedBuildNoLocationPermission,
                icon: Icons.share_location_rounded,
                switchValue: _shareLocation,
                onSwitch: (v) => setState(() => _shareLocation = v),
              ),
            ],
          ),

          const SizedBox(height: Gap.lg),
          const InfoPanel(
            text: AppText.notEmergency,
            icon: Icons.emergency_outlined,
            tone: AppColors.danger,
          ),
        ],
      ),
      bottomNavigationBar: StickyActionBar(
        note: _selected.isEmpty
            ? 'No contact selected — only you will see the timer.'
            : '${_selected.length} contact${_selected.length == 1 ? '' : 's'} will be notified (simulated).',
        primary: FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: Text('Start ${_duration.inMinutes}-minute check-in'),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.contact,
    required this.selected,
    required this.onToggle,
  });

  final TrustedContact contact;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SafarCard(
      onTap: onToggle,
      padding: const EdgeInsets.all(Gap.md),
      borderColor:
          selected ? context.scheme.primary.withValues(alpha: 0.6) : null,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.tokens.surfaceAlt,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              contact.initials,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (contact.isPrimary) ...[
                      const SizedBox(width: Gap.sm),
                      Pill(
                        label: L.of(context).primary,
                        color: context.scheme.tertiary,
                        dense: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  '${contact.relation} · ${contact.maskedPhone}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.tokens.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: selected,
            onChanged: (_) => onToggle(),
            shape: const RoundedRectangleBorder(borderRadius: Radii.allXs),
          ),
        ],
      ),
    );
  }
}
