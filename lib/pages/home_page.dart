import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/modules/classes.dart';
import 'package:travel_app/pages/find_places.dart';
import 'package:travel_app/pages/places.dart';

import '../modules/database.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static User user = FirebaseAuth.instance.currentUser!;
  final Stream<User?> firebaseUserChanges = FirebaseAuth.instance.userChanges();
  int _selectedIndex = 0;
  DataBaseHelper database = DataBaseHelper();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    const FindFriends(),
    const PlacesPage(),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('signed is as: ${user.email}')),
        MaterialButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.app.delete();
          },
          color: Colors.deepPurple[200],
          child: const Text('sign out'),
        )
      ],
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        user = event;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelApp'),
        backgroundColor: Colors.deepPurple[200],
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Clean all')),
            ],
          ),
        ],
      ),
      body: Scaffold(body: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            backgroundColor: Colors.deepPurple[200],
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.place),
            backgroundColor: Colors.deepPurple[200],
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            backgroundColor: Colors.deepPurple[200],
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[200],
        onTap: _onItemTapped,
      ),
    );
  }

  void handleClick(BuildContext context, item) {
    switch (item) {
      case 0:
        promptCleanAllData(context);
      case 1:
        break;
    }
  }

  Future<bool?> promptCleanAllData(BuildContext lastContext) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure do you want to delete all the data?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This action cannot be undone'),
                Text('If you sure, press delete, otherwise, cancel.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Not, don't delete it all"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes!'),
              onPressed: () {
                Provider.of<PlaceNotifier>(lastContext, listen: false)
                    .cleanDatabase();
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
    // In case the user dismisses the dialog by clicking away from it
  }
}
