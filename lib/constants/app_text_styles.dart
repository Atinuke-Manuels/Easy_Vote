

import 'package:flutter/material.dart';

class AppTextStyles {
  // Heading style using the primary color
  static TextStyle headingStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,  // Use primary color directly
    );
  }

  // Body text style using the onSurface color
  static TextStyle bodyTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 16,
      color: colorScheme.onSurface,  // Use onSurface color directly
    );
  }

  // Hint text style using the onSurface color
  static TextStyle hintTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 16,
      color: colorScheme.secondary,  // Use onSurface color directly
    );
  }


  // voter id color
  static TextStyle voterIdTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSecondary,  // Use onSurface color directly
    );
  }

  // Error text style using the error color
  static TextStyle errorTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 16,
      color: colorScheme.error,  // Use error color directly
    );
  }

  // Success text style (can use tertiary or any other custom color)
  static TextStyle successTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 16,
      color: colorScheme.tertiary,  // Use tertiary color
    );
  }
}
