import 'package:easy_vote/constants/app_text_styles.dart';
import 'package:easy_vote/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/mobile_screens/auth/login_option_screen.dart';
import '../themes/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface, // Match drawer background with theme
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/evbg1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Logo
                DrawerHeader(
                  decoration: BoxDecoration(
                    // color: theme.colorScheme.onPrimaryFixed.withOpacity(0.8), // Background for drawer header
                  ),
                  child: Center(
                    child: Image.asset(
                      themeProvider.logoAsset,
                      width: 100, // Adjust size as needed
                      height: 100,
                    ),
                  ),
                ),

                // Switch Mode ListTile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    title: Text("Switch Mode",
                        style: AppTextStyles.bodyTextStyle(context)),
                    leading: CupertinoSwitch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        }),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                ),
              ],
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              child: GestureDetector(
                onTap: () {
                  logout(context);
                },
                child: ListTile(
                  title: Text("L O G O U T",
                      style: AppTextStyles.bodyTextStyle(context)),
                  leading: Icon(
                    Icons.logout,
                    color: theme.colorScheme.error,
                  ),
                  onTap: () {
                    logout(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
          title: Text("Logout", style: AppTextStyles.headingStyle(context), textAlign: TextAlign.center,), // Use heading style for title
          content: Text("Are you sure you want to logout?",
              style: AppTextStyles.bodyTextStyle(context)), // Use body style for content
          actions: [
            TextButton(
              onPressed: () {
                // Cancel the logout and close the dialog
                Navigator.of(context).pop();
              },
              child: Text("No", style: AppTextStyles.bodyTextStyle(context)),
            ),
            TextButton(
              onPressed: () {
                // Proceed with logout
                final auth = FirebaseService();
                auth.signOut();

                // Navigate to the login screen and remove previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginOptionScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text("Yes", style: AppTextStyles.bodyTextStyle(context)),
            ),
          ],
        );
      },
    );
  }
}
