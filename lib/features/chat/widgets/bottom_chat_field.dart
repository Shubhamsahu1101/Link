import 'package:chat_app_2/common/utils/colors.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/features/chat/repository/chat_repository.dart';
import 'package:flutter/material.dart';

class BottomChatField extends StatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    super.key,
    required this.recieverUserId,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void sendTextMessageFinal() async {
    if (_messageController.text == '') {
      return;
    }
    sendTextMessage(
      context: context,
      text: _messageController.text.trim(),
      recieverUserId: widget.recieverUserId,
      senderUser: currentUser!,
    );
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: appBarColor,
              hintText: 'Type here!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 2,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: isShowSendButton ? Colors.green : appBarColor,
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessageFinal,
              child: const Icon(
                Icons.send,
                color: iconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
