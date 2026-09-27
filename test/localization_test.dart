import 'package:bahawalpur_safar/l10n/app_localizations.dart';
import 'package:bahawalpur_safar/models/taxonomy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders a probe widget under one locale and returns what it saw.
Future<({String appName, String disclaimer, TextDirection dir})> load(
  WidgetTester tester,
  Locale locale, {
  bool rtl = false,
}) async {
  late L l;
  late TextDirection dir;

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      // Mirrors the override main.dart applies, because Flutter's own
      // language-code heuristic gets Punjabi and Roman Urdu wrong.
      builder: (context, child) => Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: child ?? const SizedBox(),
      ),
      home: Builder(
        builder: (context) {
          l = L.of(context);
          dir = Directionality.of(context);
          return const SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return (appName: l.appName, disclaimer: l.disclaimer, dir: dir);
}

void main() {
  test('every selectable language maps to a supported locale', () {
    for (final lang in ReportLanguage.selectable) {
      final match = L.supportedLocales.any(
        (l) =>
            l.languageCode == lang.locale.languageCode &&
            l.scriptCode == lang.locale.scriptCode,
      );
      expect(match, isTrue, reason: '${lang.label} has no generated locale');
    }
  });

  testWidgets('English renders left-to-right', (tester) async {
    final r = await load(tester, const Locale('en'));
    expect(r.appName, 'Safar');
    expect(r.dir, TextDirection.ltr);
  });

  testWidgets('Urdu is translated and right-to-left', (tester) async {
    final r = await load(tester, const Locale('ur'), rtl: true);
    expect(r.appName, 'سفر');
    // The disclaimer is the product's core honesty statement — it must never
    // fall back to English just because a key was missed.
    expect(r.disclaimer, isNot(contains('does not guarantee')));
    expect(r.disclaimer, contains('ضمانت'));
    expect(r.dir, TextDirection.rtl);
  });

  testWidgets('Punjabi is translated and right-to-left', (tester) async {
    final r = await load(tester, const Locale('pa'), rtl: true);
    expect(r.appName, 'سفر');
    expect(r.disclaimer, isNot(contains('does not guarantee')));
    expect(r.dir, TextDirection.rtl);
  });

  testWidgets('Roman Urdu is Latin script, left-to-right', (tester) async {
    final r = await load(
      tester,
      const Locale.fromSubtags(languageCode: 'ur', scriptCode: 'Latn'),
    );
    expect(r.appName, 'Safar');
    expect(r.disclaimer, contains('guarantee nahi'));
    expect(r.dir, TextDirection.ltr);
  });

  testWidgets('no locale silently falls back to English text', (tester) async {
    // A missed key shows up as an English string in a non-English locale, which
    // is exactly the bug that makes localisation look half-done.
    for (final locale in [const Locale('ur'), const Locale('pa')]) {
      final r = await load(tester, locale);
      expect(r.appName, isNot('Safar'), reason: '$locale fell back');
    }
  });
}
