import 'package:flutter/material.dart';

// Define the light mode theme with color scheme
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
      primary: Colors.blueGrey.shade600,
      onPrimary: Colors.grey.shade500,
      // Primary color
      secondary: Colors.grey.shade200,
      // Secondary color
      surface: Colors.grey.shade200,
      // Background color
      //error: Colors.red.shade600,
      error: Colors.purple.shade700,
      onError: const Color(0xFFDE918B),
      // Error color
     // onPrimary: Colors.white,
      // Text on primary color
      onSecondary: Colors.purple.shade700,
      onSurfaceVariant: Colors.purple.shade300,
      onInverseSurface: const Color(0xFF7B1FA2),
      // Text on secondary color
      onSurface: Colors.black54,
      // Text on background
      //onError: Colors.white,
      // Text on error color
      tertiary: Colors.grey.shade300,
      // Custom color (tertiary)
      inversePrimary: Colors.green,
      // Another custom color
      onPrimaryFixed: Color(0xFFE6E6FA),
      //Another color

  ),

);
