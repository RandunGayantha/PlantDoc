import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Service class that handles all Firebase operations for the "Create Post"
/// module.  Keeps the UI layer free of backend logic (clean architecture).
///
/// ── Coordination note ──────────────────────────────────────────────
/// Member 6 (Community Feed) reads from the **same** `posts` collection.
/// The document schema agreed upon is:
///   • title        : String
///   • description  : String
///   • image        : String  (download URL from Firebase Storage)
///   • createdAt    : Timestamp (server‑generated)
///   • timestamp    : Timestamp (alias – kept for backward compat)
///   • category     : String  (optional tag, e.g. "Pest", "Disease")
/// DO NOT rename these fields without syncing with Member 6.
/// ───────────────────────────────────────────────────────────────────
class PostService {
  // Firestore & Storage singletons
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Available post categories for the category picker.
  static const List<String> categories = [
    'General',
    'Pest',
    'Disease',
    'Nutrition',
    'Irrigation',
    'Harvest',
  ];

  // ── 1. Upload image to Firebase Storage ────────────────────────
  /// Uploads [imageFile] to `post_images/` in Firebase Storage.
  /// Returns the public download URL on success.
  /// Throws [FirebaseException] on failure.
  Future<String> uploadImage(File imageFile) async {
    try {
      final String fileName =
          'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(fileName);

      // Upload with metadata so Firebase serves it as an image
      final UploadTask task = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await task;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Storage upload failed: ${e.message}');
    }
  }

  // ── 2. Save post document to Firestore ─────────────────────────
  /// Saves a new post to the `posts` collection.
  /// [imageUrl] should come from [uploadImage].
  /// Throws [FirebaseException] on failure.
  Future<void> savePost({
    required String title,
    required String description,
    required String imageUrl,
    String category = 'General',
  }) async {
    try {
      await _firestore.collection('posts').add({
        'title': title,
        'description': description,
        'image': imageUrl,
        'category': category,
        'createdAt': FieldValue.serverTimestamp(),
        // Member 6's forum page currently reads "timestamp", so we
        // write BOTH fields until the team aligns on a single key.
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore write failed: ${e.message}');
    }
  }

  // ── 3. Convenience: upload image + save post in one call ───────
  /// End‑to‑end helper used by the UI.  Returns when everything is
  /// persisted; throws on any failure so the UI can show an error.
  Future<void> createPost({
    required String title,
    required String description,
    required File imageFile,
    String category = 'General',
  }) async {
    final String imageUrl = await uploadImage(imageFile);
    await savePost(
      title: title,
      description: description,
      imageUrl: imageUrl,
      category: category,
    );
  }
}
