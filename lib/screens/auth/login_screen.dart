import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTab = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(isTab ? 40 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/login.png",
              width: Responsive.scale(context, 180),
            ),
            SizedBox(height: Responsive.scale(context, 30)),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontSize: Responsive.scale(context, 16)),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Responsive.scale(context, 15)),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(fontSize: Responsive.scale(context, 16)),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: Responsive.scale(context, 20)),
            SizedBox(
              width: isTab ? 300 : double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
                child: Text("Login", style: TextStyle(fontSize: Responsive.scale(context, 16))),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("Create an Account",
                  style: TextStyle(fontSize: Responsive.scale(context, 14))),
            ),
          ],
        ),
      ),
    );
  }
}