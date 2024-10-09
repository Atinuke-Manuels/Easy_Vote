import 'package:flutter/material.dart';

// Define the light mode theme with color scheme
ThemeData lightMode = ThemeData(
      colorScheme: ColorScheme.light(
            primary: Colors.blueGrey.shade600, // Primary color
            secondary: Colors.grey.shade200,   // Secondary color
            surface: Colors.grey.shade200,  // Background color
            error: Colors.red.shade600,        // Error color
            onPrimary: Colors.white,           // Text on primary color
            onSecondary: Colors.blue,         // Text on secondary color
            onSurface: Colors.black,        // Text on background
            onError: Colors.white,             // Text on error color
            tertiary: Colors.grey.shade300,    // Custom color (tertiary)
            inversePrimary: Colors.green, // Another custom color
            onPrimaryFixed: Colors.purple
      ),
);


