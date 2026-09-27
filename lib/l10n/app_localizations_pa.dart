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
}
