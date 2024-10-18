import 'package:easy_vote/screens/mobile_screens/admin/election_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../models/election.dart';
import '../../web_screens/web_admin/web_elections_details_screen.dart';

class ElectionDetailsLayout extends StatelessWidget {
  final Election election; // Store the election parameter

  const ElectionDetailsLayout({super.key, required this.election}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => ElectionDetailsScreen(election: election), // Pass the stored election
      tablet: (BuildContext context) => WebElectionDetailsScreen(election: election), // Pass the stored election
    );
  }
}
