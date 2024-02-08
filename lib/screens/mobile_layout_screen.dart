import 'package:chat_app_2/common/utils/colors.dart';
import 'package:chat_app_2/common/utils/utils.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/features/call/screens/call_pickup_screen.dart';
import 'package:chat_app_2/features/chat/repository/chat_repository.dart';
import 'package:chat_app_2/features/chat/widgets/contacts_list.dart';
import 'package:chat_app_2/features/contacts/screens/contacts_screen.dart';
import 'package:flutter/material.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      setUserState(true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          setUserState(true);
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        setState(() {
          setUserState(false);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CallPickupScreen(
      widget: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: size.height / 12,
          backgroundColor: appBarColor,
          surfaceTintColor: appBarColor,
          title: const Text(
            'Link',
            style: TextStyle(
              fontSize: 30,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: iconColor),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    signOut(context);
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ],
        ),
        body: ContactsList(),
        floatingActionButton: FloatingActionButton(
          elevation: 3,
          onPressed: () {
            push(context: context, screen: () => ContactsScreen());
          },
          backgroundColor: appBarColor,
          child: const Icon(
            Icons.comment,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
