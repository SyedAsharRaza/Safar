import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_state.dart';
import '../../state/checkin_provider.dart';
import '../../state/notifications_provider.dart';
import '../../state/places_provider.dart';
import '../../state/reports_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/safar_map.dart';

/// Presenter's control panel.
///
/// Every interesting edge case in this prototype is reachable from here, so a
/// demo can show the empty state, the error state, the offline path and the
/// AI-failure fallback on demand instead of hoping they turn up.
class DemoPanelScreen extends StatelessWidget {
  const DemoPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final reports = context.watch<ReportsProvider>();
    final places = context.watch<PlacesProvider>();
    final checkin = context.watch<CheckinProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo controls'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
        children: [
          const InfoPanel(
            title: 'For presenting, not for users',
            text:
                'These switches exist so every state in the prototype can be '
                'shown on demand. In a production build this screen would not '
                'ship.',
            icon: Icons.slideshow_rounded,
            tone: AppColors.accentDeep,
          ),

          // --- Persona ----------------------------------------------------------
          const SizedBox(height: Gap.xl),
          Text(
            'User persona',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Gap.sm),
          SegmentedSelector<DemoPersona>(
            values: DemoPersona.values,
            selected: app.persona,
            labelOf: (p) => p.label,
            onChanged: (p) {
              app.setPersona(p);
              if (p == DemoPersona.firstTime) {
                places.clearAll();
                checkin.clearContacts();
                context.read<NotificationsProvider>().clearAll();
              } else {
                places.restoreSeed();
                checkin.restoreContacts();
              }
              Toast.show(context, 'Switched to: ${p.label}');
            },
          ),
          const SizedBox(height: Gap.sm),
          Text(
            app.persona.detail,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.tokens.textSecondary,
                ),
          ),

          // --- Data states --------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SettingGroup(
            title: 'Community signal data',
            children: [
              SettingRow(
                title: 'Reload seeded signals',
                subtitle: '${reports.live.length} live right now',
                icon: Icons.refresh_rounded,
                onTap: () {
                  reports.reseed();
                  context.read<RoutesProvider>().rescore(reports.live);
                  Toast.show(context, 'Seeded signals restored.');
                },
              ),
              SettingRow(
                title: 'Empty the map',
                subtitle: 'Shows every "no data" and empty state',
                icon: Icons.layers_clear_outlined,
                onTap: () {
                  reports.clearAll();
                  context.read<RoutesProvider>().rescore(reports.live);
                  Toast.show(
                    context,
                    'All signals cleared. Empty states are now live.',
                  );
                },
              ),
              SettingRow(
                title: 'Force a load failure',
                subtitle: 'Shows the error state with retry',
                icon: Icons.error_outline_rounded,
                onTap: () async {
                  await reports.load(failFirst: true);
                  if (context.mounted) {
                    Toast.show(
                      context,
                      'Load failed on purpose. Pull to retry on Home.',
                      tone: ToastTone.warning,
                    );
                  }
                },
              ),
              SettingRow(
                title: 'Show expired reports',
                subtitle: 'Greyed out, no effect on routing',
                icon: Icons.history_rounded,
                switchValue: reports.includeExpired,
                onSwitch: reports.setIncludeExpired,
              ),
            ],
          ),

          // --- Map surface ----------------------------------------------------
          const SizedBox(height: Gap.xl),
          Text(
            'Map surface',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Gap.sm),
          SegmentedSelector<MapMode>(
            values: MapMode.values,
            selected: app.mapMode,
            labelOf: (m) => m.label,
            onChanged: (m) {
              app.setMapMode(m);
              Toast.show(context, 'Map surface: ${m.label}');
            },
          ),
          const SizedBox(height: Gap.sm),
          Text(
            app.mapMode.detail,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.tokens.textSecondary,
                ),
          ),

          // --- Failure simulation -------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: 'Failure paths',
            children: [
              SettingRow(
                title: 'Break the report classifier',
                subtitle:
                    'Next report falls back to manual category selection',
                icon: Icons.auto_awesome_outlined,
                tone: AppColors.awarenessElevated,
                switchValue: app.simulateAiFailure,
                onSwitch: (v) {
                  app.setSimulateAiFailure(v);
                  Toast.show(
                    context,
                    v
                        ? 'The next classification will fail, on purpose.'
                        : 'Classifier restored.',
                  );
                },
              ),
              SettingRow(
                title: 'Simulate offline',
                subtitle: 'Offline banner plus the cached-data path',
                icon: Icons.wifi_off_rounded,
                tone: AppColors.awarenessElevated,
                switchValue: app.offline,
                onSwitch: app.setOffline,
              ),
            ],
          ),

          // --- Other states ---------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: 'Other states',
            children: [
              SettingRow(
                title: checkin.hasContacts
                    ? 'Remove trusted contacts'
                    : 'Restore trusted contacts',
                subtitle: checkin.hasContacts
                    ? '${checkin.contacts.length} stored — clear to see the empty state'
                    : 'None stored — the empty state is live',
                icon: Icons.people_outline_rounded,
                onTap: () {
                  if (checkin.hasContacts) {
                    checkin.clearContacts();
                    Toast.show(context, 'Contacts cleared.');
                  } else {
                    checkin.restoreContacts();
                    Toast.show(context, 'Contacts restored.');
                  }
                },
              ),
              SettingRow(
                title: places.hasSaved
                    ? 'Clear saved places'
                    : 'Restore saved places',
                subtitle: places.hasSaved
                    ? '${places.saved.length} saved'
                    : 'None saved — the empty state is live',
                icon: Icons.bookmark_border_rounded,
                onTap: () {
                  if (places.hasSaved) {
                    places.clearAll();
                    Toast.show(context, 'Saved places cleared.');
                  } else {
                    places.restoreSeed();
                    Toast.show(context, 'Saved places restored.');
                  }
                },
              ),
              SettingRow(
                title: 'Clear all alerts',
                subtitle: 'Shows the empty Activity tab',
                icon: Icons.notifications_off_outlined,
                onTap: () {
                  context.read<NotificationsProvider>().clearAll();
                  Toast.show(context, 'Alerts cleared.');
                },
              ),
              SettingRow(
                title: 'Reset the current trip',
                subtitle: 'Clears origin, destination and planned routes',
                icon: Icons.restart_alt_rounded,
                onTap: () {
                  context.read<RoutesProvider>()
                    ..setOrigin(null)
                    ..setDestination(null)
                    ..reset();
                  Toast.show(context, 'Trip reset.');
                },
              ),
            ],
          ),

          // --- Demo script -------------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The two-minute demo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: Gap.md),
                for (final step in const [
                  'Home: set Model Town A to Islamia University.',
                  'Compare routes: three options, each explained in plain words.',
                  'Open "Fewer hazards" and play the Roman Urdu voice warning.',
                  'Report: "Aagay gali band hai" — review, then confirm.',
                  'Watch the route cards and the map update.',
                  'Start a safety check-in, then mark yourself arrived.',
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: context.scheme.primary
                                .withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${step.$1 + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: context.scheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: Text(
                            step.$2,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
