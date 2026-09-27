import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pa'),
    Locale('ur'),
    Locale.fromSubtags(languageCode: 'ur', scriptCode: 'Latn'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Know the road before you take it.'**
  String get tagline;

  /// No description provided for @cityLine.
  ///
  /// In en, this message translates to:
  /// **'Bahawalpur · Know the road before you take it.'**
  String get cityLine;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get navYou;

  /// No description provided for @reportAction.
  ///
  /// In en, this message translates to:
  /// **'Report a road condition'**
  String get reportAction;

  /// No description provided for @greetMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetMorning;

  /// No description provided for @greetAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetAfternoon;

  /// No description provided for @greetEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetEvening;

  /// No description provided for @greetNight.
  ///
  /// In en, this message translates to:
  /// **'Travelling tonight'**
  String get greetNight;

  /// No description provided for @greetLate.
  ///
  /// In en, this message translates to:
  /// **'Travelling late'**
  String get greetLate;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @chooseStart.
  ///
  /// In en, this message translates to:
  /// **'Choose a starting point'**
  String get chooseStart;

  /// No description provided for @whereGoing.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get whereGoing;

  /// No description provided for @compareRoutes.
  ///
  /// In en, this message translates to:
  /// **'Compare routes'**
  String get compareRoutes;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @aroundYouNow.
  ///
  /// In en, this message translates to:
  /// **'Around you right now'**
  String get aroundYouNow;

  /// No description provided for @liveSignals.
  ///
  /// In en, this message translates to:
  /// **'Live signals'**
  String get liveSignals;

  /// No description provided for @inLastHour.
  ///
  /// In en, this message translates to:
  /// **'Last hour'**
  String get inLastHour;

  /// No description provided for @roadsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked roads'**
  String get roadsBlocked;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open map'**
  String get openMap;

  /// No description provided for @recentSignals.
  ///
  /// In en, this message translates to:
  /// **'Recent community signals'**
  String get recentSignals;

  /// No description provided for @happeningNow.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get happeningNow;

  /// No description provided for @noLiveReports.
  ///
  /// In en, this message translates to:
  /// **'No live reports right now'**
  String get noLiveReports;

  /// No description provided for @noLiveReportsBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been reported in the demo area recently. That is not the same as \"all clear\" — it means we have no data.'**
  String get noLiveReportsBody;

  /// No description provided for @beFirstToReport.
  ///
  /// In en, this message translates to:
  /// **'Be the first to report'**
  String get beFirstToReport;

  /// No description provided for @safetyCheckin.
  ///
  /// In en, this message translates to:
  /// **'Safety check-in'**
  String get safetyCheckin;

  /// No description provided for @checkinRunning.
  ///
  /// In en, this message translates to:
  /// **'Check-in running'**
  String get checkinRunning;

  /// No description provided for @tellSomeone.
  ///
  /// In en, this message translates to:
  /// **'Tell someone you are travelling'**
  String get tellSomeone;

  /// No description provided for @browseMap.
  ///
  /// In en, this message translates to:
  /// **'Browse the map'**
  String get browseMap;

  /// No description provided for @seeEverySignal.
  ///
  /// In en, this message translates to:
  /// **'See every signal nearby'**
  String get seeEverySignal;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Community reports may be incomplete or unverified. This app does not guarantee safety or road availability.'**
  String get disclaimer;

  /// No description provided for @beforeYouRely.
  ///
  /// In en, this message translates to:
  /// **'Before you rely on this'**
  String get beforeYouRely;

  /// No description provided for @notEmergency.
  ///
  /// In en, this message translates to:
  /// **'Safar is not an emergency service. For emergencies contact Rescue 1122 or Police 15 directly.'**
  String get notEmergency;

  /// No description provided for @demoData.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoData;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get live;

  /// No description provided for @awarenessLow.
  ///
  /// In en, this message translates to:
  /// **'Low reported caution'**
  String get awarenessLow;

  /// No description provided for @awarenessModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate reported caution'**
  String get awarenessModerate;

  /// No description provided for @awarenessElevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated caution'**
  String get awarenessElevated;

  /// No description provided for @awarenessLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited data available'**
  String get awarenessLimited;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get confidenceHigh;

  /// No description provided for @confidenceModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate confidence'**
  String get confidenceModerate;

  /// No description provided for @confidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get confidenceLow;

  /// No description provided for @routeFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest route'**
  String get routeFastest;

  /// No description provided for @routeBetterLit.
  ///
  /// In en, this message translates to:
  /// **'Better-lit route'**
  String get routeBetterLit;

  /// No description provided for @routeFewerHazards.
  ///
  /// In en, this message translates to:
  /// **'Fewer hazards'**
  String get routeFewerHazards;

  /// No description provided for @routesToCompare.
  ///
  /// In en, this message translates to:
  /// **'{count} routes to compare'**
  String routesToCompare(int count);

  /// No description provided for @oneSensibleRoute.
  ///
  /// In en, this message translates to:
  /// **'One sensible route'**
  String get oneSensibleRoute;

  /// No description provided for @neverSafetyScore.
  ///
  /// In en, this message translates to:
  /// **'Route awareness, never a safety score.'**
  String get neverSafetyScore;

  /// No description provided for @recentReports.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recent reports} =1{1 recent report} other{{count} recent reports}}'**
  String recentReports(int count);

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @seeWhatIsOnRoute.
  ///
  /// In en, this message translates to:
  /// **'See what is on this route'**
  String get seeWhatIsOnRoute;

  /// No description provided for @passesBlockage.
  ///
  /// In en, this message translates to:
  /// **'Passes a blockage'**
  String get passesBlockage;

  /// No description provided for @whatReporting.
  ///
  /// In en, this message translates to:
  /// **'What are you reporting?'**
  String get whatReporting;

  /// No description provided for @whatExactly.
  ///
  /// In en, this message translates to:
  /// **'What exactly is happening?'**
  String get whatExactly;

  /// No description provided for @whereIsIt.
  ///
  /// In en, this message translates to:
  /// **'Where is it?'**
  String get whereIsIt;

  /// No description provided for @anythingToAdd.
  ///
  /// In en, this message translates to:
  /// **'Anything to add?'**
  String get anythingToAdd;

  /// No description provided for @reviewMyReport.
  ///
  /// In en, this message translates to:
  /// **'Review my report'**
  String get reviewMyReport;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @understoodAs.
  ///
  /// In en, this message translates to:
  /// **'We understood this as'**
  String get understoodAs;

  /// No description provided for @confirmAndPublish.
  ///
  /// In en, this message translates to:
  /// **'Confirm and publish'**
  String get confirmAndPublish;

  /// No description provided for @changeCategory.
  ///
  /// In en, this message translates to:
  /// **'Change category'**
  String get changeCategory;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reportLive.
  ///
  /// In en, this message translates to:
  /// **'Your report is live'**
  String get reportLive;

  /// No description provided for @reportNotPublished.
  ///
  /// In en, this message translates to:
  /// **'Report not published'**
  String get reportNotPublished;

  /// No description provided for @whatOthersSee.
  ///
  /// In en, this message translates to:
  /// **'What other travellers will see'**
  String get whatOthersSee;

  /// No description provided for @whatYouWrote.
  ///
  /// In en, this message translates to:
  /// **'What you wrote'**
  String get whatYouWrote;

  /// No description provided for @cannotPublish.
  ///
  /// In en, this message translates to:
  /// **'This report cannot be published'**
  String get cannotPublish;

  /// No description provided for @catSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety concern'**
  String get catSafety;

  /// No description provided for @catLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get catLighting;

  /// No description provided for @catRoad.
  ///
  /// In en, this message translates to:
  /// **'Road condition'**
  String get catRoad;

  /// No description provided for @catWater.
  ///
  /// In en, this message translates to:
  /// **'Water / drainage'**
  String get catWater;

  /// No description provided for @catBlockage.
  ///
  /// In en, this message translates to:
  /// **'Blockage'**
  String get catBlockage;

  /// No description provided for @catTraffic.
  ///
  /// In en, this message translates to:
  /// **'Traffic hazard'**
  String get catTraffic;

  /// No description provided for @anonymousByDefault.
  ///
  /// In en, this message translates to:
  /// **'Anonymous by default'**
  String get anonymousByDefault;

  /// No description provided for @privacyPromise.
  ///
  /// In en, this message translates to:
  /// **'Reports are anonymous by default. We never publish names, faces, phone numbers, vehicle plates, or private addresses.'**
  String get privacyPromise;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match my device'**
  String get themeSystem;

  /// No description provided for @voiceWarnings.
  ///
  /// In en, this message translates to:
  /// **'Voice warnings'**
  String get voiceWarnings;

  /// No description provided for @voiceWarningsSub.
  ///
  /// In en, this message translates to:
  /// **'Play a short spoken warning before you set off'**
  String get voiceWarningsSub;

  /// No description provided for @mapSurface.
  ///
  /// In en, this message translates to:
  /// **'Map surface'**
  String get mapSurface;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @reportAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Report anonymously'**
  String get reportAnonymously;

  /// No description provided for @blurSensitive.
  ///
  /// In en, this message translates to:
  /// **'Blur sensitive locations'**
  String get blurSensitive;

  /// No description provided for @trustedContacts.
  ///
  /// In en, this message translates to:
  /// **'Trusted contacts'**
  String get trustedContacts;

  /// No description provided for @savedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get savedPlaces;

  /// No description provided for @myReports.
  ///
  /// In en, this message translates to:
  /// **'My reports'**
  String get myReports;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @continueAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Continue anonymously'**
  String get continueAnonymously;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a place, area or landmark'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No places match \"{query}\"'**
  String noResults(String query);

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useMyLocation;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @popularInBwp.
  ///
  /// In en, this message translates to:
  /// **'Popular in Bahawalpur'**
  String get popularInBwp;

  /// No description provided for @iArrivedSafely.
  ///
  /// In en, this message translates to:
  /// **'I arrived safely'**
  String get iArrivedSafely;

  /// No description provided for @cancelCheckin.
  ///
  /// In en, this message translates to:
  /// **'Cancel check-in'**
  String get cancelCheckin;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @overdueBy.
  ///
  /// In en, this message translates to:
  /// **'overdue by'**
  String get overdueBy;

  /// No description provided for @startCheckin.
  ///
  /// In en, this message translates to:
  /// **'Start safety check-in'**
  String get startCheckin;

  /// No description provided for @playWarning.
  ///
  /// In en, this message translates to:
  /// **'Play warning'**
  String get playWarning;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @voiceWarning.
  ///
  /// In en, this message translates to:
  /// **'Voice warning'**
  String get voiceWarning;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline. Showing the last signals saved on this device.'**
  String get offlineBanner;

  /// No description provided for @couldNotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Showing demonstration signals.'**
  String get couldNotReachServer;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @checkIns.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get checkIns;

  /// No description provided for @noAlertsYet.
  ///
  /// In en, this message translates to:
  /// **'No alerts yet'**
  String get noAlertsYet;

  /// No description provided for @willHearUsWhenNew.
  ///
  /// In en, this message translates to:
  /// **'You will hear from us when a new report lands on a route you use, when someone confirms one of your reports, or when a check-in needs your attention.'**
  String get willHearUsWhenNew;

  /// No description provided for @reportedAnythingYet.
  ///
  /// In en, this message translates to:
  /// **'You have not reported anything yet'**
  String get reportedAnythingYet;

  /// No description provided for @firstTimeTellOtherTravellers.
  ///
  /// In en, this message translates to:
  /// **'The first time you tell other travellers about a blocked lane or a broken streetlight, it will show up here.'**
  String get firstTimeTellOtherTravellers;

  /// No description provided for @makeFirstReport.
  ///
  /// In en, this message translates to:
  /// **'Make your first report'**
  String get makeFirstReport;

  /// No description provided for @totalReports.
  ///
  /// In en, this message translates to:
  /// **'Total reports'**
  String get totalReports;

  /// No description provided for @liveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get liveNow;

  /// No description provided for @confirmedOthers.
  ///
  /// In en, this message translates to:
  /// **'Confirmed by others'**
  String get confirmedOthers;

  /// No description provided for @live2.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live2;

  /// No description provided for @stillAffectingRouteAwareness.
  ///
  /// In en, this message translates to:
  /// **'Still affecting route awareness'**
  String get stillAffectingRouteAwareness;

  /// No description provided for @expiredWithheld.
  ///
  /// In en, this message translates to:
  /// **'Expired and withheld'**
  String get expiredWithheld;

  /// No description provided for @noLongerAffectingRoutes.
  ///
  /// In en, this message translates to:
  /// **'No longer affecting routes'**
  String get noLongerAffectingRoutes;

  /// No description provided for @noCheckInsYet.
  ///
  /// In en, this message translates to:
  /// **'No check-ins yet'**
  String get noCheckInsYet;

  /// No description provided for @checkTimerShareSomeoneTrust.
  ///
  /// In en, this message translates to:
  /// **'A check-in is a timer you share with someone you trust. If you do not confirm you arrived, they know to look for you.'**
  String get checkTimerShareSomeoneTrust;

  /// No description provided for @startCheck.
  ///
  /// In en, this message translates to:
  /// **'Start a check-in'**
  String get startCheck;

  /// No description provided for @runningNow.
  ///
  /// In en, this message translates to:
  /// **'Running now'**
  String get runningNow;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @pastCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Past check-ins'**
  String get pastCheckIns;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// No description provided for @shownOnly.
  ///
  /// In en, this message translates to:
  /// **'Shown only to you'**
  String get shownOnly;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @continueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without an account'**
  String get continueWithoutAccount;

  /// No description provided for @doNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'You do not need an account'**
  String get doNeedAccount;

  /// No description provided for @reportingRoutesCheckInsAll.
  ///
  /// In en, this message translates to:
  /// **'Reporting, routes and check-ins all work anonymously. Your number is never shown to other travellers and never attached to a published report.'**
  String get reportingRoutesCheckInsAll;

  /// No description provided for @cancelCheck.
  ///
  /// In en, this message translates to:
  /// **'Cancel the check-in?'**
  String get cancelCheck;

  /// No description provided for @timerStopsContactsWillNotified.
  ///
  /// In en, this message translates to:
  /// **'The timer stops and your contacts will not be notified either way. You can start a new one whenever you like.'**
  String get timerStopsContactsWillNotified;

  /// No description provided for @keepRunning.
  ///
  /// In en, this message translates to:
  /// **'Keep it running'**
  String get keepRunning;

  /// No description provided for @noCheckRunning.
  ///
  /// In en, this message translates to:
  /// **'No check-in running'**
  String get noCheckRunning;

  /// No description provided for @checkAlreadyFinishedStartNew.
  ///
  /// In en, this message translates to:
  /// **'This check-in has already finished. Start a new one from the home screen when you next set off.'**
  String get checkAlreadyFinishedStartNew;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get check;

  /// No description provided for @emergencyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Emergency numbers'**
  String get emergencyNumbers;

  /// No description provided for @checkWindowPassed.
  ///
  /// In en, this message translates to:
  /// **'Your check-in window has passed'**
  String get checkWindowPassed;

  /// No description provided for @fullProductContactsWouldBeen.
  ///
  /// In en, this message translates to:
  /// **'In the full product your contacts would have been reminded to check on you by now. Let them know you are safe, or extend the timer if you are still on the way.'**
  String get fullProductContactsWouldBeen;

  /// No description provided for @notifyingContactsSimulatedUiBuild.
  ///
  /// In en, this message translates to:
  /// **'Notifying contacts is simulated in this UI build — no message is actually sent.'**
  String get notifyingContactsSimulatedUiBuild;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due by'**
  String get due;

  /// No description provided for @livePosition.
  ///
  /// In en, this message translates to:
  /// **'Live position'**
  String get livePosition;

  /// No description provided for @startedCheckWithoutContactSo.
  ///
  /// In en, this message translates to:
  /// **'You started this check-in without a contact, so the timer is just for you. Adding someone makes it far more useful.'**
  String get startedCheckWithoutContactSo;

  /// No description provided for @needMoreMinutes.
  ///
  /// In en, this message translates to:
  /// **'Need 10 more minutes'**
  String get needMoreMinutes;

  /// No description provided for @checkAlreadyRunning.
  ///
  /// In en, this message translates to:
  /// **'A check-in is already running'**
  String get checkAlreadyRunning;

  /// No description provided for @onlyOneCheckTimeOpen.
  ///
  /// In en, this message translates to:
  /// **'You can only have one check-in at a time. Open the running one, or cancel it first.'**
  String get onlyOneCheckTimeOpen;

  /// No description provided for @open2.
  ///
  /// In en, this message translates to:
  /// **'Open it'**
  String get open2;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'Stay here'**
  String get stayHere;

  /// No description provided for @startWithoutContact.
  ///
  /// In en, this message translates to:
  /// **'Start without a contact?'**
  String get startWithoutContact;

  /// No description provided for @nobodyWillToldIfDo.
  ///
  /// In en, this message translates to:
  /// **'Nobody will be told if you do not check in. The timer will still remind you, but a check-in works best when someone knows.'**
  String get nobodyWillToldIfDo;

  /// No description provided for @startAnyway.
  ///
  /// In en, this message translates to:
  /// **'Start anyway'**
  String get startAnyway;

  /// No description provided for @chooseContact.
  ///
  /// In en, this message translates to:
  /// **'Choose a contact'**
  String get chooseContact;

  /// No description provided for @setTimerIfDoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Set a timer. If you do not confirm you arrived, your trusted contacts are reminded to check on you.'**
  String get setTimerIfDoConfirm;

  /// No description provided for @howLongDoExpectTake.
  ///
  /// In en, this message translates to:
  /// **'How long do you expect to take?'**
  String get howLongDoExpectTake;

  /// No description provided for @whoShouldNotified.
  ///
  /// In en, this message translates to:
  /// **'Who should be notified?'**
  String get whoShouldNotified;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @noTrustedContactsYet.
  ///
  /// In en, this message translates to:
  /// **'No trusted contacts yet'**
  String get noTrustedContactsYet;

  /// No description provided for @addSomeoneWouldWantKnow.
  ///
  /// In en, this message translates to:
  /// **'Add someone you would want to know if you did not arrive.'**
  String get addSomeoneWouldWantKnow;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add a contact'**
  String get addContact;

  /// No description provided for @shareMyLivePosition.
  ///
  /// In en, this message translates to:
  /// **'Share my live position'**
  String get shareMyLivePosition;

  /// No description provided for @simulatedBuildNoLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Simulated in this build — no location permission is used'**
  String get simulatedBuildNoLocationPermission;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @addTrustedContact.
  ///
  /// In en, this message translates to:
  /// **'Add a trusted contact'**
  String get addTrustedContact;

  /// No description provided for @someoneWhoWouldNoticeIf.
  ///
  /// In en, this message translates to:
  /// **'Someone who would notice if you did not arrive. Stored on this device only.'**
  String get someoneWhoWouldNoticeIf;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @familyRoommateColleague.
  ///
  /// In en, this message translates to:
  /// **'Family, roommate, colleague…'**
  String get familyRoommateColleague;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @addContact2.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact2;

  /// No description provided for @noTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'No trusted contacts'**
  String get noTrustedContacts;

  /// No description provided for @addSomeoneWouldWantTold.
  ///
  /// In en, this message translates to:
  /// **'Add someone you would want to be told if you did not arrive. Their number stays on this device.'**
  String get addSomeoneWouldWantTold;

  /// No description provided for @addFirstContact.
  ///
  /// In en, this message translates to:
  /// **'Add your first contact'**
  String get addFirstContact;

  /// No description provided for @contactsStoredDeviceOnlySafar.
  ///
  /// In en, this message translates to:
  /// **'Contacts are stored on this device only. Safar does not upload your contact list.'**
  String get contactsStoredDeviceOnlySafar;

  /// No description provided for @theyWillNoLongerOffered.
  ///
  /// In en, this message translates to:
  /// **'They will no longer be offered when you start a check-in.'**
  String get theyWillNoLongerOffered;

  /// No description provided for @makePrimary.
  ///
  /// In en, this message translates to:
  /// **'Make primary'**
  String get makePrimary;

  /// No description provided for @recentre.
  ///
  /// In en, this message translates to:
  /// **'Recentre'**
  String get recentre;

  /// No description provided for @tapPinMapScrollList.
  ///
  /// In en, this message translates to:
  /// **'Tap a pin on the map, or scroll the list.'**
  String get tapPinMapScrollList;

  /// No description provided for @nothingMatchesTheseFilters.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters'**
  String get nothingMatchesTheseFilters;

  /// No description provided for @noLiveReportsCategoriesSelected.
  ///
  /// In en, this message translates to:
  /// **'No live reports in the categories you selected. Clear the filters to see everything in the demo area.'**
  String get noLiveReportsCategoriesSelected;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @noSignalsAreaYet.
  ///
  /// In en, this message translates to:
  /// **'No signals in this area yet'**
  String get noSignalsAreaYet;

  /// No description provided for @limitedDataSameClearRoad.
  ///
  /// In en, this message translates to:
  /// **'Limited data is not the same as a clear road. If you see something, you can be the first to report it.'**
  String get limitedDataSameClearRoad;

  /// No description provided for @addReport.
  ///
  /// In en, this message translates to:
  /// **'Add a report'**
  String get addReport;

  /// No description provided for @howRouteAwarenessCalculated.
  ///
  /// In en, this message translates to:
  /// **'How route awareness is calculated'**
  String get howRouteAwarenessCalculated;

  /// No description provided for @simulatedPositionPrototype.
  ///
  /// In en, this message translates to:
  /// **'Simulated position for this prototype'**
  String get simulatedPositionPrototype;

  /// No description provided for @bahawalpur.
  ///
  /// In en, this message translates to:
  /// **'Bahawalpur'**
  String get bahawalpur;

  /// No description provided for @afterDarkLightingReportsCount.
  ///
  /// In en, this message translates to:
  /// **'After dark, lighting reports count for more'**
  String get afterDarkLightingReportsCount;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @demoControls.
  ///
  /// In en, this message translates to:
  /// **'Demo controls'**
  String get demoControls;

  /// No description provided for @couldLoadSignals.
  ///
  /// In en, this message translates to:
  /// **'Could not load signals'**
  String get couldLoadSignals;

  /// No description provided for @nothingBeenReportedDemoArea.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been reported in the demo area recently. That is not the same as \"all clear\" — it means we have no data.'**
  String get nothingBeenReportedDemoArea;

  /// No description provided for @uiPrototypeV.
  ///
  /// In en, this message translates to:
  /// **'UI prototype · v1.0.0'**
  String get uiPrototypeV;

  /// No description provided for @whatSafar.
  ///
  /// In en, this message translates to:
  /// **'What Safar is not'**
  String get whatSafar;

  /// No description provided for @privacyAbusePrevention.
  ///
  /// In en, this message translates to:
  /// **'Privacy and abuse prevention'**
  String get privacyAbusePrevention;

  /// No description provided for @aboutDataBuild.
  ///
  /// In en, this message translates to:
  /// **'About the data in this build'**
  String get aboutDataBuild;

  /// No description provided for @routesPlannedOverHandBuilt.
  ///
  /// In en, this message translates to:
  /// **'Routes are planned over a hand-built road network for one area of Bahawalpur. Coordinates are approximate and are not survey data. The map is drawn by the app rather than served by a maps provider. Classification of report text runs locally, not against a hosted model.'**
  String get routesPlannedOverHandBuilt;

  /// No description provided for @builtBahawalpur.
  ///
  /// In en, this message translates to:
  /// **'Built for Bahawalpur.'**
  String get builtBahawalpur;

  /// No description provided for @presentingUsers.
  ///
  /// In en, this message translates to:
  /// **'For presenting, not for users'**
  String get presentingUsers;

  /// No description provided for @theseSwitchesExistSoEvery.
  ///
  /// In en, this message translates to:
  /// **'These switches exist so every state in the prototype can be shown on demand. In a production build this screen would not ship.'**
  String get theseSwitchesExistSoEvery;

  /// No description provided for @userPersona.
  ///
  /// In en, this message translates to:
  /// **'User persona'**
  String get userPersona;

  /// No description provided for @communitySignalData.
  ///
  /// In en, this message translates to:
  /// **'Community signal data'**
  String get communitySignalData;

  /// No description provided for @reloadSeededSignals.
  ///
  /// In en, this message translates to:
  /// **'Reload seeded signals'**
  String get reloadSeededSignals;

  /// No description provided for @emptyMap.
  ///
  /// In en, this message translates to:
  /// **'Empty the map'**
  String get emptyMap;

  /// No description provided for @showsEveryNoDataEmpty.
  ///
  /// In en, this message translates to:
  /// **'Shows every \"no data\" and empty state'**
  String get showsEveryNoDataEmpty;

  /// No description provided for @forceLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'Force a load failure'**
  String get forceLoadFailure;

  /// No description provided for @showsErrorStateRetry.
  ///
  /// In en, this message translates to:
  /// **'Shows the error state with retry'**
  String get showsErrorStateRetry;

  /// No description provided for @showExpiredReports.
  ///
  /// In en, this message translates to:
  /// **'Show expired reports'**
  String get showExpiredReports;

  /// No description provided for @greyedOutNoEffectRouting.
  ///
  /// In en, this message translates to:
  /// **'Greyed out, no effect on routing'**
  String get greyedOutNoEffectRouting;

  /// No description provided for @backend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get backend;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get sendTestNotification;

  /// No description provided for @pushesEverySubscribedDevice.
  ///
  /// In en, this message translates to:
  /// **'Pushes to every subscribed device'**
  String get pushesEverySubscribedDevice;

  /// No description provided for @failurePaths.
  ///
  /// In en, this message translates to:
  /// **'Failure paths'**
  String get failurePaths;

  /// No description provided for @breakReportClassifier.
  ///
  /// In en, this message translates to:
  /// **'Break the report classifier'**
  String get breakReportClassifier;

  /// No description provided for @nextReportFallsBackManual.
  ///
  /// In en, this message translates to:
  /// **'Next report falls back to manual category selection'**
  String get nextReportFallsBackManual;

  /// No description provided for @simulateOffline.
  ///
  /// In en, this message translates to:
  /// **'Simulate offline'**
  String get simulateOffline;

  /// No description provided for @offlineBannerPlusCachedData.
  ///
  /// In en, this message translates to:
  /// **'Offline banner plus the cached-data path'**
  String get offlineBannerPlusCachedData;

  /// No description provided for @otherStates.
  ///
  /// In en, this message translates to:
  /// **'Other states'**
  String get otherStates;

  /// No description provided for @clearTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'Clear trusted contacts'**
  String get clearTrustedContacts;

  /// No description provided for @clearAllAlerts.
  ///
  /// In en, this message translates to:
  /// **'Clear all alerts'**
  String get clearAllAlerts;

  /// No description provided for @showsEmptyActivityTab.
  ///
  /// In en, this message translates to:
  /// **'Shows the empty Activity tab'**
  String get showsEmptyActivityTab;

  /// No description provided for @resetCurrentTrip.
  ///
  /// In en, this message translates to:
  /// **'Reset the current trip'**
  String get resetCurrentTrip;

  /// No description provided for @clearsOriginDestinationPlannedRoutes.
  ///
  /// In en, this message translates to:
  /// **'Clears origin, destination and planned routes'**
  String get clearsOriginDestinationPlannedRoutes;

  /// No description provided for @twoMinuteDemo.
  ///
  /// In en, this message translates to:
  /// **'The two-minute demo'**
  String get twoMinuteDemo;

  /// No description provided for @reportingSomethingSafarDoesAlert.
  ///
  /// In en, this message translates to:
  /// **'Reporting something in Safar does not alert the authorities. If someone is in danger, call emergency services directly.'**
  String get reportingSomethingSafarDoesAlert;

  /// No description provided for @howWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howWorks;

  /// No description provided for @routeAwarenessSafetyScore.
  ///
  /// In en, this message translates to:
  /// **'Route awareness, not a safety score'**
  String get routeAwarenessSafetyScore;

  /// No description provided for @fourLevels.
  ///
  /// In en, this message translates to:
  /// **'The four levels'**
  String get fourLevels;

  /// No description provided for @whatGoesIntoNumber.
  ///
  /// In en, this message translates to:
  /// **'What goes into the number'**
  String get whatGoesIntoNumber;

  /// No description provided for @eachRoadSegmentGetsScore.
  ///
  /// In en, this message translates to:
  /// **'Each road segment gets a score from five weighted inputs. A route is the length-weighted average of its segments.'**
  String get eachRoadSegmentGetsScore;

  /// No description provided for @theseWeightsPrototypeValuesChosen.
  ///
  /// In en, this message translates to:
  /// **'These weights are prototype values chosen for a sensible demo. They are not validated against real incident data.'**
  String get theseWeightsPrototypeValuesChosen;

  /// No description provided for @newerReportsCountMore.
  ///
  /// In en, this message translates to:
  /// **'Newer reports count for more'**
  String get newerReportsCountMore;

  /// No description provided for @everyReportLosesInfluenceAges.
  ///
  /// In en, this message translates to:
  /// **'Every report loses influence as it ages, and how fast depends on the kind of problem. An accident stops mattering within hours; a broken streetlight stays relevant for days.'**
  String get everyReportLosesInfluenceAges;

  /// No description provided for @howReportsEarnTrust.
  ///
  /// In en, this message translates to:
  /// **'How reports earn trust'**
  String get howReportsEarnTrust;

  /// No description provided for @whatEachReportDoesRouting.
  ///
  /// In en, this message translates to:
  /// **'What each report does to routing'**
  String get whatEachReportDoesRouting;

  /// No description provided for @honestCaveat.
  ///
  /// In en, this message translates to:
  /// **'The honest caveat'**
  String get honestCaveat;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @normalMapTellsNtheFastest.
  ///
  /// In en, this message translates to:
  /// **'A normal map tells you\\nthe fastest way.'**
  String get normalMapTellsNtheFastest;

  /// No description provided for @safarTellsWhatExpectWay.
  ///
  /// In en, this message translates to:
  /// **'Safar tells you what to expect on the way.'**
  String get safarTellsWhatExpectWay;

  /// No description provided for @residentReportsWhatTheySee.
  ///
  /// In en, this message translates to:
  /// **'A resident reports what they see'**
  String get residentReportsWhatTheySee;

  /// No description provided for @reportBecomesStructuredSignal.
  ///
  /// In en, this message translates to:
  /// **'The report becomes a structured signal'**
  String get reportBecomesStructuredSignal;

  /// No description provided for @routesComparedExplained.
  ///
  /// In en, this message translates to:
  /// **'Routes are compared, and explained'**
  String get routesComparedExplained;

  /// No description provided for @nextTravellerWarned.
  ///
  /// In en, this message translates to:
  /// **'The next traveller is warned'**
  String get nextTravellerWarned;

  /// No description provided for @oneReportOnePersonHelps.
  ///
  /// In en, this message translates to:
  /// **'One report from one person helps everyone who travels that road next.'**
  String get oneReportOnePersonHelps;

  /// No description provided for @whatAppWillDo.
  ///
  /// In en, this message translates to:
  /// **'What this app will not do'**
  String get whatAppWillDo;

  /// No description provided for @worthReadingBeforeRely.
  ///
  /// In en, this message translates to:
  /// **'Worth reading before you rely on it.'**
  String get worthReadingBeforeRely;

  /// No description provided for @itIsNot.
  ///
  /// In en, this message translates to:
  /// **'It is not'**
  String get itIsNot;

  /// No description provided for @pickLanguage.
  ///
  /// In en, this message translates to:
  /// **'Pick your language'**
  String get pickLanguage;

  /// No description provided for @setsVoiceWarningsWordingReport.
  ///
  /// In en, this message translates to:
  /// **'This sets the voice warnings and the wording of report prompts. You can always report in whichever language you actually speak.'**
  String get setsVoiceWarningsWordingReport;

  /// No description provided for @loadingCommunitySignalsBahawalpur.
  ///
  /// In en, this message translates to:
  /// **'Loading community signals for Bahawalpur'**
  String get loadingCommunitySignalsBahawalpur;

  /// No description provided for @reportsStillPublishedAnonymouslyOther.
  ///
  /// In en, this message translates to:
  /// **'Your reports are still published anonymously. Other travellers never see your name or number — the account only keeps your history if you change phone.'**
  String get reportsStillPublishedAnonymouslyOther;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'You are anonymous'**
  String get anonymous;

  /// No description provided for @everythingWorksWithoutAccountAdding.
  ///
  /// In en, this message translates to:
  /// **'Everything works without an account. Adding one keeps your reports and saved places if you change phone.'**
  String get everythingWorksWithoutAccountAdding;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @reportsMade.
  ///
  /// In en, this message translates to:
  /// **'Reports made'**
  String get reportsMade;

  /// No description provided for @signalsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Signals confirmed'**
  String get signalsConfirmed;

  /// No description provided for @tripsCompared.
  ///
  /// In en, this message translates to:
  /// **'Trips compared'**
  String get tripsCompared;

  /// No description provided for @stuff.
  ///
  /// In en, this message translates to:
  /// **'Your stuff'**
  String get stuff;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @shortSpokenAlertsBeforeSet.
  ///
  /// In en, this message translates to:
  /// **'Short spoken alerts before you set off'**
  String get shortSpokenAlertsBeforeSet;

  /// No description provided for @allSettings.
  ///
  /// In en, this message translates to:
  /// **'All settings'**
  String get allSettings;

  /// No description provided for @howRouteAwarenessWorks.
  ///
  /// In en, this message translates to:
  /// **'How route awareness works'**
  String get howRouteAwarenessWorks;

  /// No description provided for @aboutSafar.
  ///
  /// In en, this message translates to:
  /// **'About Safar'**
  String get aboutSafar;

  /// No description provided for @returnAnonymousUsePhone.
  ///
  /// In en, this message translates to:
  /// **'Return to anonymous use on this phone'**
  String get returnAnonymousUsePhone;

  /// No description provided for @signOut2.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOut2;

  /// No description provided for @willKeepUsingSafarAnonymously.
  ///
  /// In en, this message translates to:
  /// **'You will keep using Safar anonymously. Your reports stay on your account and come back when you sign in.'**
  String get willKeepUsingSafarAnonymously;

  /// No description provided for @bringReportsAnotherPhone.
  ///
  /// In en, this message translates to:
  /// **'Bring reports from another phone'**
  String get bringReportsAnotherPhone;

  /// No description provided for @setsVoiceWarningsPromptWording.
  ///
  /// In en, this message translates to:
  /// **'Sets voice warnings and prompt wording.'**
  String get setsVoiceWarningsPromptWording;

  /// No description provided for @tiersRecogniseContributionTheyNever.
  ///
  /// In en, this message translates to:
  /// **'Tiers recognise contribution. They never make a report count as verified — only confirmations from other travellers do that.'**
  String get tiersRecogniseContributionTheyNever;

  /// No description provided for @labelPlace.
  ///
  /// In en, this message translates to:
  /// **'Label this place'**
  String get labelPlace;

  /// No description provided for @shortNameLikeHomeWork.
  ///
  /// In en, this message translates to:
  /// **'A short name like \"Home\", \"Work\" or \"Ammi\\\'s house\".'**
  String get shortNameLikeHomeWork;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get labelOptional;

  /// No description provided for @noSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'No saved places'**
  String get noSavedPlaces;

  /// No description provided for @tapBookmarkNextAnyPlace.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark next to any place while searching, and it will appear here for one-tap routing.'**
  String get tapBookmarkNextAnyPlace;

  /// No description provided for @willNoLongerAppear.
  ///
  /// In en, this message translates to:
  /// **'It will no longer appear in your saved places.'**
  String get willNoLongerAppear;

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change label'**
  String get changeLabel;

  /// No description provided for @routeHere.
  ///
  /// In en, this message translates to:
  /// **'Route here'**
  String get routeHere;

  /// No description provided for @languageVoice.
  ///
  /// In en, this message translates to:
  /// **'Language and voice'**
  String get languageVoice;

  /// No description provided for @warningsPromptsSummaries.
  ///
  /// In en, this message translates to:
  /// **'Warnings, prompts and summaries'**
  String get warningsPromptsSummaries;

  /// No description provided for @reportsNeverCarryName.
  ///
  /// In en, this message translates to:
  /// **'Your reports never carry a name'**
  String get reportsNeverCarryName;

  /// No description provided for @roundSafetyConcernReportsRoughly.
  ///
  /// In en, this message translates to:
  /// **'Round safety-concern reports to roughly a 250 m area'**
  String get roundSafetyConcernReportsRoughly;

  /// No description provided for @mapData.
  ///
  /// In en, this message translates to:
  /// **'Map and data'**
  String get mapData;

  /// No description provided for @greyedOutTheyDoAffect.
  ///
  /// In en, this message translates to:
  /// **'Greyed out, and they do not affect routes'**
  String get greyedOutTheyDoAffect;

  /// No description provided for @reloadCommunitySignals.
  ///
  /// In en, this message translates to:
  /// **'Reload community signals'**
  String get reloadCommunitySignals;

  /// No description provided for @fetchSeededDemonstrationDataAgain.
  ///
  /// In en, this message translates to:
  /// **'Fetch the seeded demonstration data again'**
  String get fetchSeededDemonstrationDataAgain;

  /// No description provided for @prototypeControls.
  ///
  /// In en, this message translates to:
  /// **'Prototype controls'**
  String get prototypeControls;

  /// No description provided for @demoControlPanel.
  ///
  /// In en, this message translates to:
  /// **'Demo control panel'**
  String get demoControlPanel;

  /// No description provided for @switchPersonasForceErrorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Switch personas, force errors, empty the data — for demos'**
  String get switchPersonasForceErrorsEmpty;

  /// No description provided for @showsOfflineBannerCachedData.
  ///
  /// In en, this message translates to:
  /// **'Shows the offline banner and the cached-data path'**
  String get showsOfflineBannerCachedData;

  /// No description provided for @aboutLimitations.
  ///
  /// In en, this message translates to:
  /// **'About and limitations'**
  String get aboutLimitations;

  /// No description provided for @clearLocalData.
  ///
  /// In en, this message translates to:
  /// **'Clear local data'**
  String get clearLocalData;

  /// No description provided for @resetsSavedPlacesContactsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Resets saved places, contacts and alerts'**
  String get resetsSavedPlacesContactsAlerts;

  /// No description provided for @clearLocalData2.
  ///
  /// In en, this message translates to:
  /// **'Clear local data?'**
  String get clearLocalData2;

  /// No description provided for @savedPlacesTrustedContactsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Saved places, trusted contacts and alerts on this device will be removed. Seeded demonstration signals stay, so the demo keeps working.'**
  String get savedPlacesTrustedContactsAlerts;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear data'**
  String get clearData;

  /// No description provided for @confirmReport.
  ///
  /// In en, this message translates to:
  /// **'Confirm this report?'**
  String get confirmReport;

  /// No description provided for @onlyConfirmIfSeenYourself.
  ///
  /// In en, this message translates to:
  /// **'Only confirm if you have seen this yourself. Confirmations are what move a signal from unverified to confirmed.'**
  String get onlyConfirmIfSeenYourself;

  /// No description provided for @yesISaw.
  ///
  /// In en, this message translates to:
  /// **'Yes, I saw this'**
  String get yesISaw;

  /// No description provided for @disputeReport.
  ///
  /// In en, this message translates to:
  /// **'Dispute this report?'**
  String get disputeReport;

  /// No description provided for @useWhenConditionNoLonger.
  ///
  /// In en, this message translates to:
  /// **'Use this when the condition is no longer there, or was never there. Two disputes mark the report as disputed for everyone.'**
  String get useWhenConditionNoLonger;

  /// No description provided for @dispute.
  ///
  /// In en, this message translates to:
  /// **'Dispute it'**
  String get dispute;

  /// No description provided for @withdrawReport.
  ///
  /// In en, this message translates to:
  /// **'Withdraw your report?'**
  String get withdrawReport;

  /// No description provided for @willStopAffectingRoutesImmediately.
  ///
  /// In en, this message translates to:
  /// **'It will stop affecting routes immediately and will no longer be shown to other travellers.'**
  String get willStopAffectingRoutesImmediately;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'This report is no longer available'**
  String get reportNoLongerAvailable;

  /// No description provided for @mayExpiredBeenWithdrawnWhoever.
  ///
  /// In en, this message translates to:
  /// **'It may have expired or been withdrawn by whoever submitted it.'**
  String get mayExpiredBeenWithdrawnWhoever;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @approximateLocation.
  ///
  /// In en, this message translates to:
  /// **'Approximate location'**
  String get approximateLocation;

  /// No description provided for @report2.
  ///
  /// In en, this message translates to:
  /// **'Your report'**
  String get report2;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Not published'**
  String get published;

  /// No description provided for @reportWithheldBecauseAppeared.
  ///
  /// In en, this message translates to:
  /// **'This report was withheld because it appeared to identify a specific person. It never affected routes and no other traveller can see it.'**
  String get reportWithheldBecauseAppeared;

  /// No description provided for @whatTravellersSee.
  ///
  /// In en, this message translates to:
  /// **'What travellers see'**
  String get whatTravellersSee;

  /// No description provided for @visibleOnly.
  ///
  /// In en, this message translates to:
  /// **'Visible only to you.'**
  String get visibleOnly;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @confirmations.
  ///
  /// In en, this message translates to:
  /// **'Confirmations'**
  String get confirmations;

  /// No description provided for @disputes.
  ///
  /// In en, this message translates to:
  /// **'Disputes'**
  String get disputes;

  /// No description provided for @routeEffect.
  ///
  /// In en, this message translates to:
  /// **'Route effect'**
  String get routeEffect;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get expiry;

  /// No description provided for @reported.
  ///
  /// In en, this message translates to:
  /// **'Reported in'**
  String get reported;

  /// No description provided for @categorised.
  ///
  /// In en, this message translates to:
  /// **'Categorised'**
  String get categorised;

  /// No description provided for @reported2.
  ///
  /// In en, this message translates to:
  /// **'Reported by'**
  String get reported2;

  /// No description provided for @onlyLiveReportStretchSo.
  ///
  /// In en, this message translates to:
  /// **'This is the only live report on this stretch, so the signal rests on one person. Confirmations from other travellers make it more reliable.'**
  String get onlyLiveReportStretchSo;

  /// No description provided for @expiredReportsNoLongerAffect.
  ///
  /// In en, this message translates to:
  /// **'Expired reports no longer affect routes.'**
  String get expiredReportsNoLongerAffect;

  /// No description provided for @withdrawReport2.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this report'**
  String get withdrawReport2;

  /// No description provided for @discardReport.
  ///
  /// In en, this message translates to:
  /// **'Discard this report?'**
  String get discardReport;

  /// No description provided for @whatEnteredSoFarWill.
  ///
  /// In en, this message translates to:
  /// **'What you have entered so far will not be saved, and nothing will be published.'**
  String get whatEnteredSoFarWill;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @hitHourlyLimit.
  ///
  /// In en, this message translates to:
  /// **'You have hit the hourly limit'**
  String get hitHourlyLimit;

  /// No description provided for @rateLimitsExistSoOne.
  ///
  /// In en, this message translates to:
  /// **'Rate limits exist so one person cannot flood an area with reports. Your earlier reports are still live.'**
  String get rateLimitsExistSoOne;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @pickClosestCategoryCorrectLater.
  ///
  /// In en, this message translates to:
  /// **'Pick the closest category. You can correct it later if the app reads your description differently.'**
  String get pickClosestCategoryCorrectLater;

  /// No description provided for @pickCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a category first'**
  String get pickCategoryFirst;

  /// No description provided for @goBackStepChooseWhat.
  ///
  /// In en, this message translates to:
  /// **'Go back a step and choose what kind of thing you are reporting.'**
  String get goBackStepChooseWhat;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get chooseCategory;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @phraseUnderneathEachOptionHow.
  ///
  /// In en, this message translates to:
  /// **'The phrase underneath each option is how people usually say it.'**
  String get phraseUnderneathEachOptionHow;

  /// No description provided for @tapPlacePin.
  ///
  /// In en, this message translates to:
  /// **'Tap to place the pin'**
  String get tapPlacePin;

  /// No description provided for @roundedAboutM.
  ///
  /// In en, this message translates to:
  /// **'Rounded to about 250 m'**
  String get roundedAboutM;

  /// No description provided for @reportWillApplyRoadSegment.
  ///
  /// In en, this message translates to:
  /// **'This report will apply to this road segment'**
  String get reportWillApplyRoadSegment;

  /// No description provided for @safetyConcernReportsAlwaysRounded.
  ///
  /// In en, this message translates to:
  /// **'Safety-concern reports are always rounded to an approximate area before publishing, so a report never points at one doorstep.'**
  String get safetyConcernReportsAlwaysRounded;

  /// No description provided for @sensitiveCategory.
  ///
  /// In en, this message translates to:
  /// **'Sensitive category'**
  String get sensitiveCategory;

  /// No description provided for @optionalWriteEnglishUrduRoman.
  ///
  /// In en, this message translates to:
  /// **'Optional. Write in English, Urdu or Roman Urdu — whichever is natural. The app reads it and suggests a category, which you then confirm.'**
  String get optionalWriteEnglishUrduRoman;

  /// No description provided for @eGAagayGaliBand.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Aagay gali band hai\"'**
  String get eGAagayGaliBand;

  /// No description provided for @tapExampleUse.
  ///
  /// In en, this message translates to:
  /// **'Tap an example to use it'**
  String get tapExampleUse;

  /// No description provided for @doIncludeNamesPhoneNumbers.
  ///
  /// In en, this message translates to:
  /// **'Do not include names, phone numbers, vehicle plates or private addresses. Reports that identify a person are never published.'**
  String get doIncludeNamesPhoneNumbers;

  /// No description provided for @whatWrite.
  ///
  /// In en, this message translates to:
  /// **'What not to write'**
  String get whatWrite;

  /// No description provided for @chooseRightCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose the right category'**
  String get chooseRightCategory;

  /// No description provided for @correctionWhatGetsPublishedCorrections.
  ///
  /// In en, this message translates to:
  /// **'Your correction is what gets published. Corrections also help us see where the classifier is weak.'**
  String get correctionWhatGetsPublishedCorrections;

  /// No description provided for @reportPublished.
  ///
  /// In en, this message translates to:
  /// **'Your report was not published'**
  String get reportPublished;

  /// No description provided for @cancelReport.
  ///
  /// In en, this message translates to:
  /// **'Cancel this report?'**
  String get cancelReport;

  /// No description provided for @nothingWillPublishedTextWill.
  ///
  /// In en, this message translates to:
  /// **'Nothing will be published and your text will not be saved.'**
  String get nothingWillPublishedTextWill;

  /// No description provided for @cancelReport2.
  ///
  /// In en, this message translates to:
  /// **'Cancel report'**
  String get cancelReport2;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keep;

  /// No description provided for @reviewBeforePublishing.
  ///
  /// In en, this message translates to:
  /// **'Review before publishing'**
  String get reviewBeforePublishing;

  /// No description provided for @automaticReadingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Automatic reading unavailable'**
  String get automaticReadingUnavailable;

  /// No description provided for @tryReadingAgain.
  ///
  /// In en, this message translates to:
  /// **'Try reading it again'**
  String get tryReadingAgain;

  /// No description provided for @enoughDetailPublish.
  ///
  /// In en, this message translates to:
  /// **'Not enough detail to publish'**
  String get enoughDetailPublish;

  /// No description provided for @couldTellWhatReportAbout.
  ///
  /// In en, this message translates to:
  /// **'We could not tell what this report is about. Add a few more words, or pick the category yourself.'**
  String get couldTellWhatReportAbout;

  /// No description provided for @chooseCategoryMyself.
  ///
  /// In en, this message translates to:
  /// **'Choose a category myself'**
  String get chooseCategoryMyself;

  /// No description provided for @sureRightPleaseCheckCategory.
  ///
  /// In en, this message translates to:
  /// **'We are not sure this is right. Please check the category before publishing.'**
  String get sureRightPleaseCheckCategory;

  /// No description provided for @someoneMayReportedAlready.
  ///
  /// In en, this message translates to:
  /// **'Someone may have reported this already'**
  String get someoneMayReportedAlready;

  /// No description provided for @verySimilarReportSubmittedNearby.
  ///
  /// In en, this message translates to:
  /// **'A very similar report was submitted nearby in the last 45 minutes. Publishing yours will count as a confirmation, which makes the signal stronger.'**
  String get verySimilarReportSubmittedNearby;

  /// No description provided for @corrected.
  ///
  /// In en, this message translates to:
  /// **'You corrected this'**
  String get corrected;

  /// No description provided for @unverifiedUntilConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Unverified until confirmed'**
  String get unverifiedUntilConfirmed;

  /// No description provided for @effectRouting.
  ///
  /// In en, this message translates to:
  /// **'Effect on routing'**
  String get effectRouting;

  /// No description provided for @onlySeeOriginalWordingOthers.
  ///
  /// In en, this message translates to:
  /// **'Only you can see your original wording. Others see the neutral summary above.'**
  String get onlySeeOriginalWordingOthers;

  /// No description provided for @nothingAboutIdentifiablePersonWill.
  ///
  /// In en, this message translates to:
  /// **'Nothing about an identifiable person will be published.'**
  String get nothingAboutIdentifiablePersonWill;

  /// No description provided for @iUnderstandGoBack.
  ///
  /// In en, this message translates to:
  /// **'I understand — go back'**
  String get iUnderstandGoBack;

  /// No description provided for @editMyDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit my description'**
  String get editMyDescription;

  /// No description provided for @readingReport.
  ///
  /// In en, this message translates to:
  /// **'Reading your report…'**
  String get readingReport;

  /// No description provided for @stillReportConditionItselfExample.
  ///
  /// In en, this message translates to:
  /// **'You can still report the condition itself — for example \"this lane feels unsafe at night\" — without describing a person.'**
  String get stillReportConditionItselfExample;

  /// No description provided for @structuredOutput.
  ///
  /// In en, this message translates to:
  /// **'Structured output'**
  String get structuredOutput;

  /// No description provided for @whatHappensNext.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get whatHappensNext;

  /// No description provided for @otherTravellersConfirm.
  ///
  /// In en, this message translates to:
  /// **'Other travellers can confirm it'**
  String get otherTravellersConfirm;

  /// No description provided for @fadesOverTime.
  ///
  /// In en, this message translates to:
  /// **'It fades over time'**
  String get fadesOverTime;

  /// No description provided for @stayControl.
  ///
  /// In en, this message translates to:
  /// **'You stay in control'**
  String get stayControl;

  /// No description provided for @routesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Routes updated'**
  String get routesUpdated;

  /// No description provided for @reportAlreadyPartHowThese.
  ///
  /// In en, this message translates to:
  /// **'Your report is already part of how these routes are scored.'**
  String get reportAlreadyPartHowThese;

  /// No description provided for @shareSignal.
  ///
  /// In en, this message translates to:
  /// **'Share this signal'**
  String get shareSignal;

  /// No description provided for @playVoiceWarning.
  ///
  /// In en, this message translates to:
  /// **'Play voice warning'**
  String get playVoiceWarning;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get estimatedTime;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @liveReports.
  ///
  /// In en, this message translates to:
  /// **'Live reports'**
  String get liveReports;

  /// No description provided for @route2.
  ///
  /// In en, this message translates to:
  /// **'On this route'**
  String get route2;

  /// No description provided for @limitedDataRoute.
  ///
  /// In en, this message translates to:
  /// **'Limited data on this route'**
  String get limitedDataRoute;

  /// No description provided for @nobodyReportedAnythingHereRecently.
  ///
  /// In en, this message translates to:
  /// **'Nobody has reported anything here recently. That is not a clear signal either way — it just means we do not know.'**
  String get nobodyReportedAnythingHereRecently;

  /// No description provided for @reportWhatSee.
  ///
  /// In en, this message translates to:
  /// **'Report what you see'**
  String get reportWhatSee;

  /// No description provided for @stepStep.
  ///
  /// In en, this message translates to:
  /// **'Step by step'**
  String get stepStep;

  /// No description provided for @roadsRoute.
  ///
  /// In en, this message translates to:
  /// **'Roads on this route'**
  String get roadsRoute;

  /// No description provided for @whyAwarenessLevel.
  ///
  /// In en, this message translates to:
  /// **'Why this awareness level?'**
  String get whyAwarenessLevel;

  /// No description provided for @checkNotificationsSimulatedUiBuild.
  ///
  /// In en, this message translates to:
  /// **'Check-in notifications are simulated in this UI build.'**
  String get checkNotificationsSimulatedUiBuild;

  /// No description provided for @reportNearbyIssue.
  ///
  /// In en, this message translates to:
  /// **'Report a nearby issue'**
  String get reportNearbyIssue;

  /// No description provided for @baselineLighting.
  ///
  /// In en, this message translates to:
  /// **'Baseline lighting'**
  String get baselineLighting;

  /// No description provided for @howBusy.
  ///
  /// In en, this message translates to:
  /// **'How busy'**
  String get howBusy;

  /// No description provided for @reportedDelay.
  ///
  /// In en, this message translates to:
  /// **'Reported delay'**
  String get reportedDelay;

  /// No description provided for @noCommunityReportsStretchLevel.
  ///
  /// In en, this message translates to:
  /// **'No community reports on this stretch. The level above comes from its baseline lighting and how busy it usually is.'**
  String get noCommunityReportsStretchLevel;

  /// No description provided for @communitySignal.
  ///
  /// In en, this message translates to:
  /// **'Community signal'**
  String get communitySignal;

  /// No description provided for @tapThroughFullReportIts.
  ///
  /// In en, this message translates to:
  /// **'Tap through for the full report and its route effect.'**
  String get tapThroughFullReportIts;

  /// No description provided for @reportNoLongerAvailable2.
  ///
  /// In en, this message translates to:
  /// **'This report is no longer available.'**
  String get reportNoLongerAvailable2;

  /// No description provided for @openReport.
  ///
  /// In en, this message translates to:
  /// **'Open report'**
  String get openReport;

  /// No description provided for @reverseTrip.
  ///
  /// In en, this message translates to:
  /// **'Reverse the trip'**
  String get reverseTrip;

  /// No description provided for @recentreMap.
  ///
  /// In en, this message translates to:
  /// **'Recentre the map'**
  String get recentreMap;

  /// No description provided for @comparingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Comparing routes…'**
  String get comparingRoutes;

  /// No description provided for @scoringEachRoadSegmentAgainst.
  ///
  /// In en, this message translates to:
  /// **'Scoring each road segment against recent community reports.'**
  String get scoringEachRoadSegmentAgainst;

  /// No description provided for @changeDestination.
  ///
  /// In en, this message translates to:
  /// **'Change destination'**
  String get changeDestination;

  /// No description provided for @thesePlacesTooCloseTogether.
  ///
  /// In en, this message translates to:
  /// **'These places are too close together'**
  String get thesePlacesTooCloseTogether;

  /// No description provided for @startDestinationSitSameJunction.
  ///
  /// In en, this message translates to:
  /// **'Your start and destination sit on the same junction of the road network, so there is nothing to compare. Pick a destination further away.'**
  String get startDestinationSitSameJunction;

  /// No description provided for @noRouteBetweenThesePoints.
  ///
  /// In en, this message translates to:
  /// **'No route between these points'**
  String get noRouteBetweenThesePoints;

  /// No description provided for @prototypeCoversOneDemoArea.
  ///
  /// In en, this message translates to:
  /// **'This prototype covers one demo area of Bahawalpur, so not every pair of places is connected in the seeded road network. Try a different destination.'**
  String get prototypeCoversOneDemoArea;

  /// No description provided for @sortRoutes.
  ///
  /// In en, this message translates to:
  /// **'Sort routes'**
  String get sortRoutes;

  /// No description provided for @seededRoadNetworkOffersNo.
  ///
  /// In en, this message translates to:
  /// **'The seeded road network offers no meaningfully different alternative for this trip, so there is only one option to show.'**
  String get seededRoadNetworkOffersNo;

  /// No description provided for @reportIssueRoute.
  ///
  /// In en, this message translates to:
  /// **'Report an issue on this route'**
  String get reportIssueRoute;

  /// No description provided for @simulatedNoLocationPermissionRequested.
  ///
  /// In en, this message translates to:
  /// **'Simulated — no location permission is requested'**
  String get simulatedNoLocationPermissionRequested;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noSavedRecentPlacesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved or recent places yet'**
  String get noSavedRecentPlacesYet;

  /// No description provided for @searchDestinationBelowPlacesPick.
  ///
  /// In en, this message translates to:
  /// **'Search for a destination below. Places you pick will show up here next time.'**
  String get searchDestinationBelowPlacesPick;

  /// No description provided for @prototypeCoversOneDemoArea2.
  ///
  /// In en, this message translates to:
  /// **'This prototype covers one demo area of Bahawalpur, so the place list is limited. Try \"Model Town\", \"university\" or \"bazaar\".'**
  String get prototypeCoversOneDemoArea2;

  /// No description provided for @nothingSavedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get nothingSavedYet;

  /// No description provided for @tapBookmarkAnyPlaceKeep.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on any place to keep it here for quick access.'**
  String get tapBookmarkAnyPlaceKeep;

  /// No description provided for @backSearch.
  ///
  /// In en, this message translates to:
  /// **'Back to search'**
  String get backSearch;

  /// No description provided for @willNoLongerAppearSaved.
  ///
  /// In en, this message translates to:
  /// **'It will no longer appear in your saved places. You can save it again any time.'**
  String get willNoLongerAppearSaved;

  /// No description provided for @offlineMap.
  ///
  /// In en, this message translates to:
  /// **'Offline map'**
  String get offlineMap;

  /// No description provided for @manuallyCategorised.
  ///
  /// In en, this message translates to:
  /// **'Manually categorised'**
  String get manuallyCategorised;

  /// No description provided for @howLevelCalculated.
  ///
  /// In en, this message translates to:
  /// **'How this level was calculated'**
  String get howLevelCalculated;

  /// No description provided for @textSpeechPreview.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech preview'**
  String get textSpeechPreview;

  /// No description provided for @warningsStayShortSoThey.
  ///
  /// In en, this message translates to:
  /// **'Warnings stay short so they are usable while travelling.'**
  String get warningsStayShortSoThey;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @reportNotPublishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your report was not published'**
  String get reportNotPublishedTitle;

  /// No description provided for @reportWithheldBody.
  ///
  /// In en, this message translates to:
  /// **'It appeared to identify a specific person. Reports about identifiable individuals are never published.'**
  String get reportWithheldBody;

  /// No description provided for @howStep1Title.
  ///
  /// In en, this message translates to:
  /// **'A resident reports what they see'**
  String get howStep1Title;

  /// No description provided for @howStep1Body.
  ///
  /// In en, this message translates to:
  /// **'In English, Urdu, Roman Urdu or Punjabi — \"aagay gali band hai\", \"road par pani khara hai\", \"streetlight band hai\".'**
  String get howStep1Body;

  /// No description provided for @howStep2Title.
  ///
  /// In en, this message translates to:
  /// **'The report becomes a structured signal'**
  String get howStep2Title;

  /// No description provided for @howStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Informal text is turned into a category, a severity and a neutral public summary. You always review it before it is published.'**
  String get howStep2Body;

  /// No description provided for @howStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Routes are compared, and explained'**
  String get howStep3Title;

  /// No description provided for @howStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Fresh reports count more than old ones. Every route says in plain words what it avoids and what it costs you in minutes.'**
  String get howStep3Body;

  /// No description provided for @howStep4Title.
  ///
  /// In en, this message translates to:
  /// **'The next traveller is warned'**
  String get howStep4Title;

  /// No description provided for @howStep4Body.
  ///
  /// In en, this message translates to:
  /// **'A short voice warning before you set off, and a safety check-in you can share with someone you trust.'**
  String get howStep4Body;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pa', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'ur':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return LUrLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'pa':
      return LPa();
    case 'ur':
      return LUr();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
