import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEE7FF), Color(0xFFD7C6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Icon(
                  Icons.rocket_launch,
                  size: 96,
                  color: Color(0xFF5A2CA0),
                ),
                const SizedBox(height: 24),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2B164B),
                  ),
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(milliseconds: 700),
                    animatedTexts: [
                      FadeAnimatedText('Signup Adventure'),
                      FadeAnimatedText('Build Your Profile'),
                      FadeAnimatedText('Start Your Journey'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create an account with validation, polish, and a successful finish.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4E3A76),
                    height: 1.35,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Start Signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A2CA0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
