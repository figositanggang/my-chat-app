import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user_model.dart';

class ProfileScreenProvider extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => this._currentUser;

  set currentUser(UserModel? value) {
    this._currentUser = value;
    notifyListeners();
  }

  bool _isCurrentUserLoaded = false;
  bool get isCurrentUserLoaded => this._isCurrentUserLoaded;

  set isCurrentUserLoaded(bool value) {
    this._isCurrentUserLoaded = value;
    notifyListeners();
  }
}
