import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../voter/update_elections_screen.dart';

class ElectionDetailsScreen extends StatelessWidget {
  final Election election;

  const ElectionDetailsScreen({Key? key, required this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();

    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Election"),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text("Are you sure you want to delete this election?"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await _firebaseService.deleteElection(election.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    void _showFeedbackDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Action Not Allowed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    bool isEditable() {
      // Check if the current date is before the election start date
      return DateTime.now().isBefore(election.startDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(election.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/evbg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Election Title: ${election.title}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text('Candidates: ${election.candidates.join(', ')}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text('Registered Voters: ${election.registeredVoters.join(', ')}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text('Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text('Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (isEditable()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateElectionScreen(election: election),
                          ),
                        );
                      } else {
                        _showFeedbackDialog(context, "Election in progress cannot be edited.");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0)), // Padding
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      elevation: WidgetStateProperty.all(5), // Elevation
                    ),
                    child: const Text('Edit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isEditable()) {
                        _showConfirmationDialog(context);
                      } else {
                        _showFeedbackDialog(context, "Election in progress cannot be deleted.");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0)), // Padding
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      elevation: WidgetStateProperty.all(5), // Elevation
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
