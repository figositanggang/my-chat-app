import 'package:flutter/material.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/screen/login_screen.dart';
import 'package:my_chat_app/screen/register_screen.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scaffoldBackgroundColor,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Selamat Datang di",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "My Chat App",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  MyButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Center(child: Text("Masuk")),
                    tooltip: "Masuk",
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  SizedBox(height: 5),
                  MyButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Center(child: Text("Daftar")),
                    tooltip: "Daftar",
                    padding: EdgeInsets.symmetric(vertical: 20),
                    bgColor: Colors.transparent,
                    border: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
