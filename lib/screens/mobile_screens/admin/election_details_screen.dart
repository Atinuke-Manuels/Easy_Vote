import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
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
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      appBar: AppBar(
        title: Text(election.title, style: AppTextStyles.headingStyle(context),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            reverse: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Election Title: ${election.title}', style: AppTextStyles.headingStyle(context)),
                const SizedBox(height: 25),
                Text('Candidates: ${election.candidates.join(', ')}', style: AppTextStyles.headingStyle(context)),
                const SizedBox(height: 25),
                Text('Registered Voters: ${election.registeredVoters.join(', ')}', style: AppTextStyles.headingStyle(context)),
                const SizedBox(height: 25),
                Text('Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}', style: AppTextStyles.headingStyle(context)),
                const SizedBox(height: 25),
                Text('Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}', style: AppTextStyles.headingStyle(context)),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isEditable()) {
                          Navigator.pushNamed(context, '/updateElection');
                        } else {
                          _showFeedbackDialog(context, "Election in progress cannot be edited.");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                        foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0)), // Padding
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        elevation: WidgetStateProperty.all(5), // Elevation
                      ),
                      child: Text('Edit', style: AppTextStyles.cardTextStyle(context)),
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
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                        foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0)), // Padding
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        elevation: WidgetStateProperty.all(5), // Elevation
                      ),
                      child: Text('Delete',style: AppTextStyles.cardTextStyle(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
