import 'package:chat_app_2/common/widgets/loader.dart';
import 'package:chat_app_2/common/utils/colors.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/features/chat/widgets/bottom_chat_field.dart';
import 'package:chat_app_2/features/chat/widgets/chat_list.dart';
import 'package:chat_app_2/features/call/repository/call_repository.dart';
import 'package:flutter/material.dart';

class MobileChatScreen extends StatelessWidget {
  final String name;
  final String uid;
  final String profilePic;
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.profilePic,
  });

  void makeCallFinal(BuildContext context) {
    makeCall(context, name, uid, profilePic);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height / 12,
        backgroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        title: StreamBuilder<bool>(
          stream: userData(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Column(
              children: [
                Text(name),
                Text(
                  snapshot.data! ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: snapshot.data! ? Colors.green : Colors.red,
                    fontSize: 15,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => makeCallFinal(context),
            icon: const Icon(Icons.videocam_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverUserId: uid),
          ),
          BottomChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}
