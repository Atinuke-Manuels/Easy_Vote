import 'dart:async';

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
      appBar: AppBar(title: Text(election.title),
      actions: [
        TextButton(onPressed: (){
          Navigator.pushNamed(context, '/results', arguments: election.id);
        }, child: const Text("Result"))
      ],
      ),
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

  Future<void> _checkVoterStatusAndShowDialog(BuildContext context, String candidate, Election election) async {
    User? currentUser = _firebaseService.getCurrentUser();
    if (currentUser != null) {
      String? voterId = await _firebaseService.fetchVoterId(currentUser.uid);
      if (voterId != null) {
        DocumentReference voterRef = _firebaseService.getFirestoreInstance().collection('voters').doc(voterId);
        DocumentSnapshot voterDoc = await voterRef.get();

        if (!voterDoc.exists) {
          await voterRef.set({'hasVoted': false});
          voterDoc = await voterRef.get(); // Re-fetch the document after creating it
        }

        if (voterDoc['hasVoted'] == false) {
          _showConfirmationDialog(context, candidate, election, voterId);
        } else {
          _showAlreadyVotedDialog(context);
        }
      }
    }
  }

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
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _castVoteAndShowSuccessDialog(context, candidate, election, voterId);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyVotedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Already Voted"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text("You have already voted and cannot vote again."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _castVoteAndShowSuccessDialog(BuildContext context, String candidate, Election election, String voterId) async {
    try {
      // Cast the vote
      await _firebaseService.castVote(voterId, election.id, candidate);

      // Show success dialog
      final completer = Completer<void>();
      _showSuccessDialog(context, candidate, completer);

      // Wait for the success dialog to be closed
      await completer.future;

      // Navigate to the results page
      Navigator.pushNamed(context, '/results', arguments: election.id);
    } catch (e) {
      // Handle errors and show a failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while casting the vote: ${e.toString()}')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String candidate, Completer<void> completer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vote Cast Successfully"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Your vote for $candidate has been cast successfully!"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                completer.complete(); // Complete the completer
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
