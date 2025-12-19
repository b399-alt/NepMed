import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/onboard2.png", width: 260),
          const SizedBox(height: 30),
          const Text(
            "Verified Pharmacies",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              "Order from licensed pharmacies with 100% genuine medicines.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textLight),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/onboard3'),
            child: const Text("Next"),
          )
        ],
      ),
    );
  }
}
