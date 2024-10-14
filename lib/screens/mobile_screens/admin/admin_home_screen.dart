import 'package:easy_vote/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../auth/login_option_screen.dart';
import '../voter/update_elections_screen.dart';
import 'election_details_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOptionScreen()),
          (Route<dynamic> route) =>
      false, // This predicate removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.error,
      appBar: AppBar(
        title: const Text('Elections'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/evbg1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: StreamBuilder<List<Election>>(
          stream: _firebaseService.fetchElections(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Schedule an election.'),
                  ],
                ),
              );
            }

            List<Election> elections = snapshot.data!;

            return ListView.builder(
              itemCount: elections.length,
              itemBuilder: (context, index) {
                Election election = elections[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    child: ListTile(
                      title: Text(election.title, style: AppTextStyles.cardTextStyle(context),),
                      subtitle: Text(
                        'Voting starts: ${DateFormat('dd/MM/yyyy HH:mm').format(election.startDate)}\n'
                            'Voting ends: ${DateFormat('dd/MM/yyyy HH:mm').format(election.endDate)}',
                      ),
                      subtitleTextStyle: AppTextStyles.cardTextStyle(context),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ElectionDetailsScreen(election: election),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Election temporaryElection = Election(
            id: '',
            title: '',
            creatorId: _firebaseService.currentUserId!,
            // Set creatorId here
            candidates: [],
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            registeredVoters: [],
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UpdateElectionScreen(election: temporaryElection),
            ),
          ).then((_) {
            // No need to setState here; the StreamBuilder will handle updates.
          });
        },
        tooltip: "Add Election",
        child: const Icon(Icons.add),
      ),
    );
  }
}