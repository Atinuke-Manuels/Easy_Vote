import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ResultsScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final String electionId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text("Results")),
      body: StreamBuilder<Map<String, int>>(
        stream: _firebaseService.getResults(electionId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          Map<String, int> results = snapshot.data!;
          return ListView(
            children: results.entries.map((entry) {
              return ListTile(
                title: Text("Candidate: ${entry.key}"),
                trailing: Text("Votes: ${entry.value}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
