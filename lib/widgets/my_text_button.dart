// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/resources/my_theme.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final String tooltip;
  var padding;
  var bgColor;
  var border;

  MyButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.tooltip,
    EdgeInsetsGeometry? this.padding,
    Color? this.bgColor,
    OutlinedBorder? this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      return CupertinoButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          backgroundColor: bgColor ?? blue,
          shape:
              border ?? RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
