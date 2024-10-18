import 'package:easy_vote/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../themes/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  final String voterId;
  final List<Election> registeredElections;

  const HomeScreen({
    Key? key,
    required this.voterId,
    required this.registeredElections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('Voter ID: $voterId');
    // print('Number of registered elections: ${registeredElections.length}');

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elections',
          style: AppTextStyles.headingStyle(context), // Apply heading style
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      drawer: const MyDrawer(), // Keep drawer unchanged
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
        ),
        child: registeredElections.isNotEmpty
            ? ListView.builder(
          itemCount: registeredElections.length,
          itemBuilder: (context, index) {
            final election = registeredElections[index];
            // print('Election ${index + 1}: ${election.title}, starts at ${election.startDate}, ends at ${election.endDate}');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Card(
                elevation: 4, // Add elevation for depth
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margin for cards
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                color: Theme.of(context).colorScheme.onSecondary,// Set card background color
                child: ListTile(
                  title: Text(
                    election.title,
                      style: AppTextStyles.cardTextStyle(context), // Apply body text style
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0), // Padding for subtitle
                    child: Text(
                      'Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}\n'
                          'Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}',
                      style: AppTextStyles.cardTextStyle(context), // Apply hint text style for dates
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/election',
                      arguments: election,
                    );
                  },
                ),
              ),
            );
          },
        )
            : Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding for center message
            child: Text(
              'No elections available for this voter.',
              style: AppTextStyles.bodyTextStyle(context), // Apply body text style for the message
              textAlign: TextAlign.center, // Center the text
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface, // Use background color for better contrast
    );
  }
}
