import 'package:easy_vote/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_styles.dart';
import '../../../themes/theme_provider.dart';


class WebLoginOptionScreen extends StatelessWidget {
  const WebLoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,

      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/evbg1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              reverse: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      themeProvider.logoAsset,
                      width: 220, // adjust size as needed
                      height: 220,
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
                      child: const Text("Voter - Cast your vote",)),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not Registered?",
                          style: AppTextStyles.webSmallBodyTextStyle(context)),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Sign Up',
                            style: AppTextStyles.webSmallBodyTextStyle(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
