import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/screen/chatting_screen.dart';

import 'package:my_chat_app/widgets/chat_list_tile.dart';
import 'package:my_chat_app/widgets/my_loading.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers;

  User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    getAllUsers = FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: currentUser.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          IconButton(
            tooltip: "Pengaturan",
            icon: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Icon(Icons.circle_outlined);
                } else {
                  UserModel user = UserModel.fromSnap(snapshot.data!);

                  if (snapshot.hasData && user.photoUrl.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/id/a/a3/JKT48_High_Tension_Cover.jpg"),
                    );
                  }
                }
              },
            ),
            onPressed: () {
              Navigator.pushNamed(context, "profile");
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: getAllUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: MyLoading(),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = UserModel.fromSnap(users[index]);

                return ChatListTile(
                  otherId: user.uid,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChattingScreen(otherUser: user),
                      ),
                    );
                  },
                );
              },
            );
          }

          return Center(
            child: Text("Belum ada chat"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Tambah teman",
        onPressed: () {
          Navigator.pushNamed(context, "start-chat");
        },
      ),
    );
  }
}
