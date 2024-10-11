import 'package:easy_vote/screens/mobile_screens/admin/admin_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminLoginLayout extends StatelessWidget {
  const AdminLoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => const AdminLoginScreen(),
      tablet: (BuildContext context) => const AdminLoginScreen(),
    );
  }
}
