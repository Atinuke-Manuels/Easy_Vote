import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../voter/update_elections_screen.dart';

class ElectionDetailsScreen extends StatelessWidget {
  final Election election;

  const ElectionDetailsScreen({Key? key, required this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();

    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Election"),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text("Are you sure you want to delete this election?"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await _firebaseService.deleteElection(election.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    bool isEditable() {
      // Check if the current date is before the election start date
      return DateTime.now().isBefore(election.startDate);
    }

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
            Text('Registered Voters: ${election.registeredVoters.join(', ')}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isEditable() ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateElectionScreen(election: election),
                      ),
                    );
                  } : null, // Disable button if not editable
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: isEditable() ? () {
                    _showConfirmationDialog(context);
                  } : null, // Disable button if not editable
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
