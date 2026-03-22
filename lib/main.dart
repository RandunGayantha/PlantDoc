import 'package:flutter/material.dart';
import 'dart:async';

import 'package:plantdoc/pages/camera.dart';
import 'package:plantdoc/pages/fourm.dart';
import 'package:plantdoc/pages/home.dart';
import 'package:plantdoc/pages/map.dart';
import 'package:plantdoc/pages/splash_screen.dart';
import 'package:plantdoc/pages/profile.dart';

// 1. We keep the async main function with initialized bindings for camera/maps
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// 2. A clean, single MyApp widget that routes to the SplashScreen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plant Doc",
      home: SplashScreen(),
    );
  }
}

// 3. Your Splash Screen logic
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

// 4. Your clean Navigation Page with the BottomNavigationBar
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  // I removed the "const" keyword from these pages just in case your 
  // other dart files don't have const constructors yet.
  final List<Widget> _pages = [
    Home(),
    GoogleMapsScreen(), // Make sure your map class is actually named Map() inside map.dart!
    Camera(),
    fourm(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Crucial when you have more than 3 items!
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
      ),
    );
  }
}