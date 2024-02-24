import 'package:chat_app_2/common/widgets/loader.dart';
import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/features/chat/repository/chat_repository.dart';
import 'package:chat_app_2/features/chat/screens/mobile_chat_screen.dart';
import 'package:chat_app_2/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<ChatContact>>(
              stream: getChatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss')
                        .format(chatContactData.timeSent);

                    return InkWell(
                      onTap: () {
                        push(
                          context: context,
                          screen: () => MobileChatScreen(
                            name: chatContactData.name,
                            uid: chatContactData.contactId,
                            profilePic: chatContactData.profilePic,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            chatContactData.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContactData.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            formattedDateTime,
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
