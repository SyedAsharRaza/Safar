import 'package:bahawalpur_safar/core/theme/app_theme.dart';
import 'package:bahawalpur_safar/screens/onboarding/onboarding_screen.dart';
import 'package:bahawalpur_safar/state/app_state.dart';
import 'package:bahawalpur_safar/state/checkin_provider.dart';
import 'package:bahawalpur_safar/state/notifications_provider.dart';
import 'package:bahawalpur_safar/state/places_provider.dart';
import 'package:bahawalpur_safar/state/reports_provider.dart';
import 'package:bahawalpur_safar/state/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bahawalpur_safar/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Screen sizes that matter: a small budget Android, a typical phone, and a
/// large one. Overflow almost always shows up at the small end.
const sizes = <String, Size>{
  'small (320x640)': Size(320, 640),
  'typical (412x915)': Size(412, 915),
};

Future<void> pump(WidgetTester tester, Widget child, Size size) async {
  tester.view
    ..physicalSize = size * 3.0
    ..devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()..reseed()),
        ChangeNotifierProvider(create: (_) => RoutesProvider()),
        ChangeNotifierProvider(create: (_) => CheckinProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: child,
      ),
    ),
  );
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Collects overflow errors instead of letting them fail the frame, so one run
/// reports every offender rather than stopping at the first.
List<String> captureOverflows(VoidCallback body) {
  final found = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (text.contains('overflowed')) {
      found.add(text.split('\n').first);
    } else {
      previous?.call(details);
    }
  };
  body();
  FlutterError.onError = previous;
  return found;
}

void main() {
  for (final entry in sizes.entries) {
    testWidgets('onboarding has no overflow at ${entry.key}', (tester) async {
      final overflows = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) {
        final text = details.exceptionAsString();
        if (text.contains('overflowed')) {
          overflows.add(text.split('\n').first);
        } else {
          previous?.call(details);
        }
      };

      await pump(tester, const OnboardingScreen(), entry.value);

      // Walk every onboarding page.
      for (var page = 0; page < 3; page++) {
        final next = find.text('Continue');
        if (next.evaluate().isEmpty) break;
        await tester.tap(next.first, warnIfMissed: false);
        for (var i = 0; i < 12; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      FlutterError.onError = previous;
      expect(
        overflows,
        isEmpty,
        reason: 'Overflows at ${entry.key}:\n${overflows.join('\n')}',
      );
    });
  }
}
