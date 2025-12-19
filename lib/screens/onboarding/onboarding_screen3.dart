import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/responsive.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final isTab = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/onboard3.png",
            width: Responsive.scale(context, 280),
          ),

          SizedBox(height: Responsive.scale(context, 30)),

          Text(
            "Get Your Medicines",
            style: TextStyle(
              fontSize: Responsive.scale(context, 22),
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTab ? 80 : 40,
              vertical: 10,
            ),
            child: Text(
              "Fast and reliable medicine delivery whenever you need it.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.scale(context, 16),
                color: AppColors.textLight,
              ),
            ),
          ),

          SizedBox(height: Responsive.scale(context, 25)),

          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: Responsive.scale(context, 16)),
            ),
          ),
        ],
      ),
    );
  }
}
