// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final String tooltip;
  var padding;

  MyButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.tooltip,
    EdgeInsetsGeometry? this.padding,
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
        style: padding != null
            ? ElevatedButton.styleFrom(padding: padding)
            : ElevatedButton.styleFrom(),
      ),
    );
  }
}
