import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/models/user_model.dart';

class FirebaseAuthenticationHelper {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  // Login
  static Future<String> login(
      {required String email, required String password}) async {
    String res = "error";

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      res = e.code;
    }

    return res;
  }

  // Register
  static Future<String> register({
    required String email,
    required String username,
    required String name,
    required String password,
    required String photoUrl,
  }) async {
    String res = 'error';

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(UserModel(
            uid: userCredential.user!.uid,
            email: email,
            username: username,
            name: name,
            password: password,
            photoUrl: photoUrl,
          ).toMap());

      res = 'success';
    } on FirebaseAuthException catch (e) {
      res = e.code;
    }

    return res;
  }

  // Sign Out
  static Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthChanges(),
        ),
        (route) => false);
  }
}
