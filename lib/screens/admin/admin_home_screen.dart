import 'package:easy_vote/screens/auth/login_option_screen.dart';
import 'package:easy_vote/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../models/election.dart';
import '../../services/firebase_service.dart';
import '../voter/update_elections_screen.dart';
import 'election_details_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOptionScreen()),
      (Route<dynamic> route) =>
          false, // This predicate removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Elections'),
        actions: [
          TextButton(
              onPressed: () {
                _firebaseService.signOut();
                navigateToLoginScreen(context);
              },
              child: const Icon(Icons.exit_to_app_outlined))
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
                  Text('Schedule an election.'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionDetailsScreen(election: election),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Election temporaryElection = Election(
            id: '',
            title: '',
            candidates: [],
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)), registeredVoters: [],
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UpdateElectionScreen(election: temporaryElection),
            ),
          ).then((_) {
            // No need to setState here; the StreamBuilder will handle updates.
          });
        },
        tooltip: "View Chart",
        child: const Icon(Icons.add),
      ),
    );
  }
}
