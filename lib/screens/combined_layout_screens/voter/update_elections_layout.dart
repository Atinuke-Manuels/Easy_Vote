import 'package:easy_vote/screens/mobile_screens/voter/update_elections_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../models/election.dart';

class UpdateElectionsLayout extends StatelessWidget {
  const UpdateElectionsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  UpdateElectionScreen(election: Election(id: '', title: '', candidates: [], startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 7)), registeredVoters: [])),
      tablet: (BuildContext context) =>  UpdateElectionScreen(election: Election(id: '', title: '', candidates: [], startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 7)), registeredVoters: [])),
    );
  }
}
