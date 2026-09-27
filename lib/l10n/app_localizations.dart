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
  /// **'Live'**
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
