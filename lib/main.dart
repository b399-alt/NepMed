import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: appRoutes,

      // 👇 add this
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
    );
  }
}
