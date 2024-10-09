// Define the dark mode theme similarly (optional)
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
      colorScheme: ColorScheme.dark(
            primary: Colors.blueGrey.shade200,
            secondary: Colors.grey.shade700,
            surface: Colors.grey.shade800,
            error: Colors.red.shade400,
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onError: Colors.black,
            tertiary: Colors.grey.shade600,
            inversePrimary: Colors.green,
            onPrimaryFixed: Colors.purple.shade300
      ),
);