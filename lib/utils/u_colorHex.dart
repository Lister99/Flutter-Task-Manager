import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class HexColorMaterial {
  static String colorToHext(Color color) {
    final hexColor = color.value.toRadixString(16);
    return hexColor;
  }
}
