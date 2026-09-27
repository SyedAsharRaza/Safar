/// Where the app talks to the backend.
///
/// Override at build time without touching source:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api
///
/// `10.0.2.2` is the host machine as seen from an Android emulator. On a
/// physical device use your machine's LAN address, or just leave the default
/// and talk to the deployed API.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://banao-hackathon-app-backend.vercel.app/api',
  );

  /// Set false to force the app onto its seeded demonstration data, which is
  /// what makes a demo survive a dead venue network.
  static const bool useBackend = bool.fromEnvironment(
    'USE_BACKEND',
    defaultValue: true,
  );

  static const Duration timeout = Duration(seconds: 20);

  /// A cold serverless container takes a moment to wake; the first call gets
  /// more room before it is treated as a failure.
  static const Duration coldStartTimeout = Duration(seconds: 35);

  static bool get isLocal =>
      baseUrl.contains('localhost') || baseUrl.contains('10.0.2.2');
}
