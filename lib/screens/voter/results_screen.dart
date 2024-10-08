import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No votes yet."));
          }

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
