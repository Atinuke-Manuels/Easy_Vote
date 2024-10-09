import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import 'chart_screen.dart';

class ResultsScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final String electionId =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
          // Sort results in descending order
          var sortedResults = Map.fromEntries(
            results.entries.toList()
              ..sort((e1, e2) => e2.value.compareTo(e1.value)),
          );

          return ListView(
            children: sortedResults.entries.map((entry) {
              return ListTile(
                title: Text("Candidate: ${entry.key}"),
                trailing: Text("Votes: ${entry.value}"),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get the current results from the StreamBuilder
          _firebaseService.getResults(electionId).first.then((results) {
            // Sort results in descending order
            var sortedResults = Map.fromEntries(
              results.entries.toList()
                ..sort((e1, e2) => e2.value.compareTo(e1.value)),
            );

            // Navigate to the ChartScreen with the sorted results
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChartScreen(results: sortedResults),
              ),
            );
          });
        },
        child: Icon(Icons.bar_chart),
        tooltip: "View Chart",
      ),
    );
  }
}
