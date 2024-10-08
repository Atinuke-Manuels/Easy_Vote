import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../constants/app_colors.dart';
import '../../widgets/CustomTextField.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseService _authService = FirebaseService();

  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool isSignReset = false;

  // Show SnackBar for displaying messages
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // password reset
  Future<void> _resetPassword(BuildContext context) async {
    setState(() {
      isSignReset = true; // Set loading state to true
    });

    String email = _emailController.text.trim();

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar('Please enter a valid email address.', AppColors.errorColor);
      setState(() {
        isSignReset = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showSnackBar('Password reset email sent. Please check your email.', AppColors.successColor);

      // Navigate to login screen
      Navigator.pushNamed(context, '/');
    } catch (e) {
      // Show detailed error message if password reset fails
      _showSnackBar('Failed to send password reset email: ${e.toString()}', AppColors.errorColor);
      // print('Error sending password reset email: $e');
    } finally {
      setState(() {
        isSignReset = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _resetPassword(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
                child: Text(_isLoading ? 'Loading...' : 'Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
