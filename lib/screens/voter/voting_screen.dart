import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/election.dart';
import '../../services/firebase_service.dart';

class VotingScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final Election election = ModalRoute.of(context)?.settings.arguments as Election;

    return Scaffold(
      appBar: AppBar(title: Text(election.title)),
      body: ListView.builder(
        itemCount: election.candidates.length,
        itemBuilder: (context, index) {
          String candidate = election.candidates[index];
          return ListTile(
            title: Text(candidate),
            onTap: () {
              _showConfirmationDialog(context, candidate, election);
            },
          );
        },
      ),
    );
  }

  // Show confirmation dialog before casting the vote
  void _showConfirmationDialog(BuildContext context, String candidate, Election election) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Vote"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Are you sure you want to vote for $candidate?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _castVoteAndNavigate(context, candidate, election);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Cast the vote and navigate to the results screen
  Future<void> _castVoteAndNavigate(BuildContext context, String candidate, Election election) async {
    User? currentUser = _firebaseService.getCurrentUser();
    if (currentUser != null) {
      String? voterId = await _firebaseService.fetchVoterId(currentUser.uid);
      if (voterId != null) {
        DocumentReference voterRef = _firebaseService.getFirestoreInstance()
            .collection('voters').doc(voterId);

        DocumentSnapshot voterDoc = await voterRef.get();

        if (!voterDoc.exists) {
          // If the document doesn't exist, create it with hasVoted = false
          await voterRef.set({'hasVoted': false});
          voterDoc = await voterRef.get(); // Re-fetch the document after creating it
        }

        if (voterDoc['hasVoted'] == false) {
          // Cast the vote if the voter hasn't voted yet
          await _firebaseService.castVote(voterId, election.id, candidate);

          // Show success message and navigate to the Results Page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Vote for $candidate has been cast successfully!")),
          );

          Navigator.pushNamed(context, '/results', arguments: election.id);
        } else {
          // Show error message if the voter has already voted
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have already voted!'))
          );
        }
      }
    }
  }
}
