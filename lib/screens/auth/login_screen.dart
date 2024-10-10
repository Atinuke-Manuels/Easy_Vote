import 'package:flutter/material.dart';
import '../../constants/app_text_styles.dart';
import '../../services/firebase_service.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';
import '../voter/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseService _authService =
      FirebaseService(); // Initialize AuthService

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _voterIdController = TextEditingController();

  bool _isLoading = false;

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
      String? storedVoterId =
          await _authService.fetchVoterId(userCredential.user!.uid);

      // Check if the provided Voter ID matches the stored one
      if (storedVoterId == null) {
        _showSnackBar('User data not found in database.',
            Theme.of(context).colorScheme.error);
        setState(() {
          _isLoading = false;
        });
        return; // Stop further execution if user data is not found
      }

      if (_voterIdController.text != storedVoterId) {
        _showSnackBar('Invalid Voter ID. Please try again.',
            Theme.of(context).colorScheme.error);
        setState(() {
          _isLoading = false;
        });
        return; // Stop further execution if the Voter ID does not match
      }

      _showSnackBar('Logged in successfully!',
          Theme.of(context).colorScheme.inversePrimary);

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showSnackBar('Login failed. Please try again.',
          Theme.of(context).colorScheme.error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          reverse: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login', style: AppTextStyles.headingStyle(context)),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefix: Icons.ac_unit,
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
                  prefix: Icons.ac_unit,
                ),
                CustomTextField(
                  controller: _voterIdController,
                  labelText: 'Voter ID',
                  prefix: Icons.ac_unit,
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: _isLoading ? null : _submitLogin,
                  child: Text(_isLoading ? 'Loading...' : 'Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Text('Not registered? Signup',
                      style: AppTextStyles.bodyTextStyle(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
