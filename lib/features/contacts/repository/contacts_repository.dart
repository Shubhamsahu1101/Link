import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/features/chat/screens/mobile_chat_screen.dart';
import 'package:chat_app_2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<Contact>> getContacts() async {
  List<Contact> contacts = [];
  if (await FlutterContacts.requestPermission()) {
    contacts = await FlutterContacts.getContacts(withProperties: true);
  }
  return contacts;
}

void selectContact(Contact selectedContact, BuildContext context) async {
  try {
    var userCollection = await firestore.collection('users').get();
    bool isFound = false;
    String selectedPhoneNum =
        selectedContact.phones[0].number.replaceAll(' ', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll('(', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll(')', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll('-', '');
    if (selectedPhoneNum.length < 13) {
      selectedPhoneNum = '+91$selectedPhoneNum';
    }

    if (selectedPhoneNum.length != 13) {
      showSnackBar(context: context, content: 'Number Invalid');
    } else {
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          push(
            context: context,
            screen: () => MobileChatScreen(
              name: userData.name,
              uid: userData.uid,
              profilePic: userData.profilePic,
            ),
          );
        }
      }
    }

    if (!isFound) {
      showSnackBar(
        context: context,
        content: 'The number $selectedPhoneNum does not exist',
      );
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}
