import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase/firebase_authentication_helper.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/widgets/my_text_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> key;
  late TextEditingController email;
  late TextEditingController username;
  late TextEditingController name;
  late TextEditingController password;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    key = GlobalKey<FormState>();
    email = TextEditingController();
    username = TextEditingController();
    name = TextEditingController();
    password = TextEditingController();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    email.dispose();
    username.dispose();
    name.dispose();
    password.dispose();
  }

  // Register
  register() async {
    setState(() {
      loading = true;
    });

    String res = await FirebaseAuthenticationHelper.register(
      email: email.text,
      username: username.text,
      name: name.text,
      password: password.text,
      photoUrl: "",
    );

    setState(() {
      loading = false;
    });

    if (res == "success") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register Berhasil")));
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
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, "/", (route) => false),
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
                  "Register",
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
                          hint: "username",
                          obscureText: false,
                          controller: username,
                        ),
                        SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masih Kosong";
                            }

                            return null;
                          },
                          hint: "name",
                          obscureText: false,
                          controller: name,
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

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            tooltip: "Daftar",
                            child: loading
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: LinearProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("Daftar"),
                            padding: EdgeInsets.symmetric(vertical: 25),
                            onPressed: loading
                                ? null
                                : () {
                                    if (key.currentState!.validate()) {
                                      register();
                                    }
                                  },
                          ),
                        ),

                        // Sudah Punya Akun
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Sudah punya akun?"),
                            SizedBox(width: 5),
                            InkWell(
                              child: Text(
                                "Masuk",
                                style: TextStyle(color: lightBlue),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "login");
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
