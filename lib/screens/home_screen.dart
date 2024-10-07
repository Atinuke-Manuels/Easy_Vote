import 'package:easy_vote/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../models/election.dart';
import '../services/firebase_service.dart';
import 'update_elections_screen.dart';
import 'election_screen.dart'; // Ensure this import is present

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false, // This predicate removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elections'),
      actions: [
        TextButton(onPressed: (){
          _firebaseService.signOut();
          navigateToLoginScreen(context);
        }, child: Icon(Icons.exit_to_app_outlined))
      ],
      ),
      body: StreamBuilder<List<Election>>(
        stream: _firebaseService.fetchElections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No elections available.'),
                  ElevatedButton(
                    onPressed: () {
                      Election temporaryElection = Election(
                        id: '',
                        title: '',
                        candidates: [],
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(Duration(days: 7)),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateElectionScreen(election: temporaryElection),
                        ),
                      ).then((_) {
                        // No need to setState here; the StreamBuilder will handle updates.
                      });
                    },
                    child: Text("Schedule An Election"),
                  ),
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
