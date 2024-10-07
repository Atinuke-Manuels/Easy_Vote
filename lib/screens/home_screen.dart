import 'package:easy_vote/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../models/election.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Elections"),
      actions: [
        IconButton(onPressed: (){
          final authService = FirebaseService();
          authService.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }, icon: const Icon(Icons.exit_to_app_outlined))
      ],
      ),
      body: StreamBuilder<List<Election>>(
        stream: _firebaseService.fetchElections(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<Election>? elections = snapshot.data;
          return ListView.builder(
            itemCount: elections?.length,
            itemBuilder: (context, index) {
              Election election = elections![index];
              return ListTile(
                title: Text(election.title),
                subtitle: Text("Ends on: ${election.endTime.toLocal()}"),
                onTap: () {
                  Navigator.pushNamed(context, '/election', arguments: election);
                },
              );
            },
          );
        },
      ),
    );
  }
}
