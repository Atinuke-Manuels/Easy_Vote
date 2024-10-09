import 'package:easy_vote/constants/app_text_styles.dart';
import 'package:easy_vote/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth/login_option_screen.dart';
import '../themes/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    themeProvider.logoAsset,
                    width: 100, // adjust size as needed
                    height: 100,
                  ),
                ),
              ),

              // home list tile
              // Padding(
              //   padding: const EdgeInsets.only(left: 25),
              //   child: ListTile(
              //     title: Text(
              //       "View Result",
              //       style: AppTextStyles.bodyTextStyle(context)
              //     ),
              //     leading: Icon(
              //       Icons.home,
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //
              //     // to close the drawer
              //     onTap: () {
              //       Navigator.pushNamed(context, '/election');
              //     },
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("Switch Mode",
                      style: AppTextStyles.bodyTextStyle(context)),
                  leading: CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      }),

                  // to close the drawer
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          // logout button
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: GestureDetector(
              onTap: (){
                logout(context);
              },
              child: ListTile(
                title: Text("L O G O U T",
                    style: AppTextStyles.bodyTextStyle(context)),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),

                // to log out
                onTap: (){
                  logout(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel the logout and close the dialog
                Navigator.of(context).pop();
              },
              child: Text("No"),
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
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

}
