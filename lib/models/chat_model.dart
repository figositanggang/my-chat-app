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
  final Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.timestamp,
    required this.senderId,
  });

  Map<String, dynamic> toMap() => {
        "senderId": this.senderId,
        "message": this.message,
        "timestamp": this.timestamp,
      };

  factory MessageModel.fromSnap(Map<String, dynamic> snapshot) {
    // var snap = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      senderId: snapshot['senderId'],
      message: snapshot['message'],
      timestamp: snapshot['timestamp'],
    );
  }
}
