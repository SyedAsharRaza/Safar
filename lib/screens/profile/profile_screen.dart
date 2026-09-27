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
import '../auth/auth_screen.dart';
import '../checkin/contacts_screen.dart';
import '../info/about_screen.dart';
import '../info/help_screen.dart';
import 'saved_places_screen.dart';
import 'settings_screen.dart';
import '../../l10n/app_localizations.dart';

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
                    Text(
                      app.hasAccount ? app.displayName : profile.handle,
                      style: t.headlineSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.hasAccount
                          ? 'Account · ${app.account?['phone'] ?? ''}'
                          : 'Anonymous · joined ${TimeUtils.dayMonth(profile.joinedAt)}',
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
          if (app.hasAccount)
            const InfoPanel(
              text:
                  'Your reports are still published anonymously. Other travellers '
                  'never see your name or number — the account only keeps your '
                  'history if you change phone.',
              icon: Icons.verified_user_outlined,
              tone: AppColors.teal,
              dense: true,
            )
          else
            InfoPanel(
              title: 'You are anonymous',
              text:
                  'Everything works without an account. Adding one keeps your '
                  'reports and saved places if you change phone.',
              icon: Icons.visibility_off_outlined,
              action: TextButton(
                onPressed: () => Navigator.of(context).push(
                  SlideUpRoute(
                    child: const AuthScreen(initialMode: AuthMode.signUp),
                  ),
                ),
                child: const Text('Create an account'),
              ),
            ),

          // --- Contribution tier ---------------------------------------------------
          const SizedBox(height: Gap.xl),
          _TierCard(profile: profile),

          // --- Stats -----------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          StatTileRow(
            tiles: [
              StatTile(
                  value: '${profile.reportsSubmitted}',
                  label: 'Reports made',
                  icon: Icons.campaign_outlined,
                ),
              StatTile(
                  value: '${profile.confirmationsGiven}',
                  label: 'Signals confirmed',
                  icon: Icons.how_to_reg_outlined,
                  tone: AppColors.teal,
                ),
              StatTile(
                  value: '${profile.tripsCompared}',
                  label: 'Trips compared',
                  icon: Icons.alt_route_rounded,
                  tone: AppColors.accentDeep,
                ),
            ],
          ),

          // --- Shortcuts --------------------------------------------------------------
          const SizedBox(height: Gap.xl),
          SettingGroup(
            title: 'Your stuff',
            children: [
              SettingRow(
                title: L.of(context).savedPlaces,
                subtitle: places.saved.isEmpty
                    ? 'Nothing saved yet'
                    : '${places.saved.length} saved',
                icon: Icons.bookmark_border_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const SavedPlacesScreen())),
              ),
              SettingRow(
                title: L.of(context).trustedContacts,
                subtitle: checkin.contacts.isEmpty
                    ? 'None added'
                    : '${checkin.contacts.length} contact${checkin.contacts.length == 1 ? '' : 's'}',
                icon: Icons.people_outline_rounded,
                tone: AppColors.teal,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const ContactsScreen())),
              ),
              SettingRow(
                title: L.of(context).myReports,
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
                title: L.of(context).language,
                value: app.language.nativeLabel,
                icon: Icons.translate_rounded,
                onTap: () => _languageSheet(context, app),
              ),
              SettingRow(
                title: L.of(context).voiceWarnings,
                subtitle: 'Short spoken alerts before you set off',
                icon: Icons.volume_up_outlined,
                switchValue: app.voiceWarnings,
                onSwitch: app.toggleVoiceWarnings,
              ),
              SettingRow(
                title: L.of(context).appearance,
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
                title: 'About Safar',
                icon: Icons.info_outline_rounded,
                onTap: () => Navigator.of(context)
                    .push(SlideRoute(child: const AboutScreen())),
              ),
              if (app.hasAccount)
                SettingRow(
                  title: L.of(context).signOut,
                  subtitle: 'Return to anonymous use on this phone',
                  icon: Icons.logout_rounded,
                  destructive: true,
                  onTap: () async {
                    final ok = await confirmAction(
                      context,
                      title: 'Sign out?',
                      message:
                          'You will keep using Safar anonymously. Your reports '
                          'stay on your account and come back when you sign in.',
                      confirmLabel: 'Sign out',
                      destructive: true,
                      icon: Icons.logout_rounded,
                    );
                    if (!ok || !context.mounted) return;
                    final reports = context.read<ReportsProvider>();
                    await reports.api.clearSession();
                    if (!context.mounted) return;
                    context.read<AppState>().signOutAccount();
                    await reports.load();
                    if (context.mounted) {
                      Toast.show(context, 'Signed out. Still reporting anonymously.');
                    }
                  },
                )
              else
                SettingRow(
                  title: L.of(context).signIn,
                  subtitle: 'Bring reports from another phone',
                  icon: Icons.login_rounded,
                  onTap: () => Navigator.of(context).push(
                    SlideUpRoute(child: const AuthScreen()),
                  ),
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
      title: L.of(context).language,
      subtitle: 'Sets voice warnings and prompt wording.',
      scrollable: false,
      child: Column(
        children: [
          for (final l in ReportLanguage.selectable)
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
      title: L.of(context).appearance,
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
