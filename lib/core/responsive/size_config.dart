import 'package:flutter/widgets.dart';

class SizeConfig {
  // Scales text size for tablets
  static double text(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 ? size * 1.4 : size;
  }

  // Scales padding / spacing for tablets
  static double pad(BuildContext context, double value) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 ? value * 1.2 : value;
  }
}
