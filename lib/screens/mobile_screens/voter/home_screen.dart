import 'package:easy_vote/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';



class HomeScreen extends StatelessWidget {
  final String voterId;  // Voter ID
  final List<Election> registeredElections;  // List of registered elections

  const HomeScreen({Key? key, required this.voterId, required this.registeredElections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elections',
          style: AppTextStyles.headingStyle(context), // Apply heading style
        ),
        backgroundColor: theme.colorScheme.primary, // Apply primary color from the theme
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary), // Adjust icon color to match theme
      ),
      drawer: const MyDrawer(), // Keep drawer unchanged
      body: registeredElections.isNotEmpty
          ? ListView.builder(
        itemCount: registeredElections.length,
        itemBuilder: (context, index) {
          final election = registeredElections[index];
          return Card(
            color: theme.colorScheme.surface, // Set card background color
            child: ListTile(
              title: Text(
                election.title,
                style: AppTextStyles.bodyTextStyle(context), // Apply body text style
              ),
              subtitle: Text(
                'Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}\n'
                    'Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}',
                style: AppTextStyles.hintTextStyle(context), // Apply hint text style for dates
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/election',
                  arguments: election,
                );
              },
            ),
          );
        },
      )
          : Center(
        child: Text(
          'No elections available for this voter.',
          style: AppTextStyles.bodyTextStyle(context), // Apply body text style for the message
        ),
      ),
      backgroundColor: theme.colorScheme.surface, // Set background color
    );
  }
}
