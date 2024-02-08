import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/features/call/screens/call_screen.dart';
import 'package:chat_app_2/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

Stream<DocumentSnapshot> get callStream =>
    firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

void makeCall(
  BuildContext context,
  String receiverName,
  String receiverUid,
  String receiverProfilePic,
) async {
  String callId = const Uuid().v1();

  Call senderCallData = Call(
    callerId: auth.currentUser!.uid,
    callerName: currentUser!.name,
    callerPic: currentUser!.profilePic,
    receiverId: receiverUid,
    receiverName: receiverName,
    receiverPic: receiverProfilePic,
    callId: callId,
    hasDialled: true,
  );

  Call receiverCallData = Call(
    callerId: auth.currentUser!.uid,
    callerName: currentUser!.name,
    callerPic: currentUser!.profilePic,
    receiverId: receiverUid,
    receiverName: receiverName,
    receiverPic: receiverProfilePic,
    callId: callId,
    hasDialled: false,
  );

  try {
    await firestore
        .collection('call')
        .doc(auth.currentUser!.uid)
        .set(senderCallData.toMap());
    await firestore
        .collection('call')
        .doc(receiverUid)
        .set(receiverCallData.toMap());

    push(
      context: context,
      screen: () => CallScreen(
        channelId: senderCallData.callId,
        call: senderCallData,
      ),
    );
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

void endCall(
  BuildContext context,
  String callerUid,
  String receiverUid,
) async {
  try {
    await firestore.collection('call').doc(callerUid).delete();
    await firestore.collection('call').doc(receiverUid).delete();

    Navigator.of(context).pop();
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}
