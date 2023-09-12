import 'package:flutter/foundation.dart';

class ChattingScreenProvider extends ChangeNotifier {
  bool _isChatting = false;
  bool get isChatting => this._isChatting;

  set isChatting(bool value) => this._isChatting = value;
}
