import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'permissions_screen.dart';
import 'paywall_screen.dart';
import '../auth/login_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentPage = 0;

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentPage,
      children: [
        WelcomeScreen(onContinue: _nextPage),
        PermissionsScreen(onComplete: _nextPage),
        PaywallScreen(onComplete: _completeOnboarding),
      ],
    );
  }
}
