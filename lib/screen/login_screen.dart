import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_authentication_helper.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/screen/register_screen.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> key;
  late TextEditingController email;
  late TextEditingController password;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    key = GlobalKey<FormState>();
    email = TextEditingController();
    password = TextEditingController();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    email.dispose();
    password.dispose();
  }

  // Login
  login() async {
    setState(() {
      loading = true;
    });

    String res = await FirebaseAuthenticationHelper.login(
        email: email.text, password: password.text);

    setState(() {
      loading = false;
    });

    if (res == "success") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Berhasil")));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AuthChanges(),
          ),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthChanges(),
                ),
                (route) => false),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Text
                Text(
                  "Masuk",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 30),

                // Form
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masih Kosong";
                            }

                            return null;
                          },
                          hint: "email",
                          obscureText: false,
                          controller: email,
                        ),
                        SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masih Kosong";
                            }

                            return null;
                          },
                          hint: "password",
                          obscureText: true,
                          controller: password,
                        ),
                        SizedBox(height: 5),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            tooltip: "Masuk",
                            child: loading
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: LinearProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("Masuk"),
                            padding: EdgeInsets.symmetric(vertical: 25),
                            onPressed: loading
                                ? null
                                : () {
                                    if (key.currentState!.validate()) {
                                      login();
                                    }
                                  },
                          ),
                        ),
                        SizedBox(height: 5),

                        // Belum Punya Akun
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Belum punya akun?"),
                            SizedBox(width: 5),
                            InkWell(
                              child: Text(
                                "Buat Akun",
                                style: TextStyle(color: lightBlue),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
