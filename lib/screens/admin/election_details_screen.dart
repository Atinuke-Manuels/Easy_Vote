import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/election.dart';
import '../../services/firebase_service.dart';
import '../voter/update_elections_screen.dart';

class ElectionDetailsScreen extends StatelessWidget {
  final Election election;

  const ElectionDetailsScreen({Key? key, required this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(election.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Election Title: ${election.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Candidates: ${election.candidates.join(', ')}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateElectionScreen(election: election),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _firebaseService.deleteElection(election.id);
                    Navigator.pop(context); // Go back after deletion
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
