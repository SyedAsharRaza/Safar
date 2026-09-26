import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/brand.dart';
import '../../widgets/common/surfaces.dart';
import '../home/app_shell.dart';

/// Four-page onboarding: what it is, how reporting works, what it will not do,
/// and the language choice.
///
/// The third page is deliberately about limits. A product that talks about
/// safety has to say plainly what it cannot promise, before the user relies on
/// it — not buried in a settings screen.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  static const int _pageCount = 4;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pageCount - 1) {
      _pages.nextPage(duration: Motion.base, curve: Motion.emphasized);
    } else {
      _finish();
    }
  }

  void _finish() {
    context.read<AppState>()
      ..completeOnboarding()
      ..signIn();
    Navigator.of(context).pushReplacement(
      FadeScaleRoute(child: const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onDark = _index == 0;

    return Scaffold(
      backgroundColor: onDark ? AppColors.brandNight : null,
      body: Stack(
        children: [
          if (onDark) const Positioned.fill(child: NightBackdrop()),
          SafeArea(
            child: Column(
              children: [
                // --- Skip / progress -------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Gap.page(context),
                    Gap.md,
                    Gap.page(context),
                    0,
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          for (var i = 0; i < _pageCount; i++)
                            AnimatedContainer(
                              duration: Motion.base,
                              curve: Motion.enter,
                              margin: const EdgeInsets.only(right: 5),
                              width: i == _index ? 22 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                borderRadius: Radii.pill,
                                color: i == _index
                                    ? (onDark
                                        ? AppColors.accent
                                        : context.scheme.primary)
                                    : (onDark
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : context.tokens.border),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _finish,
                        style: TextButton.styleFrom(
                          foregroundColor: onDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : context.tokens.textSecondary,
                        ),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: [
                      const _WelcomePage(),
                      const _HowItWorksPage(),
                      const _LimitsPage(),
                      _LanguagePage(onDone: _finish),
                    ],
                  ),
                ),

                // --- Action ------------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Gap.page(context),
                    Gap.md,
                    Gap.page(context),
                    Gap.xl,
                  ),
                  child: Row(
                    children: [
                      if (_index > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pages.previousPage(
                              duration: Motion.base,
                              curve: Motion.emphasized,
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_index > 0) const SizedBox(width: Gap.md),
                      Expanded(
                        flex: _index > 0 ? 2 : 1,
                        child: FilledButton(
                          onPressed: _next,
                          style: onDark
                              ? FilledButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: const Color(0xFF2E1D04),
                                )
                              : null,
                          child: Text(
                            _index == _pageCount - 1
                                ? 'Start exploring'
                                : 'Continue',
                          ),
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

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Gap.page(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafarLogo(size: 72, onDark: true),
          const SizedBox(height: Gap.xxl),
          Text(
            'A normal map tells you\nthe fastest way.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: Gap.lg),
          Text(
            'Bahawalpur Safar tells you what to expect on the way.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: Gap.xl),
          Text(
            AppText.pitch,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  height: 1.55,
                ),
          ),
          const SizedBox(height: Gap.x3l),
          Wrap(
            spacing: Gap.sm,
            runSpacing: Gap.sm,
            children: [
              for (final c in ReportCategory.pickable.take(5))
                Pill(
                  label: c.label,
                  icon: c.icon,
                  color: Colors.white.withValues(alpha: 0.9),
                  background: Colors.white.withValues(alpha: 0.10),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HowItWorksPage extends StatelessWidget {
  const _HowItWorksPage();

  static const List<({IconData icon, String title, String body})> _steps = [
    (
      icon: Icons.record_voice_over_outlined,
      title: 'A resident reports what they see',
      body:
          'In English, Urdu or Roman Urdu — "aagay gali band hai", "road par pani '
          'khara hai", "streetlight band hai".',
    ),
    (
      icon: Icons.auto_awesome_outlined,
      title: 'The report becomes a structured signal',
      body:
          'Informal text is turned into a category, a severity and a neutral '
          'public summary. You always review it before it is published.',
    ),
    (
      icon: Icons.alt_route_outlined,
      title: 'Routes are compared, and explained',
      body:
          'Fresh reports count more than old ones. Every route says in plain '
          'words what it avoids and what it costs you in minutes.',
    ),
    (
      icon: Icons.notifications_active_outlined,
      title: 'The next traveller is warned',
      body:
          'A short voice warning before you set off, and a safety check-in you '
          'can share with someone you trust.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Gap.page(context),
        vertical: Gap.lg,
      ),
      children: [
        Text(
          'How it works',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          'One report from one person helps everyone who travels that road next.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.tokens.textSecondary,
              ),
        ),
        const SizedBox(height: Gap.xxl),
        for (var i = 0; i < _steps.length; i++)
          StaggeredFadeIn(
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Gap.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: context.scheme.primary
                              .withValues(alpha: context.isDark ? 0.22 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _steps[i].icon,
                          size: 18,
                          color: context.scheme.primary,
                        ),
                      ),
                      if (i != _steps.length - 1)
                        Container(
                          width: 2,
                          height: 44,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: context.tokens.border,
                        ),
                    ],
                  ),
                  const SizedBox(width: Gap.lg),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: Gap.xs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _steps[i].title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: Gap.xs),
                          Text(
                            _steps[i].body,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _LimitsPage extends StatelessWidget {
  const _LimitsPage();

  static const List<String> _isNot = [
    'A police or emergency replacement',
    'A crime-prediction system',
    'A guarantee that any road is safe',
    'An official government reporting portal',
  ];

  static const List<String> _is = [
    'A community-powered awareness layer',
    'Anonymous by default, with no public accusations',
    'Honest about confidence and missing data',
    'Useful even when reports are thin',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Gap.page(context),
        vertical: Gap.lg,
      ),
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: context.scheme.secondaryContainer,
            borderRadius: Radii.allMd,
          ),
          child: Icon(
            Icons.balance_outlined,
            color: context.scheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(height: Gap.xl),
        Text(
          'What this app will not do',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          'Worth reading before you rely on it.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.tokens.textSecondary,
              ),
        ),
        const SizedBox(height: Gap.xxl),
        SafarCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'It is not',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: context.scheme.error),
              ),
              const SizedBox(height: Gap.md),
              for (final item in _isNot)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: context.scheme.error,
                      ),
                      const SizedBox(width: Gap.sm),
                      Expanded(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Gap.md),
        SafarCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'It is',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.awarenessLow),
              ),
              const SizedBox(height: Gap.md),
              for (final item in _is)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: AppColors.awarenessLow,
                      ),
                      const SizedBox(width: Gap.sm),
                      Expanded(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Gap.lg),
        const InfoPanel(
          text: AppText.notEmergency,
          icon: Icons.emergency_outlined,
          tone: AppColors.danger,
        ),
      ],
    );
  }
}

class _LanguagePage extends StatelessWidget {
  const _LanguagePage({required this.onDone});

  final VoidCallback onDone;

  static const List<ReportLanguage> _choices = [
    ReportLanguage.english,
    ReportLanguage.romanUrdu,
    ReportLanguage.urdu,
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Gap.page(context),
        vertical: Gap.lg,
      ),
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: context.scheme.primaryContainer,
            borderRadius: Radii.allMd,
          ),
          child: Icon(
            Icons.translate_rounded,
            color: context.scheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: Gap.xl),
        Text(
          'Pick your language',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          'This sets the voice warnings and the wording of report prompts. You '
          'can always report in whichever language you actually speak.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.tokens.textSecondary,
                height: 1.5,
              ),
        ),
        const SizedBox(height: Gap.xxl),
        for (final l in _choices)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: SafarCard(
              onTap: () => context.read<AppState>().setLanguage(l),
              borderColor: app.language == l
                  ? context.scheme.primary.withValues(alpha: 0.7)
                  : null,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.nativeLabel,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          switch (l) {
                            ReportLanguage.english =>
                              'Interface and warnings in English',
                            ReportLanguage.romanUrdu =>
                              'Urdu written in Latin script — "road kharab hai"',
                            _ => 'Urdu script for warnings and summaries',
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Motion.fast,
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: app.language == l
                          ? context.scheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: app.language == l
                            ? context.scheme.primary
                            : context.tokens.border,
                        width: 2,
                      ),
                    ),
                    child: app.language == l
                        ? const Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Gap.sm),
        const InfoPanel(
          text: AppText.disclaimer,
          icon: Icons.info_outline,
        ),
      ],
    );
  }
}
