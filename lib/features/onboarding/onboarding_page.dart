import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingPage> {
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingPages = [
    {
      'title': 'Welcome to ThreadNest',
      'subtext': 'Where Knowledge is Shared, and Connections are Made.',
      'image': 'assets/images/onboarding1.jpeg',
      'cta': 'Get Started',
    },
    {
      'title': 'Explore Your Interests',
      'subtext':
          'Join communities that match your passions and connect with like-minded people.',
      'image': 'assets/images/onboarding2.jpeg',
      'cta': 'Next',
    },
    {
      'title': 'Share & Grow Together',
      'subtext':
          'Ask questions, share knowledge, and engage in meaningful discussions.',
      'image': 'assets/images/onboarding3.jpeg',
      'cta': 'Next',
    },
    {
      'title': 'Join the Nest',
      'subtext': 'Create your account to start participating in the community.',
      'image': 'assets/images/onboarding4.jpeg',
      'cta': 'Sign Up',
      'secondary_cta': 'Log In',
      'tertiary_cta': 'Skip for Now',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPage = onboardingPages[_currentIndex];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Image.asset(
                currentPage['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // Image Section

                const SizedBox(height: 40),
                // Text Section
                Text(
                  currentPage['title']!,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  currentPage['subtext']!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // CTA Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_currentIndex < onboardingPages.length - 1) {
                        _currentIndex++;
                      } else {
                        // Navigate to sign up
                        _gotoSignUp();
                      }
                    });
                  },
                  child: Text(currentPage['cta']!),
                ),
                if (currentPage.containsKey('secondary_cta'))
                  TextButton(
                    onPressed: _gotoLogin,
                    child: Text(currentPage['secondary_cta']!),
                  ),
                if (currentPage.containsKey('tertiary_cta'))
                  TextButton(
                    onPressed: _gotoHome,
                    child: Text(currentPage['tertiary_cta']!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _gotoSignUp() => context.goNamed(AppRouteName.signup);
  void _gotoLogin() => context.goNamed(AppRouteName.login);
  void _gotoHome() => context.goNamed(AppRouteName.home);
}
