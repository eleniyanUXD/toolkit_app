import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel onboarding;

  const OnboardingPage({super.key, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),

          Expanded(
            child: Center(
              child: Image.asset(
                onboarding.image,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Text(
            onboarding.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 16),

          Text(
            onboarding.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
