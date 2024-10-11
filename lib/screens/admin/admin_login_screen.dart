import 'package:easy_vote/screens/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_text_styles.dart';
import '../../services/firebase_service.dart';
import '../../themes/theme_provider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
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

      _showSnackBar(
          'Logged in successfully!', Theme.of(context).colorScheme.onError);

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomeScreen()),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top:80, right: 16.0, left: 16),
        child: SingleChildScrollView(
          reverse: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text('Login', style: AppTextStyles.headingStyle(context)),
                Center(
                  child: Image.asset(
                    themeProvider.logoAsset,
                    width: 80, // adjust size as needed
                    height: 80,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Welcome Admin!', textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
                SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefix: Icons.email_outlined,
                  onChanged: (value) {
                    // Convert the input to lowercase as the user types
                    _emailController.value = TextEditingValue(
                      text: value.toLowerCase(),
                      selection: _emailController.selection,
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isPassword: true,
                  prefix: Icons.lock,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _voterIdController,
                  labelText: 'Voter ID',
                  prefix: Icons.how_to_vote,
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text(
                          "Forgot Password",
                          style: AppTextStyles.voterIdTextStyle(context),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: _isLoading ? null : _submitLogin,
                  child: Text(_isLoading ? 'Loading...' : 'Login'),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have An Account?",
                        style: AppTextStyles.bodyTextStyle(context)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text("Sign Up",
                          style: AppTextStyles.bodyTextStyle(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
