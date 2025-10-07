import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/wardrobe_provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'services/api/api_client.dart';
import 'services/adapty_service.dart';
import 'screens/home/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API Client
  await ApiClient().init();
  
  // Initialize Adapty
  try {
    await AdaptyService().initialize();
  } catch (e) {
    print('⚠️ Adapty initialization failed: $e');
    // Continue app even if Adapty fails
  }
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer3<ThemeProvider, UserProvider, LocaleProvider>(
        builder: (context, themeProvider, userProvider, localeProvider, child) {
          return MaterialApp(
            title: 'PeekFit',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('tr', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: FutureBuilder<Widget>(
              future: _getInitialScreen(userProvider.isLoggedIn),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return snapshot.data ?? const OnboardingFlow();
              },
            ),
          );
        },
      ),
    );
  }

  Future<Widget> _getInitialScreen(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (isLoggedIn) {
      return const MainScreen();
    } else if (!onboardingCompleted) {
      return const OnboardingFlow();
    } else {
      return const LoginScreen();
    }
  }
}
