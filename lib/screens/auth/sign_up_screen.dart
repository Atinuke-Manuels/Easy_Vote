import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../constants/app_text_styles.dart'; // Import your app colors
import '../../themes/theme_provider.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseService _authService =
      FirebaseService(); // Initialize AuthService

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
// Submit Signup
  Future<void> _submitSignup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar(
          'Passwords do not match', Theme.of(context).colorScheme.error);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var result = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );

    if (result != null) {
      var userCredential = result['userCredential']; // Get UserCredential
      var voterId = result['voterId']; // Get Voter ID

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Successful',
                style: AppTextStyles.headingStyle(context)),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Your Voter ID is: '),
                  TextSpan(
                      text: voterId, // Use the returned voterId
                      style: AppTextStyles.voterIdTextStyle(context)),
                  const TextSpan(text: '. Please make sure to save it.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: AppTextStyles.bodyTextStyle(context)),
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
      _showSnackBar('Signup failed. Please try again.',
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
      // appBar: AppBar(
      //     title: Text('Create Your Account', style: AppTextStyles.headingStyle(context))),

      body: Padding(
        padding: const EdgeInsets.only(top:100, right: 16.0, left: 16),
        child: SingleChildScrollView(
          reverse: false,
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
              Text("Let's create your account", textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefix: Icons.person,
              ),
              SizedBox(
                height: 15,
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
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                isConfirmPassword: true,
                prefix: Icons.lock,
              ),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                onPressed: _isLoading ? null : _submitSignup,
                child: Text(_isLoading ? 'Loading...' : 'Signup'),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have An Account? ",
                      style: AppTextStyles.bodyTextStyle(context)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Log In',
                        style: AppTextStyles.bodyTextStyle(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
