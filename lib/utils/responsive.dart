import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double scale(BuildContext context, double value) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 600) return value * 1.4;  // medium tablet scaling
    return value;
  }
}
