import 'package:flutter/material.dart';
import 'dart:async';

import 'package:plantdoc/pages/camera.dart';
import 'package:plantdoc/pages/fourm.dart';
import 'package:plantdoc/pages/home.dart';
import 'package:plantdoc/pages/profile.dart';
import 'package:plantdoc/pages/map.dart';

vimansa/Diagnosis-Result-Screen
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(myApp());

void main() {
  runApp(const MyApp());
 main
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plant Doc",
      home: const SplashScreen(),
    );
  }
}

vimansa/Diagnosis-Result-Screen
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Map(),
    const Camera(),
    const fourm(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
main
      ),
    );
  }
}