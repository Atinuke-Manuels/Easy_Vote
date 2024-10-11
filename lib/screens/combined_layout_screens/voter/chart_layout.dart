import 'package:easy_vote/screens/mobile_screens/voter/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChartLayout extends StatelessWidget {
  final Map<String, int> results;
  const ChartLayout({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  ChartScreen(results: results),
      tablet: (BuildContext context) =>  ChartScreen(results: results),
    );
  }
}
