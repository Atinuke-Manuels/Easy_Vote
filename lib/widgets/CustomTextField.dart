import 'package:flutter/material.dart';
import '../../constants/app_colors.dart'; // Import your app colors

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool isConfirmPassword;
  final bool isObscure;
  final Function(String)? onChanged; // Add an onChanged callback

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.isObscure = false,
    this.onChanged, // Accept an onChanged callback
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
        labelStyle: const TextStyle(color: AppColors.primaryColor), // Use the primary color for labels
        suffixIcon: widget.isPassword || widget.isConfirmPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
