import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/brand.dart';
import '../../widgets/common/surfaces.dart';

/// About, limitations and privacy. The page the product has to have if it is
/// going to talk about safety at all.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<String> _privacyRules = [
    'Reports are anonymous by default.',
    'No public accusations against identifiable people.',
    'No names, faces, phone numbers, vehicle plates or private addresses.',
    'Sensitive locations are rounded to an approximate area.',
    'Reports expire and lose influence over time.',
    'Reporters can correct the category or withdraw a report.',
    'Confidence labels are always shown, never hidden.',
    'Rate limits and duplicate detection reduce spam.',
    'Individual travel histories are never sold or shared.',
  ];

  static const List<String> _notThis = [
    'Not a police or emergency service replacement',
    'Not a crime-prediction system',
    'Not a guarantee that any road is safe or open',
    'Not an official government reporting portal',
    'Not built on scraped private messages',
  ];

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
        children: [
          Row(
            children: [
              const SafarLogo(size: 54),
              const SizedBox(width: Gap.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.appName, style: t.headlineSmall),
                    const SizedBox(height: 2),
                    Text(AppText.tagline, style: t.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          Text(AppText.pitch, style: t.bodyMedium?.copyWith(height: 1.55)),

          const SizedBox(height: Gap.xl),
          Row(
            children: const [
              Pill(
                label: 'UI prototype · v1.0.0',
                icon: Icons.construction_rounded,
              ),
              SizedBox(width: Gap.sm),
              DemoDataBadge(dense: true),
            ],
          ),

          // --- What it is not ----------------------------------------------------
          const SizedBox(height: Gap.xl),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What Bahawalpur Safar is not',
                  style: t.titleMedium?.copyWith(color: context.scheme.error),
                ),
                const SizedBox(height: Gap.md),
                for (final item in _notThis)
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
                        Expanded(child: Text(item, style: t.bodySmall)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Privacy -------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: Gap.sm),
                    Text('Privacy and abuse prevention', style: t.titleMedium),
                  ],
                ),
                const SizedBox(height: Gap.md),
                for (final rule in _privacyRules)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: AppColors.teal,
                        ),
                        const SizedBox(width: Gap.sm),
                        Expanded(
                          child: Text(
                            rule,
                            style: t.bodySmall?.copyWith(height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Data in this build ----------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About the data in this build', style: t.titleMedium),
                const SizedBox(height: Gap.sm),
                Text(
                  AppText.demoDataExplainer,
                  style: t.bodySmall?.copyWith(height: 1.5),
                ),
                const SizedBox(height: Gap.md),
                Text(
                  'Routes are planned over a hand-built road network for one area '
                  'of Bahawalpur. Coordinates are approximate and are not survey '
                  'data. The map is drawn by the app rather than served by a maps '
                  'provider. Classification of report text runs locally, not '
                  'against a hosted model.',
                  style: t.bodySmall?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: Gap.lg),
          const InfoPanel(
            text: AppText.disclaimer,
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: Gap.md),
          const InfoPanel(
            text: AppText.notEmergency,
            icon: Icons.emergency_outlined,
            tone: AppColors.danger,
          ),

          const SizedBox(height: Gap.xl),
          Center(
            child: Text(
              'Built for Bahawalpur.',
              style: t.labelMedium
                  ?.copyWith(color: context.tokens.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
