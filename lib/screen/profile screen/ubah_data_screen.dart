import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_authentication_helper.dart';
import 'package:my_chat_app/widgets/my_loading.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';

class UbahDataScreen extends StatefulWidget {
  final String title;
  final String value;
  const UbahDataScreen({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<UbahDataScreen> createState() => _UbahDataScreenState();
}

class _UbahDataScreenState extends State<UbahDataScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController controller = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      title: Text(widget.title),
                      subtitle: MyTextField(
                        hint: widget.value,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Tidak boleh kosong...";
                          }

                          return null;
                        },
                        controller: controller,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Submit Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MyButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            ubahData(widget.title);
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

  ubahData(String key) async {
    String res = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: MyLoading(),
      ),
    );

    try {
      if (key == "Email") {
        await currentUser.updateEmail(controller.text);
        await firebaseFirestore
            .collection("users")
            .doc(currentUser.uid)
            .update({"email": controller.text});
        await FirebaseAuthenticationHelper.signOut(context);
      } else {
        await firebaseFirestore
            .collection("users")
            .doc(currentUser.uid)
            .update({key.toLowerCase(): controller.text});

        Navigator.pop(context);
      }

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
