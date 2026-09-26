import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../data/mock/mock_places.dart';
import '../../models/saved_place.dart';
import '../../state/places_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';

/// Destination picker. Returns the chosen [Place] via `Navigator.pop`.
///
/// Covers the states that matter: first keystroke, no results, saved places,
/// recent searches, and a "use my current location" shortcut that is simulated.
class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({
    super.key,
    this.title = 'Where to?',
    this.excludeId,
  });

  final String title;

  /// The other end of the trip — filtered out so you cannot route A to A.
  final String? excludeId;

  @override
  State<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  final TextEditingController _query = TextEditingController();
  Timer? _debounce;
  String _term = '';
  bool _searching = false;

  static final Place currentLocation = Place(
    id: 'pl_current',
    name: 'Current location',
    area: 'Fawara Chowk area',
    kind: PlaceKind.landmark,
    location: BwpGeo.fawaraChowk,
    subtitle: 'Simulated position for this prototype',
  );

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _term = '';
        _searching = false;
      });
      return;
    }
    // Brief debounce so the "searching" state is visible, as it would be with a
    // real places API behind it.
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() {
        _term = value;
        _searching = false;
      });
    });
  }

  void _choose(Place place) {
    context.read<PlacesProvider>().recordSearch(place);
    Navigator.of(context).pop(place);
  }

  List<Place> get _results => MockPlaces.search(_term)
      .where((p) => p.id != widget.excludeId)
      .toList();

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>();
    final gutter = Gap.page(context);
    final showResults = _term.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Gap.md),
            child: SafarSearchField(
              controller: _query,
              autofocus: true,
              hint: 'Search a place, area or landmark',
              onChanged: _onChanged,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Motion.fast,
              child: showResults
                  ? _resultsView(gutter)
                  : _browseView(gutter, places),
            ),
          ),
        ],
      ),
    );
  }

  // --- Browse (no query) ------------------------------------------------------

  Widget _browseView(double gutter, PlacesProvider places) {
    final hasHistory = places.recent.isNotEmpty || places.saved.isNotEmpty;

    return ListView(
      key: const ValueKey('browse'),
      padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Gap.x4l),
      children: [
        SafarCard(
          onTap: () => _choose(currentLocation),
          padding: const EdgeInsets.all(Gap.md),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: context.scheme.tertiary
                      .withValues(alpha: context.isDark ? 0.22 : 0.1),
                  borderRadius: Radii.allSm,
                ),
                child: Icon(
                  Icons.my_location_rounded,
                  size: 18,
                  color: context.scheme.tertiary,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Use my current location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Simulated — no location permission is requested',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: context.tokens.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (places.saved.isNotEmpty) ...[
          const SizedBox(height: Gap.xxl),
          SectionHeader(
            title: 'Saved places',
            padding: const EdgeInsets.only(bottom: Gap.md),
            action: TextButton(
              onPressed: () {
                context.read<PlacesProvider>();
                Navigator.of(context).push(
                  SlideRoute(child: const _SavedPlacesQuickList()),
                );
              },
              child: const Text('Manage'),
            ),
          ),
          for (final s in places.saved)
            _PlaceRow(
              place: s.place,
              overrideTitle: s.label,
              onTap: () => _choose(s.place),
            ),
        ],

        if (places.recent.isNotEmpty) ...[
          const SizedBox(height: Gap.xxl),
          SectionHeader(
            title: 'Recent',
            padding: const EdgeInsets.only(bottom: Gap.md),
            action: TextButton(
              onPressed: () {
                context.read<PlacesProvider>().clearRecent();
                Toast.show(context, 'Recent searches cleared.');
              },
              child: const Text('Clear'),
            ),
          ),
          for (final p in places.recent)
            _PlaceRow(place: p, onTap: () => _choose(p), icon: Icons.history),
        ],

        if (!hasHistory)
          Padding(
            padding: const EdgeInsets.only(top: Gap.xxl),
            child: SafarCard(
              child: EmptyState(
                compact: true,
                icon: Icons.bookmark_border_rounded,
                title: 'No saved or recent places yet',
                message:
                    'Search for a destination below. Places you pick will show '
                    'up here next time.',
              ),
            ),
          ),

        const SizedBox(height: Gap.xxl),
        const SectionHeader(
          title: 'Popular in Bahawalpur',
          padding: EdgeInsets.only(bottom: Gap.md),
        ),
        for (final p in MockPlaces.all
            .where((p) => p.id != widget.excludeId)
            .take(8))
          _PlaceRow(place: p, onTap: () => _choose(p)),
      ],
    );
  }

  // --- Results ----------------------------------------------------------------

  Widget _resultsView(double gutter) {
    if (_searching) {
      return ListView(
        key: const ValueKey('searching'),
        padding: EdgeInsets.fromLTRB(gutter, Gap.sm, gutter, Gap.x4l),
        children: const [
          _PlaceSkeletonRow(),
          _PlaceSkeletonRow(),
          _PlaceSkeletonRow(),
          _PlaceSkeletonRow(),
        ],
      );
    }

    final results = _results;
    if (results.isEmpty) {
      return EmptyState(
        key: const ValueKey('no-results'),
        icon: Icons.search_off_rounded,
        title: 'No places match "${_term.trim()}"',
        message:
            'This prototype covers one demo area of Bahawalpur, so the place '
            'list is limited. Try "Model Town", "university" or "bazaar".',
        primaryLabel: 'Clear search',
        onPrimary: () {
          _query.clear();
          _onChanged('');
        },
      );
    }

    return ListView.builder(
      key: const ValueKey('results'),
      padding: EdgeInsets.fromLTRB(gutter, Gap.sm, gutter, Gap.x4l),
      itemCount: results.length,
      itemBuilder: (context, i) => StaggeredFadeIn(
        index: i,
        child: _PlaceRow(
          place: results[i],
          highlight: _term.trim(),
          onTap: () => _choose(results[i]),
        ),
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.onTap,
    this.overrideTitle,
    this.icon,
    this.highlight,
  });

  final Place place;
  final VoidCallback onTap;
  final String? overrideTitle;
  final IconData? icon;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>();
    final t = Theme.of(context).textTheme;
    final title = overrideTitle ?? place.name;

    return InkWell(
      onTap: onTap,
      borderRadius: Radii.allMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.md - 1),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: context.tokens.surfaceAlt,
                borderRadius: Radii.allSm,
              ),
              child: Icon(
                icon ?? place.kind.icon,
                size: 18,
                color: context.tokens.textSecondary,
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Highlighted(
                    text: title,
                    term: highlight,
                    style: t.titleMedium!,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    place.displaySubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall
                        ?.copyWith(color: context.tokens.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Gap.sm),
            if (overrideTitle != null)
              Pill(
                label: place.kind.label,
                color: context.tokens.textTertiary,
                dense: true,
              )
            else
              FavouriteButton(
                size: 18,
                saved: places.isSaved(place.id),
                onToggle: () {
                  final added =
                      context.read<PlacesProvider>().toggleSaved(place);
                  Toast.show(
                    context,
                    added
                        ? '${place.name} saved.'
                        : '${place.name} removed from saved.',
                    tone: added ? ToastTone.success : ToastTone.neutral,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Bolds the matched part of a place name so results read as a real search.
class _Highlighted extends StatelessWidget {
  const _Highlighted({
    required this.text,
    required this.style,
    this.term,
  });

  final String text;
  final TextStyle style;
  final String? term;

  @override
  Widget build(BuildContext context) {
    final q = term?.trim().toLowerCase() ?? '';
    if (q.isEmpty) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    final index = text.toLowerCase().indexOf(q);
    if (index < 0) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + q.length),
            style: style.copyWith(
              color: context.scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: text.substring(index + q.length)),
        ],
      ),
    );
  }
}

class _PlaceSkeletonRow extends StatelessWidget {
  const _PlaceSkeletonRow();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.md - 1),
        child: Row(
          children: const [
            Skeleton(width: 38, height: 38, radius: 10),
            SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(width: 150, height: 13),
                  SizedBox(height: Gap.sm),
                  Skeleton(width: 96, height: 11),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Minimal saved-places manager reachable from the picker.
class _SavedPlacesQuickList extends StatelessWidget {
  const _SavedPlacesQuickList();

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved places')),
      body: places.saved.isEmpty
          ? EmptyState(
              icon: Icons.bookmark_border_rounded,
              title: 'Nothing saved yet',
              message:
                  'Tap the bookmark on any place to keep it here for quick '
                  'access.',
              primaryLabel: 'Back to search',
              onPrimary: () => Navigator.of(context).pop(),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
              children: [
                for (final s in places.saved)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: SafarCard(
                      padding: const EdgeInsets.all(Gap.md),
                      child: Row(
                        children: [
                          Icon(s.place.kind.icon, size: 18),
                          const SizedBox(width: Gap.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  s.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  s.place.area,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              final ok = await confirmAction(
                                context,
                                title: 'Remove ${s.title}?',
                                message:
                                    'It will no longer appear in your saved '
                                    'places. You can save it again any time.',
                                confirmLabel: 'Remove',
                                destructive: true,
                                icon: Icons.bookmark_remove_outlined,
                              );
                              if (ok && context.mounted) {
                                context
                                    .read<PlacesProvider>()
                                    .toggleSaved(s.place);
                                Toast.show(context, '${s.title} removed.');
                              }
                            },
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
