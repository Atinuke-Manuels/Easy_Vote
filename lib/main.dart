import 'package:easy_vote/screens/new_screen.dart';
import 'package:easy_vote/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/election_screen.dart';
import 'screens/results_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(EasyVoteApp());
}

class EasyVoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Vote App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/new': (context) => const NewScreen(),
        '/home': (context) => HomeScreen(),
        '/election': (context) => ElectionScreen(),
        '/results': (context) => ResultsScreen(),
      },
    );
  }
}
