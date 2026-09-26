import 'package:bahawalpur_safar/data/services/mock_ai_classifier.dart';
import 'package:bahawalpur_safar/models/taxonomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockAiClassifier classifier;

  setUp(() => classifier = MockAiClassifier());

  group('language detection and classification', () {
    test('classifies the blueprint\'s Roman Urdu examples correctly', () async {
      final cases = <String, SpecificType>{
        'Road kharab hai': SpecificType.roadDamage,
        'Agay gali band hai': SpecificType.roadBlockage,
        'Aagay gali band hai, construction ka saman para hua hai':
            SpecificType.roadBlockage,
        'Yahan seepage hai': SpecificType.seepage,
        'Bhai road par pani khara hai aur bike slip ho sakti hai':
            SpecificType.standingWater,
        'Streetlight band hai': SpecificType.poorLighting,
        'Yahan accident hua hai': SpecificType.accident,
        'Construction chal rahi hai': SpecificType.construction,
      };

      for (final entry in cases.entries) {
        final result = await classifier.classify(text: entry.key);
        expect(
          result.specificType,
          entry.value,
          reason: 'Misread: "${entry.key}"',
        );
        expect(result.category, entry.value.category);
        expect(result.confidence, inInclusiveRange(0.0, 1.0));
        expect(result.safePublicText, isNotEmpty);
      }
    });

    test('recognises Roman Urdu, English and Urdu script', () async {
      final roman = await classifier.classify(text: 'Road kharab hai yahan');
      expect(roman.language, ReportLanguage.romanUrdu);

      final english = await classifier.classify(
        text: 'The streetlight at the corner is broken',
      );
      expect(english.language, ReportLanguage.english);

      final urdu = await classifier.classify(text: 'یہاں راستہ بند ہے');
      expect(urdu.language, ReportLanguage.urdu);
    });

    test('public text never leaks the reporter\'s raw wording', () async {
      const raw = 'Bhai yeh gali bilkul band hai, bohat ganda haal hai';
      final result = await classifier.classify(text: raw);
      expect(result.safePublicText, isNot(contains('Bhai')));
      expect(result.safePublicText, startsWith('Community report:'));
    });

    test('public text uses cautious wording, never a guarantee', () async {
      final result = await classifier.classify(text: 'Aagay gali band hai');
      final text = result.safePublicText.toLowerCase();
      expect(text, contains('community report'));
      expect(text.contains('definitely'), isFalse);
      expect(text.contains('guaranteed'), isFalse);
      expect(text.contains('% '), isFalse);
    });
  });

  group('privacy guard', () {
    test('blocks reports that name or identify a person', () async {
      const accusations = [
        'Ek banda mashkook tha, uska naam Ali hai aur number bhi pata hai',
        'This man lives at the corner house and follows girls',
        'Bike snatch karne wale ka number plate ABC-123 hai',
      ];
      for (final text in accusations) {
        final result = await classifier.classify(text: text);
        expect(result.doNotPublish, isTrue, reason: 'Should block: "$text"');
        expect(result.safePublicText, isEmpty);
        expect(result.withheldReason, isNotNull);
      }
    });

    test('a plain condition report is not blocked', () async {
      final result = await classifier.classify(text: 'Yahan bohat andhera hai');
      expect(result.doNotPublish, isFalse);
      expect(result.safePublicText, isNotEmpty);
    });
  });

  group('insufficient detail', () {
    test('very short text with no category is marked invalid', () async {
      final result = await classifier.classify(text: 'hm');
      expect(result.category, ReportCategory.invalid);
      expect(result.isUsable, isFalse);
    });

    test('short text still works when the user picked an issue', () async {
      final result = await classifier.classify(
        text: '',
        userSelectedType: SpecificType.pothole,
      );
      expect(result.specificType, SpecificType.pothole);
      expect(result.isUsable, isTrue);
    });
  });

  group('confidence behaviour', () {
    test('agreement between text and user choice beats disagreement', () async {
      final agreeing = await classifier.classify(
        text: 'Aagay gali band hai',
        userSelectedType: SpecificType.roadBlockage,
      );
      final disagreeing = await classifier.classify(
        text: 'Aagay gali band hai',
        userSelectedType: SpecificType.pothole,
      );
      expect(agreeing.confidence, greaterThan(disagreeing.confidence));
      // A disagreement must ask the user to check.
      expect(disagreeing.needsConfirmation, isTrue);
    });

    test('unrecognised text falls back with low confidence', () async {
      final result = await classifier.classify(
        text: 'something completely unrelated to roads',
        userSelectedType: SpecificType.other,
      );
      expect(result.confidence, lessThan(0.7));
      expect(result.needsConfirmation, isTrue);
    });
  });

  group('failure path', () {
    test('forceFailure throws so the UI can fall back to manual', () async {
      classifier.forceFailure = true;
      expect(
        () => classifier.classify(text: 'Road kharab hai'),
        throwsA(isA<AiUnavailableException>()),
      );
    });

    test('the failure flag is consumed, not sticky', () async {
      classifier.forceFailure = true;
      try {
        await classifier.classify(text: 'Road kharab hai');
      } on AiUnavailableException {
        // expected
      }
      final next = await classifier.classify(text: 'Road kharab hai');
      expect(next.specificType, SpecificType.roadDamage);
    });
  });

  group('JSON contract', () {
    test('output matches the exact field set the blueprint specifies', () async {
      final result = await classifier.classify(text: 'Yahan seepage hai');
      final json = result.toJson();
      expect(
        json.keys.toSet(),
        {
          'category',
          'specificType',
          'summary',
          'language',
          'severity',
          'urgency',
          'confidence',
          'safePublicText',
          'needsConfirmation',
          'doNotPublish',
        },
      );
      expect(json['confidence'], isA<double>());
      expect(json['needsConfirmation'], isA<bool>());
      expect(json['doNotPublish'], isA<bool>());
      expect(
        ReportCategory.values.map((e) => e.wire),
        contains(json['category']),
      );
      expect(
        SpecificType.values.map((e) => e.wire),
        contains(json['specificType']),
      );
    });

    test('summary stays under the 25-word limit', () async {
      final result = await classifier.classify(
        text: 'Road par bohat zyada pani jama ho gaya hai aur bike nahi ja sakti',
      );
      expect(result.summary.split(RegExp(r'\s+')).length, lessThan(25));
    });
  });

  group('severity', () {
    test('blockages and accidents rate high, potholes low', () async {
      final blockage = await classifier.classify(text: 'Aagay gali band hai');
      final pothole = await classifier.classify(text: 'Yahan gaddha hai');
      expect(blockage.severity, Severity.high);
      expect(pothole.severity, Severity.low);
    });

    test('intensifiers raise severity', () async {
      final mild = await classifier.classify(text: 'Yahan seepage hai');
      final strong =
          await classifier.classify(text: 'Yahan bohat zyada seepage hai');
      expect(strong.severity.multiplier,
          greaterThanOrEqualTo(mild.severity.multiplier));
    });
  });
}
