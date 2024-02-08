import 'package:chat_app_2/common/Widgets/custom_button.dart';
import 'package:chat_app_2/features/auth/repository/auth_repository.dart';
import 'package:chat_app_2/common/utils/colors.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  String code = 'Code';

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  void pickCountry() async {
    final picked =
        await countryPicker.showPicker(context: context, fullScreen: true);
    if (picked != null) {
      setState(() {
        code = picked.dialCode;
      });
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!(value.length == 10)) {
      return 'Please enter a valid phone number';
    } else if (code == 'Code') {
      return 'Please select a Country Code';
    }
    return null; // Return null if the input is valid
  }

  void _sendPhoneNumber() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired actions
      String phoneNumber = code + phoneNumberController.text;
      sendPhoneNumber(context, phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appBarColor,
        toolbarHeight: size.height / 12,
        title: const Text(
          'Login',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height / 10),
            const Text(
              'Please enter your Phone Number',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: pickCountry,
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 63,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: const BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text(
                      code,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      validator: _validatePhoneNumber,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height / 10),
            CustomButton(
              text: 'Next',
              onPressed: _sendPhoneNumber,
              size: size,
            )
          ],
        ),
      ),
    );
  }
}
