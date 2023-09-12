import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_chat_app/resources/my_theme.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LoadingAnimationWidget.prograssiveDots(
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
