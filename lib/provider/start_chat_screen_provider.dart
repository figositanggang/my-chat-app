import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StartChatScreenProvider extends ChangeNotifier {
  QuerySnapshot<Map<String, dynamic>>? _users;
  QuerySnapshot<Map<String, dynamic>>? get users => this._users;

  set users(value) {
    this._users = value;
    notifyListeners();
  }
}
