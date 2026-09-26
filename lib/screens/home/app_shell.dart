import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../state/notifications_provider.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/badges.dart';
import '../activity/activity_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';
import '../report/report_flow_screen.dart';
import 'home_screen.dart';

/// Lets any descendant switch tabs — used by home-screen shortcuts that point
/// at the Map or Activity tabs.
class ShellNav extends InheritedWidget {
  const ShellNav({
    super.key,
    required this.goToTab,
    required this.openReport,
    required super.child,
  });

  final void Function(int index) goToTab;
  final VoidCallback openReport;

  static ShellNav? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellNav>();

  @override
  bool updateShouldNotify(ShellNav old) => false;
}

/// The tab shell. Four destinations plus a centre report action, which is the
/// one thing we want a resident to be able to reach in a single tap.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index = widget.initialIndex;

  /// One navigator-free page per tab, kept alive so scroll position and map
  /// pan survive tab switches.
  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _openReport() {
    Navigator.of(context).push(
      SlideUpRoute(child: const ReportFlowScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.select<NotificationsProvider, int>(
      (n) => n.unreadCount,
    );

    return ShellNav(
      goToTab: (i) => setState(() => _index = i),
      openReport: _openReport,
      child: Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: Motion.base,
        // Cross-fade rather than slide: tabs are peers, not a hierarchy.
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        layoutBuilder: (current, previous) => Stack(
          children: [
            for (final c in previous) Positioned.fill(child: c),
            if (current != null) Positioned.fill(child: current),
          ],
        ),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _pages[_index],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _ReportFab(onTap: _openReport),
      bottomNavigationBar: _BottomBar(
        index: _index,
        unread: unread,
        onChanged: (i) => setState(() => _index = i),
      ),
      ),
    );
  }
}

class _ReportFab extends StatelessWidget {
  const _ReportFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The blockage/hazard count drives a subtle badge: if the area is noisy
    // right now, reporting is more obviously the thing to do.
    final fresh = context.select<ReportsProvider, int>((r) => r.freshCount);

    return Padding(
      padding: const EdgeInsets.only(top: Gap.sm),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: FloatingActionButton(
              onPressed: onTap,
              elevation: 4,
              highlightElevation: 6,
              backgroundColor: context.scheme.primary,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: Radii.allLg),
              tooltip: 'Report a road condition',
              child: const Icon(Icons.add_comment_rounded, size: 24),
            ),
          ),
          if (fresh > 0)
            Positioned(
              right: -2,
              top: -2,
              child: CountBadge(
                count: fresh,
                color: context.scheme.secondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.index,
    required this.unread,
    required this.onChanged,
  });

  final int index;
  final int unread;
  final ValueChanged<int> onChanged;

  static const List<({IconData icon, IconData active, String label})> _items = [
    (
      icon: Icons.explore_outlined,
      active: Icons.explore_rounded,
      label: 'Plan'
    ),
    (icon: Icons.map_outlined, active: Icons.map_rounded, label: 'Map'),
    (
      icon: Icons.notifications_none_rounded,
      active: Icons.notifications_rounded,
      label: 'Activity'
    ),
    (
      icon: Icons.person_outline_rounded,
      active: Icons.person_rounded,
      label: 'You'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.scheme.surface.withValues(alpha: 0.98),
        border: Border(top: BorderSide(color: context.tokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _tab(context, 0),
              _tab(context, 1),
              // Space for the docked report button.
              const SizedBox(width: 72),
              _tab(context, 2, badge: unread),
              _tab(context, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int i, {int badge = 0}) {
    final selected = index == i;
    final colour =
        selected ? context.scheme.primary : context.tokens.textTertiary;

    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: _items[i].label,
        child: InkWell(
          onTap: () => onChanged(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: Motion.fast,
                    child: Icon(
                      selected ? _items[i].active : _items[i].icon,
                      key: ValueKey(selected),
                      size: 22,
                      color: colour,
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: CountBadge(count: badge),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                _items[i].label,
                style: TextStyle(
                  fontFamily: 'Jakarta',
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: colour,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
