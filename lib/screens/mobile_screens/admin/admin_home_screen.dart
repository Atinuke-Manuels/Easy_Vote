import 'package:easy_vote/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:provider/provider.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart';
import '../../combined_layout_screens/admin/election_details_layout.dart';
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
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      appBar: AppBar(
        title: Text('Schedule  An  Election', style: AppTextStyles.headingStyle(context),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.error, // Set the desired color here
        ),
      ),
      drawer: const MyDrawer(),
      body: Container(
        padding: EdgeInsets.only(top:40, right: MediaQuery.of(context).size.width* 0.025, left: MediaQuery.of(context).size.width* 0.025),
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
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
                    color: Theme.of(context).colorScheme.onSecondary,
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
                            builder: (context) => ElectionDetailsLayout(election: election,),
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
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
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
          Navigator.pushNamed(
            context,
            '/updateElection',
            arguments: temporaryElection, // Pass the election as an argument
          ).then((_) {
            // No need to setState here; the StreamBuilder will handle updates.
          });
        },
        tooltip: "Add Election",
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary,),
      ),
    );
  }
}