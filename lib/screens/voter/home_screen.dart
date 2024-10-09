import 'package:easy_vote/screens/auth/login_option_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../models/election.dart';
import '../../services/firebase_service.dart';
import '../../widgets/my_drawer.dart';
import '../auth/login_screen.dart';
import 'update_elections_screen.dart';
import 'voting_screen.dart'; // Ensure this import is present

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOptionScreen()),
          (Route<dynamic> route) => false, // This predicate removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Elections'),
      actions: [
        TextButton(onPressed: (){
          _firebaseService.signOut();
          navigateToLoginScreen(context);
        }, child: const Icon(Icons.exit_to_app_outlined))
      ],
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<List<Election>>(
        stream: _firebaseService.fetchElections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No elections available.'),
                ],
              ),
            );
          }

          List<Election> elections = snapshot.data!;

          return ListView.builder(
            itemCount: elections.length,
            itemBuilder: (context, index) {
              Election election = elections[index];
              return Card(
                child: ListTile(
                  title: Text(election.title),
                  subtitle: Text(
                    'Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}\n'
                        'Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}',
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/election',  // Make sure this route matches with your main app routes
                      arguments: election,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
