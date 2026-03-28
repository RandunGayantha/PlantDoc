import 'package:flutter/material.dart';
import 'package:plantdoc/pages/settings.dart';

class ProfilePage extends StatelessWidget {
  // 1. These variables MUST be declared to receive data from NavigationPage
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/plantdoc_logo.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kavi Perera",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "kaviperera@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Divider(),
            
            // Edit Profile Tile
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.green),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            // Settings Tile - FIXED NAVIGATION
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.green),
              title: const Text("Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      isDarkMode: isDarkMode, // Passing the value
                      onThemeChanged: onThemeChanged, // Passing the function
                    ),
                  ),
                );
              },
            ),

            const Divider(),
            
            // Logout Tile
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}