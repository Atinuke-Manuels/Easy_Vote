
import 'package:easy_vote/screens/combined_layout_screens/admin/admin_home_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_styles.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomTextField.dart';
import 'admin_home_screen.dart';


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

  final TextEditingController _retrieveEmailController = TextEditingController();
  final TextEditingController _retrievePasswordController = TextEditingController();
  final TextEditingController _voterIdController2 = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _retrieveEmailController.dispose();
    _retrievePasswordController.dispose();
    _voterIdController2.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  bool _isRetrieving = false;

  // Show SnackBar for displaying messages
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Show dialog to retrieve Voter ID
  Future<void> _retrieveVoterId() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        bool _voterIdRetrieved = false;
        bool _isRetrieving = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryFixed,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Retrieve Voter ID",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _retrieveEmailController,
                      labelText: 'Email',
                      prefix: Icons.email_outlined,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _retrievePasswordController,
                      labelText: 'Password',
                      isPassword: true,
                      prefix: Icons.lock,
                    ),
                    if (_voterIdRetrieved) ...[
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: _voterIdController2,
                        labelText: 'Voter ID',
                        prefix: Icons.how_to_vote,
                        isReadOnly: true,
                      ),
                    ],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _isRetrieving = true;
                            });

                            var userCredential = await _authService.signIn(
                              _retrieveEmailController.text,
                              _retrievePasswordController.text,
                            );

                            if (userCredential != null) {
                              String? storedVoterId = await _authService.fetchVoterId(userCredential.user!.uid);

                              if (storedVoterId != null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _voterIdRetrieved = true;
                                    _voterIdController2.text = storedVoterId;
                                  });
                                });
                              } else {
                                _showSnackBar('Voter ID not found.', Theme.of(context).colorScheme.onError);
                              }
                            } else {
                              _showSnackBar('Enter valid details. Please try again.', Theme.of(context).colorScheme.onError);
                            }

                            setState(() {
                              _isRetrieving = false;
                            });
                          },
                          child: Text(_isRetrieving ? "Retrieving..." : "Retrieve", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Submit Login
  Future<void> _submitLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the signIn method from AuthService
      var userCredential = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null) {
        // Retrieve the Voter ID from Firestore
        String? storedVoterId =
        await _authService.fetchVoterId(userCredential.user!.uid);

        // Check if the provided Voter ID matches the stored one
        if (storedVoterId == null) {
          _showSnackBar('User data not found in the database.',
              Theme.of(context).colorScheme.error);
          setState(() {
            _isLoading = false;
          });
          return; // Stop further execution if user data is not found
        }

        if (_voterIdController.text != storedVoterId) {
          _showSnackBar('Invalid Voter ID. Please try again.',
              Theme.of(context).colorScheme.onError);
          setState(() {
            _isLoading = false;
          });
          return; // Stop further execution if the Voter ID does not match
        }

        _showSnackBar(
            'Logged in successfully!', Theme.of(context).colorScheme.onSurfaceVariant);

        // Navigate to Admin HomeScreen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeLayout()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors and display descriptive messages
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      _showSnackBar(errorMessage, Theme.of(context).colorScheme.onError);
    } catch (e) {
      // Handle any other errors
      _showSnackBar('An unexpected error occurred. Please try again.',
          Theme.of(context).colorScheme.onError);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Helper function to get descriptive error messages based on FirebaseAuthException
  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'Login failed. ${e.message}';
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.surface,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.only(top:60, right: MediaQuery.of(context).size.width* 0.025, left: MediaQuery.of(context).size.width* 0.025),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Welcome Admin!', textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefix: Icons.email_outlined,
                    //labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: _retrieveVoterId, // Call retrieve Voter ID
                          child: Text(
                            "Retrieve Voter ID",
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/forgotPassword');
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: _isLoading ? null : _submitLogin,
                    child: Text(_isLoading ? 'Loading...' : 'L O G I N'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have An Account?",
                          style: AppTextStyles.smallBodyTextStyle(context)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text("Sign Up",
                            style: AppTextStyles.smallBodyTextStyle(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
