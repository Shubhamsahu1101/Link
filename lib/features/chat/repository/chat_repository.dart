import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/models/chat_contact.dart';
import 'package:chat_app_2/models/message.dart';
import 'package:chat_app_2/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void _updateContact({
  required UserModel senderUser,
  required UserModel recieverUser,
  required String text,
  required DateTime timeSent,
  required String recieverUserId,
}) async {
  // users -> reciever user id => chats -> current user id -> set data
  var recieverChatContact = ChatContact(
    name: senderUser.name,
    profilePic: senderUser.profilePic,
    contactId: senderUser.uid,
    timeSent: timeSent,
    lastMessage: text,
  );
  await firestore
      .collection('users')
      .doc(recieverUserId)
      .collection('chats')
      .doc(auth.currentUser!.uid)
      .set(recieverChatContact.toMap());

  // users -> current user id  => chats -> reciever user id -> set data
  var senderChatContact = ChatContact(
    name: recieverUser.name,
    profilePic: recieverUser.profilePic,
    contactId: recieverUser.uid,
    timeSent: timeSent,
    lastMessage: text,
  );
  await firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('chats')
      .doc(recieverUserId)
      .set(senderChatContact.toMap());
}

void _updateChats({
  required String senderUserId,
  required String recieverUserId,
  required String text,
  required DateTime timeSent,
  required String messageId,
}) async {
  final message = Message(
    senderId: senderUserId,
    recieverid: recieverUserId,
    text: text,
    timeSent: timeSent,
    messageId: messageId,
  );
  // users -> sender id -> reciever id -> messages -> message id -> store message
  await firestore
      .collection('users')
      .doc(senderUserId)
      .collection('chats')
      .doc(recieverUserId)
      .collection('messages')
      .doc(messageId)
      .set(message.toMap());
  // users -> reciever id  -> sender id -> messages -> message id -> store message
  await firestore
      .collection('users')
      .doc(recieverUserId)
      .collection('chats')
      .doc(senderUserId)
      .collection('messages')
      .doc(messageId)
      .set(message.toMap());
}

void sendTextMessage({
  required BuildContext context,
  required String text,
  required String recieverUserId,
  required UserModel senderUser,
}) async {
  try {
    var timeSent = DateTime.now();
    UserModel? recieverUser;

    var userDataMap =
        await firestore.collection('users').doc(recieverUserId).get();
    recieverUser = UserModel.fromMap(userDataMap.data()!);

    var messageId = const Uuid().v1();

    _updateChats(
        senderUserId: auth.currentUser!.uid,
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId);

    _updateContact(
        senderUser: senderUser,
        recieverUser: recieverUser,
        text: text,
        timeSent: timeSent,
        recieverUserId: recieverUserId);
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

Stream<List<ChatContact>> getChatContacts() {
  return firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('chats')
      .snapshots()
      .asyncMap((event) async {
    List<ChatContact> contacts = [];
    for (var doc in event.docs) {
      var chatContact = ChatContact.fromMap(doc.data());
      var userData =
          await firestore.collection('users').doc(chatContact.contactId).get();
      var user = UserModel.fromMap(userData.data()!);

      contacts.add(
        ChatContact(
          name: user.name,
          profilePic: user.profilePic,
          contactId: chatContact.contactId,
          timeSent: chatContact.timeSent,
          lastMessage: chatContact.lastMessage,
        ),
      );
    }
    return contacts;
  });
}

Stream<List<Message>> getChatStream(String recieverUserId) {
  return firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('chats')
      .doc(recieverUserId)
      .collection('messages')
      .orderBy('timeSent')
      .snapshots()
      .map((event) {
    List<Message> messages = [];
    for (var document in event.docs) {
      messages.add(Message.fromMap(document.data()));
    }
    return messages;
  });
}

void setUserState(bool isOnline) async {
  await firestore.collection('users').doc(auth.currentUser!.uid).update({
    'isOnline': isOnline,
  });
}
