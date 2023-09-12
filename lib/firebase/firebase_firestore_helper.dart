import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chat_app/models/user_model.dart';

class FirebaseFirestoreHelper {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  // Get All Users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firebaseFirestore.collection("users").snapshots();
  }

  // Get Any User Detail
  static Future<UserModel?> getAnyUserDetails(String uid) async {
    late DocumentSnapshot<Map<String, dynamic>> snap;
    late UserModel user;

    try {
      snap = await _firebaseFirestore.collection("users").doc(uid).get();

      await Future.delayed(Duration(seconds: 1));
      user = UserModel.fromSnap(snap);
    } on FirebaseAuthException catch (e) {
      print("EROOOOOOOOOOOR: $e");

      return null;
    }

    return user;
  }

  // Update Photo Url
  static Future updatePhotoUrl({
    required String currentUserId,
    required String photoUrl,
  }) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(currentUserId)
          .update({"photoUrl": photoUrl});

      print("Berhasil Ubah Photo URL");
    } on FirebaseAuthException catch (e) {
      print("ERRRROR: $e");
    }
  }
}
