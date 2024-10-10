import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;

  const CustomButton({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context)
            .colorScheme
            .onSurface, // Use the secondary color for buttons
      ),
      child: child,
    );
  }
}
