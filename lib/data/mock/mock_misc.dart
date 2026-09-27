import '../../models/app_notification.dart';
import '../../models/trusted_contact.dart';
import '../../models/user_profile.dart';

abstract final class MockContacts {
  static const List<TrustedContact> all = [
    TrustedContact(
      id: 'tc_01',
      name: 'Ammi',
      relation: 'Family',
      phone: '+92 300 4412987',
      isPrimary: true,
    ),
    TrustedContact(
      id: 'tc_02',
      name: 'Bilal Tariq',
      relation: 'Brother',
      phone: '+92 321 7745120',
    ),
    TrustedContact(
      id: 'tc_03',
      name: 'Hina Rasheed',
      relation: 'Hostel roommate',
      phone: '+92 333 9061844',
    ),
  ];
}

abstract final class MockUser {
  static UserProfile profile() => UserProfile(
        handle: 'Traveller #4821',
        joinedAt: DateTime.now().subtract(const Duration(days: 47)),
        reportsSubmitted: 14,
        confirmationsGiven: 22,
        reportsHelpful: 9,
        tripsCompared: 63,
        homeArea: 'Model Town A',
      );
}

abstract final class MockNotifications {
  static DateTime _ago(Duration d) => DateTime.now().subtract(d);

  static List<AppNotification> seed() => [
        AppNotification(
          id: 'nt_01',
          kind: NotificationKind.routeAlert,
          title: 'New blockage report on a route you use',
          body:
              'Shahi Bazaar: the road ahead may be blocked by construction material. '
              'An alternative is available.',
          createdAt: _ago(const Duration(minutes: 18)),
          reportId: 'rep_001',
        ),
        AppNotification(
          id: 'nt_02',
          kind: NotificationKind.reportConfirmed,
          title: 'Two travellers confirmed your report',
          body:
              'Your lighting report on Model Town Road is now shown as confirmed '
              'by the community.',
          createdAt: _ago(const Duration(hours: 4)),
          reportId: 'rep_mine_01',
        ),
        AppNotification(
          id: 'nt_03',
          kind: NotificationKind.reportWithheld,
          title: 'One of your reports was not published',
          body:
              'It appeared to identify a specific person. Reports about identifiable '
              'individuals are never published.',
          createdAt: _ago(const Duration(hours: 9)),
          reportId: 'rep_mine_03',
          read: true,
        ),
        AppNotification(
          id: 'nt_04',
          kind: NotificationKind.reportExpired,
          title: 'A report you submitted expired',
          body:
              'Your road-damage report on Abbasia link road has expired and no '
              'longer affects route awareness.',
          createdAt: _ago(const Duration(hours: 26)),
          reportId: 'rep_mine_02',
          read: true,
        ),
        AppNotification(
          id: 'nt_05',
          kind: NotificationKind.community,
          title: '9 new reports in your area today',
          body:
              'Most were about lighting and water on the road. Tap to see them on '
              'the map.',
          createdAt: _ago(const Duration(hours: 30)),
          read: true,
        ),
        AppNotification(
          id: 'nt_06',
          kind: NotificationKind.system,
          title: 'About the data you see',
          body:
              'This prototype shows clearly labelled demonstration community '
              'signals, not live or official reports.',
          createdAt: _ago(const Duration(days: 2)),
          read: true,
        ),
      ];
}

/// Short voice-warning scripts. The blueprint asks for Flutter TTS here; this
/// prototype shows the same copy in an animated speaking sheet instead.
abstract final class MockVoiceLines {
  static const Map<String, String> blockedEnglish = {
    'en':
        'Caution. A road blockage has recently been reported ahead. An alternate route is available.',
    'roman':
        'Ehtiyaat karein. Aagay gali band honay ki community report mili hai. Alternate route available hai.',
    'ur':
        'احتیاط کریں۔ آگے راستہ بند ہونے کی کمیونٹی رپورٹ موصول ہوئی ہے۔ متبادل راستہ دستیاب ہے۔',
    'pa':
        'خیال رکھو۔ اگے راہ بند ہون دی کمیونٹی رپورٹ آئی اے۔ دوجا راہ موجود اے۔',
  };

  static const Map<String, String> waterEnglish = {
    'en':
        'Caution. Standing water has been reported on the road ahead. Ride carefully.',
    'roman':
        'Ehtiyaat karein. Aagay wali road par pani jama honay ki report hai. Dhyan se chalain.',
    'ur':
        'احتیاط کریں۔ آگے سڑک پر پانی جمع ہونے کی رپورٹ ہے۔ دھیان سے چلیں۔',
    'pa': 'خیال رکھو۔ اگے سڑک تے پانی کھلوتا ہون دی رپورٹ اے۔ دھیان نال چلو۔',
  };

  static const Map<String, String> lightingEnglish = {
    'en':
        'Note. Two low-light reports are on this route. A better-lit alternative is available.',
    'roman':
        'Note karein. Is rastay par do jagah kam roshni ki report hai. Behtar roshni wala rasta mojood hai.',
    'ur':
        'نوٹ کریں۔ اس راستے پر دو مقامات پر کم روشنی کی رپورٹ ہے۔ بہتر روشنی والا راستہ موجود ہے۔',
    'pa':
        'دھیان دیو۔ ایس راہ تے دو تھاواں تے گھٹ روشنی دی رپورٹ اے۔ ودھ روشنی والا راہ موجود اے۔',
  };

  static const Map<String, String> clearRoute = {
    'en': 'No recent community reports on this route. Travel safely.',
    'roman': 'Is rastay par koi taza report nahi hai. Safar mehfooz rahe.',
    'ur': 'اس راستے پر کوئی تازہ رپورٹ نہیں ہے۔ سفر محفوظ رہے۔',
    'pa': 'ایس راہ تے کوئی تازہ رپورٹ نہیں۔ سفر سلامت رہوے۔',
  };
}
