import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/surfaces.dart';

/// Emergency helplines. Displayed only — this prototype does not place calls,
/// and the sheet says so rather than implying it will dial.
Future<void> showEmergencySheet(BuildContext context) {
  return showSafarSheet<void>(
    context,
    title: 'Emergency numbers',
    subtitle: AppText.notEmergency,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in Helplines.all)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: SafarCard(
              padding: const EdgeInsets.all(Gap.md),
              onTap: () => Toast.show(
                context,
                'Dialling is not wired up in this UI build. The number is '
                '${line.number}.',
                tone: ToastTone.warning,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.danger
                          .withValues(alpha: context.isDark ? 0.2 : 0.09),
                      borderRadius: Radii.allSm,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      line.number,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          line.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          line.note,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: context.tokens.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.call_outlined,
                    size: 19,
                    color: context.tokens.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Gap.sm),
        const InfoPanel(
          text:
              'Reporting something here does not alert the authorities. If '
              'someone is in danger, contact emergency services directly.',
          icon: Icons.warning_amber_rounded,
          tone: AppColors.danger,
        ),
      ],
    ),
  );
}
