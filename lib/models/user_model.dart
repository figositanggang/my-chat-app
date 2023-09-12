import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String name;
  final String password;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.name,
    required this.password,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "email": email,
        "username": username,
        "name": name,
        "password": password,
        "photoUrl": photoUrl,
      };

  factory UserModel.fromSnap(DocumentSnapshot snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      name: snapshot['name'],
      password: snapshot['password'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
