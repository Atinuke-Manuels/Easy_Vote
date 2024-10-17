import 'package:easy_vote/screens/mobile_screens/voter/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../models/election.dart';
import '../../web_screens/web_voter/web_home_screen.dart';

// Update HomeLayout to accept voterId and registeredElections
class HomeLayout extends StatelessWidget {
  final String voterId;
  final List<Election> registeredElections;

  const HomeLayout({
    super.key,
    required this.voterId,
    required this.registeredElections,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => HomeScreen(
        voterId: voterId,
        registeredElections: registeredElections,
      ),
      tablet: (BuildContext context) => WebHomeScreen(
        voterId: voterId,
        registeredElections: registeredElections,
      ),
    );
  }
}

