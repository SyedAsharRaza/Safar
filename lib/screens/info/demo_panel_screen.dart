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
import '../../l10n/app_localizations.dart';

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
        title: Text(L.of(context).demoControls),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
        children: [
          InfoPanel(
            title: L.of(context).presentingUsers,
            text:
                L.of(context).theseSwitchesExistSoEvery,
            icon: Icons.slideshow_rounded,
            tone: AppColors.accentDeep,
          ),

          // --- Persona ----------------------------------------------------------
          const SizedBox(height: Gap.xl),
          Text(
            L.of(context).userPersona,
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
                context.read<NotificationsProvider>().clearAll();
              } else {
                places.restoreSeed();
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
            title: L.of(context).communitySignalData,
            children: [
              SettingRow(
                title: L.of(context).reloadSeededSignals,
                subtitle: '${reports.live.length} live right now',
                icon: Icons.refresh_rounded,
                onTap: () {
                  reports.reseed();
                  context.read<RoutesProvider>().rescore(reports.live);
                  Toast.show(context, 'Seeded signals restored.');
                },
              ),
              SettingRow(
                title: L.of(context).emptyMap,
                subtitle: L.of(context).showsEveryNoDataEmpty,
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
                title: L.of(context).forceLoadFailure,
                subtitle: L.of(context).showsErrorStateRetry,
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
                title: L.of(context).showExpiredReports,
                subtitle: L.of(context).greyedOutNoEffectRouting,
                icon: Icons.history_rounded,
                switchValue: reports.includeExpired,
                onSwitch: reports.setIncludeExpired,
              ),
            ],
          ),

          // --- Backend ---------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SettingGroup(
            title: L.of(context).backend,
            children: [
              SettingRow(
                title: reports.isLiveData ? 'Connected' : 'Demonstration data',
                subtitle: reports.isLiveData
                    ? 'Reports are coming from the live API'
                    : reports.backendNotice ?? 'Using seeded signals on device',
                icon: reports.isLiveData
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                tone: reports.isLiveData
                    ? AppColors.awarenessLow
                    : AppColors.awarenessModerate,
                onTap: () async {
                  await reports.load(offline: app.offline);
                  if (context.mounted) {
                    Toast.show(
                      context,
                      reports.isLiveData
                          ? 'Connected to the live API.'
                          : 'Still on demonstration data.',
                      tone: reports.isLiveData
                          ? ToastTone.success
                          : ToastTone.warning,
                    );
                  }
                },
              ),
              SettingRow(
                title: L.of(context).sendTestNotification,
                subtitle: L.of(context).pushesEverySubscribedDevice,
                icon: Icons.notifications_active_outlined,
                tone: AppColors.brand,
                onTap: () async {
                  try {
                    await reports.api.sendTestNotification();
                    if (context.mounted) {
                      Toast.show(
                        context,
                        'Test notification sent.',
                        tone: ToastTone.success,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Toast.show(context, '$e', tone: ToastTone.danger);
                    }
                  }
                },
              ),
            ],
          ),

          // --- Map surface ----------------------------------------------------
          const SizedBox(height: Gap.xl),
          Text(
            L.of(context).mapSurface,
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
            title: L.of(context).failurePaths,
            children: [
              SettingRow(
                title: L.of(context).breakReportClassifier,
                subtitle:
                    L.of(context).nextReportFallsBackManual,
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
                title: L.of(context).simulateOffline,
                subtitle: L.of(context).offlineBannerPlusCachedData,
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
            title: L.of(context).otherStates,
            children: [
              SettingRow(
                title: L.of(context).clearTrustedContacts,
                subtitle: checkin.hasContacts
                    ? '${checkin.contacts.length} saved on this device'
                    : 'None saved — the empty state is live',
                icon: Icons.people_outline_rounded,
                onTap: () {
                  checkin.clearContacts();
                  Toast.show(context, 'Trusted contacts cleared.');
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
                title: L.of(context).clearAllAlerts,
                subtitle: L.of(context).showsEmptyActivityTab,
                icon: Icons.notifications_off_outlined,
                onTap: () {
                  context.read<NotificationsProvider>().clearAll();
                  Toast.show(context, 'Alerts cleared.');
                },
              ),
              SettingRow(
                title: L.of(context).resetCurrentTrip,
                subtitle: L.of(context).clearsOriginDestinationPlannedRoutes,
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
                  L.of(context).twoMinuteDemo,
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
