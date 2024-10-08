import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../constants/app_colors.dart'; // Import your app colors
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';

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

    var userCredential = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );

    if (userCredential != null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Successful', style: AppTextStyles.headingStyle),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Your Voter ID is: '),
                  TextSpan(
                    text: _authService.generateVoterId(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.voterIdColor,
                    ),
                  ),
                  const TextSpan(text: '. Please make sure to save it.'),
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

      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();

      setState(() {
        _isLoading = false;
      });

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
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
              ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                onChanged: (value) {
                  // Convert the input to lowercase as the user types
                  _emailController.value = TextEditingValue(
                    text: value.toLowerCase(),
                    selection: _emailController.selection,
                  );
                },
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                isPassword: true,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                isConfirmPassword: true,
              ),
              CustomButton(
                onPressed: _isLoading ? null : _submitSignup,
                child: Text(_isLoading ? 'Loading...' : 'Signup'),
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
