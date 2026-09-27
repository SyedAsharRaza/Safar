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
  String get live => 'Connected';

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

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get alerts => 'Alerts';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get noAlertsYet => 'No alerts yet';

  @override
  String get willHearUsWhenNew =>
      'You will hear from us when a new report lands on a route you use, when someone confirms one of your reports, or when a check-in needs your attention.';

  @override
  String get reportedAnythingYet => 'You have not reported anything yet';

  @override
  String get firstTimeTellOtherTravellers =>
      'The first time you tell other travellers about a blocked lane or a broken streetlight, it will show up here.';

  @override
  String get makeFirstReport => 'Make your first report';

  @override
  String get totalReports => 'Total reports';

  @override
  String get liveNow => 'Live now';

  @override
  String get confirmedOthers => 'Confirmed by others';

  @override
  String get live2 => 'Live';

  @override
  String get stillAffectingRouteAwareness => 'Still affecting route awareness';

  @override
  String get expiredWithheld => 'Expired and withheld';

  @override
  String get noLongerAffectingRoutes => 'No longer affecting routes';

  @override
  String get noCheckInsYet => 'No check-ins yet';

  @override
  String get checkTimerShareSomeoneTrust =>
      'A check-in is a timer you share with someone you trust. If you do not confirm you arrived, they know to look for you.';

  @override
  String get startCheck => 'Start a check-in';

  @override
  String get runningNow => 'Running now';

  @override
  String get open => 'Open';

  @override
  String get pastCheckIns => 'Past check-ins';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get shownOnly => 'Shown only to you';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get password => 'Password';

  @override
  String get continueWithoutAccount => 'Continue without an account';

  @override
  String get doNeedAccount => 'You do not need an account';

  @override
  String get reportingRoutesCheckInsAll =>
      'Reporting, routes and check-ins all work anonymously. Your number is never shown to other travellers and never attached to a published report.';

  @override
  String get cancelCheck => 'Cancel the check-in?';

  @override
  String get timerStopsContactsWillNotified =>
      'The timer stops and your contacts will not be notified either way. You can start a new one whenever you like.';

  @override
  String get keepRunning => 'Keep it running';

  @override
  String get noCheckRunning => 'No check-in running';

  @override
  String get checkAlreadyFinishedStartNew =>
      'This check-in has already finished. Start a new one from the home screen when you next set off.';

  @override
  String get check => 'Check-in';

  @override
  String get emergencyNumbers => 'Emergency numbers';

  @override
  String get checkWindowPassed => 'Your check-in window has passed';

  @override
  String get fullProductContactsWouldBeen =>
      'In the full product your contacts would have been reminded to check on you by now. Let them know you are safe, or extend the timer if you are still on the way.';

  @override
  String get notifyingContactsSimulatedUiBuild =>
      'Notifying contacts is simulated in this UI build — no message is actually sent.';

  @override
  String get destination => 'Destination';

  @override
  String get route => 'Route';

  @override
  String get started => 'Started';

  @override
  String get due => 'Due by';

  @override
  String get livePosition => 'Live position';

  @override
  String get startedCheckWithoutContactSo =>
      'You started this check-in without a contact, so the timer is just for you. Adding someone makes it far more useful.';

  @override
  String get needMoreMinutes => 'Need 10 more minutes';

  @override
  String get checkAlreadyRunning => 'A check-in is already running';

  @override
  String get onlyOneCheckTimeOpen =>
      'You can only have one check-in at a time. Open the running one, or cancel it first.';

  @override
  String get open2 => 'Open it';

  @override
  String get stayHere => 'Stay here';

  @override
  String get startWithoutContact => 'Start without a contact?';

  @override
  String get nobodyWillToldIfDo =>
      'Nobody will be told if you do not check in. The timer will still remind you, but a check-in works best when someone knows.';

  @override
  String get startAnyway => 'Start anyway';

  @override
  String get chooseContact => 'Choose a contact';

  @override
  String get setTimerIfDoConfirm =>
      'Set a timer. If you do not confirm you arrived, your trusted contacts are reminded to check on you.';

  @override
  String get howLongDoExpectTake => 'How long do you expect to take?';

  @override
  String get whoShouldNotified => 'Who should be notified?';

  @override
  String get manage => 'Manage';

  @override
  String get noTrustedContactsYet => 'No trusted contacts yet';

  @override
  String get addSomeoneWouldWantKnow =>
      'Add someone you would want to know if you did not arrive.';

  @override
  String get addContact => 'Add a contact';

  @override
  String get shareMyLivePosition => 'Share my live position';

  @override
  String get simulatedBuildNoLocationPermission =>
      'Simulated in this build — no location permission is used';

  @override
  String get primary => 'Primary';

  @override
  String get addTrustedContact => 'Add a trusted contact';

  @override
  String get someoneWhoWouldNoticeIf =>
      'Someone who would notice if you did not arrive. Stored on this device only.';

  @override
  String get name => 'Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get familyRoommateColleague => 'Family, roommate, colleague…';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get addContact2 => 'Add contact';

  @override
  String get noTrustedContacts => 'No trusted contacts';

  @override
  String get addSomeoneWouldWantTold =>
      'Add someone you would want to be told if you did not arrive. Their number stays on this device.';

  @override
  String get addFirstContact => 'Add your first contact';

  @override
  String get contactsStoredDeviceOnlySafar =>
      'Contacts are stored on this device only. Safar does not upload your contact list.';

  @override
  String get theyWillNoLongerOffered =>
      'They will no longer be offered when you start a check-in.';

  @override
  String get makePrimary => 'Make primary';

  @override
  String get recentre => 'Recentre';

  @override
  String get tapPinMapScrollList => 'Tap a pin on the map, or scroll the list.';

  @override
  String get nothingMatchesTheseFilters => 'Nothing matches these filters';

  @override
  String get noLiveReportsCategoriesSelected =>
      'No live reports in the categories you selected. Clear the filters to see everything in the demo area.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noSignalsAreaYet => 'No signals in this area yet';

  @override
  String get limitedDataSameClearRoad =>
      'Limited data is not the same as a clear road. If you see something, you can be the first to report it.';

  @override
  String get addReport => 'Add a report';

  @override
  String get howRouteAwarenessCalculated => 'How route awareness is calculated';

  @override
  String get simulatedPositionPrototype =>
      'Simulated position for this prototype';

  @override
  String get bahawalpur => 'Bahawalpur';

  @override
  String get afterDarkLightingReportsCount =>
      'After dark, lighting reports count for more';

  @override
  String get night => 'Night';

  @override
  String get demoControls => 'Demo controls';

  @override
  String get couldLoadSignals => 'Could not load signals';

  @override
  String get nothingBeenReportedDemoArea =>
      'Nothing has been reported in the demo area recently. That is not the same as \"all clear\" — it means we have no data.';

  @override
  String get uiPrototypeV => 'UI prototype · v1.0.0';

  @override
  String get whatSafar => 'What Safar is not';

  @override
  String get privacyAbusePrevention => 'Privacy and abuse prevention';

  @override
  String get aboutDataBuild => 'About the data in this build';

  @override
  String get routesPlannedOverHandBuilt =>
      'Routes are planned over a hand-built road network for one area of Bahawalpur. Coordinates are approximate and are not survey data. The map is drawn by the app rather than served by a maps provider. Classification of report text runs locally, not against a hosted model.';

  @override
  String get builtBahawalpur => 'Built for Bahawalpur.';

  @override
  String get presentingUsers => 'For presenting, not for users';

  @override
  String get theseSwitchesExistSoEvery =>
      'These switches exist so every state in the prototype can be shown on demand. In a production build this screen would not ship.';

  @override
  String get userPersona => 'User persona';

  @override
  String get communitySignalData => 'Community signal data';

  @override
  String get reloadSeededSignals => 'Reload seeded signals';

  @override
  String get emptyMap => 'Empty the map';

  @override
  String get showsEveryNoDataEmpty => 'Shows every \"no data\" and empty state';

  @override
  String get forceLoadFailure => 'Force a load failure';

  @override
  String get showsErrorStateRetry => 'Shows the error state with retry';

  @override
  String get showExpiredReports => 'Show expired reports';

  @override
  String get greyedOutNoEffectRouting => 'Greyed out, no effect on routing';

  @override
  String get backend => 'Backend';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String get pushesEverySubscribedDevice => 'Pushes to every subscribed device';

  @override
  String get failurePaths => 'Failure paths';

  @override
  String get breakReportClassifier => 'Break the report classifier';

  @override
  String get nextReportFallsBackManual =>
      'Next report falls back to manual category selection';

  @override
  String get simulateOffline => 'Simulate offline';

  @override
  String get offlineBannerPlusCachedData =>
      'Offline banner plus the cached-data path';

  @override
  String get otherStates => 'Other states';

  @override
  String get clearTrustedContacts => 'Clear trusted contacts';

  @override
  String get clearAllAlerts => 'Clear all alerts';

  @override
  String get showsEmptyActivityTab => 'Shows the empty Activity tab';

  @override
  String get resetCurrentTrip => 'Reset the current trip';

  @override
  String get clearsOriginDestinationPlannedRoutes =>
      'Clears origin, destination and planned routes';

  @override
  String get twoMinuteDemo => 'The two-minute demo';

  @override
  String get reportingSomethingSafarDoesAlert =>
      'Reporting something in Safar does not alert the authorities. If someone is in danger, call emergency services directly.';

  @override
  String get howWorks => 'How it works';

  @override
  String get routeAwarenessSafetyScore => 'Route awareness, not a safety score';

  @override
  String get fourLevels => 'The four levels';

  @override
  String get whatGoesIntoNumber => 'What goes into the number';

  @override
  String get eachRoadSegmentGetsScore =>
      'Each road segment gets a score from five weighted inputs. A route is the length-weighted average of its segments.';

  @override
  String get theseWeightsPrototypeValuesChosen =>
      'These weights are prototype values chosen for a sensible demo. They are not validated against real incident data.';

  @override
  String get newerReportsCountMore => 'Newer reports count for more';

  @override
  String get everyReportLosesInfluenceAges =>
      'Every report loses influence as it ages, and how fast depends on the kind of problem. An accident stops mattering within hours; a broken streetlight stays relevant for days.';

  @override
  String get howReportsEarnTrust => 'How reports earn trust';

  @override
  String get whatEachReportDoesRouting => 'What each report does to routing';

  @override
  String get honestCaveat => 'The honest caveat';

  @override
  String get skip => 'Skip';

  @override
  String get normalMapTellsNtheFastest =>
      'A normal map tells you\\nthe fastest way.';

  @override
  String get safarTellsWhatExpectWay =>
      'Safar tells you what to expect on the way.';

  @override
  String get residentReportsWhatTheySee => 'A resident reports what they see';

  @override
  String get reportBecomesStructuredSignal =>
      'The report becomes a structured signal';

  @override
  String get routesComparedExplained => 'Routes are compared, and explained';

  @override
  String get nextTravellerWarned => 'The next traveller is warned';

  @override
  String get oneReportOnePersonHelps =>
      'One report from one person helps everyone who travels that road next.';

  @override
  String get whatAppWillDo => 'What this app will not do';

  @override
  String get worthReadingBeforeRely => 'Worth reading before you rely on it.';

  @override
  String get itIsNot => 'It is not';

  @override
  String get pickLanguage => 'Pick your language';

  @override
  String get setsVoiceWarningsWordingReport =>
      'This sets the voice warnings and the wording of report prompts. You can always report in whichever language you actually speak.';

  @override
  String get loadingCommunitySignalsBahawalpur =>
      'Loading community signals for Bahawalpur';

  @override
  String get reportsStillPublishedAnonymouslyOther =>
      'Your reports are still published anonymously. Other travellers never see your name or number — the account only keeps your history if you change phone.';

  @override
  String get anonymous => 'You are anonymous';

  @override
  String get everythingWorksWithoutAccountAdding =>
      'Everything works without an account. Adding one keeps your reports and saved places if you change phone.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get reportsMade => 'Reports made';

  @override
  String get signalsConfirmed => 'Signals confirmed';

  @override
  String get tripsCompared => 'Trips compared';

  @override
  String get stuff => 'Your stuff';

  @override
  String get preferences => 'Preferences';

  @override
  String get shortSpokenAlertsBeforeSet =>
      'Short spoken alerts before you set off';

  @override
  String get allSettings => 'All settings';

  @override
  String get howRouteAwarenessWorks => 'How route awareness works';

  @override
  String get aboutSafar => 'About Safar';

  @override
  String get returnAnonymousUsePhone => 'Return to anonymous use on this phone';

  @override
  String get signOut2 => 'Sign out?';

  @override
  String get willKeepUsingSafarAnonymously =>
      'You will keep using Safar anonymously. Your reports stay on your account and come back when you sign in.';

  @override
  String get bringReportsAnotherPhone => 'Bring reports from another phone';

  @override
  String get setsVoiceWarningsPromptWording =>
      'Sets voice warnings and prompt wording.';

  @override
  String get tiersRecogniseContributionTheyNever =>
      'Tiers recognise contribution. They never make a report count as verified — only confirmations from other travellers do that.';

  @override
  String get labelPlace => 'Label this place';

  @override
  String get shortNameLikeHomeWork =>
      'A short name like \"Home\", \"Work\" or \"Ammi\\\'s house\".';

  @override
  String get labelOptional => 'Label (optional)';

  @override
  String get noSavedPlaces => 'No saved places';

  @override
  String get tapBookmarkNextAnyPlace =>
      'Tap the bookmark next to any place while searching, and it will appear here for one-tap routing.';

  @override
  String get willNoLongerAppear =>
      'It will no longer appear in your saved places.';

  @override
  String get changeLabel => 'Change label';

  @override
  String get routeHere => 'Route here';

  @override
  String get languageVoice => 'Language and voice';

  @override
  String get warningsPromptsSummaries => 'Warnings, prompts and summaries';

  @override
  String get reportsNeverCarryName => 'Your reports never carry a name';

  @override
  String get roundSafetyConcernReportsRoughly =>
      'Round safety-concern reports to roughly a 250 m area';

  @override
  String get mapData => 'Map and data';

  @override
  String get greyedOutTheyDoAffect =>
      'Greyed out, and they do not affect routes';

  @override
  String get reloadCommunitySignals => 'Reload community signals';

  @override
  String get fetchSeededDemonstrationDataAgain =>
      'Fetch the seeded demonstration data again';

  @override
  String get prototypeControls => 'Prototype controls';

  @override
  String get demoControlPanel => 'Demo control panel';

  @override
  String get switchPersonasForceErrorsEmpty =>
      'Switch personas, force errors, empty the data — for demos';

  @override
  String get showsOfflineBannerCachedData =>
      'Shows the offline banner and the cached-data path';

  @override
  String get aboutLimitations => 'About and limitations';

  @override
  String get clearLocalData => 'Clear local data';

  @override
  String get resetsSavedPlacesContactsAlerts =>
      'Resets saved places, contacts and alerts';

  @override
  String get clearLocalData2 => 'Clear local data?';

  @override
  String get savedPlacesTrustedContactsAlerts =>
      'Saved places, trusted contacts and alerts on this device will be removed. Seeded demonstration signals stay, so the demo keeps working.';

  @override
  String get clearData => 'Clear data';

  @override
  String get confirmReport => 'Confirm this report?';

  @override
  String get onlyConfirmIfSeenYourself =>
      'Only confirm if you have seen this yourself. Confirmations are what move a signal from unverified to confirmed.';

  @override
  String get yesISaw => 'Yes, I saw this';

  @override
  String get disputeReport => 'Dispute this report?';

  @override
  String get useWhenConditionNoLonger =>
      'Use this when the condition is no longer there, or was never there. Two disputes mark the report as disputed for everyone.';

  @override
  String get dispute => 'Dispute it';

  @override
  String get withdrawReport => 'Withdraw your report?';

  @override
  String get willStopAffectingRoutesImmediately =>
      'It will stop affecting routes immediately and will no longer be shown to other travellers.';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get report => 'Report';

  @override
  String get reportNoLongerAvailable => 'This report is no longer available';

  @override
  String get mayExpiredBeenWithdrawnWhoever =>
      'It may have expired or been withdrawn by whoever submitted it.';

  @override
  String get goBack => 'Go back';

  @override
  String get approximateLocation => 'Approximate location';

  @override
  String get report2 => 'Your report';

  @override
  String get published => 'Not published';

  @override
  String get reportWithheldBecauseAppeared =>
      'This report was withheld because it appeared to identify a specific person. It never affected routes and no other traveller can see it.';

  @override
  String get whatTravellersSee => 'What travellers see';

  @override
  String get visibleOnly => 'Visible only to you.';

  @override
  String get severity => 'Severity';

  @override
  String get confirmations => 'Confirmations';

  @override
  String get disputes => 'Disputes';

  @override
  String get routeEffect => 'Route effect';

  @override
  String get expiry => 'Expiry';

  @override
  String get reported => 'Reported in';

  @override
  String get categorised => 'Categorised';

  @override
  String get reported2 => 'Reported by';

  @override
  String get onlyLiveReportStretchSo =>
      'This is the only live report on this stretch, so the signal rests on one person. Confirmations from other travellers make it more reliable.';

  @override
  String get expiredReportsNoLongerAffect =>
      'Expired reports no longer affect routes.';

  @override
  String get withdrawReport2 => 'Withdraw this report';

  @override
  String get discardReport => 'Discard this report?';

  @override
  String get whatEnteredSoFarWill =>
      'What you have entered so far will not be saved, and nothing will be published.';

  @override
  String get discard => 'Discard';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get hitHourlyLimit => 'You have hit the hourly limit';

  @override
  String get rateLimitsExistSoOne =>
      'Rate limits exist so one person cannot flood an area with reports. Your earlier reports are still live.';

  @override
  String get understood => 'Understood';

  @override
  String get pickClosestCategoryCorrectLater =>
      'Pick the closest category. You can correct it later if the app reads your description differently.';

  @override
  String get pickCategoryFirst => 'Pick a category first';

  @override
  String get goBackStepChooseWhat =>
      'Go back a step and choose what kind of thing you are reporting.';

  @override
  String get chooseCategory => 'Choose a category';

  @override
  String get change => 'Change';

  @override
  String get phraseUnderneathEachOptionHow =>
      'The phrase underneath each option is how people usually say it.';

  @override
  String get tapPlacePin => 'Tap to place the pin';

  @override
  String get roundedAboutM => 'Rounded to about 250 m';

  @override
  String get reportWillApplyRoadSegment =>
      'This report will apply to this road segment';

  @override
  String get safetyConcernReportsAlwaysRounded =>
      'Safety-concern reports are always rounded to an approximate area before publishing, so a report never points at one doorstep.';

  @override
  String get sensitiveCategory => 'Sensitive category';

  @override
  String get optionalWriteEnglishUrduRoman =>
      'Optional. Write in English, Urdu or Roman Urdu — whichever is natural. The app reads it and suggests a category, which you then confirm.';

  @override
  String get eGAagayGaliBand => 'e.g. \"Aagay gali band hai\"';

  @override
  String get tapExampleUse => 'Tap an example to use it';

  @override
  String get doIncludeNamesPhoneNumbers =>
      'Do not include names, phone numbers, vehicle plates or private addresses. Reports that identify a person are never published.';

  @override
  String get whatWrite => 'What not to write';

  @override
  String get chooseRightCategory => 'Choose the right category';

  @override
  String get correctionWhatGetsPublishedCorrections =>
      'Your correction is what gets published. Corrections also help us see where the classifier is weak.';

  @override
  String get reportPublished => 'Your report was not published';

  @override
  String get cancelReport => 'Cancel this report?';

  @override
  String get nothingWillPublishedTextWill =>
      'Nothing will be published and your text will not be saved.';

  @override
  String get cancelReport2 => 'Cancel report';

  @override
  String get keep => 'Keep it';

  @override
  String get reviewBeforePublishing => 'Review before publishing';

  @override
  String get automaticReadingUnavailable => 'Automatic reading unavailable';

  @override
  String get tryReadingAgain => 'Try reading it again';

  @override
  String get enoughDetailPublish => 'Not enough detail to publish';

  @override
  String get couldTellWhatReportAbout =>
      'We could not tell what this report is about. Add a few more words, or pick the category yourself.';

  @override
  String get chooseCategoryMyself => 'Choose a category myself';

  @override
  String get sureRightPleaseCheckCategory =>
      'We are not sure this is right. Please check the category before publishing.';

  @override
  String get someoneMayReportedAlready =>
      'Someone may have reported this already';

  @override
  String get verySimilarReportSubmittedNearby =>
      'A very similar report was submitted nearby in the last 45 minutes. Publishing yours will count as a confirmation, which makes the signal stronger.';

  @override
  String get corrected => 'You corrected this';

  @override
  String get unverifiedUntilConfirmed => 'Unverified until confirmed';

  @override
  String get effectRouting => 'Effect on routing';

  @override
  String get onlySeeOriginalWordingOthers =>
      'Only you can see your original wording. Others see the neutral summary above.';

  @override
  String get nothingAboutIdentifiablePersonWill =>
      'Nothing about an identifiable person will be published.';

  @override
  String get iUnderstandGoBack => 'I understand — go back';

  @override
  String get editMyDescription => 'Edit my description';

  @override
  String get readingReport => 'Reading your report…';

  @override
  String get stillReportConditionItselfExample =>
      'You can still report the condition itself — for example \"this lane feels unsafe at night\" — without describing a person.';

  @override
  String get structuredOutput => 'Structured output';

  @override
  String get whatHappensNext => 'What happens next';

  @override
  String get otherTravellersConfirm => 'Other travellers can confirm it';

  @override
  String get fadesOverTime => 'It fades over time';

  @override
  String get stayControl => 'You stay in control';

  @override
  String get routesUpdated => 'Routes updated';

  @override
  String get reportAlreadyPartHowThese =>
      'Your report is already part of how these routes are scored.';

  @override
  String get shareSignal => 'Share this signal';

  @override
  String get playVoiceWarning => 'Play voice warning';

  @override
  String get estimatedTime => 'Estimated time';

  @override
  String get distance => 'Distance';

  @override
  String get liveReports => 'Live reports';

  @override
  String get route2 => 'On this route';

  @override
  String get limitedDataRoute => 'Limited data on this route';

  @override
  String get nobodyReportedAnythingHereRecently =>
      'Nobody has reported anything here recently. That is not a clear signal either way — it just means we do not know.';

  @override
  String get reportWhatSee => 'Report what you see';

  @override
  String get stepStep => 'Step by step';

  @override
  String get roadsRoute => 'Roads on this route';

  @override
  String get whyAwarenessLevel => 'Why this awareness level?';

  @override
  String get checkNotificationsSimulatedUiBuild =>
      'Check-in notifications are simulated in this UI build.';

  @override
  String get reportNearbyIssue => 'Report a nearby issue';

  @override
  String get baselineLighting => 'Baseline lighting';

  @override
  String get howBusy => 'How busy';

  @override
  String get reportedDelay => 'Reported delay';

  @override
  String get noCommunityReportsStretchLevel =>
      'No community reports on this stretch. The level above comes from its baseline lighting and how busy it usually is.';

  @override
  String get communitySignal => 'Community signal';

  @override
  String get tapThroughFullReportIts =>
      'Tap through for the full report and its route effect.';

  @override
  String get reportNoLongerAvailable2 => 'This report is no longer available.';

  @override
  String get openReport => 'Open report';

  @override
  String get reverseTrip => 'Reverse the trip';

  @override
  String get recentreMap => 'Recentre the map';

  @override
  String get comparingRoutes => 'Comparing routes…';

  @override
  String get scoringEachRoadSegmentAgainst =>
      'Scoring each road segment against recent community reports.';

  @override
  String get changeDestination => 'Change destination';

  @override
  String get thesePlacesTooCloseTogether =>
      'These places are too close together';

  @override
  String get startDestinationSitSameJunction =>
      'Your start and destination sit on the same junction of the road network, so there is nothing to compare. Pick a destination further away.';

  @override
  String get noRouteBetweenThesePoints => 'No route between these points';

  @override
  String get prototypeCoversOneDemoArea =>
      'This prototype covers one demo area of Bahawalpur, so not every pair of places is connected in the seeded road network. Try a different destination.';

  @override
  String get sortRoutes => 'Sort routes';

  @override
  String get seededRoadNetworkOffersNo =>
      'The seeded road network offers no meaningfully different alternative for this trip, so there is only one option to show.';

  @override
  String get reportIssueRoute => 'Report an issue on this route';

  @override
  String get simulatedNoLocationPermissionRequested =>
      'Simulated — no location permission is requested';

  @override
  String get clear => 'Clear';

  @override
  String get noSavedRecentPlacesYet => 'No saved or recent places yet';

  @override
  String get searchDestinationBelowPlacesPick =>
      'Search for a destination below. Places you pick will show up here next time.';

  @override
  String get prototypeCoversOneDemoArea2 =>
      'This prototype covers one demo area of Bahawalpur, so the place list is limited. Try \"Model Town\", \"university\" or \"bazaar\".';

  @override
  String get nothingSavedYet => 'Nothing saved yet';

  @override
  String get tapBookmarkAnyPlaceKeep =>
      'Tap the bookmark on any place to keep it here for quick access.';

  @override
  String get backSearch => 'Back to search';

  @override
  String get willNoLongerAppearSaved =>
      'It will no longer appear in your saved places. You can save it again any time.';

  @override
  String get offlineMap => 'Offline map';

  @override
  String get manuallyCategorised => 'Manually categorised';

  @override
  String get howLevelCalculated => 'How this level was calculated';

  @override
  String get textSpeechPreview => 'Text-to-speech preview';

  @override
  String get warningsStayShortSoThey =>
      'Warnings stay short so they are usable while travelling.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get reportNotPublishedTitle => 'Your report was not published';

  @override
  String get reportWithheldBody =>
      'It appeared to identify a specific person. Reports about identifiable individuals are never published.';

  @override
  String get howStep1Title => 'A resident reports what they see';

  @override
  String get howStep1Body =>
      'In English, Urdu, Roman Urdu or Punjabi — \"aagay gali band hai\", \"road par pani khara hai\", \"streetlight band hai\".';

  @override
  String get howStep2Title => 'The report becomes a structured signal';

  @override
  String get howStep2Body =>
      'Informal text is turned into a category, a severity and a neutral public summary. You always review it before it is published.';

  @override
  String get howStep3Title => 'Routes are compared, and explained';

  @override
  String get howStep3Body =>
      'Fresh reports count more than old ones. Every route says in plain words what it avoids and what it costs you in minutes.';

  @override
  String get howStep4Title => 'The next traveller is warned';

  @override
  String get howStep4Body =>
      'A short voice warning before you set off, and a safety check-in you can share with someone you trust.';
}
