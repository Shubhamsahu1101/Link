import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app_2/common/widgets/loader.dart';
import 'package:chat_app_2/agora_config.dart';
import 'package:chat_app_2/features/call/repository/call_repository.dart';
import 'package:chat_app_2/models/call.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final Call call;
  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
  });

  @override
  State<StatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: ElevatedButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        endCall(
                          context,
                          widget.call.callerId,
                          widget.call.receiverId,
                        );
                      },
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
