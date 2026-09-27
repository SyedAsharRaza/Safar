// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class LUr extends L {
  LUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'سفر';

  @override
  String get tagline => 'راستہ لینے سے پہلے جان لیں۔';

  @override
  String get cityLine => 'بہاولپور · راستہ لینے سے پہلے جان لیں۔';

  @override
  String get navPlan => 'منصوبہ';

  @override
  String get navMap => 'نقشہ';

  @override
  String get navActivity => 'سرگرمی';

  @override
  String get navYou => 'آپ';

  @override
  String get reportAction => 'سڑک کی حالت رپورٹ کریں';

  @override
  String get greetMorning => 'صبح بخیر';

  @override
  String get greetAfternoon => 'دوپہر بخیر';

  @override
  String get greetEvening => 'شام بخیر';

  @override
  String get greetNight => 'آج رات کا سفر';

  @override
  String get greetLate => 'دیر سے سفر';

  @override
  String get from => 'کہاں سے';

  @override
  String get to => 'کہاں تک';

  @override
  String get chooseStart => 'ابتدائی مقام منتخب کریں';

  @override
  String get whereGoing => 'آپ کہاں جا رہے ہیں؟';

  @override
  String get compareRoutes => 'راستوں کا موازنہ کریں';

  @override
  String get swap => 'تبدیل کریں';

  @override
  String get aroundYouNow => 'اس وقت آپ کے اردگرد';

  @override
  String get liveSignals => 'موجودہ اطلاعات';

  @override
  String get inLastHour => 'پچھلا گھنٹہ';

  @override
  String get roadsBlocked => 'بند سڑکیں';

  @override
  String get openMap => 'نقشہ کھولیں';

  @override
  String get recentSignals => 'حالیہ کمیونٹی اطلاعات';

  @override
  String get happeningNow => 'ابھی ہو رہا ہے';

  @override
  String get noLiveReports => 'اس وقت کوئی تازہ رپورٹ نہیں';

  @override
  String get noLiveReportsBody =>
      'حال ہی میں اس علاقے سے کوئی اطلاع نہیں ملی۔ اس کا مطلب یہ نہیں کہ راستہ صاف ہے — بس ہمارے پاس معلومات نہیں ہیں۔';

  @override
  String get beFirstToReport => 'سب سے پہلے رپورٹ کریں';

  @override
  String get safetyCheckin => 'حفاظتی چیک اِن';

  @override
  String get checkinRunning => 'چیک اِن جاری ہے';

  @override
  String get tellSomeone => 'کسی کو بتائیں کہ آپ سفر میں ہیں';

  @override
  String get browseMap => 'نقشہ دیکھیں';

  @override
  String get seeEverySignal => 'قریب کی تمام اطلاعات دیکھیں';

  @override
  String get disclaimer =>
      'کمیونٹی رپورٹس نامکمل یا غیر تصدیق شدہ ہو سکتی ہیں۔ یہ ایپ حفاظت یا سڑک کی دستیابی کی ضمانت نہیں دیتی۔';

  @override
  String get beforeYouRely => 'اس پر بھروسہ کرنے سے پہلے';

  @override
  String get notEmergency =>
      'سفر کوئی ایمرجنسی سروس نہیں ہے۔ ہنگامی صورتحال میں ریسکیو 1122 یا پولیس 15 سے رابطہ کریں۔';

  @override
  String get demoData => 'نمونہ ڈیٹا';

  @override
  String get live => 'منسلک';

  @override
  String get awarenessLow => 'کم احتیاط درکار';

  @override
  String get awarenessModerate => 'درمیانی احتیاط درکار';

  @override
  String get awarenessElevated => 'زیادہ احتیاط درکار';

  @override
  String get awarenessLimited => 'معلومات محدود ہیں';

  @override
  String get confidenceHigh => 'زیادہ بھروسہ';

  @override
  String get confidenceModerate => 'درمیانہ بھروسہ';

  @override
  String get confidenceLow => 'کم بھروسہ';

  @override
  String get routeFastest => 'تیز ترین راستہ';

  @override
  String get routeBetterLit => 'زیادہ روشنی والا راستہ';

  @override
  String get routeFewerHazards => 'کم رکاوٹیں';

  @override
  String routesToCompare(int count) {
    return '$count راستوں کا موازنہ';
  }

  @override
  String get oneSensibleRoute => 'ایک ہی مناسب راستہ';

  @override
  String get neverSafetyScore => 'راستے کی آگاہی — حفاظتی اسکور نہیں۔';

  @override
  String recentReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تازہ رپورٹس',
      one: '1 تازہ رپورٹ',
      zero: 'کوئی تازہ رپورٹ نہیں',
    );
    return '$_temp0';
  }

  @override
  String get suggested => 'تجویز کردہ';

  @override
  String get seeWhatIsOnRoute => 'دیکھیں اس راستے پر کیا ہے';

  @override
  String get passesBlockage => 'بند راستے سے گزرتا ہے';

  @override
  String get whatReporting => 'آپ کس چیز کی رپورٹ کر رہے ہیں؟';

  @override
  String get whatExactly => 'اصل میں کیا ہو رہا ہے؟';

  @override
  String get whereIsIt => 'یہ کہاں ہے؟';

  @override
  String get anythingToAdd => 'کچھ اور بتانا چاہیں گے؟';

  @override
  String get reviewMyReport => 'میری رپورٹ دیکھیں';

  @override
  String stepOf(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get understoodAs => 'ہم نے اسے یوں سمجھا';

  @override
  String get confirmAndPublish => 'تصدیق کر کے شائع کریں';

  @override
  String get changeCategory => 'قسم تبدیل کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get reportLive => 'آپ کی رپورٹ شائع ہو گئی';

  @override
  String get reportNotPublished => 'رپورٹ شائع نہیں ہوئی';

  @override
  String get whatOthersSee => 'دوسرے مسافر کیا دیکھیں گے';

  @override
  String get whatYouWrote => 'آپ نے کیا لکھا';

  @override
  String get cannotPublish => 'یہ رپورٹ شائع نہیں کی جا سکتی';

  @override
  String get catSafety => 'حفاظتی تشویش';

  @override
  String get catLighting => 'روشنی';

  @override
  String get catRoad => 'سڑک کی حالت';

  @override
  String get catWater => 'پانی / نکاسی';

  @override
  String get catBlockage => 'رکاوٹ';

  @override
  String get catTraffic => 'ٹریفک کا مسئلہ';

  @override
  String get anonymousByDefault => 'بطورِ طے شدہ گمنام';

  @override
  String get privacyPromise =>
      'رپورٹس بطورِ طے شدہ گمنام ہوتی ہیں۔ ہم کبھی نام، چہرے، فون نمبر، گاڑی کی نمبر پلیٹ یا ذاتی پتے شائع نہیں کرتے۔';

  @override
  String get settings => 'ترتیبات';

  @override
  String get language => 'زبان';

  @override
  String get appLanguage => 'ایپ کی زبان';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get themeSystem => 'فون کے مطابق';

  @override
  String get voiceWarnings => 'آواز میں انتباہ';

  @override
  String get voiceWarningsSub => 'روانہ ہونے سے پہلے مختصر آواز میں اطلاع';

  @override
  String get mapSurface => 'نقشے کی قسم';

  @override
  String get privacy => 'رازداری';

  @override
  String get reportAnonymously => 'گمنام رپورٹ کریں';

  @override
  String get blurSensitive => 'حساس مقامات دھندلا کریں';

  @override
  String get trustedContacts => 'قابلِ اعتماد رابطے';

  @override
  String get savedPlaces => 'محفوظ مقامات';

  @override
  String get myReports => 'میری رپورٹس';

  @override
  String get about => 'تعارف';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get signIn => 'سائن اِن';

  @override
  String get continueAnonymously => 'گمنام جاری رکھیں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get back => 'واپس';

  @override
  String get done => 'مکمل';

  @override
  String get close => 'بند کریں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get remove => 'ہٹائیں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get search => 'تلاش';

  @override
  String get searchHint => 'جگہ، علاقہ یا نشانی تلاش کریں';

  @override
  String noResults(String query) {
    return '\"$query\" سے کوئی جگہ نہیں ملی';
  }

  @override
  String get clearSearch => 'تلاش صاف کریں';

  @override
  String get useMyLocation => 'میرا موجودہ مقام استعمال کریں';

  @override
  String get recent => 'حالیہ';

  @override
  String get popularInBwp => 'بہاولپور میں مشہور';

  @override
  String get iArrivedSafely => 'میں بحفاظت پہنچ گیا';

  @override
  String get cancelCheckin => 'چیک اِن منسوخ کریں';

  @override
  String get remaining => 'باقی';

  @override
  String get overdueBy => 'تاخیر';

  @override
  String get startCheckin => 'حفاظتی چیک اِن شروع کریں';

  @override
  String get playWarning => 'انتباہ سنیں';

  @override
  String get stop => 'روکیں';

  @override
  String get voiceWarning => 'آواز میں انتباہ';

  @override
  String get offlineBanner =>
      'آف لائن۔ اس فون پر محفوظ آخری اطلاعات دکھائی جا رہی ہیں۔';

  @override
  String get couldNotReachServer =>
      'سرور تک رسائی نہ ہو سکی۔ نمونہ اطلاعات دکھائی جا رہی ہیں۔';

  @override
  String get somethingWentWrong => 'کچھ غلط ہو گیا';

  @override
  String get markAllRead => 'سب پڑھا ہوا نشان زد کریں';

  @override
  String get alerts => 'اطلاعات';

  @override
  String get checkIns => 'چیک اِن';

  @override
  String get noAlertsYet => 'ابھی کوئی اطلاع نہیں';

  @override
  String get willHearUsWhenNew =>
      'جب آپ کے استعمال کردہ راستے پر نئی رپورٹ آئے گی، کوئی آپ کی رپورٹ کی تصدیق کرے گا، یا کسی چیک اِن پر توجہ درکار ہوگی تو ہم آپ کو بتائیں گے۔';

  @override
  String get reportedAnythingYet => 'آپ نے ابھی تک کچھ رپورٹ نہیں کیا';

  @override
  String get firstTimeTellOtherTravellers =>
      'جب آپ پہلی بار کسی بند گلی یا خراب اسٹریٹ لائٹ کے بارے میں دوسرے مسافروں کو بتائیں گے تو وہ یہاں نظر آئے گا۔';

  @override
  String get makeFirstReport => 'اپنی پہلی رپورٹ درج کریں';

  @override
  String get totalReports => 'کل رپورٹس';

  @override
  String get liveNow => 'ابھی فعال';

  @override
  String get confirmedOthers => 'دوسروں نے تصدیق کی';

  @override
  String get live2 => 'فعال';

  @override
  String get stillAffectingRouteAwareness =>
      'اب بھی راستے کی آگاہی پر اثر انداز';

  @override
  String get expiredWithheld => 'ختم شدہ اور روکی گئی';

  @override
  String get noLongerAffectingRoutes => 'اب راستوں پر اثر انداز نہیں';

  @override
  String get noCheckInsYet => 'ابھی کوئی چیک اِن نہیں';

  @override
  String get checkTimerShareSomeoneTrust =>
      'چیک اِن ایک ٹائمر ہے جو آپ کسی قابلِ اعتماد شخص کے ساتھ شیئر کرتے ہیں۔ اگر آپ پہنچنے کی تصدیق نہ کریں تو انہیں معلوم ہو جاتا ہے کہ آپ کو تلاش کرنا ہے۔';

  @override
  String get startCheck => 'چیک اِن شروع کریں';

  @override
  String get runningNow => 'ابھی جاری';

  @override
  String get open => 'کھولیں';

  @override
  String get pastCheckIns => 'پچھلے چیک اِن';

  @override
  String get nameOptional => 'نام (اختیاری)';

  @override
  String get shownOnly => 'صرف آپ کو نظر آئے گا';

  @override
  String get mobileNumber => 'موبائل نمبر';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get continueWithoutAccount => 'بغیر اکاؤنٹ کے جاری رکھیں';

  @override
  String get doNeedAccount => 'آپ کو اکاؤنٹ کی ضرورت نہیں';

  @override
  String get reportingRoutesCheckInsAll =>
      'رپورٹنگ، راستے اور چیک اِن سب گمنام طور پر کام کرتے ہیں۔ آپ کا نمبر کبھی دوسرے مسافروں کو نہیں دکھایا جاتا اور نہ کسی شائع شدہ رپورٹ سے جوڑا جاتا ہے۔';

  @override
  String get cancelCheck => 'چیک اِن منسوخ کریں؟';

  @override
  String get timerStopsContactsWillNotified =>
      'ٹائمر رک جائے گا اور آپ کے رابطوں کو کسی صورت اطلاع نہیں دی جائے گی۔ آپ جب چاہیں نیا شروع کر سکتے ہیں۔';

  @override
  String get keepRunning => 'جاری رکھیں';

  @override
  String get noCheckRunning => 'کوئی چیک اِن جاری نہیں';

  @override
  String get checkAlreadyFinishedStartNew =>
      'یہ چیک اِن مکمل ہو چکا ہے۔ اگلی بار روانہ ہوتے وقت ہوم اسکرین سے نیا شروع کریں۔';

  @override
  String get check => 'چیک اِن';

  @override
  String get emergencyNumbers => 'ہنگامی نمبر';

  @override
  String get checkWindowPassed => 'آپ کے چیک اِن کا وقت گزر چکا ہے';

  @override
  String get fullProductContactsWouldBeen =>
      'مکمل پروڈکٹ میں اب تک آپ کے رابطوں کو یاد دہانی مل چکی ہوتی۔ انہیں بتائیں کہ آپ محفوظ ہیں، یا اگر ابھی راستے میں ہیں تو ٹائمر بڑھا دیں۔';

  @override
  String get notifyingContactsSimulatedUiBuild =>
      'اس بلڈ میں رابطوں کو اطلاع دینا صرف نمائشی ہے — کوئی پیغام واقعی نہیں بھیجا جاتا۔';

  @override
  String get destination => 'منزل';

  @override
  String get route => 'راستہ';

  @override
  String get started => 'شروع ہوا';

  @override
  String get due => 'مقررہ وقت';

  @override
  String get livePosition => 'موجودہ مقام';

  @override
  String get startedCheckWithoutContactSo =>
      'آپ نے یہ چیک اِن بغیر کسی رابطے کے شروع کیا، اس لیے ٹائمر صرف آپ کے لیے ہے۔ کسی کو شامل کرنے سے یہ کہیں زیادہ مفید ہو جاتا ہے۔';

  @override
  String get needMoreMinutes => 'مزید 10 منٹ چاہئیں';

  @override
  String get checkAlreadyRunning => 'ایک چیک اِن پہلے سے جاری ہے';

  @override
  String get onlyOneCheckTimeOpen =>
      'ایک وقت میں صرف ایک چیک اِن ہو سکتا ہے۔ جاری والا کھولیں، یا پہلے اسے منسوخ کریں۔';

  @override
  String get open2 => 'اسے کھولیں';

  @override
  String get stayHere => 'یہیں رہیں';

  @override
  String get startWithoutContact => 'بغیر رابطے کے شروع کریں؟';

  @override
  String get nobodyWillToldIfDo =>
      'اگر آپ چیک اِن نہ کریں تو کسی کو اطلاع نہیں ملے گی۔ ٹائمر پھر بھی یاد دلائے گا، لیکن چیک اِن تب بہتر کام کرتا ہے جب کسی کو علم ہو۔';

  @override
  String get startAnyway => 'پھر بھی شروع کریں';

  @override
  String get chooseContact => 'رابطہ منتخب کریں';

  @override
  String get setTimerIfDoConfirm =>
      'ٹائمر لگائیں۔ اگر آپ پہنچنے کی تصدیق نہ کریں تو آپ کے قابلِ اعتماد رابطوں کو یاد دہانی بھیجی جاتی ہے۔';

  @override
  String get howLongDoExpectTake => 'آپ کو کتنا وقت لگے گا؟';

  @override
  String get whoShouldNotified => 'کس کو اطلاع دی جائے؟';

  @override
  String get manage => 'انتظام';

  @override
  String get noTrustedContactsYet => 'ابھی کوئی قابلِ اعتماد رابطہ نہیں';

  @override
  String get addSomeoneWouldWantKnow =>
      'کسی ایسے شخص کو شامل کریں جسے آپ بتانا چاہیں گے اگر آپ نہ پہنچیں۔';

  @override
  String get addContact => 'رابطہ شامل کریں';

  @override
  String get shareMyLivePosition => 'میرا موجودہ مقام شیئر کریں';

  @override
  String get simulatedBuildNoLocationPermission =>
      'اس بلڈ میں نمائشی — کوئی لوکیشن اجازت استعمال نہیں ہوتی';

  @override
  String get primary => 'بنیادی';

  @override
  String get addTrustedContact => 'قابلِ اعتماد رابطہ شامل کریں';

  @override
  String get someoneWhoWouldNoticeIf =>
      'کوئی ایسا شخص جو محسوس کرے اگر آپ نہ پہنچیں۔ صرف اسی فون پر محفوظ ہوتا ہے۔';

  @override
  String get name => 'نام';

  @override
  String get relationship => 'رشتہ';

  @override
  String get familyRoommateColleague => 'خاندان، روم میٹ، ساتھی…';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get addContact2 => 'رابطہ شامل کریں';

  @override
  String get noTrustedContacts => 'کوئی قابلِ اعتماد رابطہ نہیں';

  @override
  String get addSomeoneWouldWantTold =>
      'کسی ایسے شخص کو شامل کریں جسے بتایا جائے اگر آپ نہ پہنچیں۔ ان کا نمبر اسی فون پر رہتا ہے۔';

  @override
  String get addFirstContact => 'اپنا پہلا رابطہ شامل کریں';

  @override
  String get contactsStoredDeviceOnlySafar =>
      'رابطے صرف اسی فون پر محفوظ ہوتے ہیں۔ سفر آپ کی رابطہ فہرست اپ لوڈ نہیں کرتا۔';

  @override
  String get theyWillNoLongerOffered =>
      'چیک اِن شروع کرتے وقت اب یہ پیش نہیں کیے جائیں گے۔';

  @override
  String get makePrimary => 'بنیادی بنائیں';

  @override
  String get recentre => 'دوبارہ مرکز میں لائیں';

  @override
  String get tapPinMapScrollList =>
      'نقشے پر کسی پن کو دبائیں، یا فہرست دیکھیں۔';

  @override
  String get nothingMatchesTheseFilters => 'ان فلٹرز سے کچھ نہیں ملا';

  @override
  String get noLiveReportsCategoriesSelected =>
      'منتخب کردہ اقسام میں کوئی تازہ رپورٹ نہیں۔ سب کچھ دیکھنے کے لیے فلٹر ہٹا دیں۔';

  @override
  String get clearFilters => 'فلٹر ہٹائیں';

  @override
  String get noSignalsAreaYet => 'اس علاقے میں ابھی کوئی اطلاع نہیں';

  @override
  String get limitedDataSameClearRoad =>
      'معلومات کم ہونا صاف راستے کے برابر نہیں۔ اگر آپ کچھ دیکھیں تو سب سے پہلے رپورٹ کر سکتے ہیں۔';

  @override
  String get addReport => 'رپورٹ شامل کریں';

  @override
  String get howRouteAwarenessCalculated => 'راستے کی آگاہی کیسے نکالی جاتی ہے';

  @override
  String get simulatedPositionPrototype => 'اس پروٹوٹائپ کے لیے فرضی مقام';

  @override
  String get bahawalpur => 'بہاولپور';

  @override
  String get afterDarkLightingReportsCount =>
      'اندھیرے کے بعد روشنی کی رپورٹس زیادہ اہم ہوتی ہیں';

  @override
  String get night => 'رات';

  @override
  String get demoControls => 'ڈیمو کنٹرول';

  @override
  String get couldLoadSignals => 'اطلاعات لوڈ نہیں ہو سکیں';

  @override
  String get nothingBeenReportedDemoArea =>
      'حال ہی میں اس علاقے سے کوئی اطلاع نہیں ملی۔ اس کا مطلب یہ نہیں کہ سب ٹھیک ہے — بس ہمارے پاس معلومات نہیں ہیں۔';

  @override
  String get uiPrototypeV => 'v1.0.0';

  @override
  String get whatSafar => 'سفر کیا نہیں ہے';

  @override
  String get privacyAbusePrevention => 'رازداری اور غلط استعمال کی روک تھام';

  @override
  String get aboutDataBuild => 'اس بلڈ کے ڈیٹا کے بارے میں';

  @override
  String get routesPlannedOverHandBuilt =>
      'راستے بہاولپور کے ایک علاقے کے لیے ہاتھ سے بنائے گئے سڑک نیٹ ورک پر بنائے جاتے ہیں۔ کوآرڈینیٹس تخمینی ہیں اور سروے ڈیٹا نہیں۔ رپورٹ کے متن کی درجہ بندی مقامی طور پر ہوتی ہے۔';

  @override
  String get builtBahawalpur => 'بہاولپور کے لیے بنایا گیا۔';

  @override
  String get presentingUsers => 'پیشکش کے لیے، صارفین کے لیے نہیں';

  @override
  String get theseSwitchesExistSoEvery =>
      'یہ سوئچ اس لیے ہیں کہ پروٹوٹائپ کی ہر حالت مانگنے پر دکھائی جا سکے۔ پروڈکشن بلڈ میں یہ اسکرین شامل نہیں ہوگی۔';

  @override
  String get userPersona => 'صارف کی قسم';

  @override
  String get communitySignalData => 'کمیونٹی اطلاعات کا ڈیٹا';

  @override
  String get reloadSeededSignals => 'نمونہ اطلاعات دوبارہ لوڈ کریں';

  @override
  String get emptyMap => 'نقشہ خالی کریں';

  @override
  String get showsEveryNoDataEmpty =>
      'ہر \"کوئی ڈیٹا نہیں\" اور خالی حالت دکھاتا ہے';

  @override
  String get forceLoadFailure => 'لوڈ ناکامی پیدا کریں';

  @override
  String get showsErrorStateRetry => 'دوبارہ کوشش کے ساتھ ایرر حالت دکھاتا ہے';

  @override
  String get showExpiredReports => 'ختم شدہ رپورٹس دکھائیں';

  @override
  String get greyedOutNoEffectRouting => 'دھندلی، راستوں پر کوئی اثر نہیں';

  @override
  String get backend => 'بیک اینڈ';

  @override
  String get sendTestNotification => 'آزمائشی اطلاع بھیجیں';

  @override
  String get pushesEverySubscribedDevice =>
      'ہر سبسکرائب شدہ ڈیوائس کو بھیجتا ہے';

  @override
  String get failurePaths => 'ناکامی کے راستے';

  @override
  String get breakReportClassifier => 'رپورٹ درجہ بندی خراب کریں';

  @override
  String get nextReportFallsBackManual =>
      'اگلی رپورٹ دستی قسم کے انتخاب پر چلی جائے گی';

  @override
  String get simulateOffline => 'آف لائن حالت بنائیں';

  @override
  String get offlineBannerPlusCachedData =>
      'آف لائن بینر اور محفوظ ڈیٹا کا راستہ';

  @override
  String get otherStates => 'دیگر حالتیں';

  @override
  String get clearTrustedContacts => 'قابلِ اعتماد رابطے ہٹائیں';

  @override
  String get clearAllAlerts => 'تمام اطلاعات ہٹائیں';

  @override
  String get showsEmptyActivityTab => 'خالی سرگرمی ٹیب دکھاتا ہے';

  @override
  String get resetCurrentTrip => 'موجودہ سفر ری سیٹ کریں';

  @override
  String get clearsOriginDestinationPlannedRoutes =>
      'آغاز، منزل اور بنائے گئے راستے ہٹا دیتا ہے';

  @override
  String get twoMinuteDemo => 'دو منٹ کا ڈیمو';

  @override
  String get reportingSomethingSafarDoesAlert =>
      'سفر میں کچھ رپورٹ کرنے سے حکام کو اطلاع نہیں جاتی۔ اگر کوئی خطرے میں ہے تو براہِ راست ہنگامی سروس کو کال کریں۔';

  @override
  String get howWorks => 'یہ کیسے کام کرتا ہے';

  @override
  String get routeAwarenessSafetyScore => 'راستے کی آگاہی، حفاظتی اسکور نہیں';

  @override
  String get fourLevels => 'چار درجے';

  @override
  String get whatGoesIntoNumber => 'اس عدد میں کیا شامل ہوتا ہے';

  @override
  String get eachRoadSegmentGetsScore =>
      'ہر سڑک کے حصے کو پانچ وزن دار عوامل سے اسکور ملتا ہے۔ راستہ اپنے حصوں کی لمبائی کے حساب سے اوسط ہے۔';

  @override
  String get theseWeightsPrototypeValuesChosen =>
      'یہ وزن ایک مناسب ڈیمو کے لیے چنے گئے پروٹوٹائپ اعداد ہیں۔ ان کی اصل واقعاتی ڈیٹا سے تصدیق نہیں کی گئی۔';

  @override
  String get newerReportsCountMore => 'نئی رپورٹس زیادہ اہم ہوتی ہیں';

  @override
  String get everyReportLosesInfluenceAges =>
      'ہر رپورٹ وقت کے ساتھ اثر کھوتی ہے، اور یہ رفتار مسئلے کی قسم پر منحصر ہے۔ حادثہ چند گھنٹوں میں غیر اہم ہو جاتا ہے؛ خراب اسٹریٹ لائٹ کئی دن اہم رہتی ہے۔';

  @override
  String get howReportsEarnTrust => 'رپورٹس بھروسہ کیسے حاصل کرتی ہیں';

  @override
  String get whatEachReportDoesRouting => 'ہر رپورٹ راستے پر کیا اثر ڈالتی ہے';

  @override
  String get honestCaveat => 'ایک ایماندارانہ وضاحت';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get normalMapTellsNtheFastest =>
      'عام نقشہ آپ کو\nسب سے تیز راستہ بتاتا ہے۔';

  @override
  String get safarTellsWhatExpectWay =>
      'سفر آپ کو بتاتا ہے کہ راستے میں کیا ملے گا۔';

  @override
  String get residentReportsWhatTheySee =>
      'کوئی رہائشی جو دیکھتا ہے وہ رپورٹ کرتا ہے';

  @override
  String get reportBecomesStructuredSignal => 'رپورٹ ایک منظم اطلاع بن جاتی ہے';

  @override
  String get routesComparedExplained => 'راستوں کا موازنہ اور وضاحت';

  @override
  String get nextTravellerWarned => 'اگلے مسافر کو خبردار کیا جاتا ہے';

  @override
  String get oneReportOnePersonHelps =>
      'ایک شخص کی ایک رپورٹ ہر اُس مسافر کے کام آتی ہے جو اگلا اُس سڑک سے گزرے۔';

  @override
  String get whatAppWillDo => 'یہ ایپ کیا نہیں کرے گی';

  @override
  String get worthReadingBeforeRely =>
      'اس پر بھروسہ کرنے سے پہلے پڑھنے کے قابل۔';

  @override
  String get itIsNot => 'یہ نہیں ہے';

  @override
  String get pickLanguage => 'اپنی زبان منتخب کریں';

  @override
  String get setsVoiceWarningsWordingReport =>
      'اس سے آواز کے انتباہ اور رپورٹ کے الفاظ طے ہوتے ہیں۔ آپ ہمیشہ اُسی زبان میں رپورٹ کر سکتے ہیں جو آپ واقعی بولتے ہیں۔';

  @override
  String get loadingCommunitySignalsBahawalpur =>
      'بہاولپور کے لیے کمیونٹی اطلاعات لوڈ ہو رہی ہیں';

  @override
  String get reportsStillPublishedAnonymouslyOther =>
      'آپ کی رپورٹس اب بھی گمنام شائع ہوتی ہیں۔ دوسرے مسافر کبھی آپ کا نام یا نمبر نہیں دیکھتے — اکاؤنٹ صرف فون بدلنے پر آپ کی تاریخ محفوظ رکھتا ہے۔';

  @override
  String get anonymous => 'آپ گمنام ہیں';

  @override
  String get everythingWorksWithoutAccountAdding =>
      'سب کچھ بغیر اکاؤنٹ کے کام کرتا ہے۔ اکاؤنٹ بنانے سے فون بدلنے پر آپ کی رپورٹس اور محفوظ مقامات باقی رہتے ہیں۔';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get reportsMade => 'کی گئی رپورٹس';

  @override
  String get signalsConfirmed => 'تصدیق شدہ اطلاعات';

  @override
  String get tripsCompared => 'موازنہ کیے گئے سفر';

  @override
  String get stuff => 'آپ کی چیزیں';

  @override
  String get preferences => 'ترجیحات';

  @override
  String get shortSpokenAlertsBeforeSet =>
      'روانگی سے پہلے مختصر آواز میں اطلاع';

  @override
  String get allSettings => 'تمام ترتیبات';

  @override
  String get howRouteAwarenessWorks => 'راستے کی آگاہی کیسے کام کرتی ہے';

  @override
  String get aboutSafar => 'سفر کے بارے میں';

  @override
  String get returnAnonymousUsePhone => 'اس فون پر گمنام استعمال پر واپس جائیں';

  @override
  String get signOut2 => 'سائن آؤٹ کریں؟';

  @override
  String get willKeepUsingSafarAnonymously =>
      'آپ سفر گمنام طور پر استعمال کرتے رہیں گے۔ آپ کی رپورٹس آپ کے اکاؤنٹ پر رہیں گی اور سائن اِن کرنے پر واپس آ جائیں گی۔';

  @override
  String get bringReportsAnotherPhone => 'دوسرے فون سے رپورٹس لائیں';

  @override
  String get setsVoiceWarningsPromptWording =>
      'آواز کے انتباہ اور الفاظ طے کرتا ہے۔';

  @override
  String get tiersRecogniseContributionTheyNever =>
      'درجے شراکت کو تسلیم کرتے ہیں۔ یہ کبھی کسی رپورٹ کو تصدیق شدہ نہیں بناتے — یہ صرف دوسرے مسافروں کی تصدیق سے ہوتا ہے۔';

  @override
  String get labelPlace => 'اس جگہ کو نام دیں';

  @override
  String get shortNameLikeHomeWork =>
      'مختصر نام جیسے \"گھر\"، \"دفتر\" یا \"امی کا گھر\"۔';

  @override
  String get labelOptional => 'نام (اختیاری)';

  @override
  String get noSavedPlaces => 'کوئی محفوظ مقام نہیں';

  @override
  String get tapBookmarkNextAnyPlace =>
      'تلاش کے دوران کسی جگہ کے ساتھ بک مارک دبائیں، وہ یہاں ایک ٹیپ میں راستہ بنانے کے لیے آ جائے گی۔';

  @override
  String get willNoLongerAppear =>
      'یہ اب آپ کے محفوظ مقامات میں نظر نہیں آئے گی۔';

  @override
  String get changeLabel => 'نام تبدیل کریں';

  @override
  String get routeHere => 'یہاں کا راستہ';

  @override
  String get languageVoice => 'زبان اور آواز';

  @override
  String get warningsPromptsSummaries => 'انتباہ، سوالات اور خلاصے';

  @override
  String get reportsNeverCarryName => 'آپ کی رپورٹس پر کبھی نام نہیں ہوتا';

  @override
  String get roundSafetyConcernReportsRoughly =>
      'حفاظتی رپورٹس کو تقریباً 250 میٹر کے علاقے تک محدود کریں';

  @override
  String get mapData => 'نقشہ اور ڈیٹا';

  @override
  String get greyedOutTheyDoAffect =>
      'دھندلی، اور یہ راستوں پر اثر نہیں ڈالتیں';

  @override
  String get reloadCommunitySignals => 'کمیونٹی اطلاعات دوبارہ لوڈ کریں';

  @override
  String get fetchSeededDemonstrationDataAgain => 'نمونہ ڈیٹا دوبارہ حاصل کریں';

  @override
  String get prototypeControls => 'پروٹوٹائپ کنٹرول';

  @override
  String get demoControlPanel => 'ڈیمو کنٹرول پینل';

  @override
  String get switchPersonasForceErrorsEmpty =>
      'صارف کی قسم بدلیں، ایرر پیدا کریں، ڈیٹا خالی کریں — ڈیمو کے لیے';

  @override
  String get showsOfflineBannerCachedData =>
      'آف لائن بینر اور محفوظ ڈیٹا کا راستہ دکھاتا ہے';

  @override
  String get aboutLimitations => 'تعارف اور حدود';

  @override
  String get clearLocalData => 'مقامی ڈیٹا صاف کریں';

  @override
  String get resetsSavedPlacesContactsAlerts =>
      'محفوظ مقامات، رابطے اور اطلاعات ری سیٹ کرتا ہے';

  @override
  String get clearLocalData2 => 'مقامی ڈیٹا صاف کریں؟';

  @override
  String get savedPlacesTrustedContactsAlerts =>
      'اس فون پر محفوظ مقامات، قابلِ اعتماد رابطے اور اطلاعات ہٹا دی جائیں گی۔ نمونہ اطلاعات باقی رہیں گی تاکہ ڈیمو چلتا رہے۔';

  @override
  String get clearData => 'ڈیٹا صاف کریں';

  @override
  String get confirmReport => 'اس رپورٹ کی تصدیق کریں؟';

  @override
  String get onlyConfirmIfSeenYourself =>
      'صرف تب تصدیق کریں جب آپ نے خود دیکھا ہو۔ تصدیقیں ہی کسی اطلاع کو غیر تصدیق شدہ سے تصدیق شدہ بناتی ہیں۔';

  @override
  String get yesISaw => 'ہاں، میں نے یہ دیکھا';

  @override
  String get disputeReport => 'اس رپورٹ سے اختلاف کریں؟';

  @override
  String get useWhenConditionNoLonger =>
      'یہ تب استعمال کریں جب وہ صورتحال اب نہیں ہے، یا کبھی تھی ہی نہیں۔ دو اختلاف رپورٹ کو سب کے لیے متنازع کر دیتے ہیں۔';

  @override
  String get dispute => 'اختلاف کریں';

  @override
  String get withdrawReport => 'اپنی رپورٹ واپس لیں؟';

  @override
  String get willStopAffectingRoutesImmediately =>
      'یہ فوراً راستوں پر اثر ڈالنا بند کر دے گی اور دوسرے مسافروں کو نظر نہیں آئے گی۔';

  @override
  String get withdraw => 'واپس لیں';

  @override
  String get report => 'رپورٹ';

  @override
  String get reportNoLongerAvailable => 'یہ رپورٹ اب دستیاب نہیں';

  @override
  String get mayExpiredBeenWithdrawnWhoever =>
      'شاید یہ ختم ہو گئی ہو یا بھیجنے والے نے واپس لے لی ہو۔';

  @override
  String get goBack => 'واپس جائیں';

  @override
  String get approximateLocation => 'تخمینی مقام';

  @override
  String get report2 => 'آپ کی رپورٹ';

  @override
  String get published => 'شائع نہیں ہوئی';

  @override
  String get reportWithheldBecauseAppeared =>
      'یہ رپورٹ اس لیے روکی گئی کہ اس میں کسی مخصوص شخص کی نشاندہی محسوس ہوئی۔ اس نے کبھی راستوں پر اثر نہیں ڈالا اور کوئی دوسرا مسافر اسے نہیں دیکھ سکتا۔';

  @override
  String get whatTravellersSee => 'مسافر کیا دیکھتے ہیں';

  @override
  String get visibleOnly => 'صرف آپ کو نظر آتا ہے۔';

  @override
  String get severity => 'شدت';

  @override
  String get confirmations => 'تصدیقیں';

  @override
  String get disputes => 'اختلافات';

  @override
  String get routeEffect => 'راستے پر اثر';

  @override
  String get expiry => 'مدت';

  @override
  String get reported => 'رپورٹ کی زبان';

  @override
  String get categorised => 'درجہ بندی';

  @override
  String get reported2 => 'رپورٹ کرنے والا';

  @override
  String get onlyLiveReportStretchSo =>
      'اس حصے پر یہی واحد تازہ رپورٹ ہے، اس لیے یہ اطلاع ایک شخص پر منحصر ہے۔ دوسرے مسافروں کی تصدیق اسے زیادہ قابلِ بھروسہ بناتی ہے۔';

  @override
  String get expiredReportsNoLongerAffect =>
      'ختم شدہ رپورٹس اب راستوں پر اثر نہیں ڈالتیں۔';

  @override
  String get withdrawReport2 => 'یہ رپورٹ واپس لیں';

  @override
  String get discardReport => 'یہ رپورٹ ضائع کریں؟';

  @override
  String get whatEnteredSoFarWill =>
      'آپ نے اب تک جو لکھا ہے وہ محفوظ نہیں ہوگا، اور کچھ شائع نہیں کیا جائے گا۔';

  @override
  String get discard => 'ضائع کریں';

  @override
  String get keepEditing => 'لکھتے رہیں';

  @override
  String get hitHourlyLimit => 'آپ گھنٹہ وار حد تک پہنچ گئے ہیں';

  @override
  String get rateLimitsExistSoOne =>
      'حد اس لیے ہے کہ ایک شخص کسی علاقے کو رپورٹس سے بھر نہ دے۔ آپ کی پچھلی رپورٹس اب بھی فعال ہیں۔';

  @override
  String get understood => 'سمجھ گیا';

  @override
  String get pickClosestCategoryCorrectLater =>
      'قریب ترین قسم منتخب کریں۔ اگر ایپ آپ کی تفصیل کو مختلف سمجھے تو آپ بعد میں درست کر سکتے ہیں۔';

  @override
  String get pickCategoryFirst => 'پہلے ایک قسم منتخب کریں';

  @override
  String get goBackStepChooseWhat =>
      'ایک قدم پیچھے جا کر منتخب کریں کہ آپ کس قسم کی چیز رپورٹ کر رہے ہیں۔';

  @override
  String get chooseCategory => 'قسم منتخب کریں';

  @override
  String get change => 'تبدیل کریں';

  @override
  String get phraseUnderneathEachOptionHow =>
      'ہر انتخاب کے نیچے لکھا جملہ وہی ہے جو لوگ عام طور پر کہتے ہیں۔';

  @override
  String get tapPlacePin => 'پن رکھنے کے لیے دبائیں';

  @override
  String get roundedAboutM => 'تقریباً 250 میٹر تک محدود';

  @override
  String get reportWillApplyRoadSegment =>
      'یہ رپورٹ اس سڑک کے حصے پر لاگو ہوگی';

  @override
  String get safetyConcernReportsAlwaysRounded =>
      'حفاظتی رپورٹس شائع ہونے سے پہلے ہمیشہ تخمینی علاقے تک محدود کی جاتی ہیں، تاکہ کوئی رپورٹ کسی ایک دروازے کی نشاندہی نہ کرے۔';

  @override
  String get sensitiveCategory => 'حساس قسم';

  @override
  String get optionalWriteEnglishUrduRoman =>
      'اختیاری۔ انگریزی، اردو یا رومن اردو میں لکھیں — جو بھی آسان ہو۔ ایپ اسے پڑھ کر ایک قسم تجویز کرتی ہے، جس کی آپ تصدیق کرتے ہیں۔';

  @override
  String get eGAagayGaliBand => 'مثلاً \"آگے گلی بند ہے\"';

  @override
  String get tapExampleUse => 'استعمال کے لیے کسی مثال کو دبائیں';

  @override
  String get doIncludeNamesPhoneNumbers =>
      'نام، فون نمبر، گاڑی کی نمبر پلیٹ یا ذاتی پتے شامل نہ کریں۔ جو رپورٹس کسی شخص کی نشاندہی کریں وہ کبھی شائع نہیں ہوتیں۔';

  @override
  String get whatWrite => 'کیا نہیں لکھنا';

  @override
  String get chooseRightCategory => 'درست قسم منتخب کریں';

  @override
  String get correctionWhatGetsPublishedCorrections =>
      'آپ کی درستی ہی شائع ہوتی ہے۔ درستیاں ہمیں یہ بھی بتاتی ہیں کہ درجہ بندی کہاں کمزور ہے۔';

  @override
  String get reportPublished => 'آپ کی رپورٹ شائع نہیں ہوئی';

  @override
  String get cancelReport => 'یہ رپورٹ منسوخ کریں؟';

  @override
  String get nothingWillPublishedTextWill =>
      'کچھ شائع نہیں ہوگا اور آپ کا متن محفوظ نہیں کیا جائے گا۔';

  @override
  String get cancelReport2 => 'رپورٹ منسوخ کریں';

  @override
  String get keep => 'رہنے دیں';

  @override
  String get reviewBeforePublishing => 'شائع کرنے سے پہلے جائزہ';

  @override
  String get automaticReadingUnavailable => 'خودکار پڑھائی دستیاب نہیں';

  @override
  String get tryReadingAgain => 'دوبارہ پڑھنے کی کوشش کریں';

  @override
  String get enoughDetailPublish => 'شائع کرنے کے لیے تفصیل کم ہے';

  @override
  String get couldTellWhatReportAbout =>
      'ہم سمجھ نہیں سکے کہ یہ رپورٹ کس بارے میں ہے۔ چند الفاظ مزید لکھیں، یا خود قسم منتخب کریں۔';

  @override
  String get chooseCategoryMyself => 'میں خود قسم منتخب کروں گا';

  @override
  String get sureRightPleaseCheckCategory =>
      'ہمیں یقین نہیں کہ یہ درست ہے۔ شائع کرنے سے پہلے قسم دیکھ لیں۔';

  @override
  String get someoneMayReportedAlready =>
      'شاید کوئی پہلے ہی یہ رپورٹ کر چکا ہے';

  @override
  String get verySimilarReportSubmittedNearby =>
      'پچھلے 45 منٹ میں قریب ہی ایسی ہی رپورٹ آئی ہے۔ آپ کی رپورٹ تصدیق شمار ہوگی، جس سے اطلاع مضبوط ہو جاتی ہے۔';

  @override
  String get corrected => 'آپ نے اسے درست کیا';

  @override
  String get unverifiedUntilConfirmed => 'تصدیق تک غیر تصدیق شدہ';

  @override
  String get effectRouting => 'راستے پر اثر';

  @override
  String get onlySeeOriginalWordingOthers =>
      'آپ کے اصل الفاظ صرف آپ دیکھ سکتے ہیں۔ دوسروں کو اوپر والا غیر جانبدار خلاصہ نظر آتا ہے۔';

  @override
  String get nothingAboutIdentifiablePersonWill =>
      'کسی قابلِ شناخت شخص کے بارے میں کچھ شائع نہیں کیا جائے گا۔';

  @override
  String get iUnderstandGoBack => 'سمجھ گیا — واپس جائیں';

  @override
  String get editMyDescription => 'اپنی تفصیل میں ترمیم کریں';

  @override
  String get readingReport => 'آپ کی رپورٹ پڑھی جا رہی ہے…';

  @override
  String get stillReportConditionItselfExample =>
      'آپ پھر بھی صورتحال خود رپورٹ کر سکتے ہیں — مثلاً \"یہ گلی رات کو غیر محفوظ لگتی ہے\" — کسی شخص کا ذکر کیے بغیر۔';

  @override
  String get structuredOutput => 'منظم نتیجہ';

  @override
  String get whatHappensNext => 'اس کے بعد کیا ہوتا ہے';

  @override
  String get otherTravellersConfirm => 'دوسرے مسافر اس کی تصدیق کر سکتے ہیں';

  @override
  String get fadesOverTime => 'یہ وقت کے ساتھ ماند پڑ جاتی ہے';

  @override
  String get stayControl => 'اختیار آپ کے پاس رہتا ہے';

  @override
  String get routesUpdated => 'راستے اپ ڈیٹ ہو گئے';

  @override
  String get reportAlreadyPartHowThese =>
      'آپ کی رپورٹ پہلے ہی ان راستوں کے حساب کا حصہ ہے۔';

  @override
  String get shareSignal => 'یہ اطلاع شیئر کریں';

  @override
  String get playVoiceWarning => 'آواز میں انتباہ سنیں';

  @override
  String get estimatedTime => 'متوقع وقت';

  @override
  String get distance => 'فاصلہ';

  @override
  String get liveReports => 'تازہ رپورٹس';

  @override
  String get route2 => 'اس راستے پر';

  @override
  String get limitedDataRoute => 'اس راستے پر معلومات کم ہیں';

  @override
  String get nobodyReportedAnythingHereRecently =>
      'حال ہی میں یہاں کسی نے کچھ رپورٹ نہیں کیا۔ یہ کسی طرف کا واضح اشارہ نہیں — بس ہمیں معلوم نہیں۔';

  @override
  String get reportWhatSee => 'جو دیکھیں وہ رپورٹ کریں';

  @override
  String get stepStep => 'قدم بہ قدم';

  @override
  String get roadsRoute => 'اس راستے کی سڑکیں';

  @override
  String get whyAwarenessLevel => 'یہ درجہ کیوں؟';

  @override
  String get checkNotificationsSimulatedUiBuild =>
      'اس بلڈ میں چیک اِن اطلاعات صرف نمائشی ہیں۔';

  @override
  String get reportNearbyIssue => 'قریبی مسئلہ رپورٹ کریں';

  @override
  String get baselineLighting => 'بنیادی روشنی';

  @override
  String get howBusy => 'کتنا مصروف';

  @override
  String get reportedDelay => 'بتائی گئی تاخیر';

  @override
  String get noCommunityReportsStretchLevel =>
      'اس حصے پر کوئی کمیونٹی رپورٹ نہیں۔ اوپر والا درجہ اس کی بنیادی روشنی اور عام مصروفیت سے آتا ہے۔';

  @override
  String get communitySignal => 'کمیونٹی اطلاع';

  @override
  String get tapThroughFullReportIts =>
      'مکمل رپورٹ اور اس کے راستے پر اثر کے لیے دبائیں۔';

  @override
  String get reportNoLongerAvailable2 => 'یہ رپورٹ اب دستیاب نہیں۔';

  @override
  String get openReport => 'رپورٹ کھولیں';

  @override
  String get reverseTrip => 'سفر الٹا کریں';

  @override
  String get recentreMap => 'نقشہ دوبارہ مرکز میں لائیں';

  @override
  String get comparingRoutes => 'راستوں کا موازنہ ہو رہا ہے…';

  @override
  String get scoringEachRoadSegmentAgainst =>
      'ہر سڑک کے حصے کو تازہ کمیونٹی رپورٹس کے مقابل پرکھا جا رہا ہے۔';

  @override
  String get changeDestination => 'منزل تبدیل کریں';

  @override
  String get thesePlacesTooCloseTogether =>
      'یہ مقامات ایک دوسرے کے بہت قریب ہیں';

  @override
  String get startDestinationSitSameJunction =>
      'آپ کا آغاز اور منزل سڑک کے ایک ہی چوک پر ہیں، اس لیے موازنے کے لیے کچھ نہیں۔ کوئی دور کی منزل منتخب کریں۔';

  @override
  String get noRouteBetweenThesePoints => 'ان مقامات کے درمیان کوئی راستہ نہیں';

  @override
  String get prototypeCoversOneDemoArea =>
      'یہ پروٹوٹائپ بہاولپور کے ایک علاقے تک محدود ہے، اس لیے ہر جوڑا سڑک نیٹ ورک میں جڑا نہیں۔ کوئی اور منزل آزمائیں۔';

  @override
  String get sortRoutes => 'راستے ترتیب دیں';

  @override
  String get seededRoadNetworkOffersNo =>
      'اس سفر کے لیے نمونہ سڑک نیٹ ورک میں کوئی الگ متبادل نہیں، اس لیے صرف ایک ہی آپشن دکھایا جا رہا ہے۔';

  @override
  String get reportIssueRoute => 'اس راستے پر مسئلہ رپورٹ کریں';

  @override
  String get simulatedNoLocationPermissionRequested =>
      'نمائشی — کوئی لوکیشن اجازت نہیں مانگی جاتی';

  @override
  String get clear => 'صاف کریں';

  @override
  String get noSavedRecentPlacesYet => 'ابھی کوئی محفوظ یا حالیہ مقام نہیں';

  @override
  String get searchDestinationBelowPlacesPick =>
      'نیچے منزل تلاش کریں۔ جو مقامات آپ منتخب کریں گے وہ اگلی بار یہاں نظر آئیں گے۔';

  @override
  String get prototypeCoversOneDemoArea2 =>
      'یہ پروٹوٹائپ بہاولپور کے ایک علاقے تک محدود ہے، اس لیے مقامات کی فہرست محدود ہے۔ \"ماڈل ٹاؤن\"، \"یونیورسٹی\" یا \"بازار\" آزمائیں۔';

  @override
  String get nothingSavedYet => 'ابھی کچھ محفوظ نہیں';

  @override
  String get tapBookmarkAnyPlaceKeep =>
      'کسی بھی جگہ پر بک مارک دبائیں تاکہ وہ یہاں جلدی رسائی کے لیے رہے۔';

  @override
  String get backSearch => 'تلاش پر واپس';

  @override
  String get willNoLongerAppearSaved =>
      'یہ اب آپ کے محفوظ مقامات میں نہیں ہوگی۔ آپ جب چاہیں دوبارہ محفوظ کر سکتے ہیں۔';

  @override
  String get offlineMap => 'آف لائن نقشہ';

  @override
  String get manuallyCategorised => 'دستی درجہ بندی';

  @override
  String get howLevelCalculated => 'یہ درجہ کیسے نکالا گیا';

  @override
  String get textSpeechPreview => 'متن سے آواز';

  @override
  String get warningsStayShortSoThey =>
      'انتباہ مختصر رکھے جاتے ہیں تاکہ سفر کے دوران کام آ سکیں۔';

  @override
  String get continueLabel => 'جاری رکھیں';

  @override
  String get reportNotPublishedTitle => 'آپ کی رپورٹ شائع نہیں ہوئی';

  @override
  String get reportWithheldBody =>
      'اس میں کسی مخصوص شخص کی نشاندہی محسوس ہوئی۔ قابلِ شناخت افراد کے بارے میں رپورٹس کبھی شائع نہیں کی جاتیں۔';

  @override
  String get howStep1Title => 'کوئی رہائشی جو دیکھتا ہے وہ رپورٹ کرتا ہے';

  @override
  String get howStep1Body =>
      'انگریزی، اردو، رومن اردو یا پنجابی میں — \"آگے گلی بند ہے\"، \"روڈ پر پانی کھڑا ہے\"، \"سٹریٹ لائٹ بند ہے\"۔';

  @override
  String get howStep2Title => 'رپورٹ ایک منظم اطلاع بن جاتی ہے';

  @override
  String get howStep2Body =>
      'غیر رسمی متن کو ایک قسم، شدت اور غیر جانبدار عوامی خلاصے میں بدلا جاتا ہے۔ شائع ہونے سے پہلے آپ ہمیشہ اس کا جائزہ لیتے ہیں۔';

  @override
  String get howStep3Title => 'راستوں کا موازنہ اور وضاحت';

  @override
  String get howStep3Body =>
      'تازہ رپورٹس پرانی سے زیادہ اہم ہوتی ہیں۔ ہر راستہ سادہ الفاظ میں بتاتا ہے کہ وہ کیا بچاتا ہے اور کتنے منٹ لیتا ہے۔';

  @override
  String get howStep4Title => 'اگلے مسافر کو خبردار کیا جاتا ہے';

  @override
  String get howStep4Body =>
      'روانگی سے پہلے مختصر آواز میں انتباہ، اور ایک حفاظتی چیک اِن جو آپ کسی قابلِ اعتماد شخص کے ساتھ شیئر کر سکتے ہیں۔';
}

/// The translations for Urdu, using the Latin script (`ur_Latn`).
class LUrLatn extends LUr {
  LUrLatn() : super('ur_Latn');

  @override
  String get appName => 'Safar';

  @override
  String get tagline => 'Rasta lene se pehle jaan lein.';

  @override
  String get cityLine => 'Bahawalpur · Rasta lene se pehle jaan lein.';

  @override
  String get navPlan => 'Plan';

  @override
  String get navMap => 'Naqsha';

  @override
  String get navActivity => 'Sargarmi';

  @override
  String get navYou => 'Aap';

  @override
  String get reportAction => 'Road ki halat report karein';

  @override
  String get greetMorning => 'Subah bakhair';

  @override
  String get greetAfternoon => 'Dopehr bakhair';

  @override
  String get greetEvening => 'Shaam bakhair';

  @override
  String get greetNight => 'Aaj raat ka safar';

  @override
  String get greetLate => 'Der se safar';

  @override
  String get from => 'Kahan se';

  @override
  String get to => 'Kahan tak';

  @override
  String get chooseStart => 'Shuru ki jagah chunein';

  @override
  String get whereGoing => 'Aap kahan ja rahe hain?';

  @override
  String get compareRoutes => 'Raston ka moazna karein';

  @override
  String get swap => 'Badlein';

  @override
  String get aroundYouNow => 'Is waqt aap ke aas paas';

  @override
  String get liveSignals => 'Mojooda reports';

  @override
  String get inLastHour => 'Pichla ghanta';

  @override
  String get roadsBlocked => 'Band roads';

  @override
  String get openMap => 'Naqsha kholein';

  @override
  String get recentSignals => 'Haaliya community reports';

  @override
  String get happeningNow => 'Abhi ho raha hai';

  @override
  String get noLiveReports => 'Is waqt koi taza report nahi';

  @override
  String get noLiveReportsBody =>
      'Haal hi mein is ilaqe se koi report nahi mili. Iska matlab yeh nahi ke rasta saaf hai — bas hamare paas maloomat nahi hain.';

  @override
  String get beFirstToReport => 'Sab se pehle report karein';

  @override
  String get safetyCheckin => 'Mehfooz check-in';

  @override
  String get checkinRunning => 'Check-in chal raha hai';

  @override
  String get tellSomeone => 'Kisi ko batayein ke aap safar mein hain';

  @override
  String get browseMap => 'Naqsha dekhein';

  @override
  String get seeEverySignal => 'Qareeb ki tamam reports dekhein';

  @override
  String get disclaimer =>
      'Community reports adhoori ya ghair tasdeeq shuda ho sakti hain. Yeh app hifazat ya road ki dastyabi ki guarantee nahi deti.';

  @override
  String get beforeYouRely => 'Is par bharosa karne se pehle';

  @override
  String get notEmergency =>
      'Safar koi emergency service nahi hai. Emergency mein Rescue 1122 ya Police 15 se rabta karein.';

  @override
  String get demoData => 'Demo data';

  @override
  String get live => 'Connected';

  @override
  String get awarenessLow => 'Kam ehtiyaat darkar';

  @override
  String get awarenessModerate => 'Darmiyani ehtiyaat darkar';

  @override
  String get awarenessElevated => 'Zyada ehtiyaat darkar';

  @override
  String get awarenessLimited => 'Maloomat mehdood hain';

  @override
  String get confidenceHigh => 'Zyada bharosa';

  @override
  String get confidenceModerate => 'Darmiyana bharosa';

  @override
  String get confidenceLow => 'Kam bharosa';

  @override
  String get routeFastest => 'Sab se tez rasta';

  @override
  String get routeBetterLit => 'Zyada roshni wala rasta';

  @override
  String get routeFewerHazards => 'Kam rukawatein';

  @override
  String routesToCompare(int count) {
    return '$count raston ka moazna';
  }

  @override
  String get oneSensibleRoute => 'Aik hi munasib rasta';

  @override
  String get neverSafetyScore => 'Raste ki aagahi — safety score nahi.';

  @override
  String recentReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taza reports',
      one: '1 taza report',
      zero: 'Koi taza report nahi',
    );
    return '$_temp0';
  }

  @override
  String get suggested => 'Tajweez karda';

  @override
  String get seeWhatIsOnRoute => 'Dekhein is raste par kya hai';

  @override
  String get passesBlockage => 'Band raste se guzarta hai';

  @override
  String get whatReporting => 'Aap kis cheez ki report kar rahe hain?';

  @override
  String get whatExactly => 'Asal mein kya ho raha hai?';

  @override
  String get whereIsIt => 'Yeh kahan hai?';

  @override
  String get anythingToAdd => 'Kuch aur batana chahenge?';

  @override
  String get reviewMyReport => 'Meri report dekhein';

  @override
  String stepOf(int current, int total) {
    return 'Marhala $current az $total';
  }

  @override
  String get understoodAs => 'Hum ne ise yun samjha';

  @override
  String get confirmAndPublish => 'Tasdeeq kar ke shaya karein';

  @override
  String get changeCategory => 'Qisam badlein';

  @override
  String get cancel => 'Mansookh karein';

  @override
  String get reportLive => 'Aap ki report shaya ho gayi';

  @override
  String get reportNotPublished => 'Report shaya nahi hui';

  @override
  String get whatOthersSee => 'Doosre musafir kya dekhenge';

  @override
  String get whatYouWrote => 'Aap ne kya likha';

  @override
  String get cannotPublish => 'Yeh report shaya nahi ki ja sakti';

  @override
  String get catSafety => 'Mehfooz mahol ki report';

  @override
  String get catLighting => 'Roshni';

  @override
  String get catRoad => 'Road ki halat';

  @override
  String get catWater => 'Pani / seepage';

  @override
  String get catBlockage => 'Rasta band';

  @override
  String get catTraffic => 'Traffic ka masla';

  @override
  String get anonymousByDefault => 'Bataur-e-tai shuda gumnaam';

  @override
  String get privacyPromise =>
      'Reports bataur-e-tai shuda gumnaam hoti hain. Hum kabhi naam, chehre, phone number, gaari ki number plate ya zaati pate shaya nahi karte.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Zabaan';

  @override
  String get appLanguage => 'App ki zabaan';

  @override
  String get appearance => 'Zahiri shakal';

  @override
  String get themeLight => 'Roshan';

  @override
  String get themeDark => 'Tareek';

  @override
  String get themeSystem => 'Phone ke mutabiq';

  @override
  String get voiceWarnings => 'Awaz mein intibah';

  @override
  String get voiceWarningsSub =>
      'Rawana hone se pehle mukhtasar awaz mein ittila';

  @override
  String get mapSurface => 'Naqshe ki qisam';

  @override
  String get privacy => 'Raazdari';

  @override
  String get reportAnonymously => 'Gumnaam report karein';

  @override
  String get blurSensitive => 'Hassas maqamat dhundla karein';

  @override
  String get trustedContacts => 'Qabil-e-aitmaad raabte';

  @override
  String get savedPlaces => 'Mehfooz maqamat';

  @override
  String get myReports => 'Meri reports';

  @override
  String get about => 'Taaruf';

  @override
  String get signOut => 'Sign out';

  @override
  String get signIn => 'Sign in';

  @override
  String get continueAnonymously => 'Gumnaam jari rakhein';

  @override
  String get retry => 'Dobara koshish karein';

  @override
  String get back => 'Wapas';

  @override
  String get done => 'Mukammal';

  @override
  String get close => 'Band karein';

  @override
  String get save => 'Mehfooz karein';

  @override
  String get remove => 'Hatayein';

  @override
  String get confirm => 'Tasdeeq karein';

  @override
  String get search => 'Talash';

  @override
  String get searchHint => 'Jagah, ilaqa ya nishani talash karein';

  @override
  String noResults(String query) {
    return '\"$query\" se koi jagah nahi mili';
  }

  @override
  String get clearSearch => 'Talash saaf karein';

  @override
  String get useMyLocation => 'Mera mojooda maqam istemal karein';

  @override
  String get recent => 'Haaliya';

  @override
  String get popularInBwp => 'Bahawalpur mein mashhoor';

  @override
  String get iArrivedSafely => 'Main behifazat pohanch gaya';

  @override
  String get cancelCheckin => 'Check-in mansookh karein';

  @override
  String get remaining => 'baqi';

  @override
  String get overdueBy => 'takheer';

  @override
  String get startCheckin => 'Mehfooz check-in shuru karein';

  @override
  String get playWarning => 'Intibah sunein';

  @override
  String get stop => 'Rokein';

  @override
  String get voiceWarning => 'Awaz mein intibah';

  @override
  String get offlineBanner =>
      'Offline. Is phone par mehfooz aakhri reports dikhai ja rahi hain.';

  @override
  String get couldNotReachServer =>
      'Server tak rasai na ho saki. Demo reports dikhai ja rahi hain.';

  @override
  String get somethingWentWrong => 'Kuch ghalat ho gaya';

  @override
  String get markAllRead => 'Sab parha hua mark karein';

  @override
  String get alerts => 'Ittilaat';

  @override
  String get checkIns => 'Check-in';

  @override
  String get noAlertsYet => 'Abhi koi ittila nahi';

  @override
  String get willHearUsWhenNew =>
      'Jab aap ke istemal karda raste par nayi report aaye gi, koi aap ki report ki tasdeeq kare ga, ya kisi check-in par tawajjo darkar hogi to hum aap ko batayenge.';

  @override
  String get reportedAnythingYet => 'Aap ne abhi tak kuch report nahi kiya';

  @override
  String get firstTimeTellOtherTravellers =>
      'Jab aap pehli baar kisi band gali ya kharab streetlight ke baare mein doosre musafiron ko batayenge to woh yahan nazar aaye ga.';

  @override
  String get makeFirstReport => 'Apni pehli report darj karein';

  @override
  String get totalReports => 'Kul reports';

  @override
  String get liveNow => 'Abhi faal';

  @override
  String get confirmedOthers => 'Doosron ne tasdeeq ki';

  @override
  String get live2 => 'Faal';

  @override
  String get stillAffectingRouteAwareness =>
      'Ab bhi raste ki aagahi par asar andaz';

  @override
  String get expiredWithheld => 'Khatam shuda aur roki gayi';

  @override
  String get noLongerAffectingRoutes => 'Ab raston par asar andaz nahi';

  @override
  String get noCheckInsYet => 'Abhi koi check-in nahi';

  @override
  String get checkTimerShareSomeoneTrust =>
      'Check-in aik timer hai jo aap kisi qabil-e-aitmaad shakhs ke saath share karte hain. Agar aap pohanchne ki tasdeeq na karein to unhein maloom ho jata hai ke aap ko talash karna hai.';

  @override
  String get startCheck => 'Check-in shuru karein';

  @override
  String get runningNow => 'Abhi jari';

  @override
  String get open => 'Kholein';

  @override
  String get pastCheckIns => 'Pichle check-in';

  @override
  String get nameOptional => 'Naam (ikhtiyari)';

  @override
  String get shownOnly => 'Sirf aap ko nazar aaye ga';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get password => 'Password';

  @override
  String get continueWithoutAccount => 'Bina account ke jari rakhein';

  @override
  String get doNeedAccount => 'Aap ko account ki zaroorat nahi';

  @override
  String get reportingRoutesCheckInsAll =>
      'Reporting, raste aur check-in sab gumnaam tor par kaam karte hain. Aap ka number kabhi doosre musafiron ko nahi dikhaya jata aur na kisi shaya shuda report se jora jata hai.';

  @override
  String get cancelCheck => 'Check-in mansookh karein?';

  @override
  String get timerStopsContactsWillNotified =>
      'Timer ruk jaye ga aur aap ke raabton ko kisi soorat ittila nahi di jaye gi. Aap jab chahein naya shuru kar sakte hain.';

  @override
  String get keepRunning => 'Jari rakhein';

  @override
  String get noCheckRunning => 'Koi check-in jari nahi';

  @override
  String get checkAlreadyFinishedStartNew =>
      'Yeh check-in mukammal ho chuka hai. Agli baar rawana hote waqt home screen se naya shuru karein.';

  @override
  String get check => 'Check-in';

  @override
  String get emergencyNumbers => 'Hangami number';

  @override
  String get checkWindowPassed => 'Aap ke check-in ka waqt guzar chuka hai';

  @override
  String get fullProductContactsWouldBeen =>
      'Mukammal product mein ab tak aap ke raabton ko yaad dahani mil chuki hoti. Unhein batayein ke aap mehfooz hain, ya agar abhi raste mein hain to timer barha dein.';

  @override
  String get notifyingContactsSimulatedUiBuild =>
      'Is build mein raabton ko ittila dena sirf numaishi hai — koi paigham waqai nahi bheja jata.';

  @override
  String get destination => 'Manzil';

  @override
  String get route => 'Rasta';

  @override
  String get started => 'Shuru hua';

  @override
  String get due => 'Muqarrara waqt';

  @override
  String get livePosition => 'Mojooda maqam';

  @override
  String get startedCheckWithoutContactSo =>
      'Aap ne yeh check-in bina kisi raabte ke shuru kiya, is liye timer sirf aap ke liye hai. Kisi ko shamil karne se yeh kahin zyada mufeed ho jata hai.';

  @override
  String get needMoreMinutes => 'Mazeed 10 minute chahiyen';

  @override
  String get checkAlreadyRunning => 'Aik check-in pehle se jari hai';

  @override
  String get onlyOneCheckTimeOpen =>
      'Aik waqt mein sirf aik check-in ho sakta hai. Jari wala kholein, ya pehle ise mansookh karein.';

  @override
  String get open2 => 'Ise kholein';

  @override
  String get stayHere => 'Yahin rahein';

  @override
  String get startWithoutContact => 'Bina raabte ke shuru karein?';

  @override
  String get nobodyWillToldIfDo =>
      'Agar aap check-in na karein to kisi ko ittila nahi mile gi. Timer phir bhi yaad dilaye ga, lekin check-in tab behtar kaam karta hai jab kisi ko ilm ho.';

  @override
  String get startAnyway => 'Phir bhi shuru karein';

  @override
  String get chooseContact => 'Raabta muntakhib karein';

  @override
  String get setTimerIfDoConfirm =>
      'Timer lagayein. Agar aap pohanchne ki tasdeeq na karein to aap ke qabil-e-aitmaad raabton ko yaad dahani bheji jati hai.';

  @override
  String get howLongDoExpectTake => 'Aap ko kitna waqt lage ga?';

  @override
  String get whoShouldNotified => 'Kis ko ittila di jaye?';

  @override
  String get manage => 'Intezam';

  @override
  String get noTrustedContactsYet => 'Abhi koi qabil-e-aitmaad raabta nahi';

  @override
  String get addSomeoneWouldWantKnow =>
      'Kisi aise shakhs ko shamil karein jise aap batana chahenge agar aap na pohanchein.';

  @override
  String get addContact => 'Raabta shamil karein';

  @override
  String get shareMyLivePosition => 'Mera mojooda maqam share karein';

  @override
  String get simulatedBuildNoLocationPermission =>
      'Is build mein numaishi — koi location ijazat istemal nahi hoti';

  @override
  String get primary => 'Bunyadi';

  @override
  String get addTrustedContact => 'Qabil-e-aitmaad raabta shamil karein';

  @override
  String get someoneWhoWouldNoticeIf =>
      'Koi aisa shakhs jo mehsoos kare agar aap na pohanchein. Sirf isi phone par mehfooz hota hai.';

  @override
  String get name => 'Naam';

  @override
  String get relationship => 'Rishta';

  @override
  String get familyRoommateColleague => 'Khandan, roommate, saathi…';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get addContact2 => 'Raabta shamil karein';

  @override
  String get noTrustedContacts => 'Koi qabil-e-aitmaad raabta nahi';

  @override
  String get addSomeoneWouldWantTold =>
      'Kisi aise shakhs ko shamil karein jise bataya jaye agar aap na pohanchein. Un ka number isi phone par rehta hai.';

  @override
  String get addFirstContact => 'Apna pehla raabta shamil karein';

  @override
  String get contactsStoredDeviceOnlySafar =>
      'Raabte sirf isi phone par mehfooz hote hain. Safar aap ki raabta fehrist upload nahi karta.';

  @override
  String get theyWillNoLongerOffered =>
      'Check-in shuru karte waqt ab yeh pesh nahi kiye jayenge.';

  @override
  String get makePrimary => 'Bunyadi banayein';

  @override
  String get recentre => 'Dobara markaz mein layein';

  @override
  String get tapPinMapScrollList =>
      'Naqshe par kisi pin ko dabayein, ya fehrist dekhein.';

  @override
  String get nothingMatchesTheseFilters => 'In filters se kuch nahi mila';

  @override
  String get noLiveReportsCategoriesSelected =>
      'Muntakhib karda aqsam mein koi taza report nahi. Sab kuch dekhne ke liye filter hata dein.';

  @override
  String get clearFilters => 'Filter hatayein';

  @override
  String get noSignalsAreaYet => 'Is ilaqe mein abhi koi ittila nahi';

  @override
  String get limitedDataSameClearRoad =>
      'Maloomat kam hona saaf raste ke barabar nahi. Agar aap kuch dekhein to sab se pehle report kar sakte hain.';

  @override
  String get addReport => 'Report shamil karein';

  @override
  String get howRouteAwarenessCalculated =>
      'Raste ki aagahi kaise nikali jati hai';

  @override
  String get simulatedPositionPrototype => 'Is prototype ke liye farzi maqam';

  @override
  String get bahawalpur => 'Bahawalpur';

  @override
  String get afterDarkLightingReportsCount =>
      'Andhere ke baad roshni ki reports zyada ahem hoti hain';

  @override
  String get night => 'Raat';

  @override
  String get demoControls => 'Demo control';

  @override
  String get couldLoadSignals => 'Ittilaat load nahi ho sakin';

  @override
  String get nothingBeenReportedDemoArea =>
      'Haal hi mein is ilaqe se koi ittila nahi mili. Is ka matlab yeh nahi ke sab theek hai — bas hamare paas maloomat nahi hain.';

  @override
  String get uiPrototypeV => 'v1.0.0';

  @override
  String get whatSafar => 'Safar kya nahi hai';

  @override
  String get privacyAbusePrevention =>
      'Raazdari aur ghalat istemal ki rok tham';

  @override
  String get aboutDataBuild => 'Is build ke data ke baare mein';

  @override
  String get routesPlannedOverHandBuilt =>
      'Raste Bahawalpur ke aik ilaqe ke liye haath se banaye gaye road network par banaye jate hain. Coordinates takhmini hain aur survey data nahi. Report ke matan ki darja bandi maqami tor par hoti hai.';

  @override
  String get builtBahawalpur => 'Bahawalpur ke liye banaya gaya.';

  @override
  String get presentingUsers => 'Peshkash ke liye, users ke liye nahi';

  @override
  String get theseSwitchesExistSoEvery =>
      'Yeh switch is liye hain ke prototype ki har haalat mangne par dikhai ja sake. Production build mein yeh screen shamil nahi hogi.';

  @override
  String get userPersona => 'User ki qisam';

  @override
  String get communitySignalData => 'Community ittilaat ka data';

  @override
  String get reloadSeededSignals => 'Numoona ittilaat dobara load karein';

  @override
  String get emptyMap => 'Naqsha khali karein';

  @override
  String get showsEveryNoDataEmpty =>
      'Har \"koi data nahi\" aur khali haalat dikhata hai';

  @override
  String get forceLoadFailure => 'Load nakami paida karein';

  @override
  String get showsErrorStateRetry =>
      'Dobara koshish ke saath error haalat dikhata hai';

  @override
  String get showExpiredReports => 'Khatam shuda reports dikhayein';

  @override
  String get greyedOutNoEffectRouting => 'Dhundli, raston par koi asar nahi';

  @override
  String get backend => 'Backend';

  @override
  String get sendTestNotification => 'Aazmaishi ittila bhejein';

  @override
  String get pushesEverySubscribedDevice =>
      'Har subscribe shuda device ko bhejta hai';

  @override
  String get failurePaths => 'Nakami ke raste';

  @override
  String get breakReportClassifier => 'Report darja bandi kharab karein';

  @override
  String get nextReportFallsBackManual =>
      'Agli report dasti qisam ke intikhab par chali jaye gi';

  @override
  String get simulateOffline => 'Offline haalat banayein';

  @override
  String get offlineBannerPlusCachedData =>
      'Offline banner aur mehfooz data ka rasta';

  @override
  String get otherStates => 'Deegar haalatein';

  @override
  String get clearTrustedContacts => 'Qabil-e-aitmaad raabte hatayein';

  @override
  String get clearAllAlerts => 'Tamam ittilaat hatayein';

  @override
  String get showsEmptyActivityTab => 'Khali sargarmi tab dikhata hai';

  @override
  String get resetCurrentTrip => 'Mojooda safar reset karein';

  @override
  String get clearsOriginDestinationPlannedRoutes =>
      'Aaghaz, manzil aur banaye gaye raste hata deta hai';

  @override
  String get twoMinuteDemo => 'Do minute ka demo';

  @override
  String get reportingSomethingSafarDoesAlert =>
      'Safar mein kuch report karne se hukaam ko ittila nahi jati. Agar koi khatre mein hai to barah-e-raast hangami service ko call karein.';

  @override
  String get howWorks => 'Yeh kaise kaam karta hai';

  @override
  String get routeAwarenessSafetyScore => 'Raste ki aagahi, safety score nahi';

  @override
  String get fourLevels => 'Chaar darje';

  @override
  String get whatGoesIntoNumber => 'Is adad mein kya shamil hota hai';

  @override
  String get eachRoadSegmentGetsScore =>
      'Har road ke hisse ko paanch wazan daar awamil se score milta hai. Rasta apne hisson ki lambai ke hisab se ausat hai.';

  @override
  String get theseWeightsPrototypeValuesChosen =>
      'Yeh wazan aik munasib demo ke liye chune gaye prototype aadad hain. In ki asal waqiati data se tasdeeq nahi ki gayi.';

  @override
  String get newerReportsCountMore => 'Nayi reports zyada ahem hoti hain';

  @override
  String get everyReportLosesInfluenceAges =>
      'Har report waqt ke saath asar khoti hai, aur yeh raftar masle ki qisam par munhasir hai. Haadsa chand ghanton mein ghair ahem ho jata hai; kharab streetlight kai din ahem rehti hai.';

  @override
  String get howReportsEarnTrust => 'Reports bharosa kaise hasil karti hain';

  @override
  String get whatEachReportDoesRouting =>
      'Har report raste par kya asar daalti hai';

  @override
  String get honestCaveat => 'Aik imaandarana wazahat';

  @override
  String get skip => 'Chhorein';

  @override
  String get normalMapTellsNtheFastest =>
      'Aam naqsha aap ko\nsab se tez rasta batata hai.';

  @override
  String get safarTellsWhatExpectWay =>
      'Safar aap ko batata hai ke raste mein kya mile ga.';

  @override
  String get residentReportsWhatTheySee =>
      'Koi rehaishi jo dekhta hai woh report karta hai';

  @override
  String get reportBecomesStructuredSignal =>
      'Report aik munazzam ittila ban jati hai';

  @override
  String get routesComparedExplained => 'Raston ka moazna aur wazahat';

  @override
  String get nextTravellerWarned => 'Agle musafir ko khabardar kiya jata hai';

  @override
  String get oneReportOnePersonHelps =>
      'Aik shakhs ki aik report har us musafir ke kaam aati hai jo agla us sarak se guzre.';

  @override
  String get whatAppWillDo => 'Yeh app kya nahi kare gi';

  @override
  String get worthReadingBeforeRely =>
      'Is par bharosa karne se pehle parhne ke qabil.';

  @override
  String get itIsNot => 'Yeh nahi hai';

  @override
  String get pickLanguage => 'Apni zabaan muntakhib karein';

  @override
  String get setsVoiceWarningsWordingReport =>
      'Is se awaz ke intibah aur report ke alfaz tay hote hain. Aap hamesha usi zabaan mein report kar sakte hain jo aap waqai bolte hain.';

  @override
  String get loadingCommunitySignalsBahawalpur =>
      'Bahawalpur ke liye community ittilaat load ho rahi hain';

  @override
  String get reportsStillPublishedAnonymouslyOther =>
      'Aap ki reports ab bhi gumnaam shaya hoti hain. Doosre musafir kabhi aap ka naam ya number nahi dekhte — account sirf phone badalne par aap ki tareekh mehfooz rakhta hai.';

  @override
  String get anonymous => 'Aap gumnaam hain';

  @override
  String get everythingWorksWithoutAccountAdding =>
      'Sab kuch bina account ke kaam karta hai. Account banane se phone badalne par aap ki reports aur mehfooz maqamat baqi rehte hain.';

  @override
  String get createAccount => 'Account banayein';

  @override
  String get reportsMade => 'Ki gayi reports';

  @override
  String get signalsConfirmed => 'Tasdeeq shuda ittilaat';

  @override
  String get tripsCompared => 'Moazna kiye gaye safar';

  @override
  String get stuff => 'Aap ki cheezein';

  @override
  String get preferences => 'Tarjeehat';

  @override
  String get shortSpokenAlertsBeforeSet =>
      'Rawangi se pehle mukhtasar awaz mein ittila';

  @override
  String get allSettings => 'Tamam settings';

  @override
  String get howRouteAwarenessWorks => 'Raste ki aagahi kaise kaam karti hai';

  @override
  String get aboutSafar => 'Safar ke baare mein';

  @override
  String get returnAnonymousUsePhone =>
      'Is phone par gumnaam istemal par wapas jayein';

  @override
  String get signOut2 => 'Sign out karein?';

  @override
  String get willKeepUsingSafarAnonymously =>
      'Aap Safar gumnaam tor par istemal karte rahenge. Aap ki reports aap ke account par rahengi aur sign in karne par wapas aa jayengi.';

  @override
  String get bringReportsAnotherPhone => 'Doosre phone se reports layein';

  @override
  String get setsVoiceWarningsPromptWording =>
      'Awaz ke intibah aur alfaz tay karta hai.';

  @override
  String get tiersRecogniseContributionTheyNever =>
      'Darje shirkat ko tasleem karte hain. Yeh kabhi kisi report ko tasdeeq shuda nahi banate — yeh sirf doosre musafiron ki tasdeeq se hota hai.';

  @override
  String get labelPlace => 'Is jagah ko naam dein';

  @override
  String get shortNameLikeHomeWork =>
      'Mukhtasar naam jaise \"Ghar\", \"Daftar\" ya \"Ammi ka ghar\".';

  @override
  String get labelOptional => 'Naam (ikhtiyari)';

  @override
  String get noSavedPlaces => 'Koi mehfooz maqam nahi';

  @override
  String get tapBookmarkNextAnyPlace =>
      'Talash ke doran kisi jagah ke saath bookmark dabayein, woh yahan aik tap mein rasta banane ke liye aa jaye gi.';

  @override
  String get willNoLongerAppear =>
      'Yeh ab aap ke mehfooz maqamat mein nazar nahi aaye gi.';

  @override
  String get changeLabel => 'Naam badlein';

  @override
  String get routeHere => 'Yahan ka rasta';

  @override
  String get languageVoice => 'Zabaan aur awaz';

  @override
  String get warningsPromptsSummaries => 'Intibah, sawalat aur khulase';

  @override
  String get reportsNeverCarryName => 'Aap ki reports par kabhi naam nahi hota';

  @override
  String get roundSafetyConcernReportsRoughly =>
      'Mehfooz mahol ki reports ko taqreeban 250 m ke ilaqe tak mehdood karein';

  @override
  String get mapData => 'Naqsha aur data';

  @override
  String get greyedOutTheyDoAffect =>
      'Dhundli, aur yeh raston par asar nahi daaltin';

  @override
  String get reloadCommunitySignals => 'Community ittilaat dobara load karein';

  @override
  String get fetchSeededDemonstrationDataAgain =>
      'Numoona data dobara hasil karein';

  @override
  String get prototypeControls => 'Prototype control';

  @override
  String get demoControlPanel => 'Demo control panel';

  @override
  String get switchPersonasForceErrorsEmpty =>
      'User ki qisam badlein, error paida karein, data khali karein — demo ke liye';

  @override
  String get showsOfflineBannerCachedData =>
      'Offline banner aur mehfooz data ka rasta dikhata hai';

  @override
  String get aboutLimitations => 'Taaruf aur hudood';

  @override
  String get clearLocalData => 'Maqami data saaf karein';

  @override
  String get resetsSavedPlacesContactsAlerts =>
      'Mehfooz maqamat, raabte aur ittilaat reset karta hai';

  @override
  String get clearLocalData2 => 'Maqami data saaf karein?';

  @override
  String get savedPlacesTrustedContactsAlerts =>
      'Is phone par mehfooz maqamat, qabil-e-aitmaad raabte aur ittilaat hata di jayengi. Numoona ittilaat baqi rahengi taake demo chalta rahe.';

  @override
  String get clearData => 'Data saaf karein';

  @override
  String get confirmReport => 'Is report ki tasdeeq karein?';

  @override
  String get onlyConfirmIfSeenYourself =>
      'Sirf tab tasdeeq karein jab aap ne khud dekha ho. Tasdeeqein hi kisi ittila ko ghair tasdeeq shuda se tasdeeq shuda banati hain.';

  @override
  String get yesISaw => 'Haan, main ne yeh dekha';

  @override
  String get disputeReport => 'Is report se ikhtilaf karein?';

  @override
  String get useWhenConditionNoLonger =>
      'Yeh tab istemal karein jab woh soorat-e-haal ab nahi hai, ya kabhi thi hi nahi. Do ikhtilaf report ko sab ke liye mutanaza kar dete hain.';

  @override
  String get dispute => 'Ikhtilaf karein';

  @override
  String get withdrawReport => 'Apni report wapas lein?';

  @override
  String get willStopAffectingRoutesImmediately =>
      'Yeh foran raston par asar daalna band kar de gi aur doosre musafiron ko nazar nahi aaye gi.';

  @override
  String get withdraw => 'Wapas lein';

  @override
  String get report => 'Report';

  @override
  String get reportNoLongerAvailable => 'Yeh report ab dastyab nahi';

  @override
  String get mayExpiredBeenWithdrawnWhoever =>
      'Shayad yeh khatam ho gayi ho ya bhejne wale ne wapas le li ho.';

  @override
  String get goBack => 'Wapas jayein';

  @override
  String get approximateLocation => 'Takhmini maqam';

  @override
  String get report2 => 'Aap ki report';

  @override
  String get published => 'Shaya nahi hui';

  @override
  String get reportWithheldBecauseAppeared =>
      'Yeh report is liye roki gayi ke is mein kisi makhsoos shakhs ki nishandahi mehsoos hui. Is ne kabhi raston par asar nahi daala aur koi doosra musafir ise nahi dekh sakta.';

  @override
  String get whatTravellersSee => 'Musafir kya dekhte hain';

  @override
  String get visibleOnly => 'Sirf aap ko nazar aata hai.';

  @override
  String get severity => 'Shiddat';

  @override
  String get confirmations => 'Tasdeeqein';

  @override
  String get disputes => 'Ikhtilafat';

  @override
  String get routeEffect => 'Raste par asar';

  @override
  String get expiry => 'Muddat';

  @override
  String get reported => 'Report ki zabaan';

  @override
  String get categorised => 'Darja bandi';

  @override
  String get reported2 => 'Report karne wala';

  @override
  String get onlyLiveReportStretchSo =>
      'Is hisse par yehi wahid taza report hai, is liye yeh ittila aik shakhs par munhasir hai. Doosre musafiron ki tasdeeq ise zyada qabil-e-bharosa banati hai.';

  @override
  String get expiredReportsNoLongerAffect =>
      'Khatam shuda reports ab raston par asar nahi daaltin.';

  @override
  String get withdrawReport2 => 'Yeh report wapas lein';

  @override
  String get discardReport => 'Yeh report zaya karein?';

  @override
  String get whatEnteredSoFarWill =>
      'Aap ne ab tak jo likha hai woh mehfooz nahi hoga, aur kuch shaya nahi kiya jaye ga.';

  @override
  String get discard => 'Zaya karein';

  @override
  String get keepEditing => 'Likhte rahein';

  @override
  String get hitHourlyLimit => 'Aap ghanta waar hadd tak pohanch gaye hain';

  @override
  String get rateLimitsExistSoOne =>
      'Hadd is liye hai ke aik shakhs kisi ilaqe ko reports se bhar na de. Aap ki pichli reports ab bhi faal hain.';

  @override
  String get understood => 'Samajh gaya';

  @override
  String get pickClosestCategoryCorrectLater =>
      'Qareeb tareen qisam muntakhib karein. Agar app aap ki tafseel ko mukhtalif samjhe to aap baad mein durust kar sakte hain.';

  @override
  String get pickCategoryFirst => 'Pehle aik qisam muntakhib karein';

  @override
  String get goBackStepChooseWhat =>
      'Aik qadam peeche ja kar muntakhib karein ke aap kis qisam ki cheez report kar rahe hain.';

  @override
  String get chooseCategory => 'Qisam muntakhib karein';

  @override
  String get change => 'Badlein';

  @override
  String get phraseUnderneathEachOptionHow =>
      'Har intikhab ke neeche likha jumla wohi hai jo log aam tor par kehte hain.';

  @override
  String get tapPlacePin => 'Pin rakhne ke liye dabayein';

  @override
  String get roundedAboutM => 'Taqreeban 250 m tak mehdood';

  @override
  String get reportWillApplyRoadSegment =>
      'Yeh report is road ke hisse par lagu hogi';

  @override
  String get safetyConcernReportsAlwaysRounded =>
      'Mehfooz mahol ki reports shaya hone se pehle hamesha takhmini ilaqe tak mehdood ki jati hain, taake koi report kisi aik darwaze ki nishandahi na kare.';

  @override
  String get sensitiveCategory => 'Hassas qisam';

  @override
  String get optionalWriteEnglishUrduRoman =>
      'Ikhtiyari. Angrezi, Urdu ya Roman Urdu mein likhein — jo bhi aasan ho. App ise parh kar aik qisam tajweez karti hai, jis ki aap tasdeeq karte hain.';

  @override
  String get eGAagayGaliBand => 'Misaal: \"Aagay gali band hai\"';

  @override
  String get tapExampleUse => 'Istemal ke liye kisi misaal ko dabayein';

  @override
  String get doIncludeNamesPhoneNumbers =>
      'Naam, phone number, gaari ki number plate ya zaati pate shamil na karein. Jo reports kisi shakhs ki nishandahi karein woh kabhi shaya nahi hotin.';

  @override
  String get whatWrite => 'Kya nahi likhna';

  @override
  String get chooseRightCategory => 'Durust qisam muntakhib karein';

  @override
  String get correctionWhatGetsPublishedCorrections =>
      'Aap ki durusti hi shaya hoti hai. Durustiyan humein yeh bhi batati hain ke darja bandi kahan kamzor hai.';

  @override
  String get reportPublished => 'Aap ki report shaya nahi hui';

  @override
  String get cancelReport => 'Yeh report mansookh karein?';

  @override
  String get nothingWillPublishedTextWill =>
      'Kuch shaya nahi hoga aur aap ka matan mehfooz nahi kiya jaye ga.';

  @override
  String get cancelReport2 => 'Report mansookh karein';

  @override
  String get keep => 'Rehne dein';

  @override
  String get reviewBeforePublishing => 'Shaya karne se pehle jaiza';

  @override
  String get automaticReadingUnavailable => 'Khudkar parhai dastyab nahi';

  @override
  String get tryReadingAgain => 'Dobara parhne ki koshish karein';

  @override
  String get enoughDetailPublish => 'Shaya karne ke liye tafseel kam hai';

  @override
  String get couldTellWhatReportAbout =>
      'Hum samajh nahi sake ke yeh report kis baare mein hai. Chand alfaz mazeed likhein, ya khud qisam muntakhib karein.';

  @override
  String get chooseCategoryMyself => 'Main khud qisam muntakhib karunga';

  @override
  String get sureRightPleaseCheckCategory =>
      'Humein yaqeen nahi ke yeh durust hai. Shaya karne se pehle qisam dekh lein.';

  @override
  String get someoneMayReportedAlready =>
      'Shayad koi pehle hi yeh report kar chuka hai';

  @override
  String get verySimilarReportSubmittedNearby =>
      'Pichle 45 minute mein qareeb hi aisi hi report aayi hai. Aap ki report tasdeeq shumar hogi, jis se ittila mazboot ho jati hai.';

  @override
  String get corrected => 'Aap ne ise durust kiya';

  @override
  String get unverifiedUntilConfirmed => 'Tasdeeq tak ghair tasdeeq shuda';

  @override
  String get effectRouting => 'Raste par asar';

  @override
  String get onlySeeOriginalWordingOthers =>
      'Aap ke asal alfaz sirf aap dekh sakte hain. Doosron ko ooper wala ghair janibdar khulasa nazar aata hai.';

  @override
  String get nothingAboutIdentifiablePersonWill =>
      'Kisi qabil-e-shanakht shakhs ke baare mein kuch shaya nahi kiya jaye ga.';

  @override
  String get iUnderstandGoBack => 'Samajh gaya — wapas jayein';

  @override
  String get editMyDescription => 'Apni tafseel mein tarmeem karein';

  @override
  String get readingReport => 'Aap ki report parhi ja rahi hai…';

  @override
  String get stillReportConditionItselfExample =>
      'Aap phir bhi soorat-e-haal khud report kar sakte hain — misaal ke tor par \"yeh gali raat ko ghair mehfooz lagti hai\" — kisi shakhs ka zikr kiye baghair.';

  @override
  String get structuredOutput => 'Munazzam nateeja';

  @override
  String get whatHappensNext => 'Is ke baad kya hota hai';

  @override
  String get otherTravellersConfirm =>
      'Doosre musafir is ki tasdeeq kar sakte hain';

  @override
  String get fadesOverTime => 'Yeh waqt ke saath maand par jati hai';

  @override
  String get stayControl => 'Ikhtiyar aap ke paas rehta hai';

  @override
  String get routesUpdated => 'Raste update ho gaye';

  @override
  String get reportAlreadyPartHowThese =>
      'Aap ki report pehle hi in raston ke hisab ka hissa hai.';

  @override
  String get shareSignal => 'Yeh ittila share karein';

  @override
  String get playVoiceWarning => 'Awaz mein intibah sunein';

  @override
  String get estimatedTime => 'Mutawaqqa waqt';

  @override
  String get distance => 'Fasla';

  @override
  String get liveReports => 'Taza reports';

  @override
  String get route2 => 'Is raste par';

  @override
  String get limitedDataRoute => 'Is raste par maloomat kam hain';

  @override
  String get nobodyReportedAnythingHereRecently =>
      'Haal hi mein yahan kisi ne kuch report nahi kiya. Yeh kisi taraf ka wazeh ishara nahi — bas humein maloom nahi.';

  @override
  String get reportWhatSee => 'Jo dekhein woh report karein';

  @override
  String get stepStep => 'Qadam ba qadam';

  @override
  String get roadsRoute => 'Is raste ki saraken';

  @override
  String get whyAwarenessLevel => 'Yeh darja kyun?';

  @override
  String get checkNotificationsSimulatedUiBuild =>
      'Is build mein check-in ittilaat sirf numaishi hain.';

  @override
  String get reportNearbyIssue => 'Qareebi masla report karein';

  @override
  String get baselineLighting => 'Bunyadi roshni';

  @override
  String get howBusy => 'Kitna masroof';

  @override
  String get reportedDelay => 'Batai gayi takheer';

  @override
  String get noCommunityReportsStretchLevel =>
      'Is hisse par koi community report nahi. Ooper wala darja is ki bunyadi roshni aur aam masroofiyat se aata hai.';

  @override
  String get communitySignal => 'Community ittila';

  @override
  String get tapThroughFullReportIts =>
      'Mukammal report aur is ke raste par asar ke liye dabayein.';

  @override
  String get reportNoLongerAvailable2 => 'Yeh report ab dastyab nahi.';

  @override
  String get openReport => 'Report kholein';

  @override
  String get reverseTrip => 'Safar ulta karein';

  @override
  String get recentreMap => 'Naqsha dobara markaz mein layein';

  @override
  String get comparingRoutes => 'Raston ka moazna ho raha hai…';

  @override
  String get scoringEachRoadSegmentAgainst =>
      'Har road ke hisse ko taza community reports ke muqabil parkha ja raha hai.';

  @override
  String get changeDestination => 'Manzil badlein';

  @override
  String get thesePlacesTooCloseTogether =>
      'Yeh maqamat aik doosre ke bohat qareeb hain';

  @override
  String get startDestinationSitSameJunction =>
      'Aap ka aaghaz aur manzil sarak ke aik hi chowk par hain, is liye moazne ke liye kuch nahi. Koi door ki manzil muntakhib karein.';

  @override
  String get noRouteBetweenThesePoints =>
      'In maqamat ke darmiyan koi rasta nahi';

  @override
  String get prototypeCoversOneDemoArea =>
      'Yeh prototype Bahawalpur ke aik ilaqe tak mehdood hai, is liye har jora road network mein jura nahi. Koi aur manzil aazmayein.';

  @override
  String get sortRoutes => 'Raste tarteeb dein';

  @override
  String get seededRoadNetworkOffersNo =>
      'Is safar ke liye numoona road network mein koi alag mutabadil nahi, is liye sirf aik hi option dikhaya ja raha hai.';

  @override
  String get reportIssueRoute => 'Is raste par masla report karein';

  @override
  String get simulatedNoLocationPermissionRequested =>
      'Numaishi — koi location ijazat nahi mangi jati';

  @override
  String get clear => 'Saaf karein';

  @override
  String get noSavedRecentPlacesYet => 'Abhi koi mehfooz ya haaliya maqam nahi';

  @override
  String get searchDestinationBelowPlacesPick =>
      'Neeche manzil talash karein. Jo maqamat aap muntakhib karenge woh agli baar yahan nazar aayenge.';

  @override
  String get prototypeCoversOneDemoArea2 =>
      'Yeh prototype Bahawalpur ke aik ilaqe tak mehdood hai, is liye maqamat ki fehrist mehdood hai. \"Model Town\", \"university\" ya \"bazaar\" aazmayein.';

  @override
  String get nothingSavedYet => 'Abhi kuch mehfooz nahi';

  @override
  String get tapBookmarkAnyPlaceKeep =>
      'Kisi bhi jagah par bookmark dabayein taake woh yahan jaldi rasai ke liye rahe.';

  @override
  String get backSearch => 'Talash par wapas';

  @override
  String get willNoLongerAppearSaved =>
      'Yeh ab aap ke mehfooz maqamat mein nahi hogi. Aap jab chahein dobara mehfooz kar sakte hain.';

  @override
  String get offlineMap => 'Offline naqsha';

  @override
  String get manuallyCategorised => 'Dasti darja bandi';

  @override
  String get howLevelCalculated => 'Yeh darja kaise nikala gaya';

  @override
  String get textSpeechPreview => 'Matan se awaz';

  @override
  String get warningsStayShortSoThey =>
      'Intibah mukhtasar rakhe jate hain taake safar ke doran kaam aa sakein.';

  @override
  String get continueLabel => 'Jari rakhein';

  @override
  String get reportNotPublishedTitle => 'Aap ki report shaya nahi hui';

  @override
  String get reportWithheldBody =>
      'Is mein kisi makhsoos shakhs ki nishandahi mehsoos hui. Qabil-e-shanakht afrad ke baare mein reports kabhi shaya nahi ki jatin.';

  @override
  String get howStep1Title => 'Koi rehaishi jo dekhta hai woh report karta hai';

  @override
  String get howStep1Body =>
      'Angrezi, Urdu, Roman Urdu ya Punjabi mein — \"aagay gali band hai\", \"road par pani khara hai\", \"streetlight band hai\".';

  @override
  String get howStep2Title => 'Report aik munazzam ittila ban jati hai';

  @override
  String get howStep2Body =>
      'Ghair rasmi matan ko aik qisam, shiddat aur ghair janibdar awami khulase mein badla jata hai. Shaya hone se pehle aap hamesha is ka jaiza lete hain.';

  @override
  String get howStep3Title => 'Raston ka moazna aur wazahat';

  @override
  String get howStep3Body =>
      'Taza reports purani se zyada ahem hoti hain. Har rasta sada alfaz mein batata hai ke woh kya bachata hai aur kitne minute leta hai.';

  @override
  String get howStep4Title => 'Agle musafir ko khabardar kiya jata hai';

  @override
  String get howStep4Body =>
      'Rawangi se pehle mukhtasar awaz mein intibah, aur aik mehfooz check-in jo aap kisi qabil-e-aitmaad shakhs ke saath share kar sakte hain.';
}
