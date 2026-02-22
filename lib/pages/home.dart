import 'package:flutter/material.dart';
import 'diagnosis_result_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text("Diagnosis Result"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiagnosisResultScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
