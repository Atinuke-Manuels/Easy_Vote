import 'package:flutter/material.dart';
import '../../constants/app_text_styles.dart'; // Import your app colors

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool isConfirmPassword;
  final bool isObscure;
  final Function(String)? onChanged; // Add an onChanged callback
  final IconData prefix;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.isObscure = false,
    this.onChanged, // Accept an onChanged callback
    required this.prefix
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: AppTextStyles.hintTextStyle(context), // Use the primary color for labels
        prefixIcon: Icon(widget.prefix, color: Theme.of(context).colorScheme.tertiary,),
        suffixIcon: widget.isPassword || widget.isConfirmPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
      obscureText: (widget.isPassword || widget.isConfirmPassword) && !_isPasswordVisible,
      onChanged: (value) {
        // If an onChanged function is provided, call it
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
