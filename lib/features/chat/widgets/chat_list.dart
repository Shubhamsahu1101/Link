import 'package:chat_app_2/common/widgets/loader.dart';
import 'package:chat_app_2/features/chat/repository/chat_repository.dart';
import 'package:chat_app_2/features/chat/widgets/my_chat_card.dart';
import 'package:chat_app_2/features/chat/widgets/sender_chat_card.dart';
import 'package:chat_app_2/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  final String recieverUserId;
  const ChatList({
    super.key,
    required this.recieverUserId,
  });

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: getChatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(messageData.timeSent);

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: formattedDateTime,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: formattedDateTime,
            );
          },
        );
      },
    );
  }
}
