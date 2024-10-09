import 'package:easy_vote/widgets/CustomButton.dart';
import 'package:flutter/material.dart';

import '../../constants/app_text_styles.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Login Option"),
          CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/adminLogin');
              },
              child: const Text("Admin - Schedule an election")),
              SizedBox(height: 20,),
              CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Vote - Cast your vote")),
              const SizedBox(height: 40,),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text('Not registered? Signup', style: AppTextStyles.bodyTextStyle(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
