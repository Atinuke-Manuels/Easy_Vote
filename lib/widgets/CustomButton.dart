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
        backgroundColor: Theme.of(context).colorScheme.secondary, // Use the secondary color for buttons
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        minimumSize: Size(280, 70),
        shape: RoundedRectangleBorder(

          side: BorderSide(color:Theme.of(context).colorScheme.onSurface, width:3),
        )
      ),
      child: child,
    );
  }
}
