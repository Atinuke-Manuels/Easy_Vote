import 'package:easy_vote/screens/mobile_screens/auth/login_option_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../web_screens/web_auth/web_login_option_screen.dart';

class LoginOptionScreenLayout extends StatelessWidget {
  const LoginOptionScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) =>  const LoginOptionScreen(),
      tablet: (BuildContext context) =>  const WebLoginOptionScreen(),
    );
  }
}
