import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/onboarding/splash_screen.dart';
import 'state/app_state.dart';
import 'state/checkin_provider.dart';
import 'state/notifications_provider.dart';
import 'state/places_provider.dart';
import 'state/reports_provider.dart';
import 'state/routes_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge with transparent system bars; each screen's app bar sets the
  // icon brightness through its own overlay style.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const BahawalpurSafarApp());
}

class BahawalpurSafarApp extends StatelessWidget {
  const BahawalpurSafarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => RoutesProvider()),
        ChangeNotifierProvider(create: (_) => CheckinProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: Consumer<AppState>(
        builder: (context, app, _) => MaterialApp(
          title: AppText.appName,
          debugShowCheckedModeBanner: false,
          themeMode: app.themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const SplashScreen(),
          builder: (context, child) {
            // Clamp text scaling so very large system font settings do not break
            // dense layouts like the route cards, while still honouring the
            // user's preference up to a readable limit.
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale.clamp(0.85, 1.3)),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
