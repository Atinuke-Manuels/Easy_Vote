import 'package:easy_vote/screens/mobile_screens/voter/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResultsLayout extends StatelessWidget {
  const ResultsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  ResultsScreen(),
      tablet: (BuildContext context) =>  ResultsScreen(),
    );
  }
}