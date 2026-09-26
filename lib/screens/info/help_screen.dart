import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/taxonomy.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/surfaces.dart';

/// Explains the awareness model in plain language, including what it cannot do.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('How it works')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
        children: [
          Text('Route awareness, not a safety score', style: t.headlineMedium),
          const SizedBox(height: Gap.sm),
          Text(
            AppText.awarenessExplainer,
            style: t.bodyMedium?.copyWith(height: 1.55),
          ),
          const SizedBox(height: Gap.xl),

          // --- The four bands ----------------------------------------------------
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The four levels', style: t.titleMedium),
                const SizedBox(height: Gap.md),
                for (final level in AwarenessLevel.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AwarenessBadge(level: level, dense: true, short: true),
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: Text(
                            switch (level) {
                              AwarenessLevel.low =>
                                'Few or no recent reports, and the roads are '
                                    'reasonably lit and used.',
                              AwarenessLevel.moderate =>
                                'Some recent reports, or a stretch that is dim '
                                    'or quiet.',
                              AwarenessLevel.elevated =>
                                'Several fresh reports, or a blockage or hazard '
                                    'on the route.',
                              AwarenessLevel.limited =>
                                'Not enough data to say anything useful. This is '
                                    'not the same as "clear".',
                            },
                            style: t.bodySmall?.copyWith(height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- The formula --------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What goes into the number', style: t.titleMedium),
                const SizedBox(height: Gap.sm),
                Text(
                  'Each road segment gets a score from five weighted inputs. A '
                  'route is the length-weighted average of its segments.',
                  style: t.bodySmall?.copyWith(height: 1.45),
                ),
                const SizedBox(height: Gap.md),
                for (final row in const [
                  (35, 'Recent safety and caution reports'),
                  (25, 'Lighting — counts for more after dark'),
                  (20, 'Road surface, seepage and flooding'),
                  (10, 'Blockages and traffic hazards'),
                  (10, 'Uncertainty — how thin the data is'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            '${row.$1}%',
                            style: t.titleSmall
                                ?.copyWith(color: context.scheme.primary),
                          ),
                        ),
                        Expanded(child: Text(row.$2, style: t.bodySmall)),
                      ],
                    ),
                  ),
                const SizedBox(height: Gap.sm),
                const InfoPanel(
                  text:
                      'These weights are prototype values chosen for a sensible '
                      'demo. They are not validated against real incident data.',
                  icon: Icons.science_outlined,
                  dense: true,
                ),
              ],
            ),
          ),

          // --- Freshness -----------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Newer reports count for more', style: t.titleMedium),
                const SizedBox(height: Gap.sm),
                Text(
                  'Every report loses influence as it ages, and how fast depends '
                  'on the kind of problem. An accident stops mattering within '
                  'hours; a broken streetlight stays relevant for days.',
                  style: t.bodySmall?.copyWith(height: 1.5),
                ),
                const SizedBox(height: Gap.md),
                for (final row in const [
                  ('Accident, heavy traffic', 'Fades within hours'),
                  ('Standing water, blockage', 'Fades within a day'),
                  ('Seepage, road damage', 'Fades over several days'),
                  ('Broken streetlight, construction', 'Fades over a week or more'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: Row(
                      children: [
                        Expanded(child: Text(row.$1, style: t.bodySmall)),
                        Text(
                          row.$2,
                          style: t.labelMedium?.copyWith(
                            color: context.tokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Trust ----------------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How reports earn trust', style: t.titleMedium),
                const SizedBox(height: Gap.md),
                for (final status in [
                  ReportStatus.unverified,
                  ReportStatus.corroborated,
                  ReportStatus.disputed,
                  ReportStatus.expired,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusChip(status: status),
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: Text(
                            switch (status) {
                              ReportStatus.unverified =>
                                'Where every report starts. One person saw it.',
                              ReportStatus.corroborated =>
                                'Two or more independent travellers confirmed it, '
                                    'so it counts for more.',
                              ReportStatus.disputed =>
                                'Others said it is not there. Its influence drops.',
                              _ => 'Past its lifetime. No longer affects routes.',
                            },
                            style: t.bodySmall?.copyWith(height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Report types ----------------------------------------------------------
          const SizedBox(height: Gap.lg),
          SafarCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What each report does to routing', style: t.titleMedium),
                const SizedBox(height: Gap.md),
                for (final type in [
                  SpecificType.roadBlockage,
                  SpecificType.accident,
                  SpecificType.flooding,
                  SpecificType.seepage,
                  SpecificType.roadDamage,
                  SpecificType.poorLighting,
                  SpecificType.heavyTraffic,
                  SpecificType.pothole,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: Row(
                      children: [
                        Icon(
                          type.icon,
                          size: 15,
                          color: type.category.color,
                        ),
                        const SizedBox(width: Gap.sm),
                        Expanded(child: Text(type.label, style: t.bodySmall)),
                        Text(
                          type.routeEffect,
                          style: t.labelMedium?.copyWith(
                            color: context.tokens.textSecondary,
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
            text: AppText.disclaimer,
            icon: Icons.shield_outlined,
            title: 'The honest caveat',
          ),
          const SizedBox(height: Gap.md),
          const InfoPanel(
            text: AppText.notEmergency,
            icon: Icons.emergency_outlined,
            tone: AppColors.danger,
          ),
        ],
      ),
    );
  }
}
