import 'package:flutter/material.dart';
import 'sign_up_screen.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/sign_up_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Heading
              Text(
                'Welcome back',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                'Sign in to continue with Toolkit.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF777777),
                ),
              ),

              const SizedBox(height: 24),

              // Signup form
              SignInForm(
                onSignIn: () {},
                onSignup: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                onForgotPassword: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
