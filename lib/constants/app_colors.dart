import 'package:flutter/material.dart';

class AppColors {
  // Primary color for the app (blue for trust and reliability)
  static const Color primaryColor = Color(0xFF1E88E5); // Light blue
  // Secondary color (for buttons and highlights)
  static const Color secondaryColor = Color(0xFF42A5F5); // Lighter blue
  // Background color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light grey
  // Card color for content sections
  static const Color cardColor = Color(0xFFFFFFFF); // White
  // Error color
  static const Color errorColor = Color(0xFFD32F2F); // Red
  // Success color
  static const Color successColor = Color(0xFF388E3C); // Green
  // Voter ID color
  static const Color voterIdColor = Color(0xFF2196F3); // Blue for Voter ID text
  // Text colors
  static const Color textColor = Color(0xFF212121); // Dark gray for primary text
  static const Color subtitleColor = Color(0xFF757575); // Light gray for subtitles
}

class AppTextStyles {
  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.subtitleColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.errorColor,
  );

  static const TextStyle successTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.successColor,
  );
}
