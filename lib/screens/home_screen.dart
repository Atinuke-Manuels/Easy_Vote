import 'package:easy_vote/screens/update_elections_screen.dart';
import 'package:flutter/material.dart';
import '../models/election.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elections')),
      body: FutureBuilder<List<Election>>(
        future: _firebaseService.fetchElections(),
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
                      // Create a temporary Election object
                      Election temporaryElection = Election(
                        id: '',
                        title: '',
                        candidates: [],
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(Duration(days: 7)),
                      );

                      // Navigate to the UpdateElectionScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateElectionScreen(election: temporaryElection),
                        ),
                      ).then((_) {
                        // Re-fetch elections after coming back from the UpdateElectionScreen
                        setState(() {});
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
                  subtitle: Text('Voting Period: ${election.startDate} - ${election.endDate}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/electionDetails', arguments: election);
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
