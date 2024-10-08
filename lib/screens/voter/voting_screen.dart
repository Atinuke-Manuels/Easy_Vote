import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              _checkVoterStatusAndShowDialog(context, candidate, election);
            },
          );
        },
      ),
    );
  }

  // Check if the voter has already voted before showing the appropriate dialog
  Future<void> _checkVoterStatusAndShowDialog(BuildContext context, String candidate, Election election) async {
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
          // If the voter hasn't voted, show the confirmation dialog
          _showConfirmationDialog(context, candidate, election, voterId);
        } else {
          // If the voter has already voted, show a different dialog
          _showAlreadyVotedDialog(context);
        }
      }
    }
  }

  // Show the confirmation dialog for first-time voters
  void _showConfirmationDialog(BuildContext context, String candidate, Election election, String voterId) {
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
              onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _castVoteAndNavigate(context, candidate, election, voterId); // Proceed to cast the vote
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Show the dialog informing the user that they have already voted
  void _showAlreadyVotedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Already Voted"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text("You have already voted and cannot vote again."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Cast the vote and navigate to the results screen for first-time voters
  Future<void> _castVoteAndNavigate(BuildContext context, String candidate, Election election, String voterId) async {
    try {
      // Cast the vote
      await _firebaseService.castVote(voterId, election.id, candidate);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vote for $candidate has been cast successfully!")),
      );

      // Navigate to the results page after a brief delay
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushNamed(context, '/results', arguments: election.id);
    } catch (e) {
      // Handle any potential errors and show a failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while casting the vote: ${e.toString()}')),
      );
    }
  }
}
