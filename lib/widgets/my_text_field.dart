// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  String? Function(String? value)? validator;

  MyTextField({
    super.key,
    required this.hint,
    required this.obscureText,
    required this.validator,
    required this.controller,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();

    obscureText = widget.obscureText;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: widget.hint == "password"
            ? Tooltip(
                message: "Visibility",
                child: InkWell(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: obscureText
                      ? Icon(Icons.remove_red_eye_outlined)
                      : Icon(Icons.remove_red_eye),
                ),
              )
            : null,
      ),
    );
  }
}
