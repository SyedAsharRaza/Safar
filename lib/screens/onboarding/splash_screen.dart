import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../state/app_state.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/brand.dart';
import 'onboarding_screen.dart';
import '../home/app_shell.dart';
import '../../l10n/app_localizations.dart';

/// Splash. Loads the seeded community signals while the brand animates in, so
/// the first real screen already has data.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final app = context.read<AppState>();
    final reports = context.read<ReportsProvider>();

    await Future.wait([
      reports.load(offline: app.offline),
      // Hold the splash long enough to read the tagline, no longer.
      Future<void>.delayed(const Duration(milliseconds: 1500)),
    ]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      FadeScaleRoute(
        child: app.onboarded ? const AppShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _ambient,
        builder: (context, _) => NightBackdrop(
          animationValue: _ambient.value,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Gap.x3l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  _fade(
                    0.0,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1).animate(
                        CurvedAnimation(
                          parent: _intro,
                          curve: const Interval(0, 0.6, curve: Motion.spring),
                        ),
                      ),
                      child: const SafarLogo(size: 88, onDark: true),
                    ),
                  ),
                  const SizedBox(height: Gap.xxl),
                  _fade(0.28, child: const SafarWordmark(onDark: true)),
                  const Spacer(),
                  _fade(
                    0.5,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: Gap.lg),
                        Text(
                          L.of(context).loadingCommunitySignalsBahawalpur,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.62),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.x3l),
                  _fade(
                    0.62,
                    child: Text(
                      AppText.uiOnlyBuildNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fade(double start, {required Widget child}) {
    final animation = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, (start + 0.42).clamp(0.0, 1.0), curve: Motion.enter),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
