import 'package:flutter/material.dart';

class ThemeGradients {
  static LinearGradient darkModeGradient = const LinearGradient(
    colors: [
      Color(0xFF4B0082), // Deep purple
      Color(0xFF6A5ACD), // Slate blue
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient lightModeGradient = const LinearGradient(
    colors: [
      Color(0xFFE6E6FA), // Lavender
      Color(0xFFD8BFD8), // Thistle
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
