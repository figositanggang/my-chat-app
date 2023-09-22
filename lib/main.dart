import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/firebase_options.dart';
import 'package:my_chat_app/provider/chatting_screen_provider.dart';
import 'package:my_chat_app/screen/profile%20screen/profile_screen.dart';
import 'package:my_chat_app/screen/register_screen.dart';
import 'package:my_chat_app/screen/start_chat_screen.dart';
import 'package:my_chat_app/screen/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/main_page.dart';
import 'package:my_chat_app/provider/profile_screen_provider.dart';
import 'package:my_chat_app/provider/start_chat_screen_provider.dart';
import 'package:my_chat_app/resources/my_theme.dart';
import 'package:my_chat_app/screen/login_screen.dart';

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
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => AuthChanges(),
        "home": (context) => MainPage(),
        "welcome": (context) => WelcomeScreen(),
        "profile": (context) => ProfileScreen(),
        "login": (context) => LoginScreen(),
        "register": (context) => RegisterScreen(),
        "start-chat": (context) => StartChatScreen(),
      },
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
