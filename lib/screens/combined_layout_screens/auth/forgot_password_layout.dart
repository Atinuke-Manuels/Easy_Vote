import 'package:easy_vote/screens/mobile_screens/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordLayout extends StatelessWidget {
  const ForgotPasswordLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  ForgotPasswordScreen(),
      tablet: (BuildContext context) =>  ForgotPasswordScreen(),
    );
  }
}
