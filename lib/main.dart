import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit_app/screens/onboarding_screen.dart';
import 'package:toolkit_app/screens/sign_up_screen.dart';
import 'package:toolkit_app/screens/sign_in_screen.dart';
import 'navigation/main_navigation.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ajjritgcpshvvixjlobb.supabase.co',
    publishableKey: 'sb_publishable_Gk1e0Yeo78Hv0xWopyFu9Q_icaaYiTv',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}
