import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_firestore_helper.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/widgets/chat_list_tile.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({super.key});

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  List<UserModel> users = [];
  List<UserModel> searchUsers = [];

  late TextEditingController searchController;
  StreamSubscription? usersSubscription;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    usersSubscription = FirebaseFirestoreHelper.getAllUsers().listen(
      (QuerySnapshot snapshot) {
        if (mounted) {
          users = snapshot.docs.map((e) => UserModel.fromSnap(e)).toList();
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    usersSubscription?.cancel();
    super.dispose();
  }

  searchUser(String searchText) {
    try {
      if (searchText.isNotEmpty) {
        List<UserModel> temp = [];
        for (var i = 0; i < users.length; i++) {
          UserModel user = users[i];
          String lowSearchText = searchText.toLowerCase();
          String lowUserName = user.username.toLowerCase();
          String lowName = user.name.toLowerCase();

          if (lowUserName == lowSearchText || lowName == lowSearchText) {
            temp.add(user);
          }
        }

        searchUsers = temp;
      } else {
        searchUsers.clear();
      }
    } catch (e) {
      print("ERROR: $e");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "username atau name...",
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: () {
                searchController.text = "";
                searchUser(searchController.text);
              },
              child: Icon(Icons.close),
            ),
          ),
          onChanged: (value) {
            searchUser(searchController.text);
          },
        ),
      ),
      body: searchUsers.length > 0
          ? ListView.builder(
              itemCount: searchUsers.length,
              itemBuilder: (context, index) {
                UserModel user = searchUsers[index];

                return ChatListTile(otherId: user.uid);
              },
            )
          : Center(),
    );
  }
}
