import 'package:bahawalpur_safar/core/theme/app_theme.dart';
import 'package:bahawalpur_safar/data/mock/mock_places.dart';
import 'package:bahawalpur_safar/screens/home/app_shell.dart';
import 'package:bahawalpur_safar/state/app_state.dart';
import 'package:bahawalpur_safar/state/checkin_provider.dart';
import 'package:bahawalpur_safar/state/notifications_provider.dart';
import 'package:bahawalpur_safar/state/places_provider.dart';
import 'package:bahawalpur_safar/state/reports_provider.dart';
import 'package:bahawalpur_safar/state/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// A typical Android phone. The default 800x600 test surface is wider and much
/// shorter than any real handset, so these layouts are exercised at a size they
/// are actually designed for.
const Size kPhone = Size(412, 915);

/// The map's location dot and the skeleton shimmer repeat forever by design, so
/// `pumpAndSettle` would never return. Pump a fixed number of frames instead —
/// long enough for entrance animations and mock latency to finish.
Future<void> settle(
  WidgetTester tester, {
  Duration total = const Duration(seconds: 3),
}) async {
  const step = Duration(milliseconds: 100);
  for (var elapsed = Duration.zero; elapsed < total; elapsed += step) {
    await tester.pump(step);
  }
}

Future<void> _usePhoneSurface(WidgetTester tester) async {
  tester.view
    ..physicalSize = kPhone * 3.0
    ..devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

/// Boots the shell with providers already loaded, skipping splash/onboarding so
/// each test starts from a signed-in, data-ready state.
Future<ReportsProvider> pumpShell(
  WidgetTester tester, {
  bool withReports = true,
  int initialIndex = 0,
}) async {
  await _usePhoneSurface(tester);

  final reports = ReportsProvider();
  if (withReports) {
    reports.reseed();
  } else {
    reports.clearAll();
  }

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..completeOnboarding()),
        ChangeNotifierProvider<ReportsProvider>.value(value: reports),
        ChangeNotifierProvider(create: (_) => RoutesProvider()),
        ChangeNotifierProvider(create: (_) => CheckinProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: AppShell(initialIndex: initialIndex),
      ),
    ),
  );
  await settle(tester);
  return reports;
}

void main() {
  testWidgets('home screen renders the trip planner and signals', (
    tester,
  ) async {
    await pumpShell(tester);

    expect(find.text('Bahawalpur'), findsOneWidget);
    expect(find.text('Compare routes'), findsOneWidget);
    expect(find.text('FROM'), findsOneWidget);
    expect(find.text('TO'), findsOneWidget);
    // Seeded data must always be labelled as demonstration data.
    expect(find.textContaining('Demo data'), findsWidgets);
  });

  testWidgets('every bottom-nav destination opens without error', (
    tester,
  ) async {
    await pumpShell(tester);

    for (final label in ['Map', 'Activity', 'You', 'Plan']) {
      await tester.tap(find.text(label).last);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'Tab "$label" threw');
    }
  });

  testWidgets('the report button opens the report flow', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.byTooltip('Report a road condition'));
    await settle(tester);

    expect(find.text('Report a road condition'), findsWidgets);
    expect(find.text('What are you reporting?'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);
  });

  testWidgets('report flow walks category to description', (tester) async {
    await pumpShell(tester);
    await tester.tap(find.byTooltip('Report a road condition'));
    await settle(tester);

    // Step 1: category.
    await tester.tap(find.text('Blockage'));
    await settle(tester);
    expect(find.text('What exactly is happening?'), findsOneWidget);
    expect(find.text('Step 2 of 4'), findsOneWidget);

    // Step 2: specific issue.
    await tester.tap(find.text('Street blocked'));
    await settle(tester);
    expect(find.text('Where is it?'), findsOneWidget);
    expect(find.text('Step 3 of 4'), findsOneWidget);

    // Step 3: location.
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('Anything to add?'), findsOneWidget);
    expect(find.text('Step 4 of 4'), findsOneWidget);
    expect(find.text('Review my report'), findsOneWidget);
  });

  testWidgets('classification review publishes a report', (tester) async {
    final reports = await pumpShell(tester);
    final before = reports.mine.length;

    await tester.tap(find.byTooltip('Report a road condition'));
    await settle(tester);
    await tester.tap(find.text('Blockage'));
    await settle(tester);
    await tester.tap(find.text('Street blocked'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    await tester.enterText(
      find.byType(TextField).first,
      'Aagay gali band hai',
    );
    await settle(tester);
    await tester.tap(find.text('Review my report'));
    await settle(tester);

    // The review screen states its reading before anything is published.
    expect(find.text('We understood this as'), findsOneWidget);
    expect(find.text('Street blocked'), findsWidgets);
    expect(find.text('Confirm and publish'), findsOneWidget);

    await tester.tap(find.text('Confirm and publish'));
    await settle(tester);

    expect(find.text('Your report is live'), findsOneWidget);
    expect(reports.mine.length, before + 1);
  });

  testWidgets('a report naming a person is blocked, not published', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(find.byTooltip('Report a road condition'));
    await settle(tester);
    await tester.tap(find.text('Safety concern'));
    await settle(tester);
    await tester.tap(find.text('Suspicious activity'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    await tester.enterText(
      find.byType(TextField).first,
      'Uska naam Ali hai aur uska phone number bhi mujhe pata hai',
    );
    await settle(tester);
    await tester.tap(find.text('Review my report'));
    await settle(tester);

    expect(find.text('This report cannot be published'), findsOneWidget);
    expect(find.text('Confirm and publish'), findsNothing);
  });

  testWidgets('route comparison produces explained options', (tester) async {
    await pumpShell(tester);

    final routes = Provider.of<RoutesProvider>(
      tester.element(find.byType(AppShell)),
      listen: false,
    );
    final reports = Provider.of<ReportsProvider>(
      tester.element(find.byType(AppShell)),
      listen: false,
    );

    routes
      ..setOrigin(MockPlaces.byId('pl_model_town_a'))
      ..setDestination(MockPlaces.byId('pl_iub'));
    await settle(tester);

    await tester.tap(find.text('Compare routes'));
    await settle(tester);
    await routes.plan(reports: reports.live);
    await settle(tester);

    expect(routes.options, isNotEmpty);
    expect(find.text('Fastest route'), findsWidgets);
    // Awareness is stated as words, never as a percentage.
    expect(find.textContaining('% safe'), findsNothing);
  });

  testWidgets('empty data shows an honest limited-data message', (
    tester,
  ) async {
    await pumpShell(tester, withReports: false);

    expect(find.text('No live reports right now'), findsOneWidget);
    expect(
      find.textContaining('not the same as "all clear"'),
      findsOneWidget,
    );
  });

  testWidgets('activity tab shows alerts, reports and check-ins', (
    tester,
  ) async {
    await pumpShell(tester, initialIndex: 2);

    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('My reports'), findsOneWidget);
    expect(find.text('Check-ins'), findsOneWidget);

    await tester.tap(find.text('My reports'));
    await settle(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Check-ins'));
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile exposes settings and the disclaimers', (tester) async {
    await pumpShell(tester, initialIndex: 3);

    expect(find.textContaining('Traveller #'), findsOneWidget);
    expect(find.text('Saved places'), findsOneWidget);
    expect(find.text('Trusted contacts'), findsOneWidget);

    await tester.tap(find.text('About Bahawalpur Safar'));
    await settle(tester);
    expect(find.text('What Bahawalpur Safar is not'), findsOneWidget);
    expect(
      find.textContaining('does not guarantee safety'),
      findsWidgets,
    );
  });

  testWidgets('dark theme renders every tab without overflow', (tester) async {
    await _usePhoneSurface(tester);
    final reports = ReportsProvider()..reseed();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AppState()..completeOnboarding(),
          ),
          ChangeNotifierProvider<ReportsProvider>.value(value: reports),
          ChangeNotifierProvider(create: (_) => RoutesProvider()),
          ChangeNotifierProvider(create: (_) => CheckinProvider()),
          ChangeNotifierProvider(create: (_) => PlacesProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.dark,
          home: const AppShell(),
        ),
      ),
    );
    await settle(tester);

    for (final label in ['Map', 'Activity', 'You']) {
      await tester.tap(find.text(label).last);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'Dark "$label" threw');
    }
  });
}
