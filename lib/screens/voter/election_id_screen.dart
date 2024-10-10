import 'package:easy_vote/screens/voter/home_screen.dart';
import 'package:flutter/material.dart';
import '../../models/election.dart';
import '../../services/firebase_service.dart';

class ElectionIdScreen extends StatefulWidget {
  final String electionId; // Add this line

  const ElectionIdScreen({Key? key, required this.electionId}) : super(key: key); // Update constructor

  @override
  _ElectionIdScreenState createState() => _ElectionIdScreenState();
}

class _ElectionIdScreenState extends State<ElectionIdScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _electionIdController = TextEditingController();

  Future<void> _verifyElection() async {
    String electionId = _electionIdController.text.trim();

    if (electionId.isEmpty) {
      _showErrorDialog('Election ID is required.');
      return;
    }

    // Optionally, use the passed electionId from the constructor
    print("Passed Election ID: ${widget.electionId}"); // Debug print statement to see the passed ID

    // Fetch the election using the election ID
    Election? election = await _firebaseService.fetchElectionById(electionId);

    if (election != null) {
      // Navigate to the election page if found
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(electionId: electionId),
        ),
      );
    } else {
      _showErrorDialog('Invalid Election ID. Please try again.');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Election ID')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _electionIdController,
              decoration: const InputDecoration(labelText: 'Election ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyElection,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
