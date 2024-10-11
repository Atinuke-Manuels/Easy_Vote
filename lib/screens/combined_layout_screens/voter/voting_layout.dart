import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../mobile_screens/voter/voting_screen.dart';

class VotingLayout extends StatelessWidget {
  const VotingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  VotingScreen(),
      tablet: (BuildContext context) =>  VotingScreen(),
    );
  }
}
