import 'package:flutter/material.dart';

// Splash
import 'screens/splash/splash_screen.dart';

// Onboarding
import 'screens/onboarding/onboarding_screen1.dart';
import 'screens/onboarding/onboarding_screen2.dart';
import 'screens/onboarding/onboarding_screen3.dart';

// Auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// Main Navigation
import 'main_navigation.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/onboard1': (context) => const OnboardingScreen1(),
  '/onboard2': (context) => const OnboardingScreen2(),
  '/onboard3': (context) => const OnboardingScreen3(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/main': (context) => const MainNavigation(),
};