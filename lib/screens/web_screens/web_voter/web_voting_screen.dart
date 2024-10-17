import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';


class WebVotingScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  WebVotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Attempt to retrieve the election argument from the route settings
    final Election? election =
    ModalRoute.of(context)?.settings.arguments as Election?;

    // Check if election is null and handle the case
    if (election == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'No election data available.',
            style: AppTextStyles.cardTextStyle(context),
          ),
        ),
      );
    }

    return
      Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('${election.title} Candidates'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/results',
                    arguments: election.id);
              },
              child: Text("View Result",style: AppTextStyles.headingStyle(context) ,))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top:40, right: MediaQuery.of(context).size.width* 0.2, left: MediaQuery.of(context).size.width* 0.2),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/evbg1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: ListView.builder(
            itemCount: election.candidates.length,
            itemBuilder: (context, index) {
              String candidate = election.candidates[index];
              return ListTile(
                title: Card(
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(candidate, style: AppTextStyles.cardTextStyle(context),),
                  ),
                ),
                onTap: () {
                  _checkVoterStatusAndShowDialog(context, candidate, election);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _checkVoterStatusAndShowDialog(
      BuildContext context, String candidate, Election election) async {
    User? currentUser = _firebaseService.getCurrentUser();
    if (currentUser != null) {
      String? voterId = await _firebaseService.fetchVoterId(currentUser.uid);
      if (voterId != null) {
        DocumentReference voterRef = _firebaseService
            .getFirestoreInstance()
            .collection('voters')
            .doc(voterId);
        DocumentSnapshot voterDoc = await voterRef.get();

        if (!voterDoc.exists) {
          await voterRef.set({'votes': {}}); // Initialize votes map
          voterDoc =
          await voterRef.get(); // Re-fetch the document after creating it
        }

        final votes = voterDoc['votes'] as Map<String, dynamic>;
        if (votes[election.id] == null || votes[election.id] == false) {
          _showConfirmationDialog(context, candidate, election, voterId);
        } else {
          _showAlreadyVotedDialog(context);
        }
      }
    }
  }

  void _showConfirmationDialog(BuildContext context, String candidate,
      Election election, String voterId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
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
                await _castVoteAndShowSuccessDialog(
                    context, candidate, election, voterId);
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

  Future<void> _castVoteAndShowSuccessDialog(BuildContext context,
      String candidate, Election election, String voterId) async {
    try {
      // Cast the vote with the election start and end dates
      await _firebaseService.castVote(
        voterId,
        election.id,
        candidate,
        election.startDate,
        election.endDate,
      );

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
        SnackBar(
          content: Text(
              'An error occurred while casting the vote: ${e.toString()}'
          ),
        ),
      );
    }
  }


  void _showSuccessDialog(
      BuildContext context, String candidate, Completer<void> completer) {
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
