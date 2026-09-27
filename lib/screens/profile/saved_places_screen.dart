import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../state/places_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// Saved places, with relabelling and a shortcut to route straight there.
class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({super.key});

  Future<void> _relabel(BuildContext context, String placeId, String? current) async {
    final controller = TextEditingController(text: current ?? '');
    final saved = await showSafarSheet<bool>(
      context,
      title: 'Label this place',
      subtitle: 'A short name like "Home", "Work" or "Ammi\'s house".',
      child: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Label (optional)'),
      ),
      footer: Builder(
        builder: (sheetContext) => Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(sheetContext).pop(false),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(sheetContext).pop(true),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );

    if (saved == true && context.mounted) {
      final text = controller.text.trim();
      context.read<PlacesProvider>().relabel(placeId, text.isEmpty ? null : text);
      Toast.show(context, 'Label updated.', tone: ToastTone.success);
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).savedPlaces)),
      body: places.saved.isEmpty
          ? EmptyState(
              icon: Icons.bookmark_border_rounded,
              title: 'No saved places',
              message:
                  'Tap the bookmark next to any place while searching, and it '
                  'will appear here for one-tap routing.',
              primaryLabel: 'Back',
              onPrimary: () => Navigator.of(context).pop(),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
              children: [
                for (final s in places.saved)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: SafarCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: context.tokens.surfaceAlt,
                                  borderRadius: Radii.allSm,
                                ),
                                child: Icon(s.place.kind.icon, size: 19),
                              ),
                              const SizedBox(width: Gap.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      s.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      s.label == null
                                          ? s.place.displaySubtitle
                                          : s.place.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  size: 20,
                                ),
                                onSelected: (value) async {
                                  if (value == 'label') {
                                    await _relabel(
                                      context,
                                      s.place.id,
                                      s.label,
                                    );
                                  } else if (value == 'remove') {
                                    final ok = await confirmAction(
                                      context,
                                      title: 'Remove ${s.title}?',
                                      message:
                                          'It will no longer appear in your '
                                          'saved places.',
                                      confirmLabel: 'Remove',
                                      destructive: true,
                                      icon: Icons.bookmark_remove_outlined,
                                    );
                                    if (ok && context.mounted) {
                                      context
                                          .read<PlacesProvider>()
                                          .toggleSaved(s.place);
                                      Toast.show(
                                        context,
                                        '${s.title} removed.',
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'label',
                                    child: Text('Change label'),
                                  ),
                                  PopupMenuItem(
                                    value: 'remove',
                                    child: Text(L.of(context).remove),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: Gap.md),
                          Row(
                            children: [
                              Pill(
                                label: s.place.kind.label,
                                color: context.tokens.textSecondary,
                                dense: true,
                              ),
                              const SizedBox(width: Gap.sm),
                              Pill(
                                label:
                                    'Saved ${TimeUtils.relative(s.savedAt)}',
                                icon: Icons.schedule_rounded,
                                color: context.tokens.textTertiary,
                                dense: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: Gap.md),
                          OutlinedButton.icon(
                            onPressed: () {
                              context
                                  .read<RoutesProvider>()
                                  .setDestination(s.place);
                              Navigator.of(context).pop();
                              Toast.show(
                                context,
                                '${s.title} set as your destination.',
                                tone: ToastTone.success,
                              );
                            },
                            icon: const Icon(Icons.alt_route_rounded, size: 17),
                            label: const Text('Route here'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
