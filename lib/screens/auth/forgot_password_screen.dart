import 'package:easy_vote/widgets/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../constants/app_text_styles.dart';
import '../../themes/theme_provider.dart';
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
      _showSnackBar('Please enter a valid email address.',
          Theme.of(context).colorScheme.error);
      setState(() {
        isSignReset = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showSnackBar('Password reset email sent. Please check your email.',
          Theme.of(context).colorScheme.onError);

      // Navigate to login screen
      Navigator.pushNamed(context, '/');
    } catch (e) {
      // Show detailed error message if password reset fails
      _showSnackBar('Failed to send password reset email: ${e.toString()}',
          Theme.of(context).colorScheme.error);
      // print('Error sending password reset email: $e');
    } finally {
      setState(() {
        isSignReset = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.only(top:100, right: 16.0, left: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  themeProvider.logoAsset,
                  width: 120, // adjust size as needed
                  height: 120,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text("Enter your email to reset your password", textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefix: Icons.email_outlined,
              ),
              SizedBox(height: 40),
              CustomButton(
                onPressed: _isLoading ? null : () => _resetPassword(context),
                child: Text(_isLoading ? 'Loading...' : 'Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
