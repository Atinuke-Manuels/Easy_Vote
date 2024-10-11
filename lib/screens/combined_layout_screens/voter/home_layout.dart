import 'package:easy_vote/screens/mobile_screens/voter/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  const HomeScreen(voterId: '', registeredElections: [],),
      tablet: (BuildContext context) =>  const HomeScreen(voterId: '', registeredElections: [],),
    );
  }
}
