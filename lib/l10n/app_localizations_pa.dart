// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class LPa extends L {
  LPa([String locale = 'pa']) : super(locale);

  @override
  String get appName => 'سفر';

  @override
  String get tagline => 'راہ پین توں پہلاں جان لؤ۔';

  @override
  String get cityLine => 'بہاولپور · راہ پین توں پہلاں جان لؤ۔';

  @override
  String get navPlan => 'پلان';

  @override
  String get navMap => 'نقشہ';

  @override
  String get navActivity => 'کم کار';

  @override
  String get navYou => 'تسیں';

  @override
  String get reportAction => 'سڑک دی حالت دسو';

  @override
  String get greetMorning => 'صبح بخیر';

  @override
  String get greetAfternoon => 'دوپہر بخیر';

  @override
  String get greetEvening => 'شام بخیر';

  @override
  String get greetNight => 'اج رات دا سفر';

  @override
  String get greetLate => 'دیر نال سفر';

  @override
  String get from => 'کتھوں';

  @override
  String get to => 'کتھے';

  @override
  String get chooseStart => 'شروع دی تھاں چُنو';

  @override
  String get whereGoing => 'تسیں کتھے جا رہے او؟';

  @override
  String get compareRoutes => 'راہواں دا موازنہ کرو';

  @override
  String get swap => 'بدلو';

  @override
  String get aroundYouNow => 'ہُن تہاڈے آلے دوآلے';

  @override
  String get liveSignals => 'موجودہ اطلاعاں';

  @override
  String get inLastHour => 'پچھلا گھنٹہ';

  @override
  String get roadsBlocked => 'بند سڑکاں';

  @override
  String get openMap => 'نقشہ کھولو';

  @override
  String get recentSignals => 'تازہ کمیونٹی اطلاعاں';

  @override
  String get happeningNow => 'ہُن ہو رہیا اے';

  @override
  String get noLiveReports => 'ہُن کوئی تازہ رپورٹ نہیں';

  @override
  String get noLiveReportsBody =>
      'ہُنے ایس علاقے توں کوئی اطلاع نہیں آئی۔ ایہدا مطلب ایہ نہیں کہ راہ صاف اے — بس سانوں پتہ نہیں۔';

  @override
  String get beFirstToReport => 'سب توں پہلاں دسو';

  @override
  String get safetyCheckin => 'حفاظتی چیک اِن';

  @override
  String get checkinRunning => 'چیک اِن چل رہیا اے';

  @override
  String get tellSomeone => 'کسے نوں دسو کہ تسیں سفر تے او';

  @override
  String get browseMap => 'نقشہ ویکھو';

  @override
  String get seeEverySignal => 'نیڑے دیاں ساریاں اطلاعاں ویکھو';

  @override
  String get disclaimer =>
      'کمیونٹی رپورٹاں ادھوریاں یا غیر تصدیق شدہ ہو سکدیاں نیں۔ ایہ ایپ حفاظت یا سڑک دی دستیابی دی ضمانت نہیں دیندی۔';

  @override
  String get beforeYouRely => 'ایس تے بھروسہ کرن توں پہلاں';

  @override
  String get notEmergency =>
      'سفر کوئی ایمرجنسی سروس نہیں۔ ایمرجنسی وچ ریسکیو 1122 یا پولیس 15 نوں رابطہ کرو۔';

  @override
  String get demoData => 'نمونہ ڈیٹا';

  @override
  String get live => 'جُڑیا ہویا';

  @override
  String get awarenessLow => 'گھٹ احتیاط لوڑیندی';

  @override
  String get awarenessModerate => 'درمیانی احتیاط لوڑیندی';

  @override
  String get awarenessElevated => 'ودھ احتیاط لوڑیندی';

  @override
  String get awarenessLimited => 'معلومات گھٹ نیں';

  @override
  String get confidenceHigh => 'ودھ بھروسہ';

  @override
  String get confidenceModerate => 'درمیانا بھروسہ';

  @override
  String get confidenceLow => 'گھٹ بھروسہ';

  @override
  String get routeFastest => 'سب توں تیز راہ';

  @override
  String get routeBetterLit => 'ودھ روشنی والا راہ';

  @override
  String get routeFewerHazards => 'گھٹ رکاوٹاں';

  @override
  String routesToCompare(int count) {
    return '$count راہواں دا موازنہ';
  }

  @override
  String get oneSensibleRoute => 'اک ای ٹھیک راہ';

  @override
  String get neverSafetyScore => 'راہ دی آگاہی — حفاظتی سکور نہیں۔';

  @override
  String recentReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تازہ رپورٹاں',
      one: '1 تازہ رپورٹ',
      zero: 'کوئی تازہ رپورٹ نہیں',
    );
    return '$_temp0';
  }

  @override
  String get suggested => 'تجویز کیتا';

  @override
  String get seeWhatIsOnRoute => 'ویکھو ایس راہ تے کی اے';

  @override
  String get passesBlockage => 'بند راہ توں لنگھدا اے';

  @override
  String get whatReporting => 'تسیں کیہدی رپورٹ کر رہے او؟';

  @override
  String get whatExactly => 'اصل وچ کی ہو رہیا اے؟';

  @override
  String get whereIsIt => 'ایہ کتھے اے؟';

  @override
  String get anythingToAdd => 'کجھ ہور دسنا چاہندے او؟';

  @override
  String get reviewMyReport => 'میری رپورٹ ویکھو';

  @override
  String stepOf(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get understoodAs => 'اسیں ایہنوں ایہ سمجھیا';

  @override
  String get confirmAndPublish => 'تصدیق کر کے چھاپو';

  @override
  String get changeCategory => 'قسم بدلو';

  @override
  String get cancel => 'منسوخ کرو';

  @override
  String get reportLive => 'تہاڈی رپورٹ چھپ گئی';

  @override
  String get reportNotPublished => 'رپورٹ نہیں چھپی';

  @override
  String get whatOthersSee => 'دوجے مسافر کی ویکھن گے';

  @override
  String get whatYouWrote => 'تسیں کی لکھیا';

  @override
  String get cannotPublish => 'ایہ رپورٹ نہیں چھاپی جا سکدی';

  @override
  String get catSafety => 'حفاظتی فکر';

  @override
  String get catLighting => 'روشنی';

  @override
  String get catRoad => 'سڑک دی حالت';

  @override
  String get catWater => 'پانی / نکاسی';

  @override
  String get catBlockage => 'رکاوٹ';

  @override
  String get catTraffic => 'ٹریفک دا مسئلہ';

  @override
  String get anonymousByDefault => 'پہلاں توں گمنام';

  @override
  String get privacyPromise =>
      'رپورٹاں پہلاں توں گمنام ہوندیاں نیں۔ اسیں کدے وی ناں، چہرے، فون نمبر، گڈی دی نمبر پلیٹ یا ذاتی پتے نہیں چھاپدے۔';

  @override
  String get settings => 'ترتیباں';

  @override
  String get language => 'زبان';

  @override
  String get appLanguage => 'ایپ دی زبان';

  @override
  String get appearance => 'شکل';

  @override
  String get themeLight => 'چانن';

  @override
  String get themeDark => 'ہنیرا';

  @override
  String get themeSystem => 'فون مطابق';

  @override
  String get voiceWarnings => 'اواز وچ خبردار';

  @override
  String get voiceWarningsSub => 'ٹُرن توں پہلاں نکی جہی اواز وچ اطلاع';

  @override
  String get mapSurface => 'نقشے دی قسم';

  @override
  String get privacy => 'پردہ داری';

  @override
  String get reportAnonymously => 'گمنام رپورٹ کرو';

  @override
  String get blurSensitive => 'نازک تھاواں دھندلیاں کرو';

  @override
  String get trustedContacts => 'بھروسے والے رابطے';

  @override
  String get savedPlaces => 'سانبھیاں تھاواں';

  @override
  String get myReports => 'میریاں رپورٹاں';

  @override
  String get about => 'جان پچھان';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get signIn => 'سائن اِن';

  @override
  String get continueAnonymously => 'گمنام اگے ودھو';

  @override
  String get retry => 'فیر کوشش کرو';

  @override
  String get back => 'واپس';

  @override
  String get done => 'ہو گیا';

  @override
  String get close => 'بند کرو';

  @override
  String get save => 'سانبھو';

  @override
  String get remove => 'ہٹاؤ';

  @override
  String get confirm => 'تصدیق کرو';

  @override
  String get search => 'لبھو';

  @override
  String get searchHint => 'تھاں، علاقہ یا نشانی لبھو';

  @override
  String noResults(String query) {
    return '\"$query\" نال کوئی تھاں نہیں لبھی';
  }

  @override
  String get clearSearch => 'کھوج صاف کرو';

  @override
  String get useMyLocation => 'میری ہُن دی تھاں ورتو';

  @override
  String get recent => 'تازہ';

  @override
  String get popularInBwp => 'بہاولپور وچ مشہور';

  @override
  String get iArrivedSafely => 'میں سلامت پُج گیا';

  @override
  String get cancelCheckin => 'چیک اِن منسوخ کرو';

  @override
  String get remaining => 'باقی';

  @override
  String get overdueBy => 'دیر';

  @override
  String get startCheckin => 'حفاظتی چیک اِن شروع کرو';

  @override
  String get playWarning => 'خبردار سنو';

  @override
  String get stop => 'روکو';

  @override
  String get voiceWarning => 'اواز وچ خبردار';

  @override
  String get offlineBanner =>
      'آف لائن۔ ایس فون تے سانبھیاں آخری اطلاعاں وکھائیاں جا رہیاں نیں۔';

  @override
  String get couldNotReachServer =>
      'سرور تک نہیں پُجے۔ نمونہ اطلاعاں وکھائیاں جا رہیاں نیں۔';

  @override
  String get somethingWentWrong => 'کجھ غلط ہو گیا';

  @override
  String get markAllRead => 'سارے پڑھے ہوئے نشان لاؤ';

  @override
  String get alerts => 'اطلاعاں';

  @override
  String get checkIns => 'چیک اِن';

  @override
  String get noAlertsYet => 'ہُن کوئی اطلاع نہیں';

  @override
  String get willHearUsWhenNew =>
      'جدوں تہاڈے ورتے راہ تے نویں رپورٹ آوے گی، کوئی تہاڈی رپورٹ دی تصدیق کرے گا، یا کسے چیک اِن ولے دھیان چاہیدا ہووے گا تے اسیں تہانوں دساں گے۔';

  @override
  String get reportedAnythingYet => 'تسیں ہُن تک کجھ نہیں دسیا';

  @override
  String get firstTimeTellOtherTravellers =>
      'جدوں تسیں پہلی واری کسے بند گلی یا خراب سٹریٹ لائٹ بارے دوجے مسافراں نوں دسو گے تے اوہ ایتھے وکھائی دیوے گا۔';

  @override
  String get makeFirstReport => 'اپنی پہلی رپورٹ کرو';

  @override
  String get totalReports => 'کُل رپورٹاں';

  @override
  String get liveNow => 'ہُن چالو';

  @override
  String get confirmedOthers => 'دوجیاں نے تصدیق کیتی';

  @override
  String get live2 => 'چالو';

  @override
  String get stillAffectingRouteAwareness => 'ہالے وی راہ دی آگاہی تے اثر';

  @override
  String get expiredWithheld => 'مُک گئیاں تے روکیاں';

  @override
  String get noLongerAffectingRoutes => 'ہُن راہواں تے اثر نہیں';

  @override
  String get noCheckInsYet => 'ہُن کوئی چیک اِن نہیں';

  @override
  String get checkTimerShareSomeoneTrust =>
      'چیک اِن اک ٹائمر اے جیہڑا تسیں کسے بھروسے والے نال شیئر کردے او۔ جے تسیں پُجن دی تصدیق نہ کرو تے اونہاں نوں پتہ لگ جاندا اے کہ تہانوں لبھنا اے۔';

  @override
  String get startCheck => 'چیک اِن شروع کرو';

  @override
  String get runningNow => 'ہُن چل رہیا';

  @override
  String get open => 'کھولو';

  @override
  String get pastCheckIns => 'پچھلے چیک اِن';

  @override
  String get nameOptional => 'ناں (مرضی نال)';

  @override
  String get shownOnly => 'صرف تہانوں وکھے گا';

  @override
  String get mobileNumber => 'موبائل نمبر';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get continueWithoutAccount => 'بغیر اکاؤنٹ اگے ودھو';

  @override
  String get doNeedAccount => 'تہانوں اکاؤنٹ دی لوڑ نہیں';

  @override
  String get reportingRoutesCheckInsAll =>
      'رپورٹنگ، راہ تے چیک اِن سارے گمنام کم کردے نیں۔ تہاڈا نمبر کدے دوجے مسافراں نوں نہیں وکھایا جاندا تے نہ کسے چھپی رپورٹ نال جوڑیا جاندا اے۔';

  @override
  String get cancelCheck => 'چیک اِن منسوخ کرنا اے؟';

  @override
  String get timerStopsContactsWillNotified =>
      'ٹائمر رُک جاوے گا تے تہاڈے رابطیاں نوں کسے وی صورت اطلاع نہیں دتی جاوے گی۔ تسیں جدوں چاہو نواں شروع کر سکدے او۔';

  @override
  String get keepRunning => 'چلدا رہن دیو';

  @override
  String get noCheckRunning => 'کوئی چیک اِن نہیں چل رہیا';

  @override
  String get checkAlreadyFinishedStartNew =>
      'ایہ چیک اِن مُک چکیا اے۔ اگلی واری ٹُرن ویلے ہوم سکرین توں نواں شروع کرو۔';

  @override
  String get check => 'چیک اِن';

  @override
  String get emergencyNumbers => 'ایمرجنسی نمبر';

  @override
  String get checkWindowPassed => 'تہاڈے چیک اِن دا ویلہ لنگھ گیا اے';

  @override
  String get fullProductContactsWouldBeen =>
      'پورے پروڈکٹ وچ ہُن تک تہاڈے رابطیاں نوں یاد دہانی مل چکی ہوندی۔ اونہاں نوں دسو کہ تسیں سلامت او، یا جے ہالے راہ وچ او تے ٹائمر ودھا دیو۔';

  @override
  String get notifyingContactsSimulatedUiBuild =>
      'ایس بلڈ وچ رابطیاں نوں اطلاع دینا صرف وکھاوے لئی اے — کوئی سنیہا سچ مچ نہیں گھلیا جاندا۔';

  @override
  String get destination => 'منزل';

  @override
  String get route => 'راہ';

  @override
  String get started => 'شروع ہویا';

  @override
  String get due => 'مقررہ ویلہ';

  @override
  String get livePosition => 'ہُن دی تھاں';

  @override
  String get startedCheckWithoutContactSo =>
      'تسیں ایہ چیک اِن بغیر کسے رابطے شروع کیتا، ایس لئی ٹائمر صرف تہاڈے لئی اے۔ کسے نوں شامل کرن نال ایہ بوہت زیادہ کم دا بن جاندا اے۔';

  @override
  String get needMoreMinutes => 'ہور 10 منٹ چاہیدے';

  @override
  String get checkAlreadyRunning => 'اک چیک اِن پہلاں توں چل رہیا اے';

  @override
  String get onlyOneCheckTimeOpen =>
      'اک ویلے صرف اک چیک اِن ہو سکدا اے۔ چلدا ہویا کھولو، یا پہلاں اینوں منسوخ کرو۔';

  @override
  String get open2 => 'اینوں کھولو';

  @override
  String get stayHere => 'ایتھے ای رہو';

  @override
  String get startWithoutContact => 'بغیر رابطے شروع کرنا اے؟';

  @override
  String get nobodyWillToldIfDo =>
      'جے تسیں چیک اِن نہ کرو تے کسے نوں اطلاع نہیں ملے گی۔ ٹائمر فیر وی یاد کراوے گا، پر چیک اِن اودوں چنگا کم کردا اے جدوں کسے نوں پتہ ہووے۔';

  @override
  String get startAnyway => 'فیر وی شروع کرو';

  @override
  String get chooseContact => 'رابطہ چُنو';

  @override
  String get setTimerIfDoConfirm =>
      'ٹائمر لاؤ۔ جے تسیں پُجن دی تصدیق نہ کرو تے تہاڈے بھروسے والے رابطیاں نوں یاد دہانی گھلی جاندی اے۔';

  @override
  String get howLongDoExpectTake => 'تہانوں کِنا ویلہ لگے گا؟';

  @override
  String get whoShouldNotified => 'کیہنوں اطلاع دتی جاوے؟';

  @override
  String get manage => 'انتظام';

  @override
  String get noTrustedContactsYet => 'ہُن کوئی بھروسے والا رابطہ نہیں';

  @override
  String get addSomeoneWouldWantKnow =>
      'کسے ایہو جیہے بندے نوں شامل کرو جیہنوں تسیں دسنا چاہو گے جے تسیں نہ پُجو۔';

  @override
  String get addContact => 'رابطہ شامل کرو';

  @override
  String get shareMyLivePosition => 'میری ہُن دی تھاں شیئر کرو';

  @override
  String get simulatedBuildNoLocationPermission =>
      'ایس بلڈ وچ وکھاوے لئی — کوئی لوکیشن اجازت نہیں ورتی جاندی';

  @override
  String get primary => 'مُکھ';

  @override
  String get addTrustedContact => 'بھروسے والا رابطہ شامل کرو';

  @override
  String get someoneWhoWouldNoticeIf =>
      'کوئی ایہو جیہا بندہ جیہنوں پتہ لگے جے تسیں نہ پُجو۔ صرف ایسے فون تے سانبھیا جاندا اے۔';

  @override
  String get name => 'ناں';

  @override
  String get relationship => 'رشتہ';

  @override
  String get familyRoommateColleague => 'ٹبر، روم میٹ، ساتھی…';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get addContact2 => 'رابطہ شامل کرو';

  @override
  String get noTrustedContacts => 'کوئی بھروسے والا رابطہ نہیں';

  @override
  String get addSomeoneWouldWantTold =>
      'کسے ایہو جیہے بندے نوں شامل کرو جیہنوں دسیا جاوے جے تسیں نہ پُجو۔ اونہاں دا نمبر ایسے فون تے رہندا اے۔';

  @override
  String get addFirstContact => 'اپنا پہلا رابطہ شامل کرو';

  @override
  String get contactsStoredDeviceOnlySafar =>
      'رابطے صرف ایسے فون تے سانبھے جاندے نیں۔ سفر تہاڈی رابطہ لسٹ اپ لوڈ نہیں کردا۔';

  @override
  String get theyWillNoLongerOffered =>
      'چیک اِن شروع کرن ویلے ہُن ایہ پیش نہیں کیتے جان گے۔';

  @override
  String get makePrimary => 'مُکھ بناؤ';

  @override
  String get recentre => 'فیر وچکار لیاؤ';

  @override
  String get tapPinMapScrollList => 'نقشے تے کسے پن نوں دباؤ، یا لسٹ ویکھو۔';

  @override
  String get nothingMatchesTheseFilters => 'ایہناں فلٹراں نال کجھ نہیں لبھیا';

  @override
  String get noLiveReportsCategoriesSelected =>
      'چُنیاں قسماں وچ کوئی تازہ رپورٹ نہیں۔ سب کجھ ویکھن لئی فلٹر ہٹا دیو۔';

  @override
  String get clearFilters => 'فلٹر ہٹاؤ';

  @override
  String get noSignalsAreaYet => 'ایس علاقے وچ ہُن کوئی اطلاع نہیں';

  @override
  String get limitedDataSameClearRoad =>
      'معلومات گھٹ ہونا صاف راہ دے برابر نہیں۔ جے تسیں کجھ ویکھو تے سب توں پہلاں دس سکدے او۔';

  @override
  String get addReport => 'رپورٹ شامل کرو';

  @override
  String get howRouteAwarenessCalculated => 'راہ دی آگاہی کِویں کڈھی جاندی اے';

  @override
  String get simulatedPositionPrototype => 'ایس پروٹوٹائپ لئی فرضی تھاں';

  @override
  String get bahawalpur => 'بہاولپور';

  @override
  String get afterDarkLightingReportsCount =>
      'ہنیرے مگروں روشنی دیاں رپورٹاں ودھ اہم ہوندیاں نیں';

  @override
  String get night => 'رات';

  @override
  String get demoControls => 'ڈیمو کنٹرول';

  @override
  String get couldLoadSignals => 'اطلاعاں لوڈ نہیں ہو سکیاں';

  @override
  String get nothingBeenReportedDemoArea =>
      'ہُنے ایس علاقے توں کوئی اطلاع نہیں آئی۔ ایہدا مطلب ایہ نہیں کہ سب ٹھیک اے — بس سانوں پتہ نہیں۔';

  @override
  String get uiPrototypeV => 'v1.0.0';

  @override
  String get whatSafar => 'سفر کی نہیں اے';

  @override
  String get privacyAbusePrevention => 'پردہ داری تے غلط ورتوں دی روک تھام';

  @override
  String get aboutDataBuild => 'ایس بلڈ دے ڈیٹا بارے';

  @override
  String get routesPlannedOverHandBuilt =>
      'راہ بہاولپور دے اک علاقے لئی ہتھ نال بݨائے سڑک نیٹ ورک تے بݨدے نیں۔ کوآرڈینیٹ اندازے نیں، سروے ڈیٹا نہیں۔ رپورٹ دے متن دی درجہ بندی مقامی طور تے ہوندی اے۔';

  @override
  String get builtBahawalpur => 'بہاولپور لئی بݨایا گیا۔';

  @override
  String get presentingUsers => 'وکھاوے لئی، ورتن والیاں لئی نہیں';

  @override
  String get theseSwitchesExistSoEvery =>
      'ایہ سوئچ ایس لئی نیں کہ پروٹوٹائپ دی ہر حالت منگݨ تے وکھائی جا سکے۔ پروڈکشن بلڈ وچ ایہ سکرین نہیں ہووے گی۔';

  @override
  String get userPersona => 'ورتن والے دی قسم';

  @override
  String get communitySignalData => 'کمیونٹی اطلاعاں دا ڈیٹا';

  @override
  String get reloadSeededSignals => 'نمونہ اطلاعاں فیر لوڈ کرو';

  @override
  String get emptyMap => 'نقشہ خالی کرو';

  @override
  String get showsEveryNoDataEmpty =>
      'ہر \"کوئی ڈیٹا نہیں\" تے خالی حالت وکھاندا اے';

  @override
  String get forceLoadFailure => 'لوڈ ناکامی پیدا کرو';

  @override
  String get showsErrorStateRetry => 'فیر کوشش نال ایرر حالت وکھاندا اے';

  @override
  String get showExpiredReports => 'مُک گئیاں رپورٹاں وکھاؤ';

  @override
  String get greyedOutNoEffectRouting => 'دھندلیاں، راہواں تے کوئی اثر نہیں';

  @override
  String get backend => 'بیک اینڈ';

  @override
  String get sendTestNotification => 'اجمائشی اطلاع گھلو';

  @override
  String get pushesEverySubscribedDevice =>
      'ہر سبسکرائب کیتی ڈیوائس نوں گھلدا اے';

  @override
  String get failurePaths => 'ناکامی دے راہ';

  @override
  String get breakReportClassifier => 'رپورٹ درجہ بندی خراب کرو';

  @override
  String get nextReportFallsBackManual =>
      'اگلی رپورٹ ہتھ نال قسم چُݨݨ تے چلی جاوے گی';

  @override
  String get simulateOffline => 'آف لائن حالت بݨاؤ';

  @override
  String get offlineBannerPlusCachedData =>
      'آف لائن بینر تے سانبھے ڈیٹا دا راہ';

  @override
  String get otherStates => 'ہور حالتاں';

  @override
  String get clearTrustedContacts => 'بھروسے والے رابطے ہٹاؤ';

  @override
  String get clearAllAlerts => 'ساریاں اطلاعاں ہٹاؤ';

  @override
  String get showsEmptyActivityTab => 'خالی سرگرمی ٹیب وکھاندا اے';

  @override
  String get resetCurrentTrip => 'ہُن دا سفر ری سیٹ کرو';

  @override
  String get clearsOriginDestinationPlannedRoutes =>
      'شروع، منزل تے بݨائے راہ ہٹا دیندا اے';

  @override
  String get twoMinuteDemo => 'دو منٹ دا ڈیمو';

  @override
  String get reportingSomethingSafarDoesAlert =>
      'سفر وچ کجھ دسݨ نال حکام نوں اطلاع نہیں جاندی۔ جے کوئی خطرے وچ اے تے سِدھا ایمرجنسی سروس نوں کال کرو۔';

  @override
  String get howWorks => 'ایہ کِویں کم کردا اے';

  @override
  String get routeAwarenessSafetyScore => 'راہ دی آگاہی، حفاظتی سکور نہیں';

  @override
  String get fourLevels => 'چار درجے';

  @override
  String get whatGoesIntoNumber => 'ایس عدد وچ کی شامل ہوندا اے';

  @override
  String get eachRoadSegmentGetsScore =>
      'ہر سڑک دے حصے نوں پنج وزن والے عاملاں توں سکور ملدا اے۔ راہ اپنے حصیاں دی لمبائی دے حساب نال اوسط اے۔';

  @override
  String get theseWeightsPrototypeValuesChosen =>
      'ایہ وزن اک ٹھیک ڈیمو لئی چُݨے پروٹوٹائپ عدد نیں۔ ایہناں دی اصل واقعاتی ڈیٹا نال تصدیق نہیں کیتی گئی۔';

  @override
  String get newerReportsCountMore => 'نویاں رپورٹاں ودھ اہم ہوندیاں نیں';

  @override
  String get everyReportLosesInfluenceAges =>
      'ہر رپورٹ ویلے نال اثر گھٹاندی اے، تے ایہ رفتار مسئلے دی قسم تے منحصر اے۔ حادثہ کجھ گھنٹیاں وچ بے معنی ہو جاندا اے؛ خراب سٹریٹ لائٹ کئی دن اہم رہندی اے۔';

  @override
  String get howReportsEarnTrust => 'رپورٹاں بھروسہ کِویں کماندیاں نیں';

  @override
  String get whatEachReportDoesRouting => 'ہر رپورٹ راہ تے کی اثر پاندی اے';

  @override
  String get honestCaveat => 'اک سچی وضاحت';

  @override
  String get skip => 'چھڈو';

  @override
  String get normalMapTellsNtheFastest =>
      'عام نقشہ تہانوں\nسب توں تیز راہ دسدا اے۔';

  @override
  String get safarTellsWhatExpectWay =>
      'سفر تہانوں دسدا اے کہ راہ وچ کی ملے گا۔';

  @override
  String get residentReportsWhatTheySee =>
      'کوئی رہݨ والا جو ویکھدا اے اوہ دسدا اے';

  @override
  String get reportBecomesStructuredSignal =>
      'رپورٹ اک ترتیب والی اطلاع بݨ جاندی اے';

  @override
  String get routesComparedExplained => 'راہواں دا موازنہ تے وضاحت';

  @override
  String get nextTravellerWarned => 'اگلے مسافر نوں خبردار کیتا جاندا اے';

  @override
  String get oneReportOnePersonHelps =>
      'اک بندے دی اک رپورٹ ہر اوس مسافر دے کم آندی اے جیہڑا اگے اوس سڑک توں لنگھے۔';

  @override
  String get whatAppWillDo => 'ایہ ایپ کی نہیں کرے گی';

  @override
  String get worthReadingBeforeRely =>
      'ایس تے بھروسہ کرن توں پہلاں پڑھن والی گل۔';

  @override
  String get itIsNot => 'ایہ نہیں اے';

  @override
  String get pickLanguage => 'اپنی زبان چُݨو';

  @override
  String get setsVoiceWarningsWordingReport =>
      'ایس نال اواز دے خبردار تے رپورٹ دے لفظ طے ہوندے نیں۔ تسیں ہمیشہ اوسے زبان وچ دس سکدے او جیہڑی تسیں سچ مچ بولدے او۔';

  @override
  String get loadingCommunitySignalsBahawalpur =>
      'بہاولپور لئی کمیونٹی اطلاعاں لوڈ ہو رہیاں نیں';

  @override
  String get reportsStillPublishedAnonymouslyOther =>
      'تہاڈیاں رپورٹاں ہالے وی گمنام چھپدیاں نیں۔ دوجے مسافر کدے تہاڈا ناں یا نمبر نہیں ویکھدے — اکاؤنٹ صرف فون بدلݨ تے تہاڈی تاریخ سانبھدا اے۔';

  @override
  String get anonymous => 'تسیں گمنام او';

  @override
  String get everythingWorksWithoutAccountAdding =>
      'سب کجھ بغیر اکاؤنٹ کم کردا اے۔ اکاؤنٹ بݨاؤݨ نال فون بدلݨ تے تہاڈیاں رپورٹاں تے سانبھیاں تھاواں رہندیاں نیں۔';

  @override
  String get createAccount => 'اکاؤنٹ بݨاؤ';

  @override
  String get reportsMade => 'کیتیاں رپورٹاں';

  @override
  String get signalsConfirmed => 'تصدیق شدہ اطلاعاں';

  @override
  String get tripsCompared => 'موازنہ کیتے سفر';

  @override
  String get stuff => 'تہاڈیاں چیزاں';

  @override
  String get preferences => 'پسند';

  @override
  String get shortSpokenAlertsBeforeSet =>
      'ٹُرن توں پہلاں نکی جہی اواز وچ اطلاع';

  @override
  String get allSettings => 'ساریاں ترتیباں';

  @override
  String get howRouteAwarenessWorks => 'راہ دی آگاہی کِویں کم کردی اے';

  @override
  String get aboutSafar => 'سفر بارے';

  @override
  String get returnAnonymousUsePhone => 'ایس فون تے گمنام ورتوں تے واپس جاؤ';

  @override
  String get signOut2 => 'سائن آؤٹ کرنا اے؟';

  @override
  String get willKeepUsingSafarAnonymously =>
      'تسیں سفر گمنام ورتدے رہو گے۔ تہاڈیاں رپورٹاں تہاڈے اکاؤنٹ تے رہݨ گیاں تے سائن اِن کرن تے واپس آ جاݨ گیاں۔';

  @override
  String get bringReportsAnotherPhone => 'دوجے فون توں رپورٹاں لیاؤ';

  @override
  String get setsVoiceWarningsPromptWording =>
      'اواز دے خبردار تے لفظ طے کردا اے۔';

  @override
  String get tiersRecogniseContributionTheyNever =>
      'درجے حصہ پاؤݨ نوں مندے نیں۔ ایہ کدے کسے رپورٹ نوں تصدیق شدہ نہیں بݨاندے — ایہ صرف دوجے مسافراں دی تصدیق نال ہوندا اے۔';

  @override
  String get labelPlace => 'ایس تھاں نوں ناں دیو';

  @override
  String get shortNameLikeHomeWork =>
      'نِکا جیہا ناں جیویں \"گھر\"، \"دفتر\" یا \"ماں دا گھر\"۔';

  @override
  String get labelOptional => 'ناں (مرضی نال)';

  @override
  String get noSavedPlaces => 'کوئی سانبھی تھاں نہیں';

  @override
  String get tapBookmarkNextAnyPlace =>
      'لبھݨ ویلے کسے تھاں نال بک مارک دباؤ، اوہ ایتھے اک ٹیپ نال راہ بݨاؤݨ لئی آ جاوے گی۔';

  @override
  String get willNoLongerAppear =>
      'ایہ ہُن تہاڈیاں سانبھیاں تھاواں وچ نہیں وکھے گی۔';

  @override
  String get changeLabel => 'ناں بدلو';

  @override
  String get routeHere => 'ایتھے دا راہ';

  @override
  String get languageVoice => 'زبان تے اواز';

  @override
  String get warningsPromptsSummaries => 'خبردار، سوال تے خلاصے';

  @override
  String get reportsNeverCarryName => 'تہاڈیاں رپورٹاں تے کدے ناں نہیں ہوندا';

  @override
  String get roundSafetyConcernReportsRoughly =>
      'حفاظتی رپورٹاں نوں تقریباً 250 میٹر دے علاقے تک محدود کرو';

  @override
  String get mapData => 'نقشہ تے ڈیٹا';

  @override
  String get greyedOutTheyDoAffect =>
      'دھندلیاں، تے ایہ راہواں تے اثر نہیں پاندیاں';

  @override
  String get reloadCommunitySignals => 'کمیونٹی اطلاعاں فیر لوڈ کرو';

  @override
  String get fetchSeededDemonstrationDataAgain => 'نمونہ ڈیٹا فیر لیاؤ';

  @override
  String get prototypeControls => 'پروٹوٹائپ کنٹرول';

  @override
  String get demoControlPanel => 'ڈیمو کنٹرول پینل';

  @override
  String get switchPersonasForceErrorsEmpty =>
      'ورتن والے دی قسم بدلو، ایرر پیدا کرو، ڈیٹا خالی کرو — ڈیمو لئی';

  @override
  String get showsOfflineBannerCachedData =>
      'آف لائن بینر تے سانبھے ڈیٹا دا راہ وکھاندا اے';

  @override
  String get aboutLimitations => 'جان پچھان تے حداں';

  @override
  String get clearLocalData => 'مقامی ڈیٹا صاف کرو';

  @override
  String get resetsSavedPlacesContactsAlerts =>
      'سانبھیاں تھاواں، رابطے تے اطلاعاں ری سیٹ کردا اے';

  @override
  String get clearLocalData2 => 'مقامی ڈیٹا صاف کرنا اے؟';

  @override
  String get savedPlacesTrustedContactsAlerts =>
      'ایس فون تے سانبھیاں تھاواں، بھروسے والے رابطے تے اطلاعاں ہٹا دتیاں جاݨ گیاں۔ نمونہ اطلاعاں رہݨ گیاں تاں جو ڈیمو چلدا رہوے۔';

  @override
  String get clearData => 'ڈیٹا صاف کرو';

  @override
  String get confirmReport => 'ایس رپورٹ دی تصدیق کرنی اے؟';

  @override
  String get onlyConfirmIfSeenYourself =>
      'صرف اودوں تصدیق کرو جدوں تسیں آپ ویکھیا ہووے۔ تصدیقاں ای کسے اطلاع نوں غیر تصدیق شدہ توں تصدیق شدہ بݨاندیاں نیں۔';

  @override
  String get yesISaw => 'ہاں، میں ایہ ویکھیا';

  @override
  String get disputeReport => 'ایس رپورٹ نال اختلاف کرنا اے؟';

  @override
  String get useWhenConditionNoLonger =>
      'ایہ اودوں ورتو جدوں اوہ حالت ہُن نہیں اے، یا کدے سی ای نہیں۔ دو اختلاف رپورٹ نوں سب لئی متنازع کر دیندے نیں۔';

  @override
  String get dispute => 'اختلاف کرو';

  @override
  String get withdrawReport => 'اپنی رپورٹ واپس لینی اے؟';

  @override
  String get willStopAffectingRoutesImmediately =>
      'ایہ فوراً راہواں تے اثر پاؤݨا بند کر دیوے گی تے دوجے مسافراں نوں نہیں وکھے گی۔';

  @override
  String get withdraw => 'واپس لؤ';

  @override
  String get report => 'رپورٹ';

  @override
  String get reportNoLongerAvailable => 'ایہ رپورٹ ہُن نہیں ملدی';

  @override
  String get mayExpiredBeenWithdrawnWhoever =>
      'شاید ایہ مُک گئی ہووے یا گھلݨ والے نے واپس لے لئی ہووے۔';

  @override
  String get goBack => 'واپس جاؤ';

  @override
  String get approximateLocation => 'اندازے دی تھاں';

  @override
  String get report2 => 'تہاڈی رپورٹ';

  @override
  String get published => 'نہیں چھپی';

  @override
  String get reportWithheldBecauseAppeared =>
      'ایہ رپورٹ ایس لئی روکی گئی کہ ایس وچ کسے خاص بندے دی نشاندہی لگی۔ ایس نے کدے راہواں تے اثر نہیں پایا تے کوئی دوجا مسافر ایہنوں نہیں ویکھ سکدا۔';

  @override
  String get whatTravellersSee => 'مسافر کی ویکھدے نیں';

  @override
  String get visibleOnly => 'صرف تہانوں وکھدا اے۔';

  @override
  String get severity => 'شدت';

  @override
  String get confirmations => 'تصدیقاں';

  @override
  String get disputes => 'اختلاف';

  @override
  String get routeEffect => 'راہ تے اثر';

  @override
  String get expiry => 'مدت';

  @override
  String get reported => 'رپورٹ دی زبان';

  @override
  String get categorised => 'درجہ بندی';

  @override
  String get reported2 => 'رپورٹ کرن والا';

  @override
  String get onlyLiveReportStretchSo =>
      'ایس حصے تے ایہو اکلوتی تازہ رپورٹ اے، ایس لئی ایہ اطلاع اک بندے تے منحصر اے۔ دوجے مسافراں دی تصدیق ایہنوں ودھ بھروسے والا بݨاندی اے۔';

  @override
  String get expiredReportsNoLongerAffect =>
      'مُک گئیاں رپورٹاں ہُن راہواں تے اثر نہیں پاندیاں۔';

  @override
  String get withdrawReport2 => 'ایہ رپورٹ واپس لؤ';

  @override
  String get discardReport => 'ایہ رپورٹ سُٹ دیئے؟';

  @override
  String get whatEnteredSoFarWill =>
      'تسیں ہُن تک جو لکھیا اے اوہ نہیں سانبھیا جاوے گا، تے کجھ نہیں چھپے گا۔';

  @override
  String get discard => 'سُٹ دیو';

  @override
  String get keepEditing => 'لکھدے رہو';

  @override
  String get hitHourlyLimit => 'تسیں گھنٹے والی حد تے پُج گئے او';

  @override
  String get rateLimitsExistSoOne =>
      'حد ایس لئی اے کہ اک بندہ کسے علاقے نوں رپورٹاں نال نہ بھر دیوے۔ تہاڈیاں پچھلیاں رپورٹاں ہالے وی چالو نیں۔';

  @override
  String get understood => 'سمجھ گیا';

  @override
  String get pickClosestCategoryCorrectLater =>
      'سب توں نیڑے دی قسم چُݨو۔ جے ایپ تہاڈی تفصیل نوں وکھرا سمجھے تے تسیں مگروں ٹھیک کر سکدے او۔';

  @override
  String get pickCategoryFirst => 'پہلاں اک قسم چُݨو';

  @override
  String get goBackStepChooseWhat =>
      'اک قدم پچھے جا کے چُݨو کہ تسیں کیہدی رپورٹ کر رہے او۔';

  @override
  String get chooseCategory => 'قسم چُݨو';

  @override
  String get change => 'بدلو';

  @override
  String get phraseUnderneathEachOptionHow =>
      'ہر چوݨ دے تھلے لکھیا جملہ اوہو اے جیہڑا لوک عام طور تے کہندے نیں۔';

  @override
  String get tapPlacePin => 'پن رکھݨ لئی دباؤ';

  @override
  String get roundedAboutM => 'تقریباً 250 میٹر تک محدود';

  @override
  String get reportWillApplyRoadSegment => 'ایہ رپورٹ ایس سڑک دے حصے تے لگے گی';

  @override
  String get safetyConcernReportsAlwaysRounded =>
      'حفاظتی رپورٹاں چھپݨ توں پہلاں ہمیشہ اندازے دے علاقے تک محدود کیتیاں جاندیاں نیں، تاں جو کوئی رپورٹ کسے اک بوہے ولے اشارہ نہ کرے۔';

  @override
  String get sensitiveCategory => 'نازک قسم';

  @override
  String get optionalWriteEnglishUrduRoman =>
      'مرضی نال۔ انگریزی، اردو یا رومن اردو وچ لکھو — جیہڑی وی سوکھی لگے۔ ایپ ایہنوں پڑھ کے اک قسم دسدی اے، جیہدی تسیں تصدیق کردے او۔';

  @override
  String get eGAagayGaliBand => 'مثلاً \"اگے گلی بند اے\"';

  @override
  String get tapExampleUse => 'ورتݨ لئی کسے مثال نوں دباؤ';

  @override
  String get doIncludeNamesPhoneNumbers =>
      'ناں، فون نمبر، گڈی دی نمبر پلیٹ یا ذاتی پتے شامل نہ کرو۔ جیہڑیاں رپورٹاں کسے بندے دی نشاندہی کرن اوہ کدے نہیں چھپدیاں۔';

  @override
  String get whatWrite => 'کی نہیں لکھنا';

  @override
  String get chooseRightCategory => 'ٹھیک قسم چُݨو';

  @override
  String get correctionWhatGetsPublishedCorrections =>
      'تہاڈی درستی ای چھپدی اے۔ درستیاں سانوں ایہ وی دسدیاں نیں کہ درجہ بندی کِتھے کمزور اے۔';

  @override
  String get reportPublished => 'تہاڈی رپورٹ نہیں چھپی';

  @override
  String get cancelReport => 'ایہ رپورٹ منسوخ کرنی اے؟';

  @override
  String get nothingWillPublishedTextWill =>
      'کجھ نہیں چھپے گا تے تہاڈا متن نہیں سانبھیا جاوے گا۔';

  @override
  String get cancelReport2 => 'رپورٹ منسوخ کرو';

  @override
  String get keep => 'رہݨ دیو';

  @override
  String get reviewBeforePublishing => 'چھاپݨ توں پہلاں ویکھو';

  @override
  String get automaticReadingUnavailable => 'آپے پڑھݨ دی سہولت نہیں';

  @override
  String get tryReadingAgain => 'فیر پڑھݨ دی کوشش کرو';

  @override
  String get enoughDetailPublish => 'چھاپݨ لئی تفصیل گھٹ اے';

  @override
  String get couldTellWhatReportAbout =>
      'اسیں سمجھ نہیں سکے کہ ایہ رپورٹ کیہدے بارے اے۔ کجھ لفظ ہور لکھو، یا آپ قسم چُݨو۔';

  @override
  String get chooseCategoryMyself => 'میں آپ قسم چُݨاں گا';

  @override
  String get sureRightPleaseCheckCategory =>
      'سانوں یقین نہیں کہ ایہ ٹھیک اے۔ چھاپݨ توں پہلاں قسم ویکھ لؤ۔';

  @override
  String get someoneMayReportedAlready => 'شاید کسے نے پہلاں ای ایہ دس دتا اے';

  @override
  String get verySimilarReportSubmittedNearby =>
      'پچھلے 45 منٹاں وچ نیڑے ای ایہو جیہی رپورٹ آئی اے۔ تہاڈی رپورٹ تصدیق گِݨی جاوے گی، جیہدے نال اطلاع پکی ہو جاندی اے۔';

  @override
  String get corrected => 'تسیں ایہنوں ٹھیک کیتا';

  @override
  String get unverifiedUntilConfirmed => 'تصدیق تک غیر تصدیق شدہ';

  @override
  String get effectRouting => 'راہ تے اثر';

  @override
  String get onlySeeOriginalWordingOthers =>
      'تہاڈے اصل لفظ صرف تسیں ویکھ سکدے او۔ دوجیاں نوں اُتے والا غیر جانبدار خلاصہ وکھدا اے۔';

  @override
  String get nothingAboutIdentifiablePersonWill =>
      'کسے پچھاݨے جاݨ والے بندے بارے کجھ نہیں چھپے گا۔';

  @override
  String get iUnderstandGoBack => 'سمجھ گیا — واپس جاؤ';

  @override
  String get editMyDescription => 'اپنی تفصیل بدلو';

  @override
  String get readingReport => 'تہاڈی رپورٹ پڑھی جا رہی اے…';

  @override
  String get stillReportConditionItselfExample =>
      'تسیں فیر وی حالت آپ دس سکدے او — جیویں \"ایہ گلی رات نوں غیر محفوظ لگدی اے\" — کسے بندے دا ذکر کیتے بغیر۔';

  @override
  String get structuredOutput => 'ترتیب والا نتیجہ';

  @override
  String get whatHappensNext => 'ایس مگروں کی ہوندا اے';

  @override
  String get otherTravellersConfirm => 'دوجے مسافر ایہدی تصدیق کر سکدے نیں';

  @override
  String get fadesOverTime => 'ایہ ویلے نال مدھم پے جاندی اے';

  @override
  String get stayControl => 'اختیار تہاڈے کول رہندا اے';

  @override
  String get routesUpdated => 'راہ اپ ڈیٹ ہو گئے';

  @override
  String get reportAlreadyPartHowThese =>
      'تہاڈی رپورٹ پہلاں ای ایہناں راہواں دے حساب دا حصہ اے۔';

  @override
  String get shareSignal => 'ایہ اطلاع شیئر کرو';

  @override
  String get playVoiceWarning => 'اواز وچ خبردار سݨو';

  @override
  String get estimatedTime => 'اندازے دا ویلہ';

  @override
  String get distance => 'پینڈا';

  @override
  String get liveReports => 'تازہ رپورٹاں';

  @override
  String get route2 => 'ایس راہ تے';

  @override
  String get limitedDataRoute => 'ایس راہ تے معلومات گھٹ نیں';

  @override
  String get nobodyReportedAnythingHereRecently =>
      'ہُنے ایتھے کسے نے کجھ نہیں دسیا۔ ایہ کسے پاسے دا صاف اشارہ نہیں — بس سانوں پتہ نہیں۔';

  @override
  String get reportWhatSee => 'جو ویکھو اوہ دسو';

  @override
  String get stepStep => 'قدم بہ قدم';

  @override
  String get roadsRoute => 'ایس راہ دیاں سڑکاں';

  @override
  String get whyAwarenessLevel => 'ایہ درجہ کیوں؟';

  @override
  String get checkNotificationsSimulatedUiBuild =>
      'ایس بلڈ وچ چیک اِن اطلاعاں صرف وکھاوے لئی نیں۔';

  @override
  String get reportNearbyIssue => 'نیڑے دا مسئلہ دسو';

  @override
  String get baselineLighting => 'بنیادی روشنی';

  @override
  String get howBusy => 'کِنا رُجھیا';

  @override
  String get reportedDelay => 'دسی گئی دیر';

  @override
  String get noCommunityReportsStretchLevel =>
      'ایس حصے تے کوئی کمیونٹی رپورٹ نہیں۔ اُتے والا درجہ ایہدی بنیادی روشنی تے عام رَش توں آندا اے۔';

  @override
  String get communitySignal => 'کمیونٹی اطلاع';

  @override
  String get tapThroughFullReportIts =>
      'پوری رپورٹ تے ایہدے راہ تے اثر لئی دباؤ۔';

  @override
  String get reportNoLongerAvailable2 => 'ایہ رپورٹ ہُن نہیں ملدی۔';

  @override
  String get openReport => 'رپورٹ کھولو';

  @override
  String get reverseTrip => 'سفر اُلٹا کرو';

  @override
  String get recentreMap => 'نقشہ فیر وچکار لیاؤ';

  @override
  String get comparingRoutes => 'راہواں دا موازنہ ہو رہیا اے…';

  @override
  String get scoringEachRoadSegmentAgainst =>
      'ہر سڑک دے حصے نوں تازہ کمیونٹی رپورٹاں نال پرکھیا جا رہیا اے۔';

  @override
  String get changeDestination => 'منزل بدلو';

  @override
  String get thesePlacesTooCloseTogether =>
      'ایہ تھاواں اک دوجے دے بوہت نیڑے نیں';

  @override
  String get startDestinationSitSameJunction =>
      'تہاڈا شروع تے منزل سڑک دے اکو چوک تے نیں، ایس لئی موازنے لئی کجھ نہیں۔ کوئی دور دی منزل چُݨو۔';

  @override
  String get noRouteBetweenThesePoints => 'ایہناں تھاواں وچکار کوئی راہ نہیں';

  @override
  String get prototypeCoversOneDemoArea =>
      'ایہ پروٹوٹائپ بہاولپور دے اک علاقے تک محدود اے، ایس لئی ہر جوڑا سڑک نیٹ ورک وچ جُڑیا نہیں۔ کوئی ہور منزل اجماؤ۔';

  @override
  String get sortRoutes => 'راہ ترتیب دیو';

  @override
  String get seededRoadNetworkOffersNo =>
      'ایس سفر لئی نمونہ سڑک نیٹ ورک وچ کوئی وکھرا بدل نہیں، ایس لئی صرف اکو آپشن وکھایا جا رہیا اے۔';

  @override
  String get reportIssueRoute => 'ایس راہ تے مسئلہ دسو';

  @override
  String get simulatedNoLocationPermissionRequested =>
      'وکھاوے لئی — کوئی لوکیشن اجازت نہیں منگی جاندی';

  @override
  String get clear => 'صاف کرو';

  @override
  String get noSavedRecentPlacesYet => 'ہُن کوئی سانبھی یا تازہ تھاں نہیں';

  @override
  String get searchDestinationBelowPlacesPick =>
      'تھلے منزل لبھو۔ جیہڑیاں تھاواں تسیں چُݨو گے اوہ اگلی واری ایتھے وکھݨ گیاں۔';

  @override
  String get prototypeCoversOneDemoArea2 =>
      'ایہ پروٹوٹائپ بہاولپور دے اک علاقے تک محدود اے، ایس لئی تھاواں دی لسٹ محدود اے۔ \"ماڈل ٹاؤن\"، \"یونیورسٹی\" یا \"بازار\" اجماؤ۔';

  @override
  String get nothingSavedYet => 'ہُن کجھ نہیں سانبھیا';

  @override
  String get tapBookmarkAnyPlaceKeep =>
      'کسے وی تھاں تے بک مارک دباؤ تاں جو اوہ ایتھے چھیتی لبھݨ لئی رہوے۔';

  @override
  String get backSearch => 'لبھݨ تے واپس';

  @override
  String get willNoLongerAppearSaved =>
      'ایہ ہُن تہاڈیاں سانبھیاں تھاواں وچ نہیں ہووے گی۔ تسیں جدوں چاہو فیر سانبھ سکدے او۔';

  @override
  String get offlineMap => 'آف لائن نقشہ';

  @override
  String get manuallyCategorised => 'ہتھ نال درجہ بندی';

  @override
  String get howLevelCalculated => 'ایہ درجہ کِویں کڈھیا گیا';

  @override
  String get textSpeechPreview => 'متن توں اواز';

  @override
  String get warningsStayShortSoThey =>
      'خبردار نِکے رکھے جاندے نیں تاں جو سفر ویلے کم آ سکݨ۔';

  @override
  String get continueLabel => 'اگے ودھو';

  @override
  String get reportNotPublishedTitle => 'تہاڈی رپورٹ نہیں چھپی';

  @override
  String get reportWithheldBody =>
      'ایس وچ کسے خاص بندے دی نشاندہی لگی۔ پچھاݨے جاݨ والے بندیاں بارے رپورٹاں کدے نہیں چھپدیاں۔';

  @override
  String get howStep1Title => 'کوئی رہݨ والا جو ویکھدا اے اوہ دسدا اے';

  @override
  String get howStep1Body =>
      'انگریزی، اردو، رومن اردو یا پنجابی وچ — \"اگے گلی بند اے\"، \"روڈ تے پاݨی کھلوتا اے\"، \"سٹریٹ لائٹ بند اے\"۔';

  @override
  String get howStep2Title => 'رپورٹ اک ترتیب والی اطلاع بݨ جاندی اے';

  @override
  String get howStep2Body =>
      'غیر رسمی متن نوں اک قسم، شدت تے غیر جانبدار عوامی خلاصے وچ بدلیا جاندا اے۔ چھپݨ توں پہلاں تسیں ہمیشہ ایہنوں ویکھدے او۔';

  @override
  String get howStep3Title => 'راہواں دا موازنہ تے وضاحت';

  @override
  String get howStep3Body =>
      'تازہ رپورٹاں پراݨیاں توں ودھ اہم ہوندیاں نیں۔ ہر راہ سادے لفظاں وچ دسدا اے کہ اوہ کی بچاندا اے تے کِنے منٹ لیندا اے۔';

  @override
  String get howStep4Title => 'اگلے مسافر نوں خبردار کیتا جاندا اے';

  @override
  String get howStep4Body =>
      'ٹُرن توں پہلاں نکی جہی اواز وچ خبردار، تے اک حفاظتی چیک اِن جیہڑا تسیں کسے بھروسے والے نال شیئر کر سکدے او۔';
}
