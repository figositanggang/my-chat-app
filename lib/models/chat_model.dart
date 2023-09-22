import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final List messages;

  ChatModel({
    required this.messages,
  });

  Map<String, dynamic> toMap() => {
        "messages": this.messages,
      };

  static ChatModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return ChatModel(
      messages: snap['messages'],
    );
  }
}

class MessageModel {
  final senderId;
  final String message;
  final String date;
  final String time;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
        "senderId": this.senderId,
        "message": this.message,
        "date": this.date,
        "time": this.time,
      };

  factory MessageModel.fromSnap(Map<String, dynamic> snapshot) {
    // var snap = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      senderId: snapshot['senderId'],
      message: snapshot['message'],
      date: snapshot['date'],
      time: snapshot['time'],
    );
  }
}
