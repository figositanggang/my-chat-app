import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_chat_app/models/chat_model.dart';

class ChatMethods {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send Message
  static Future<void> sendMessage({
    required String currentUserId,
    required String otherId,
    required String message,
  }) async {
    String chatId1 = "${currentUserId}-${otherId}";
    String chatId2 = "${otherId}-${currentUserId}";

    DocumentSnapshot<Map<String, dynamic>> chatSnap1 =
        await _firebaseFirestore.collection("chats").doc(chatId1).get();
    DocumentSnapshot<Map<String, dynamic>> chatSnap2 =
        await _firebaseFirestore.collection("chats").doc(chatId2).get();

    DateTime now = DateTime.now();

    String date = "${now.year}-${now.month}-${now.day}";
    String time = "${now.hour}:${now.minute}";

    // Chat Kosong
    if (chatSnap1.data() == null) {
      try {
        await _firebaseFirestore.collection("chats").doc(chatId1).set(
              ChatModel(
                messages: [
                  MessageModel(
                    message: message,
                    senderId: currentUserId,
                    date: date,
                    time: time,
                  ).toMap(),
                ],
              ).toMap(),
            );
      } catch (e) {}
    }

    // Chat Kosong
    if (chatSnap2.data() == null) {
      try {
        await _firebaseFirestore.collection("chats").doc(chatId2).set(
              ChatModel(
                messages: [
                  MessageModel(
                    message: message,
                    senderId: currentUserId,
                    date: date,
                    time: time,
                  ).toMap(),
                ],
              ).toMap(),
            );
      } catch (e) {}
    }

    // Sudah Pernah Chatting-an
    else {
      DocumentSnapshot<Map<String, dynamic>> snap1 =
          await _firebaseFirestore.collection("chats").doc(chatId1).get();

      var chat1 = ChatModel.fromSnap(snap1);

      List messages = chat1.messages;

      messages.add(MessageModel(
        message: message,
        senderId: currentUserId,
        date: date,
        time: time,
      ).toMap());

      await _firebaseFirestore
          .collection("chats")
          .doc(chatId1)
          .update({"messages": messages});
      await _firebaseFirestore
          .collection("chats")
          .doc(chatId2)
          .update({"messages": messages});
    }
  }
}
