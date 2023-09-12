// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late GlobalKey<FormState> key;
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

    key = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    print("ID: ${currentUser.uid}-${widget.otherUser.uid}");

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(widget.otherUser.name),
          actions: [
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg"),
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

                        Future.delayed(Duration(milliseconds: 500), () {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                          );
                        });

                        return ListView.builder(
                          key: listViewKey,
                          controller: scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            MessageModel message =
                                MessageModel.fromSnap(messages[index]);

                            return Align(
                              alignment: message.senderId == currentUser.uid
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: ChatBubble(
                                message: message,
                              ),
                            );
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
                key: key,
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
                  child: ChatForm(
                    currentUser: currentUser,
                    otherUserId: widget.otherUser.uid,
                    scrollController: scrollController,
                    formKey: key,
                  ),
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
}

class ChatForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final User currentUser;
  final String otherUserId;
  final ScrollController scrollController;

  const ChatForm({
    Key? key,
    required this.formKey,
    required this.currentUser,
    required this.otherUserId,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: false,
      maxLines: null,
      controller: chatController,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.zero,
        hintText: "Ketik pesan",
        suffixIcon: Tooltip(
          message: chatController.text.isNotEmpty ? "Kirim" : "",
          child: InkWell(
            child: Icon(
              Icons.send,
              color: chatController.text.isNotEmpty ? lightBlue : Colors.grey,
            ),
            onTap: chatController.text.isNotEmpty
                ? () async {
                    if (widget.formKey.currentState!.validate()) {
                      await ChatMethods.sendMessage(
                        currentUserId: widget.currentUser.uid,
                        otherId: widget.otherUserId,
                        message: chatController.text,
                      );

                      widget.scrollController.animateTo(
                        widget.scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      );

                      chatController.text = "";

                      setState(() {});
                    }
                  }
                : null,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(.5)),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Tidak boleh kosong...";
        }

        return null;
      },
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
