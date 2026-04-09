import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  // Pass the current theme state and the toggle function from the parent
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Local variables to handle switch UI states
  late bool _isDark;
  bool _isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize the local switch state from the parent's current theme
    _isDark = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          // Push Notifications Switch
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined, color: Colors.green),
            title: const Text("Push Notifications"),
            subtitle: const Text("Enable or disable app alerts"),
            trailing: Switch(
              value: _isNotificationsEnabled,
              activeColor: Colors.green,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
            ),
          ),

          // Dark Mode Switch
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined, color: Colors.green),
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch between light and dark themes"),
            trailing: Switch(
              value: _isDark,
              activeColor: Colors.green,
              onChanged: (bool value) {
                setState(() {
                  _isDark = value;
                });
                // CRITICAL: This sends the new value back to main.dart 
                // to update the theme for the WHOLE app
                widget.onThemeChanged(value);
              },
            ),
          ),

          const Divider(),

          // Privacy Settings
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.green),
            title: const Text("Privacy"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Add Privacy Navigation here
            },
          ),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.green),
            title: const Text("Help & Support"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Add Help Navigation here
            },
          ),

          const Divider(),

          // About App Section
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.grey),
            title: Text("App Version"),
            trailing: Text("1.0.0", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}