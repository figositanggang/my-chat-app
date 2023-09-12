import 'package:flutter/material.dart';
import 'package:my_chat_app/models/chat_model.dart';
import 'package:my_chat_app/resources/my_theme.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    String year = message.timestamp.toDate().year.toString();
    String month = message.timestamp.toDate().month.toString();
    String day = message.timestamp.toDate().day.toString();
    String hour = message.timestamp.toDate().hour.toString();
    String minute = message.timestamp.toDate().minute.toString();

    return Container(
      child: Text(message.message),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: blue.withOpacity(.5),
      ),
    );
  }
}
