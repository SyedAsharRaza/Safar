import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/checkin_provider.dart';
import '../../state/notifications_provider.dart';
import '../../state/places_provider.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/safar_map.dart';
import '../checkin/contacts_screen.dart';
import '../info/about_screen.dart';
import '../info/demo_panel_screen.dart';
import '../info/help_screen.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final reports = context.watch<ReportsProvider>();
    final checkin = context.watch<CheckinProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).settings)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
        children: [
          // --- Language & voice ---------------------------------------------------
          SettingGroup(
            title: L.of(context).languageVoice,
            children: [
              SettingRow(
                title: L.of(context).appLanguage,
                subtitle: L.of(context).warningsPromptsSummaries,
                value: app.language.nativeLabel,
                icon: Icons.translate_rounded,
                onTap: () => _pick<ReportLanguage>(
                  context,
                  title: L.of(context).appLanguage,
                  values: ReportLanguage.selectable,
                  selected: app.language,
                  labelOf: (l) => l.nativeLabel,
                  subtitleOf: (l) => l.label,
                  onPick: app.setLanguage,
                ),
              ),
              SettingRow(
                title: L.of(context).voiceWarnings,
                subtitle: L.of(context).voiceWarningsSub,
                icon: Icons.volume_up_outlined,
                switchValue: app.voiceWarnings,
                onSwitch: app.toggleVoiceWarnings,
              ),
            ],
          ),

          // --- Privacy ----------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: L.of(context).privacy,
            children: [
              SettingRow(
                title: L.of(context).reportAnonymously,
                subtitle: L.of(context).reportsNeverCarryName,
                icon: Icons.visibility_off_outlined,
                tone: AppColors.teal,
                switchValue: app.anonymousByDefault,
                onSwitch: (v) {
                  if (!v) {
                    Toast.show(
                      context,
                      'Anonymous reporting cannot be turned off in this prototype.',
                      tone: ToastTone.warning,
                    );
                    return;
                  }
                  app.toggleAnonymous(v);
                },
              ),
              SettingRow(
                title: L.of(context).blurSensitive,
                subtitle:
                    L.of(context).roundSafetyConcernReportsRoughly,
                icon: Icons.blur_on_rounded,
                tone: AppColors.teal,
                switchValue: app.approximateSensitive,
                onSwitch: app.toggleApproximateSensitive,
              ),
              SettingRow(
                title: L.of(context).trustedContacts,
                subtitle: checkin.contacts.isEmpty
                    ? 'None added'
                    : '${checkin.contacts.length} stored on this device',
                icon: Icons.people_outline_rounded,
                tone: AppColors.teal,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const ContactsScreen())),
              ),
            ],
          ),

          // --- Map and data -------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: L.of(context).mapData,
            children: [
              SettingRow(
                title: L.of(context).showExpiredReports,
                subtitle: L.of(context).greyedOutTheyDoAffect,
                icon: Icons.history_rounded,
                switchValue: reports.includeExpired,
                onSwitch: reports.setIncludeExpired,
              ),
              SettingRow(
                title: L.of(context).mapSurface,
                subtitle: app.mapMode.detail,
                value: app.mapMode.label,
                icon: Icons.map_outlined,
                onTap: () => _pick<MapMode>(
                  context,
                  title: L.of(context).mapSurface,
                  values: MapMode.values,
                  selected: app.mapMode,
                  labelOf: (m) => m.label,
                  subtitleOf: (m) => m.detail,
                  onPick: app.setMapMode,
                ),
              ),
              SettingRow(
                title: L.of(context).appearance,
                value: switch (app.themeMode) {
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                  ThemeMode.system => 'System',
                },
                icon: Icons.dark_mode_outlined,
                onTap: () => _pick<ThemeMode>(
                  context,
                  title: L.of(context).appearance,
                  values: ThemeMode.values,
                  selected: app.themeMode,
                  labelOf: (m) => switch (m) {
                    ThemeMode.light => 'Light',
                    ThemeMode.dark => 'Dark',
                    ThemeMode.system => 'Match my device',
                  },
                  onPick: app.setThemeMode,
                ),
              ),
              SettingRow(
                title: L.of(context).reloadCommunitySignals,
                subtitle: L.of(context).fetchSeededDemonstrationDataAgain,
                icon: Icons.refresh_rounded,
                onTap: () async {
                  await reports.load(offline: app.offline);
                  if (context.mounted) {
                    Toast.show(
                      context,
                      'Signals reloaded.',
                      tone: ToastTone.success,
                    );
                  }
                },
              ),
            ],
          ),

          // --- Demo controls ---------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: L.of(context).prototypeControls,
            children: [
              SettingRow(
                title: L.of(context).demoControlPanel,
                subtitle:
                    L.of(context).switchPersonasForceErrorsEmpty,
                icon: Icons.tune_rounded,
                tone: AppColors.accentDeep,
                onTap: () => Navigator.of(context)
                    .push(SlideUpRoute(child: const DemoPanelScreen())),
              ),
              SettingRow(
                title: L.of(context).simulateOffline,
                subtitle: L.of(context).showsOfflineBannerCachedData,
                icon: Icons.wifi_off_rounded,
                tone: AppColors.accentDeep,
                switchValue: app.offline,
                onSwitch: (v) {
                  app.setOffline(v);
                  Toast.show(
                    context,
                    v
                        ? 'Offline mode on. Cached signals are still shown.'
                        : 'Back online.',
                  );
                },
              ),
            ],
          ),

          // --- About --------------------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: L.of(context).about,
            children: [
              SettingRow(
                title: L.of(context).howRouteAwarenessWorks,
                icon: Icons.help_outline_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const HelpScreen())),
              ),
              SettingRow(
                title: L.of(context).aboutLimitations,
                icon: Icons.info_outline_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const AboutScreen())),
              ),
              SettingRow(
                title: L.of(context).clearLocalData,
                subtitle: L.of(context).resetsSavedPlacesContactsAlerts,
                icon: Icons.delete_outline_rounded,
                destructive: true,
                onTap: () async {
                  final ok = await confirmAction(
                    context,
                    title: L.of(context).clearLocalData2,
                    message:
                        L.of(context).savedPlacesTrustedContactsAlerts,
                    confirmLabel: L.of(context).clearData,
                    destructive: true,
                    icon: Icons.delete_outline_rounded,
                  );
                  if (!ok || !context.mounted) return;
                  context.read<PlacesProvider>().clearAll();
                  context.read<CheckinProvider>().clearContacts();
                  context.read<NotificationsProvider>().clearAll();
                  Toast.show(
                    context,
                    'Local data cleared.',
                    tone: ToastTone.success,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: Gap.xl),
          const InfoPanel(
            text: AppText.uiOnlyBuildNote,
            icon: Icons.construction_rounded,
            dense: true,
          ),
        ],
      ),
    );
  }

  void _pick<T>(
    BuildContext context, {
    required String title,
    required List<T> values,
    required T selected,
    required String Function(T) labelOf,
    required ValueChanged<T> onPick,
    String Function(T)? subtitleOf,
  }) {
    showSafarSheet<void>(
      context,
      title: title,
      scrollable: false,
      child: Column(
        children: [
          for (final v in values)
            RadioListTile<T>(
              value: v,
              // ignore: deprecated_member_use
              groupValue: selected,
              contentPadding: EdgeInsets.zero,
              title: Text(labelOf(v)),
              subtitle: subtitleOf == null ? null : Text(subtitleOf(v)),
              // ignore: deprecated_member_use
              onChanged: (value) {
                if (value != null) onPick(value);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
