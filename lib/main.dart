import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/models/user_model.dart';
import 'package:chat_app_2/firebase_options.dart';
import 'package:chat_app_2/screens/landing_screen.dart';
import 'package:chat_app_2/screens/mobile_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UserModel? user = await getCurrentUserData();
  runApp(
    MaterialApp(
      home: user == null ? LandingScreen() : MobileLayoutScreen(),
    ),
  );
}