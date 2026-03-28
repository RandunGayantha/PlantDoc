import 'package:flutter/material.dart';
import 'dart:async';

import 'package:plantdoc/pages/camera.dart';
import 'package:plantdoc/pages/fourm.dart';
import 'package:plantdoc/pages/home.dart';
import 'package:plantdoc/pages/map.dart';
import 'package:plantdoc/pages/splash_screen.dart';
import 'package:plantdoc/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Global variable for Theme state
  bool _isDarkMode = false;

  // Global function to toggle theme
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plant Doc",
      
      // Light Theme configuration
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),

      // Dark Theme configuration
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),

      // This is what makes the whole app change!
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, 

      home: NavigationPage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

// NavigationPage now acts as the host for other pages
class NavigationPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const NavigationPage({
    super.key, 
    required this.isDarkMode, 
    required this.onThemeChanged
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Home(), // Assuming these are already defined
      GoogleMapsScreen(),
      Camera(),
      fourm(),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}