import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomTextField.dart';
import '../voter/home_screen.dart';

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
      isScrollControlled: true, // Allows the bottom sheet to be full-screen or to adjust size based on content
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final _retrieveEmailController = TextEditingController();
        final _retrievePasswordController = TextEditingController();
        final _voterIdController = TextEditingController();
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
                        controller: _voterIdController,
                        labelText: 'Voter ID',
                        prefix: Icons.how_to_vote,
                        isReadOnly: true, // Make it read-only since it’s a retrieved value
                      ),
                    ],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              _retrieveEmailController.text,
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
                                _showSnackBar('Voter ID not found.', Theme.of(context).colorScheme.error);
                              }
                            } else {
                              _showSnackBar('Enter valid details. Please try again.', Theme.of(context).colorScheme.error);
                            }

                            setState(() {
                              _isRetrieving = false;
                            });
                          },
                          child: Text(_isRetrieving ? "Retrieving..." : "Retrieve"),
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

    print('Attempting to sign in with email: ${_emailController.text} and password: ${_passwordController.text}');

    var userCredential = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (userCredential != null) {
      print('User signed in successfully with UID: ${userCredential.user!.uid}');
      String? storedVoterId = await _authService.fetchVoterId(userCredential.user!.uid);
      print('Fetched Voter ID from the database: $storedVoterId');

      if (storedVoterId == null) {
        _showSnackBar('User data not found in database.', Theme.of(context).colorScheme.error);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (_voterIdController.text == storedVoterId) {
        _showSnackBar('Logged in successfully!', Theme.of(context).colorScheme.inversePrimary);

        print('Fetching registered elections for Voter ID: ${_voterIdController.text}');
        // Fetch elections that the voter is registered for
        List<Election> registeredElections = await _authService.fetchRegisteredElections(_voterIdController.text);

        print('Number of registered elections fetched: ${registeredElections.length}');
        // Navigate to HomeScreen and pass the list of registered elections
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              voterId: _voterIdController.text,
              registeredElections: registeredElections,
            ),
          ),
        );

      } else {
        _showSnackBar('Invalid Voter ID. Please try again.', Theme.of(context).colorScheme.error);
      }
    } else {
      _showSnackBar('Login failed. Please try again.', Theme.of(context).colorScheme.error);
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
     // backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/evbg1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: EdgeInsets.only(top:60, right: MediaQuery.of(context).size.width* 0.1, left: MediaQuery.of(context).size.width* 0.1),
          child: SingleChildScrollView(
            reverse: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      themeProvider.logoAsset,
                      width: 80, // adjust size as needed
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Welcome, login to continue', textAlign: TextAlign.center, style: AppTextStyles.headingStyle(context)),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefix: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Convert the input to lowercase as the user types
                      _emailController.value = TextEditingValue(
                        text: value.toLowerCase(),
                        selection: _emailController.selection,
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    isPassword: true,
                    prefix: Icons.lock,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    keyboardType: TextInputType.number,
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
                    child: Text(_isLoading ? 'Loading...' : 'Login'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have An Account?", style: AppTextStyles.smallBodyTextStyle(context)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Sign Up', style: AppTextStyles.smallBodyTextStyle(context)),
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
