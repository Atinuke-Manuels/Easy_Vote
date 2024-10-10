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
                  width: 100, // adjust size as needed
                  height: 100,
                ),
              ),
              SizedBox(height: 60,),
              const Text("Select Login Option"),
              CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminLogin');
                  },
                  child: const Text("Admin - Schedule an election")),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Vote - Cast your vote")),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text('Not registered? Signup',
                    style: AppTextStyles.bodyTextStyle(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
