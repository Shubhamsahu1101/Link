import 'package:chat_app_2/common/utils/colors.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), // Adjust the radius as needed
              topRight: Radius.circular(10), // Adjust the radius as needed
              bottomLeft: Radius.circular(10), // Adjust the radius as needed
            ),
          ),
          color: myMessageColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
