
import 'package:travel_app/pages/auth/auth_page.dart';
import 'package:travel_app/pages/home_page.dart';
import 'package:travel_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: const MainPage(),

    debugShowCheckedModeBanner: false,
    routes: {
      HomePage.routeName: (context) => const HomePage(),
      AuthPage.routeName: (context) => const AuthPage(),
    },
  ));
}
