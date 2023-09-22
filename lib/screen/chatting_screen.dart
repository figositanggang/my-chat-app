// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/provider/chatting_screen_provider.dart';
import 'package:provider/provider.dart';

import 'package:my_chat_app/firebase/chat_methods.dart';
import 'package:my_chat_app/firebase/firebase_firestore_helper.dart';
import 'package:my_chat_app/models/chat_model.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/provider/profile_screen_provider.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/widgets/chat_buble.dart';
import 'package:my_chat_app/widgets/my_loading.dart';

class ChattingScreen extends StatefulWidget {
  final UserModel otherUser;

  const ChattingScreen({super.key, required this.otherUser});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  late GlobalKey<FormState> formKey;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> getChat;
  late Future<UserModel?> getUser;
  late ProfileScreenProvider profileScreenProvider;
  ScrollController scrollController = ScrollController();

  final GlobalKey listViewKey = GlobalKey();

  final currentUser = FirebaseAuth.instance.currentUser!;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    profileScreenProvider =
        Provider.of<ProfileScreenProvider>(context, listen: false);
    getUser = FirebaseFirestoreHelper.getAnyUserDetails(widget.otherUser.uid);

    getChat = FirebaseFirestore.instance
        .collection("chats")
        .doc("${currentUser.uid}-${widget.otherUser.uid}")
        .snapshots();

    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel otherUser = widget.otherUser;

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Text(otherUser.name),
          actions: [
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  otherUser.photoUrl.isEmpty
                      ? "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg"
                      : otherUser.photoUrl,
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
        body: Stack(
          children: [
            // Semua Chat
            Positioned.fill(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kToolbarHeight + 10),
                child: StreamBuilder(
                  stream: getChat,
                  builder: (context, snapshot) {
                    // Waiting
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: MyLoading(),
                      );
                    } else {
                      // Ada chat
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        final snap = snapshot.data!;

                        ChatModel chat = ChatModel.fromSnap(snap);
                        List messages = chat.messages;

                        var group = groupBy(messages, (data) => data['date']);
                        List<int> temp = [];
                        List<int> indexes = [];
                        group.values.forEach((element) {
                          temp.add(element.length);
                        });

                        for (var i = 0; i < temp.length; i++) {
                          for (var j = i + 1; j < temp.length; j++) {
                            indexes.add(messages.length - temp[j] + 1);
                          }
                        }

                        temp = temp.reversed.toList();

                        for (var i = 0; i < temp.length; i++) {
                          for (var j = i + 1; j < temp.length; j++) {
                            indexes.add(messages.length - temp[i] - temp[j]);
                          }
                        }

                        indexes = indexes.reversed.toList();

                        for (var i = 0; i < indexes.length; i++) {
                          int index = indexes[i];
                          messages.insert(
                              index,
                              MessageModel(
                                message: '',
                                senderId: '',
                                date: messages[index]['date'],
                                time: '',
                              ).toMap());
                        }

                        Future.delayed(Duration(milliseconds: 250), () {
                          try {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                            );
                          } catch (e) {}
                        });

                        return ListView.builder(
                          key: listViewKey,
                          controller: scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            MessageModel message =
                                MessageModel.fromSnap(messages[index]);

                            // Return Chat
                            if (message.senderId != '') {
                              return Align(
                                alignment: message.senderId == currentUser.uid
                                    ? Alignment.topRight
                                    : message.senderId == ''
                                        ? Alignment.center
                                        : Alignment.topLeft,
                                child: ChatBubble(
                                  currentUserId: currentUser.uid,
                                  message: message,
                                ),
                              );
                            }

                            // Return Date
                            else {
                              return Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: blue.withOpacity(.1),
                                ),
                                child: Text(
                                  message.date,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.75)),
                                ),
                              );
                            }
                          },
                        );

                        // return Text("aw");
                      }

                      // Belum ada chat
                      else {
                        return Center(
                          child: Text(
                            "Belum Ada Chat",
                            style:
                                TextStyle(color: Colors.white.withOpacity(.5)),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),

            // Chat Form
            Positioned(
              bottom: 0,
              left: 0,
              child: Form(
                key: formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ChatForm(context),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ChatForm(BuildContext context) {
    final provider = Provider.of<ChattingScreenProvider>(context);

    return TextFormField(
      obscureText: false,
      maxLines: null,
      controller: provider.chatController,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.zero,
        hintText: "Ketik pesan",
        suffixIcon: Tooltip(
          message: provider.chatController.text.isNotEmpty ? "Kirim" : "",
          child: InkWell(
            child: Icon(
              Icons.send,
              color: lightBlue,
            ),
            onTap: () async {
              if (provider.chatController.text.isNotEmpty) {
                if (formKey.currentState!.validate()) {
                  String message = provider.chatController.text;
                  provider.chatController.text = "";

                  await ChatMethods.sendMessage(
                    currentUserId: currentUser.uid,
                    otherId: widget.otherUser.uid,
                    message: message,
                  ).then(
                    (value) => Future.delayed(Duration(milliseconds: 250), () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    }),
                  );
                }
              }
            },
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(.5)),
        ),
      ),
    );
  }
}
