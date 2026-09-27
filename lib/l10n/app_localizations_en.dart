// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Safar';

  @override
  String get tagline => 'Know the road before you take it.';

  @override
  String get cityLine => 'Bahawalpur · Know the road before you take it.';

  @override
  String get navPlan => 'Plan';

  @override
  String get navMap => 'Map';

  @override
  String get navActivity => 'Activity';

  @override
  String get navYou => 'You';

  @override
  String get reportAction => 'Report a road condition';

  @override
  String get greetMorning => 'Good morning';

  @override
  String get greetAfternoon => 'Good afternoon';

  @override
  String get greetEvening => 'Good evening';

  @override
  String get greetNight => 'Travelling tonight';

  @override
  String get greetLate => 'Travelling late';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get chooseStart => 'Choose a starting point';

  @override
  String get whereGoing => 'Where are you going?';

  @override
  String get compareRoutes => 'Compare routes';

  @override
  String get swap => 'Swap';

  @override
  String get aroundYouNow => 'Around you right now';

  @override
  String get liveSignals => 'Live signals';

  @override
  String get inLastHour => 'Last hour';

  @override
  String get roadsBlocked => 'Blocked roads';

  @override
  String get openMap => 'Open map';

  @override
  String get recentSignals => 'Recent community signals';

  @override
  String get happeningNow => 'Happening now';

  @override
  String get noLiveReports => 'No live reports right now';

  @override
  String get noLiveReportsBody =>
      'Nothing has been reported in the demo area recently. That is not the same as \"all clear\" — it means we have no data.';

  @override
  String get beFirstToReport => 'Be the first to report';

  @override
  String get safetyCheckin => 'Safety check-in';

  @override
  String get checkinRunning => 'Check-in running';

  @override
  String get tellSomeone => 'Tell someone you are travelling';

  @override
  String get browseMap => 'Browse the map';

  @override
  String get seeEverySignal => 'See every signal nearby';

  @override
  String get disclaimer =>
      'Community reports may be incomplete or unverified. This app does not guarantee safety or road availability.';

  @override
  String get beforeYouRely => 'Before you rely on this';

  @override
  String get notEmergency =>
      'Safar is not an emergency service. For emergencies contact Rescue 1122 or Police 15 directly.';

  @override
  String get demoData => 'Demo data';

  @override
  String get live => 'Live';

  @override
  String get awarenessLow => 'Low reported caution';

  @override
  String get awarenessModerate => 'Moderate reported caution';

  @override
  String get awarenessElevated => 'Elevated caution';

  @override
  String get awarenessLimited => 'Limited data available';

  @override
  String get confidenceHigh => 'High confidence';

  @override
  String get confidenceModerate => 'Moderate confidence';

  @override
  String get confidenceLow => 'Low confidence';

  @override
  String get routeFastest => 'Fastest route';

  @override
  String get routeBetterLit => 'Better-lit route';

  @override
  String get routeFewerHazards => 'Fewer hazards';

  @override
  String routesToCompare(int count) {
    return '$count routes to compare';
  }

  @override
  String get oneSensibleRoute => 'One sensible route';

  @override
  String get neverSafetyScore => 'Route awareness, never a safety score.';

  @override
  String recentReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recent reports',
      one: '1 recent report',
      zero: 'No recent reports',
    );
    return '$_temp0';
  }

  @override
  String get suggested => 'Suggested';

  @override
  String get seeWhatIsOnRoute => 'See what is on this route';

  @override
  String get passesBlockage => 'Passes a blockage';

  @override
  String get whatReporting => 'What are you reporting?';

  @override
  String get whatExactly => 'What exactly is happening?';

  @override
  String get whereIsIt => 'Where is it?';

  @override
  String get anythingToAdd => 'Anything to add?';

  @override
  String get reviewMyReport => 'Review my report';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get understoodAs => 'We understood this as';

  @override
  String get confirmAndPublish => 'Confirm and publish';

  @override
  String get changeCategory => 'Change category';

  @override
  String get cancel => 'Cancel';

  @override
  String get reportLive => 'Your report is live';

  @override
  String get reportNotPublished => 'Report not published';

  @override
  String get whatOthersSee => 'What other travellers will see';

  @override
  String get whatYouWrote => 'What you wrote';

  @override
  String get cannotPublish => 'This report cannot be published';

  @override
  String get catSafety => 'Safety concern';

  @override
  String get catLighting => 'Lighting';

  @override
  String get catRoad => 'Road condition';

  @override
  String get catWater => 'Water / drainage';

  @override
  String get catBlockage => 'Blockage';

  @override
  String get catTraffic => 'Traffic hazard';

  @override
  String get anonymousByDefault => 'Anonymous by default';

  @override
  String get privacyPromise =>
      'Reports are anonymous by default. We never publish names, faces, phone numbers, vehicle plates, or private addresses.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'Match my device';

  @override
  String get voiceWarnings => 'Voice warnings';

  @override
  String get voiceWarningsSub =>
      'Play a short spoken warning before you set off';

  @override
  String get mapSurface => 'Map surface';

  @override
  String get privacy => 'Privacy';

  @override
  String get reportAnonymously => 'Report anonymously';

  @override
  String get blurSensitive => 'Blur sensitive locations';

  @override
  String get trustedContacts => 'Trusted contacts';

  @override
  String get savedPlaces => 'Saved places';

  @override
  String get myReports => 'My reports';

  @override
  String get about => 'About';

  @override
  String get signOut => 'Sign out';

  @override
  String get signIn => 'Sign in';

  @override
  String get continueAnonymously => 'Continue anonymously';

  @override
  String get retry => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get remove => 'Remove';

  @override
  String get confirm => 'Confirm';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search a place, area or landmark';

  @override
  String noResults(String query) {
    return 'No places match \"$query\"';
  }

  @override
  String get clearSearch => 'Clear search';

  @override
  String get useMyLocation => 'Use my current location';

  @override
  String get recent => 'Recent';

  @override
  String get popularInBwp => 'Popular in Bahawalpur';

  @override
  String get iArrivedSafely => 'I arrived safely';

  @override
  String get cancelCheckin => 'Cancel check-in';

  @override
  String get remaining => 'remaining';

  @override
  String get overdueBy => 'overdue by';

  @override
  String get startCheckin => 'Start safety check-in';

  @override
  String get playWarning => 'Play warning';

  @override
  String get stop => 'Stop';

  @override
  String get voiceWarning => 'Voice warning';

  @override
  String get offlineBanner =>
      'Offline. Showing the last signals saved on this device.';

  @override
  String get couldNotReachServer =>
      'Could not reach the server. Showing demonstration signals.';

  @override
  String get somethingWentWrong => 'Something went wrong';
}
