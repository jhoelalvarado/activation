import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/app_state.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final sp = await SharedPreferences.getInstance();
  appState = AppState();
  final onboardingHecho = sp.getBool('onboarding_visto') ?? false;

  runApp(ActivationApp(onboardingHecho: onboardingHecho));
}

class ActivationApp extends StatefulWidget {
  const ActivationApp({super.key, required this.onboardingHecho});
  final bool onboardingHecho;

  @override
  State<ActivationApp> createState() => _ActivationAppState();
}

class _ActivationAppState extends State<ActivationApp> {
  String _tema = 'sistema';

  @override
  void initState() {
    super.initState();
    appState.addListener(_syncTema);
  }

  void _syncTema() {
    if (appState.prefs.tema != _tema) {
      setState(() => _tema = appState.prefs.tema);
    }
  }

  @override
  void dispose() {
    appState.removeListener(_syncTema);
    super.dispose();
  }

  ThemeMode get _themeMode => switch (_tema) {
        'claro' => ThemeMode.light,
        'oscuro' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  @override
  Widget build(BuildContext context) {
    // Forzar Inter sin depender de red en el primer frame.
    GoogleFonts.config.allowRuntimeFetching = false;
    return MaterialApp(
      title: 'Activation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: SplashScreen(
        siguiente: widget.onboardingHecho
            ? const HomeShell()
            : const OnboardingScreen(),
      ),
    );
  }
}
