/// Product-level copy and constants. Centralised because the disclaimer and the
/// "demonstration data" labelling must read identically everywhere they appear.
abstract final class AppText {
  static const String appName = 'Bahawalpur Safar';
  static const String tagline = 'Know the road before you take it.';
  static const String taglineRoman = 'Rasta lene se pehle jaan lein.';

  static const String pitch =
      'A community-powered route-awareness app that helps you choose '
      'better-informed routes using fresh reports about lighting, road '
      'conditions, blockages, hazards, and local safety concerns.';

  /// Shown on the home screen and anywhere routes are compared.
  static const String disclaimer =
      'Community reports may be incomplete or unverified. This app does not '
      'guarantee safety or road availability.';

  static const String demoDataLabel = 'Demonstration community signals';

  static const String demoDataExplainer =
      'This prototype uses clearly labelled demonstration reports for one area '
      'of Bahawalpur. They are not live or official data.';

  static const String notEmergency =
      'Bahawalpur Safar is not an emergency service. For emergencies contact '
      'Rescue 1122 or Police 15 directly.';

  static const String privacyPromise =
      'Reports are anonymous by default. We never publish names, faces, phone '
      'numbers, vehicle plates, or private addresses.';

  static const String awarenessExplainer =
      'Route awareness combines recent community reports with each road\'s '
      'lighting and activity. Newer reports count more, and reports fade over '
      'time. It is never a safety score or a percentage.';

  static const String uiOnlyBuildNote =
      'UI prototype build. Reports, routes, and AI classification run on local '
      'demonstration data — no backend is connected.';
}

abstract final class AppLimits {
  /// Rate limit shown in the report flow. Enforced locally in this prototype.
  static const int maxReportsPerHour = 5;
  static const int descriptionMaxChars = 280;
  static const Duration duplicateWindow = Duration(minutes: 45);

  static const List<Duration> checkinDurations = [
    Duration(minutes: 10),
    Duration(minutes: 20),
    Duration(minutes: 30),
    Duration(minutes: 45),
    Duration(minutes: 60),
  ];
}

/// Helpline numbers surfaced in the emergency sheet. Displayed only — the
/// prototype does not place calls.
abstract final class Helplines {
  static const List<({String name, String number, String note})> all = [
    (name: 'Rescue 1122', number: '1122', note: 'Medical and fire emergencies'),
    (name: 'Police', number: '15', note: 'Punjab Police emergency'),
    (
      name: 'Punjab Emergency Helpline',
      number: '1129',
      note: 'Non-emergency reporting'
    ),
    (
      name: 'Motorway Police',
      number: '130',
      note: 'Highways and motorway assistance'
    ),
    (
      name: 'Women Safety (Virtual Police Station)',
      number: '1043',
      note: 'Punjab women safety helpline'
    ),
  ];
}
