import 'package:easy_vote/screens/mobile_screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreenLayout extends StatelessWidget {
  const LoginScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  const LoginScreen(),
      tablet: (BuildContext context) =>  const LoginScreen(),
    );
  }
}