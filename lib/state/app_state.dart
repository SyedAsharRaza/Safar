import 'package:flutter/material.dart';

import '../models/taxonomy.dart';
import '../models/user_profile.dart';
import '../data/mock/mock_misc.dart';
import '../widgets/map/safar_map.dart';

/// Which "demo persona" the app is in. Lets a presenter show the first-run
/// experience and the returning-user experience without reinstalling.
enum DemoPersona {
  firstTime('First-time user', 'Empty saved places, no history'),
  returning('Returning user', 'Saved places, past reports, stats');

  const DemoPersona(this.label, this.detail);
  final String label;
  final String detail;
}

/// App-wide preferences and the demo switches that drive the edge-case states.
class AppState extends ChangeNotifier {
  AppState();

  ThemeMode _themeMode = ThemeMode.system;
  ReportLanguage _language = ReportLanguage.english;
  bool _voiceWarnings = true;
  bool _anonymousByDefault = true;
  bool _approximateSensitive = true;
  bool _showExpiredReports = false;
  bool _offline = false;
  bool _onboarded = false;
  bool _signedIn = false;
  DemoPersona _persona = DemoPersona.returning;
  MapMode _mapMode = MapMode.auto;
  UserProfile _profile = MockUser.profile();

  /// Forces the next AI classification to fail, for demoing the fallback.
  bool _simulateAiFailure = false;

  ThemeMode get themeMode => _themeMode;
  ReportLanguage get language => _language;
  bool get voiceWarnings => _voiceWarnings;
  bool get anonymousByDefault => _anonymousByDefault;
  bool get approximateSensitive => _approximateSensitive;
  bool get showExpiredReports => _showExpiredReports;
  bool get offline => _offline;
  bool get onboarded => _onboarded;
  bool get signedIn => _signedIn;
  DemoPersona get persona => _persona;
  MapMode get mapMode => _mapMode;
  UserProfile get profile => _profile;
  bool get simulateAiFailure => _simulateAiFailure;

  bool get isFirstTime => _persona == DemoPersona.firstTime;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLanguage(ReportLanguage l) {
    _language = l;
    notifyListeners();
  }

  void toggleVoiceWarnings(bool v) {
    _voiceWarnings = v;
    notifyListeners();
  }

  void toggleAnonymous(bool v) {
    _anonymousByDefault = v;
    notifyListeners();
  }

  void toggleApproximateSensitive(bool v) {
    _approximateSensitive = v;
    notifyListeners();
  }

  void toggleShowExpired(bool v) {
    _showExpiredReports = v;
    notifyListeners();
  }

  void setMapMode(MapMode m) {
    _mapMode = m;
    notifyListeners();
  }

  void setOffline(bool v) {
    _offline = v;
    notifyListeners();
  }

  void setSimulateAiFailure(bool v) {
    _simulateAiFailure = v;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboarded = true;
    notifyListeners();
  }

  /// Account details when registered, null while anonymous.
  Map<String, dynamic>? _account;
  Map<String, dynamic>? get account => _account;

  /// True only for a registered account — anonymous users are "signed in" to
  /// the app but have no account, and the UI must not conflate the two.
  bool get hasAccount => _account?['accountType'] == 'registered';

  String get displayName =>
      (_account?['displayName'] as String?)?.trim().isNotEmpty == true
          ? _account!['displayName'] as String
          : _profile.handle;

  void signIn({Map<String, dynamic>? account}) {
    _signedIn = true;
    if (account != null) {
      _account = account;
      final handle = account['handle'] as String?;
      if (handle != null) {
        _profile = UserProfile(
          handle: handle,
          joinedAt: DateTime.tryParse(account['createdAt'] as String? ?? '') ??
              _profile.joinedAt,
          reportsSubmitted:
              (account['stats']?['reportsSubmitted'] as num?)?.toInt() ??
                  _profile.reportsSubmitted,
          confirmationsGiven:
              (account['stats']?['confirmationsGiven'] as num?)?.toInt() ??
                  _profile.confirmationsGiven,
          reportsHelpful: _profile.reportsHelpful,
          tripsCompared:
              (account['stats']?['tripsCompared'] as num?)?.toInt() ??
                  _profile.tripsCompared,
          isAnonymous: account['accountType'] != 'registered',
          homeArea: account['homeArea'] as String? ?? _profile.homeArea,
        );
      }
    }
    notifyListeners();
  }

  /// Returns to anonymous use. Reports stay attached to the account on the
  /// server, so signing back in restores them.
  void signOutAccount() {
    _account = null;
    notifyListeners();
  }

  void signOut() {
    _signedIn = false;
    _onboarded = false;
    _account = null;
    notifyListeners();
  }

  void setPersona(DemoPersona p) {
    _persona = p;
    _profile = p == DemoPersona.firstTime
        ? UserProfile(
            handle: 'Traveller #9104',
            joinedAt: DateTime.now(),
            reportsSubmitted: 0,
            confirmationsGiven: 0,
            reportsHelpful: 0,
            tripsCompared: 0,
          )
        : MockUser.profile();
    notifyListeners();
  }

  void recordTripCompared() {
    _profile = _profile.copyWith(tripsCompared: _profile.tripsCompared + 1);
    notifyListeners();
  }

  void recordReportSubmitted() {
    _profile = _profile.copyWith(
      reportsSubmitted: _profile.reportsSubmitted + 1,
    );
    notifyListeners();
  }

  void recordConfirmation() {
    _profile = _profile.copyWith(
      confirmationsGiven: _profile.confirmationsGiven + 1,
    );
    notifyListeners();
  }

  /// Locale for MaterialApp, derived from the chosen language.
  Locale get locale => _language.locale;

  /// The voice-warning language key used by [MockVoiceLines].
  String get voiceKey => switch (_language) {
        ReportLanguage.urdu => 'ur',
        ReportLanguage.romanUrdu => 'roman',
        ReportLanguage.punjabi => 'pa',
        _ => 'en',
      };
}
