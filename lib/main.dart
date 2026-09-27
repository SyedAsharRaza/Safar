import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'data/push/push_service.dart';
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

  // Push is an enhancement: if Firebase is missing or the permission is
  // refused, the app must still plan routes, so this never blocks startup.
  final push = PushService();
  unawaited(push.initialise());

  runApp(BahawalpurSafarApp(push: push));
}

class BahawalpurSafarApp extends StatelessWidget {
  const BahawalpurSafarApp({super.key, required this.push});

  final PushService push;

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
        Provider<PushService>.value(value: push),
      ],
      builder: (context, child) {
        // Route incoming pushes into the in-app feed the Activity tab shows.
        return _PushBridge(push: push, child: child!);
      },
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


/// Feeds push notifications into [NotificationsProvider] so they appear in the
/// Activity tab, not just in the system tray.
class _PushBridge extends StatefulWidget {
  const _PushBridge({required this.push, required this.child});

  final PushService push;
  final Widget child;

  @override
  State<_PushBridge> createState() => _PushBridgeState();
}

class _PushBridgeState extends State<_PushBridge> {
  StreamSubscription<void>? _incoming;

  @override
  void initState() {
    super.initState();
    _incoming = widget.push.incoming.listen((notification) {
      if (!mounted) return;
      context.read<NotificationsProvider>().push(notification);
      // A new signal may change routes the user is looking at, so refresh.
      context.read<ReportsProvider>().refresh();
    });
  }

  @override
  void dispose() {
    _incoming?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
