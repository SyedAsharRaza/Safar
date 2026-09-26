import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/taxonomy.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../state/checkin_provider.dart';
import '../../state/places_provider.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/surfaces.dart';
import '../checkin/contacts_screen.dart';
import '../info/about_screen.dart';
import '../info/help_screen.dart';
import '../onboarding/splash_screen.dart';
import 'saved_places_screen.dart';
import 'settings_screen.dart';

/// Profile: anonymous identity, contribution stats, and the way into settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final reports = context.watch<ReportsProvider>();
    final places = context.watch<PlacesProvider>();
    final checkin = context.watch<CheckinProvider>();
    final profile = app.profile;
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 120),
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + Gap.lg),

          // --- Identity ----------------------------------------------------------
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand, AppColors.brandDeep],
                  ),
                  borderRadius: Radii.allLg,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: Gap.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.handle, style: t.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      profile.isAnonymous
                          ? 'Anonymous · joined ${TimeUtils.dayMonth(profile.joinedAt)}'
                          : 'Joined ${TimeUtils.dayMonth(profile.joinedAt)}',
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Settings',
                onPressed: () => Navigator.of(context)
                    .push(SlideRoute(child: const SettingsScreen())),
                icon: const Icon(Icons.settings_outlined, size: 22),
              ),
            ],
          ),

          const SizedBox(height: Gap.lg),
          const InfoPanel(
            text:
                'You are signed in anonymously. Your reports carry no name, and '
                'nothing links them to your identity.',
            icon: Icons.visibility_off_outlined,
            dense: true,
          ),

          // --- Contribution tier ---------------------------------------------------
          const SizedBox(height: Gap.xl),
          _TierCard(profile: profile),

          // --- Stats -----------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  value: '${profile.reportsSubmitted}',
                  label: 'Reports made',
                  icon: Icons.campaign_outlined,
                ),
              ),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: StatTile(
                  value: '${profile.confirmationsGiven}',
                  label: 'Signals confirmed',
                  icon: Icons.how_to_reg_outlined,
                  tone: AppColors.teal,
                ),
              ),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: StatTile(
                  value: '${profile.tripsCompared}',
                  label: 'Trips compared',
                  icon: Icons.alt_route_rounded,
                  tone: AppColors.accentDeep,
                ),
              ),
            ],
          ),

          // --- Shortcuts --------------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SettingGroup(
            title: 'Your stuff',
            children: [
              SettingRow(
                title: 'Saved places',
                subtitle: places.saved.isEmpty
                    ? 'Nothing saved yet'
                    : '${places.saved.length} saved',
                icon: Icons.bookmark_border_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const SavedPlacesScreen())),
              ),
              SettingRow(
                title: 'Trusted contacts',
                subtitle: checkin.contacts.isEmpty
                    ? 'None added'
                    : '${checkin.contacts.length} contact${checkin.contacts.length == 1 ? '' : 's'}',
                icon: Icons.people_outline_rounded,
                tone: AppColors.teal,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const ContactsScreen())),
              ),
              SettingRow(
                title: 'My reports',
                subtitle: '${reports.mine.length} submitted',
                icon: Icons.history_rounded,
                tone: AppColors.accentDeep,
                onTap: () => Toast.show(
                  context,
                  'Your reports live under the Activity tab.',
                ),
              ),
            ],
          ),

          // --- Preferences -------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: 'Preferences',
            children: [
              SettingRow(
                title: 'Language',
                value: app.language.nativeLabel,
                icon: Icons.translate_rounded,
                onTap: () => _languageSheet(context, app),
              ),
              SettingRow(
                title: 'Voice warnings',
                subtitle: 'Short spoken alerts before you set off',
                icon: Icons.volume_up_outlined,
                switchValue: app.voiceWarnings,
                onSwitch: app.toggleVoiceWarnings,
              ),
              SettingRow(
                title: 'Appearance',
                value: switch (app.themeMode) {
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                  ThemeMode.system => 'System',
                },
                icon: Icons.dark_mode_outlined,
                onTap: () => _themeSheet(context, app),
              ),
              SettingRow(
                title: 'All settings',
                icon: Icons.tune_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const SettingsScreen())),
              ),
            ],
          ),

          // --- About -------------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SettingGroup(
            title: 'About',
            children: [
              SettingRow(
                title: 'How route awareness works',
                icon: Icons.help_outline_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const HelpScreen())),
              ),
              SettingRow(
                title: 'About Bahawalpur Safar',
                icon: Icons.info_outline_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const AboutScreen())),
              ),
              SettingRow(
                title: 'Sign out',
                subtitle: 'Returns to onboarding',
                icon: Icons.logout_rounded,
                destructive: true,
                onTap: () async {
                  final ok = await confirmAction(
                    context,
                    title: 'Sign out?',
                    message:
                        'You will go back to the onboarding screens. Nothing is '
                        'deleted — this prototype keeps its demo data.',
                    confirmLabel: 'Sign out',
                    destructive: true,
                    icon: Icons.logout_rounded,
                  );
                  if (ok && context.mounted) {
                    context.read<AppState>().signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      FadeScaleRoute(child: const SplashScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: Gap.xl),
          Center(
            child: Column(
              children: [
                Text(
                  '${AppText.appName} · UI prototype',
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textTertiary),
                ),
                const SizedBox(height: Gap.xs),
                Text(
                  AppText.tagline,
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _languageSheet(BuildContext context, AppState app) {
    showSafarSheet<void>(
      context,
      title: 'Language',
      subtitle: 'Sets voice warnings and prompt wording.',
      scrollable: false,
      child: Column(
        children: [
          for (final l in [
            ReportLanguage.english,
            ReportLanguage.romanUrdu,
            ReportLanguage.urdu,
          ])
            RadioListTile<ReportLanguage>(
              value: l,
              // ignore: deprecated_member_use
              groupValue: app.language,
              contentPadding: EdgeInsets.zero,
              title: Text(l.nativeLabel),
              subtitle: Text(l.label),
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) app.setLanguage(v);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  void _themeSheet(BuildContext context, AppState app) {
    showSafarSheet<void>(
      context,
      title: 'Appearance',
      scrollable: false,
      child: Column(
        children: [
          for (final mode in ThemeMode.values)
            RadioListTile<ThemeMode>(
              value: mode,
              // ignore: deprecated_member_use
              groupValue: app.themeMode,
              contentPadding: EdgeInsets.zero,
              title: Text(switch (mode) {
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
                ThemeMode.system => 'Match my device',
              }),
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) app.setThemeMode(v);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

/// Contribution tier. Recognition only — a high tier never marks a report as
/// verified, which would defeat the point of corroboration.
class _TierCard extends StatelessWidget {
  const _TierCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final next = profile.tier.next;

    return SafarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent
                      .withValues(alpha: context.isDark ? 0.22 : 0.12),
                  borderRadius: Radii.allSm,
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  size: 20,
                  color: AppColors.accentDeep,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.tier.label, style: t.titleMedium),
                    Text(
                      next == null
                          ? 'Top contribution tier'
                          : '${profile.reportsToNext} more report${profile.reportsToNext == 1 ? '' : 's'} to ${next.label}',
                      style: t.labelMedium
                          ?.copyWith(color: context.tokens.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          ClipRRect(
            borderRadius: Radii.pill,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: profile.progressToNext),
              duration: Motion.slow,
              curve: Motion.enter,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 7,
                color: AppColors.accentDeep,
              ),
            ),
          ),
          const SizedBox(height: Gap.md),
          Text(
            'Tiers recognise contribution. They never make a report count as '
            'verified — only confirmations from other travellers do that.',
            style: t.labelMedium?.copyWith(color: context.tokens.textTertiary),
          ),
        ],
      ),
    );
  }
}
