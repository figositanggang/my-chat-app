import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_chat_app/firebase/firebase_authentication_helper.dart';
import 'package:my_chat_app/firebase/firebase_firestore_helper.dart';
import 'package:my_chat_app/firebase/firebase_storage_helper.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/screen/login_screen.dart';
import 'package:my_chat_app/screen/welcome_screen.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  late Stream<DocumentSnapshot<Map<String, dynamic>>> getUser;

  @override
  void initState() {
    super.initState();

    getUser = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .snapshots();
  }

  // Sign Out
  signOut() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ingin Keluar?"),
          actions: [
            MyButton(
              child: Text("Ya"),
              tooltip: "Keluar",
              onPressed: () {
                FirebaseAuthenticationHelper.signOut().then(
                  (value) async {
                    await Future.delayed(Duration(seconds: 1));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil Keluar"),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                        context, "welcome", (route) => false);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor.withOpacity(.5),
        elevation: 0,
        title: Text("Pengaturan"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: getUser,
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: BoxDecoration(
                      color: lightBlue.withOpacity(.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              );
            }

            // Loading Selesai
            else {
              // Ada Data
              if (snapshot.hasData) {
                final UserModel user = UserModel.fromSnap(snapshot.data!);

                return _profileScreen(user);
              }

              // Tidak Ada Data
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text("Tidak Ada User"),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget Ada Data
  Widget _profileScreen(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner
        AspectRatio(
          aspectRatio: user.photoUrl.isNotEmpty
              ? NetworkImage(user.photoUrl).scale * 2
              : NetworkImage(
                          "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg")
                      .scale *
                  2,
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                top: 0,
                child: GestureDetector(
                  child: Image.network(
                    user.photoUrl.isNotEmpty
                        ? user.photoUrl
                        : "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg",
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(.5),
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Material(
                          color: scaffoldBackgroundColor,
                          child: InteractiveViewer(
                            trackpadScrollCausesScale: true,
                            child: Image.network(
                              user.photoUrl.isNotEmpty
                                  ? user.photoUrl
                                  : "https://i.ytimg.com/vi/2otuSepwPvY/maxresdefault.jpg",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: IconButton(
                  tooltip: "Ubah Gambar",
                  icon: Icon(Icons.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue.withOpacity(.25),
                    foregroundColor: Colors.white.withOpacity(.75),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(),
                      barrierDismissible: false,
                    );

                    await FirebaseStorageHelper.pickImage(
                      platform: Theme.of(context).platform,
                      currentUserId: currentUser.uid,
                    );

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),

        // Akun
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Akun
            Container(
              color: lightBlue.withOpacity(.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title("Akun"),
                  _Item(title: Text(user.email), subtitle: Text("email")),
                  _Item(title: Text(user.username), subtitle: Text("username")),
                  _Item(title: Text(user.name), subtitle: Text("name")),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Pengaturan
            Container(
              color: lightBlue.withOpacity(.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title("Pengaturan"),

                  // Ubah Data
                  Tooltip(
                    message: "Ubah Data",
                    child: _Item(
                      leading: Icon(Icons.edit, color: lightBlue),
                      title: Text("Ubah Data"),
                      onTap: () {},
                    ),
                  ),

                  // Keluar
                  Tooltip(
                    message: "Keluar",
                    child: _Item(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text(
                        "Keluar",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _Title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Text(
        text,
        style: TextStyle(
          color: lightBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _Item({
    Widget? subtitle,
    Widget? leading,
    required Widget title,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          leading: leading ?? null,
          title: title,
          subtitle: subtitle ?? null,
          subtitleTextStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(.25),
          ),
          onTap: onTap ?? null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            height: 0,
            color: Colors.white.withOpacity(.1),
          ),
        ),
      ],
    );
  }
}
