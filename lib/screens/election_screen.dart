import 'package:flutter/material.dart';
import '../models/election.dart';
import '../services/firebase_service.dart';

class ElectionScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final Election election = ModalRoute.of(context)?.settings.arguments as Election; // This retrieves the election object
    return Scaffold(
      appBar: AppBar(title: Text(election.title)),
      body: ListView.builder(
        itemCount: election.candidates.length,
        itemBuilder: (context, index) {
          String candidate = election.candidates[index];
          return ListTile(
            title: Text(candidate),
            onTap: () {
              _firebaseService.castVote("voterId", election.id, candidate);
              // Navigate to Results Page
              Navigator.pushNamed(context, '/results', arguments: election.id);
            },
          );
        },
      ),
    );
  }
}
