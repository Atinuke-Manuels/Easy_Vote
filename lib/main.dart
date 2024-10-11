import 'package:easy_vote/screens/mobile_screens/admin/admin_home_screen.dart';
import 'package:easy_vote/screens/mobile_screens/admin/admin_login_screen.dart';
import 'package:easy_vote/screens/mobile_screens/admin/election_details_screen.dart';
import 'package:easy_vote/screens/mobile_screens/auth/forgot_password_screen.dart';
import 'package:easy_vote/screens/mobile_screens/auth/login_option_screen.dart';
import 'package:easy_vote/screens/mobile_screens/auth/login_screen.dart';
import 'package:easy_vote/screens/mobile_screens/auth/sign_up_screen.dart';
import 'package:easy_vote/screens/mobile_screens/voter/home_screen.dart';
import 'package:easy_vote/screens/mobile_screens/voter/results_screen.dart';
import 'package:easy_vote/screens/mobile_screens/voter/update_elections_screen.dart';
import 'package:easy_vote/screens/mobile_screens/voter/voting_screen.dart';
import 'package:easy_vote/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/election.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()..updateSystemTheme()),
      ],
      child: EasyVoteApp(),
    ),
  );
}

class EasyVoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Vote App',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginOptionScreen(),
        '/login': (context) => const LoginScreen(),
        '/adminLogin': (context) => const AdminLoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(voterId: '', registeredElections: [],),
        '/adminHome': (context) => AdminHomeScreen(),
        '/updateElection': (context) => UpdateElectionScreen(election: Election(id: '', title: '', candidates: [], startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 7)), registeredVoters: [], creatorId: '')),
        '/election': (context) => VotingScreen(),
        '/electionDetails': (context) => ElectionDetailsScreen(election: Election(id: '', title: '', candidates: [], startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 7)), registeredVoters: [], creatorId: '')),
        '/results': (context) => ResultsScreen(),
      },
    );
  }
}
