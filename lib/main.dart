import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:travel_app/model/map_style.dart';
import 'package:travel_app/pages/auth/auth_page.dart';
import 'package:travel_app/pages/find_places.dart';
import 'package:travel_app/pages/auth/login_page.dart';
import 'package:travel_app/pages/home_page.dart';
import 'package:travel_app/pages/main_page.dart';
import 'package:travel_app/pages/map_circles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_app/pages/place_details_page.dart';
import 'firebase_options.dart';

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
