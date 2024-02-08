import 'dart:io';
import 'package:chat_app_2/features/auth/screens/otp_screen.dart';
import 'package:chat_app_2/features/auth/screens/user_information_screen.dart';
import 'package:chat_app_2/common/repositories/common_firebase_storage_repository.dart';
import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/models/user_model.dart';
import 'package:chat_app_2/screens/landing_screen.dart';
import 'package:chat_app_2/screens/mobile_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
String vId = 'default';
String pN = 'default';
UserModel? currentUser;

void finishLogin(BuildContext context) async {
  var userData =
      await firestore.collection('users').doc(auth.currentUser?.uid).get();
  if (userData.data() != null) {
    currentUser = UserModel.fromMap(userData.data()!);
    pushAndRemoveUntil(context: context, screen: () => MobileLayoutScreen());
  } else {
    pushAndRemoveUntil(context: context, screen: () => UserInformationScreen());
  }
}

Future<UserModel?> getCurrentUserData() async {
  var userData =
      await firestore.collection('users').doc(auth.currentUser?.uid).get();
  if (userData.data() != null) {
    currentUser = UserModel.fromMap(userData.data()!);
  }
  return currentUser;
}

void sendPhoneNumber(BuildContext context, String phoneNumber) async {
  pN = phoneNumber;
  await auth
      .verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        showSnackBar(
            context: context,
            content: 'The provided phone number is not valid.');
      } else {
        showSnackBar(
            context: context, content: e.message ?? "No Error Message");
      }

      // Handle other errors
    },
    codeSent: ((String verificationId, int? resendToken) async {
      vId = verificationId;
      push(
          context: context,
          screen: () => OTPScreen());
    }),
    timeout: const Duration(seconds: 30),
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out...
    },
  )
      .onError(
    (error, stackTrace) {
      showSnackBar(context: context, content: error.toString());
    },
  );
}

void verifyOTP(String userOTP, BuildContext context) async {
  try {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: vId, smsCode: userOTP);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential).then((value) {
      finishLogin(context);
    });
  } on Exception catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

void saveUserDataToFirebase({
  required String name,
  required File? profilePic,
  required BuildContext context,
}) async {
  try {
    String uid = auth.currentUser!.uid;
    String photoUrl =
        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

    if (profilePic != null) {
      photoUrl = await storeFileToFirebase('profilePicture/$uid', profilePic);
    }

    var user = UserModel(
      name: name,
      uid: uid,
      profilePic: photoUrl,
      isOnline: true,
      phoneNumber: pN,
      groupId: [],
    );

    await firestore.collection('users').doc(uid).set(user.toMap());

    pushAndRemoveUntil(
        context: context, screen: () => const MobileLayoutScreen());
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

void signOut(BuildContext context) {
  auth.signOut();
  pushAndRemoveUntil(context: context, screen: () => LandingScreen());
}

Stream<bool> userData(String userId) {
  return firestore
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((event) => event.data()!['isOnline']);
}
