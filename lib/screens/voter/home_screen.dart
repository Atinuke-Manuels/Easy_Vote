

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/election.dart';

class HomeScreen extends StatelessWidget {
  final String voterId;  // Voter ID
  final List<Election> registeredElections;  // List of registered elections

  const HomeScreen({Key? key, required this.voterId, required this.registeredElections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elections'),
      ),
      body: registeredElections.isNotEmpty
          ? ListView.builder(
        itemCount: registeredElections.length,
        itemBuilder: (context, index) {
          final election = registeredElections[index];
          return Card(
            child: ListTile(
              title: Text(election.title),
              subtitle: Text(
                'Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}\n'
                    'Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}',
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
          : const Center(child: Text('No elections available for this voter.')),
    );
  }
}
