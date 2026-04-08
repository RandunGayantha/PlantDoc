import 'package:flutter/material.dart';
import 'dart:async';

import 'package:plantdoc/pages/camera.dart';
import 'package:plantdoc/pages/fourm.dart';
import 'package:plantdoc/pages/home.dart';
import 'package:plantdoc/pages/map.dart';
import 'package:plantdoc/pages/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
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
      Home(), 
      GoogleMapsScreen(),
      fourm(),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Opens the camera page as a new screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Camera()),
          );
        },
        backgroundColor: const Color(0xFF2E7D32), // Dark green to match your design
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.document_scanner_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // The custom bottom app bar with a notch for the floating button
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side tabs
              _buildNavItem(Icons.home_filled, 'Home', 0),
              _buildNavItem(Icons.map_outlined, 'Map', 1),
              
              // Empty space in the middle for the floating button
              const SizedBox(width: 40), 
              
              // Right side tabs
              _buildNavItem(Icons.people_outline, 'Forum', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque, // Ensures the whole area is clickable
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
