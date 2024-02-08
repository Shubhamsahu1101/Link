import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/features/auth/screens/login_screen.dart';
import 'package:chat_app_2/common/utils/colors.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  void navigateToLoginScreen() {
    push(context: context, screen: () => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: size.height / 18),
              const Text(
                'Welcome to Link',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height / 9),
              Image.asset(
                'assets/logo1.png',
                color: appBarColor,
                height: size.width * 0.9,
                width: size.width * 0.9,
              ),
              SizedBox(height: size.height / 9),
              const Text(
                'Read our Privacy Policy. Tap "Agree and Continue" to accept terms and conditions',
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.75,
                height: 50,
                child: ElevatedButton(
                  onPressed: navigateToLoginScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                  ),
                  child: const Text(
                    'Agree and Continue',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
