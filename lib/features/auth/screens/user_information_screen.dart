import 'dart:io';
import 'package:chat_app_2/common/widgets/custom_button.dart';
import 'package:chat_app_2/common/utils/colors.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/common/utils/utils.dart';
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      saveUserDataToFirebase(
        name: name,
        profilePic: image,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'User Details',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: appBarColor,
        toolbarHeight: size.height / 12,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png'),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 80,
                  child: Icon(
                    Icons.add_a_photo,
                  ),
                ),
              ],
            ),
            Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
            ),
            SizedBox(height: size.height / 10),
            CustomButton(text: 'Finish', onPressed: storeUserData, size: size),
          ],
        ),
      ),
    );
  }
}
