import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;

  const CustomButton({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor, // Use the secondary color for buttons
      ),
    );
  }
}
