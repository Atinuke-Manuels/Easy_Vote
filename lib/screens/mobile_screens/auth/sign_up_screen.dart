import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_text_styles.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomTextField.dart';


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
    // Trim all input fields to remove leading/trailing spaces
    // String email = _emailController.text.trim();
    // String password = _passwordController.text.trim();
    // String confirmPassword = _confirmPasswordController.text.trim();
    // String name = _nameController.text.trim();

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar(
          'Passwords do not match', Theme.of(context).colorScheme.onError);
      return;
    }

    setState(() {
      _isLoading = true;
    });



    var result = await _authService.signUp(
      _emailController.text.trim(),
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
                  const TextSpan(text: '. Please make sure you save it.'),
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
          Theme.of(context).colorScheme.onError);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Container(
              width: double.infinity,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: themeProvider.backgroundGradient,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 60,
                  right: MediaQuery.of(context).size.width * 0.025,
                  left: MediaQuery.of(context).size.width * 0.025,
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              themeProvider.logoAsset,
                              width: 80, // Adjust size as needed
                              height: 80,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Let's create your account",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingStyle(context),
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            prefix: Icons.person,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            prefix: Icons.email_outlined,
                            onChanged: (value) {
                              _emailController.value = TextEditingValue(
                                text: value.toLowerCase(),
                                selection: _emailController.selection,
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            isPassword: true,
                            prefix: Icons.lock,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirm Password',
                            isConfirmPassword: true,
                            prefix: Icons.lock,
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            onPressed: _isLoading ? null : _submitSignup,
                            child: Text(_isLoading ? 'Loading...' : 'S I G N U P'),
                          ),
                          const SizedBox(height: 10),
                          Spacer(), // Push content up when keyboard is shown
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already Have An Account? ",
                                style: AppTextStyles.smallBodyTextStyle(context),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: Text(
                                  'Log In',
                                  style: AppTextStyles.smallBodyTextStyle(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
