import 'package:easy_vote/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_text_styles.dart';
import '../../themes/theme_provider.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    themeProvider.logoAsset,
                    width: 120, // adjust size as needed
                    height: 120,
                  ),
                ),
                SizedBox(height: 60,),
                const Text("Select Login Option"),
                SizedBox(height: 40,),
                CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/adminLogin');
                    },
                    child: const Text("Admin - Schedule an election")),
                SizedBox(
                  height: 30,
                ),
                CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Vote - Cast your vote",)),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not Registered?",
                        style: AppTextStyles.bodyTextStyle(context)),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text('Sign Up',
                          style: AppTextStyles.bodyTextStyle(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

    );
  }
}
