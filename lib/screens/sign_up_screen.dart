import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../constants/app_colors.dart'; // Import your app colors

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseService _authService = FirebaseService(); // Initialize AuthService

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Show SnackBar for displaying messages
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Submit Signup
  Future<void> _submitSignup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match', AppColors.errorColor);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call the signup method from AuthService
    var userCredential = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );

    if (userCredential != null) {
      // Show the Voter ID in a dialog before navigating away
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Successful', style: AppTextStyles.headingStyle),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black), // Default text style
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Your Voter ID is: ', // Regular text
                  ),
                  TextSpan(
                    text: _authService.generateVoterId(), // Voter ID text
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // Make the Voter ID bold
                      color: AppColors.voterIdColor, // Use the defined Voter ID color
                    ),
                  ),
                  const TextSpan(
                    text: '. Please make sure to save it, as you will need it to log in.', // Regular text
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: AppTextStyles.bodyTextStyle),
              ),
            ],
          );
        },
      );

      // Clear the fields after successful signup
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();

      // Reset loading state before navigation
      setState(() {
        _isLoading = false;
      });

      // Navigate to login screen after successful signup
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _showSnackBar('Signup failed. Please try again.', AppColors.errorColor);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup', style: AppTextStyles.headingStyle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Use the primary color for labels
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Use the primary color for labels
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Use the primary color for labels
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Use the primary color for labels
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitSignup,
                child: Text(_isLoading ? 'Loading...' : 'Signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor, // Use the secondary color for buttons
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('Already have an account? Login', style: AppTextStyles.bodyTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
