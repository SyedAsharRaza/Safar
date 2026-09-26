import 'package:flutter/material.dart';

import '../models/taxonomy.dart';
import '../models/user_profile.dart';
import '../data/mock/mock_misc.dart';

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

  void signIn() {
    _signedIn = true;
    notifyListeners();
  }

  void signOut() {
    _signedIn = false;
    _onboarded = false;
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

  /// The voice-warning language key used by [MockVoiceLines].
  String get voiceKey => switch (_language) {
        ReportLanguage.urdu => 'ur',
        ReportLanguage.romanUrdu => 'roman',
        _ => 'en',
      };
}
