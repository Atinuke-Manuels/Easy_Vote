import 'package:easy_vote/screens/mobile_screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpLayout extends StatelessWidget {
  const SignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  const SignUpScreen(),
      tablet: (BuildContext context) =>  const SignUpScreen(),
    );
  }
}
