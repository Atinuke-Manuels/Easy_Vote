import 'package:easy_vote/screens/mobile_screens/voter/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../web_screens/web_voter/web_results_screen.dart';

class ResultsLayout extends StatelessWidget {
  const ResultsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String? electionId = args is String ? args : null;

    if (electionId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Election ID not found.'),
        ),
      );
    }

    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => ResultsScreen(electionId: electionId),
      tablet: (BuildContext context) => WebResultsScreen(electionId: electionId),
    );
  }
}
