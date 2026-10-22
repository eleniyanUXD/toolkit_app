import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'onboarding_screen.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Allow the logo to slide into position.
    await _controller.forward();

    // Keep the logo visible briefly.
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final preferences = await SharedPreferences.getInstance();
    final hasSeenOnboarding = preferences.getBool('seenOnboarding') ?? false;

    final session = Supabase.instance.client.auth.currentSession;

    Widget nextScreen;

    if (session != null) {
      // User is already authenticated.
      nextScreen = const MainNavigation();
    } else if (!hasSeenOnboarding) {
      // First-time user.
      nextScreen = const OnboardingScreen();
    } else {
      // Returning user who is signed out.
      nextScreen = const SignInScreen();
    }

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: Image.asset(
            'assets/logo/toolkit_logoo.png',
            width: 220,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
