import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomTextField.dart';
import '../../combined_layout_screens/voter/home_layout.dart';
import '../../mobile_screens/voter/home_screen.dart';


class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  _WebLoginScreenState createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final FirebaseService _authService = FirebaseService(); // Initialize AuthService

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _voterIdController = TextEditingController();

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _retrieveEmailController = TextEditingController();
        final _retrievePasswordController = TextEditingController();
        final _voterIdController = TextEditingController();
        bool _voterIdRetrieved = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              title: Text("Retrieve Voter ID"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      controller: _voterIdController,
                      labelText: 'Voter ID',
                      prefix: Icons.how_to_vote,
                      isReadOnly: true, // Make it read-only since it’s a retrieved value
                    ),
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _isRetrieving = true;
                    });

                    var userCredential = await _authService.signIn(
                      _retrieveEmailController.text.trim(),
                      _retrievePasswordController.text,
                    );

                    if (userCredential != null) {
                      String? storedVoterId = await _authService.fetchVoterId(userCredential.user!.uid);

                      if (storedVoterId != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _voterIdRetrieved = true;
                            _voterIdController.text = storedVoterId; // Set Voter ID in the controller
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
                  child: Text(_isRetrieving ? "Retrieving..." : "Retrieve"),
                ),
              ],
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
      var userCredential = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null) {
        String? storedVoterId = await _authService.fetchVoterId(userCredential.user!.uid);

        if (storedVoterId == null) {
          _showSnackBar('User data not found in the database.', Theme.of(context).colorScheme.onError);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (_voterIdController.text == storedVoterId) {
          _showSnackBar('Logged in successfully!', Theme.of(context).colorScheme.onSurfaceVariant);

          // Fetch elections that the voter is registered for
          List<Election> registeredElections = await _authService.fetchRegisteredElections(_voterIdController.text);

          // Navigate to HomeScreen and pass the list of registered elections
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeLayout(
                voterId: _voterIdController.text,
                registeredElections: registeredElections,
              ),
            ),
          );
        } else {
          _showSnackBar('Invalid Voter ID. Please try again.', Theme.of(context).colorScheme.onError);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Display more descriptive error messages based on the error code
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        default:
          errorMessage = 'Login failed. ${e.message}';
          break;
      }

      _showSnackBar(errorMessage, Theme.of(context).colorScheme.onError);
    } catch (e) {
      // For any other errors, show a general error message
      _showSnackBar('An unexpected error occurred. Please try again.', Theme.of(context).colorScheme.onError);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.only(top:60, right: MediaQuery.of(context).size.width* 0.25, left: MediaQuery.of(context).size.width* 0.25),
          child: SingleChildScrollView(
            reverse: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      themeProvider.logoAsset,
                      width: 110, // adjust size as needed
                      height: 110,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Welcome, login to continue', textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    isPassword: true,
                    prefix: Icons.lock,
                  ),
                  const SizedBox(height: 15),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have An Account?", style: AppTextStyles.webSmallBodyTextStyle(context)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Sign Up', style: AppTextStyles.webSmallBodyTextStyle(context)),
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
