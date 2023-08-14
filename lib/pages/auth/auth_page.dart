import 'package:flutter/material.dart';
import 'package:travel_app/pages/auth/login_page.dart';
import 'package:travel_app/pages/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  static const routeName = 'AuthPage';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggleScrens (){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScrens);
    }
    else {
      return RegisterPage(showLoginPage: toggleScrens);
    }
  }
}
