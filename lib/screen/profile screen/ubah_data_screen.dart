import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_authentication_helper.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/widgets/my_loading.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';

class UbahDataScreen extends StatefulWidget {
  final UserModel user;
  const UbahDataScreen({super.key, required this.user});

  @override
  State<UbahDataScreen> createState() => _UbahDataScreenState();
}

class _UbahDataScreenState extends State<UbahDataScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Data"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Form
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Form(
                key: key,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    // Email
                    ListTile(
                      title: Text("Email"),
                      subtitle: MyTextField(
                        hint: user.email,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Tidak boleh kosong...";
                          }

                          return null;
                        },
                        controller: email,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Username
                    ListTile(
                      title: Text("Username"),
                      subtitle: MyTextField(
                        hint: user.username,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Tidak boleh kosong...";
                          }

                          return null;
                        },
                        controller: username,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Submit Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MyButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            ubahData();
                          }
                        },
                        child: Text("Ubah"),
                        tooltip: '',
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ubahData() async {
    String res = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: MyLoading(),
      ),
    );

    try {
      await currentUser.updateEmail(email.text);
      await FirebaseAuthenticationHelper.signOut(context);

      res = 'success';
    } on FirebaseAuthException catch (_) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Ada error silahkan login ulang"),
          actions: [
            MyButton(
              onPressed: () async {
                await FirebaseAuthenticationHelper.signOut(context);
              },
              child: Text("Oke"),
              tooltip: '',
            ),
            MyButton(
              bgColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
              tooltip: '',
            ),
          ],
        ),
      );
    }
  }
}
