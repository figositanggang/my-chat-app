// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_firestore_helper.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/provider/profile_screen_provider.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatListTile extends StatefulWidget {
  final String otherId;
  var onTap;

  ChatListTile({super.key, required this.otherId, Function()? this.onTap});

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late Future<UserModel?> getUser;
  late ProfileScreenProvider profileScreenProvider;

  @override
  void initState() {
    super.initState();

    profileScreenProvider =
        Provider.of<ProfileScreenProvider>(context, listen: false);
    getUser = FirebaseFirestoreHelper.getAnyUserDetails(widget.otherId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Container(
                    alignment: Alignment.topLeft,
                    height: 20,
                    color: Colors.red,
                  ),
                ),
                baseColor: blue.withOpacity(.5),
                highlightColor: lightBlue.withOpacity(.5),
              );
            } else {
              if (snapshot.hasData) {
                final UserModel user = snapshot.data!;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg"),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.username),
                  onTap: widget.onTap,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                );
              }

              return ListTile(
                title: Text("Error"),
              );
            }
          },
        ),
        Divider(
          height: 0,
          color: Colors.white.withOpacity(.1),
        ),
      ],
    );
  }
}
