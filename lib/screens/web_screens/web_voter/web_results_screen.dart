import 'package:flutter/material.dart';
import '../../../constants/app_text_styles.dart';
import '../../../services/firebase_service.dart';
import '../../mobile_screens/voter/chart_screen.dart';


class WebResultsScreen extends StatelessWidget {
  final String electionId;
  final FirebaseService _firebaseService = FirebaseService();

  WebResultsScreen({super.key, required this.electionId});

  @override
  Widget build(BuildContext context) {
    final String electionId =
    ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("R E S U L T S"), centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        leading: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Back", style: AppTextStyles.bodyTextStyle(context),)),
        leadingWidth: 80,
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
        child: StreamBuilder<Map<String, int>>(
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
                  title: Text("Candidate: ${entry.key}", style: AppTextStyles.cardTitleTextStyle(context).copyWith(color: Colors.white)),
                  trailing: Text("Votes: ${entry.value}", style: AppTextStyles.cardTextStyle(context).copyWith(color: Colors.white),),
                );
              }).toList(),
            );
          },
        ),
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
            Navigator.pushNamed(
              context,
              '/chart',
              arguments: results,
            );
          });
        },
        tooltip: "View Chart",
        child: Icon(Icons.bar_chart),
      ),
    );
  }
}
