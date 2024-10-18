// Define the dark mode theme similarly (optional)
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey.shade200,
      onPrimary: Colors.grey.shade400,
      secondary: Colors.grey.shade700,
      surface: Colors.grey.shade800,
      onSecondary: const Color(0xFFE6E6FA),
      onSurfaceVariant: const Color(0xFFD8BFD8),
      onInverseSurface: const Color(0xFFD8BFD8),
      //error: Colors.red,
      error: Colors.white,
      onError: Colors.red,
      // onPrimary: Colors.black,
      //onSecondary: Colors.white,
     // onSurface: Colors.white,
     // onError: Colors.black,
      tertiary: Color(0xFF4B0082),
      inversePrimary: Colors.white,
      onPrimaryFixed: const Color(0xFF4B0082)
  ),
);
