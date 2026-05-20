import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class fourm extends StatefulWidget {
  const fourm({super.key});

  @override
  State<fourm> createState() => _fourmState();
}

class _fourmState extends State<fourm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Feed"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No posts yet 🌱",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final data = posts[index].data() as Map<String, dynamic>;

              // Get timestamp and format it
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedTime = timestamp != null
                  ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
                  : '';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data['description'] ?? 'No Description',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Display formatted timestamp
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}