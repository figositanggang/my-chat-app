// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_chat_app/models/chat_model.dart';
import 'package:my_chat_app/resources/my_theme.dart';

class ChatBubble extends StatefulWidget {
  final MessageModel message;
  final String currentUserId;

  ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final MessageModel message = widget.message;

    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.25),
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: message.senderId == widget.currentUserId
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(message.message),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: message.senderId == widget.currentUserId
                  ? blue.withOpacity(.5)
                  : blue.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.5),
                  blurRadius: 7,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
            child: Text(
              "${message.time}",
              style: TextStyle(
                color: Colors.white.withOpacity(.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
