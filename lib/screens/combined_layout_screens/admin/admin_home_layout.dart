import 'package:easy_vote/screens/mobile_screens/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminHomeLayout extends StatelessWidget {
  const AdminHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  AdminHomeScreen(),
      tablet: (BuildContext context) =>  AdminHomeScreen(),
    );
  }
}
