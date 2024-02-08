import 'package:chat_app_2/common/utils/colors.dart';
import 'package:chat_app_2/features/contacts/repository/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  Future<void> fetchContacts() async {
    List<Contact> temp = await getContacts();
    setState(() {
      contacts = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height / 12,
        backgroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontSize: 30,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: fetchContacts,
              icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              selectContact(contacts[index], context);
            },
            child: ListTile(title: Text(contacts[index].displayName)),
          );
        },
      ),
    );
  }
}
