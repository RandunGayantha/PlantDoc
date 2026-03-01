import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantdoc/pages/camera.dart';
import 'package:plantdoc/pages/fourm.dart';
import 'package:plantdoc/pages/home.dart';
import 'package:plantdoc/pages/profile.dart';
import 'package:plantdoc/pages/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Map(),
    Camera(),
    fourm(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plant Doc",
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Dashbord",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: "Camera",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: "Forum",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_2),
              label: "Profile",
            ),
          ],
        ),
        body: _pages[_currentIndex],
      ),
    );
  }
}