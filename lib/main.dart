import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase_options.dart';
import 'package:my_chat_app/provider/chatting_screen_provider.dart';
import 'package:my_chat_app/screen/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/main_page.dart';
import 'package:my_chat_app/provider/profile_screen_provider.dart';
import 'package:my_chat_app/provider/start_chat_screen_provider.dart';
import 'package:my_chat_app/resources/my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProfileScreenProvider()),
      ChangeNotifierProvider(create: (context) => StartChatScreenProvider()),
      ChangeNotifierProvider(create: (context) => ChattingScreenProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun App',
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: AuthChanges(),
    );
  }
}

class AuthChanges extends StatelessWidget {
  const AuthChanges({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainPage();
        } else
          return WelcomeScreen();
      },
    );
  }
}
