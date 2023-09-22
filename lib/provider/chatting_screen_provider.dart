import 'package:flutter/material.dart';

class ChattingScreenProvider extends ChangeNotifier {
  bool _isChatting = false;
  bool get isChatting => this._isChatting;

  set isChatting(bool value) => this._isChatting = value;

  TextEditingController _chatController = TextEditingController();
  TextEditingController get chatController => this._chatController;

  set chatController(TextEditingController value) {
    this._chatController = value;
    notifyListeners();
  }
}
