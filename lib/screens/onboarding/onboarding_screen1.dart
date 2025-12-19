import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/responsive.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final isTab = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/onboard1.png",
            width: Responsive.scale(context, 280),
          ),
          SizedBox(height: Responsive.scale(context, 30)),
          Text(
            "Instant Medicine Delivery",
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
              "Get your medicines delivered to your door within minutes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.scale(context, 16),
                color: AppColors.textLight,
              ),
            ),
          ),
          SizedBox(height: Responsive.scale(context, 25)),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/onboard2'),
            child: Text("Next", style: TextStyle(fontSize: Responsive.scale(context, 16))),
          ),
        ],
      ),
    );
  }
}
