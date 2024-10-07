import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'home_screen.dart';
import '../constants/app_colors.dart'; // Import your app colors

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseService _authService = FirebaseService(); // Initialize AuthService

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _voterIdController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Show SnackBar for displaying messages
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Submit Login
  Future<void> _submitLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Call the signIn method from AuthService
    var userCredential = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (userCredential != null) {
      // Retrieve the Voter ID from Firestore
      String? storedVoterId = await _authService.fetchVoterId(userCredential.user!.uid);

      // Check if the provided Voter ID matches the stored one
      if (storedVoterId == null) {
        _showSnackBar('User data not found in database.', AppColors.errorColor);
        setState(() {
          _isLoading = false;
        });
        return; // Stop further execution if user data is not found
      }

      if (_voterIdController.text != storedVoterId) {
        _showSnackBar('Invalid Voter ID. Please try again.', AppColors.errorColor);
        setState(() {
          _isLoading = false;
        });
        return; // Stop further execution if the Voter ID does not match
      }

      _showSnackBar('Logged in successfully!', AppColors.successColor);

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showSnackBar('Login failed. Please try again.', AppColors.errorColor);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login', style: AppTextStyles.headingStyle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.primaryColor), // Use primary color for labels
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: AppColors.primaryColor), // Use primary color for labels
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
              controller: _voterIdController,
              decoration: InputDecoration(
                labelText: 'Voter ID',
                labelStyle: TextStyle(color: AppColors.primaryColor), // Use primary color for labels
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitLogin,
              child: Text(_isLoading ? 'Loading...' : 'Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor, // Use the secondary color for buttons
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: Text('Not registered? Signup', style: AppTextStyles.bodyTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
