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
  String get live => 'براہِ راست';

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
  String get live => 'Live';

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
}
