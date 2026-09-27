import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// Emergency helplines.
///
/// Opens the dialer with the number pre-filled rather than placing the call
/// outright. On a screen someone reaches while frightened, a mis-tap that
/// silently dials the police is worse than one extra press — they get to see
/// the number and confirm.
Future<void> showEmergencySheet(BuildContext context) {
  return showSafarSheet<void>(
    context,
    title: L.of(context).emergencyNumbers,
    subtitle: AppText.notEmergency,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in Helplines.all)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: SafarCard(
              padding: const EdgeInsets.all(Gap.md),
              onTap: () => _openDialer(context, line.number, line.name),
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
                    color: AppColors.danger,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Gap.sm),
        InfoPanel(
          text:
              L.of(context).reportingSomethingSafarDoesAlert,
          icon: Icons.warning_amber_rounded,
          tone: AppColors.danger,
        ),
      ],
    ),
  );
}


/// Opens the phone dialer with [number] entered, without placing the call.
///
/// Uses `tel:` rather than a direct call so no permission is needed and the
/// person always confirms. If no dialer can handle it — a tablet, say — the
/// number is shown so it can still be read out or written down.
Future<void> _openDialer(
  BuildContext context,
  String number,
  String name,
) async {
  final uri = Uri(scheme: 'tel', path: number);
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showNumberFallback(context, number, name);
    }
  } catch (_) {
    if (context.mounted) _showNumberFallback(context, number, name);
  }
}

void _showNumberFallback(BuildContext context, String number, String name) {
  Toast.show(
    context,
    'No dialer on this device. $name is $number.',
    tone: ToastTone.warning,
    duration: const Duration(seconds: 8),
  );
}
