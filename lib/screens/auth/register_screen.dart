import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/responsive.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              "assets/images/register.png",
              width: Responsive.scale(context, 180),
            ),
            SizedBox(height: Responsive.scale(context, 30)),
            _input("Full Name", context),
            SizedBox(height: Responsive.scale(context, 15)),
            _input("Email", context),
            SizedBox(height: Responsive.scale(context, 15)),
            _input("Password", context, obscure: true),
            SizedBox(height: Responsive.scale(context, 20)),
            SizedBox(
              width: isTab ? 300 : double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: Text("Register", style: TextStyle(fontSize: Responsive.scale(context, 16))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, BuildContext context, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: Responsive.scale(context, 16)),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
