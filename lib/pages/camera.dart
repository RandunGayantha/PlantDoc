// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'classifier.dart';
import 'diagnosis_result_screen.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _selectedImage;
  bool _isLoading = false;
  final Classifier _classifier = Classifier();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _classifier.loadModel();
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  // Save scan result to Firebase in background
  Future<void> _saveScanResult(String label, double confidence) async {
    try {
      await FirebaseFirestore.instance.collection('scans').add({
        'disease': label,
        'confidence': confidence,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Firebase save successful!');
    } catch (e) {
      print('❌ Firebase error: $e');
    }
  }

  // Pick image from camera
  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (photo != null) {
      setState(() => _selectedImage = File(photo.path));
    }
  }

  // Pick image from gallery
  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (photo != null) {
      setState(() => _selectedImage = File(photo.path));
    }
  }

  // Run prediction and navigate to result
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      print('🔍 Starting analysis...');
      final result = await _classifier.predict(_selectedImage!);
      final String label = result['label'] ?? 'Unknown';
      final double confidence = result['confidence'] ?? 0.0;
      print('✅ AI done: $label ($confidence)');

      // Save to Firebase in background - no await so it doesn't block result
      _saveScanResult(label, confidence);
      print('📱 Navigating to result...');

      // Match label to disease
      ChilliDisease matchedDisease = _matchDisease(label, confidence);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisResultScreen(
              disease: matchedDisease,
              imagePath: _selectedImage!.path,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing image: $e')),
      );
    }
  }

  // Match predicted label to ChilliDisease object
  ChilliDisease _matchDisease(String label, double confidence) {
    String lowerLabel = label.toLowerCase();

    ChilliDisease matched = chilliDiseases[0]; // default healthy

    // ✅ FIXED: correct bracket logic for bacterial spot
    if (lowerLabel.contains('bacterial_spot') ||
        (lowerLabel.contains('spot') && lowerLabel.contains('bacterial'))) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'bacterial_spot',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('cercospora')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'cercospora',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('anthracnose')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'anthracnose',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('curl') || lowerLabel.contains('virus')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'curl_virus',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('healthy')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'healthy',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('nutrition') ||
        lowerLabel.contains('deficiency')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'nutrition_deficiency',
          orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('white')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'white_spot',
          orElse: () => chilliDiseases[0]);
    }

    return ChilliDisease(
      id: matched.id,
      name: matched.name,
      emoji: matched.emoji,
      confidence: '${(confidence * 100).toStringAsFixed(1)}%',
      confidenceValue: confidence,
      severity: matched.severity,
      severityColor: matched.severityColor,
      description: matched.description,
      symptoms: matched.symptoms,
      treatments: matched.treatments,
      accentColor: matched.accentColor,
      lightColor: matched.lightColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C2D12),
        title: const Text(
          '🌶️  Scan Leaf',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chilli Leaf Scanner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Take or upload a photo of a chilli leaf to detect disease',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 24),

            // Image preview box
            GestureDetector(
              onTap: _pickFromGallery,
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedImage != null
                        ? const Color(0xFF7C2D12)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              '🌿',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tap to upload leaf image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF444444),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'or use camera below',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Camera and Gallery buttons
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    color: const Color(0xFF7C2D12),
                    onTap: _pickFromCamera,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    color: const Color(0xFF059669),
                    onTap: _pickFromGallery,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tips box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📸  Tips for best results',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Take photo in good lighting',
                      style: TextStyle(fontSize: 13, color: Color(0xFF78350F))),
                  Text('• Focus on a single leaf clearly',
                      style: TextStyle(fontSize: 13, color: Color(0xFF78350F))),
                  Text('• Avoid blurry or dark images',
                      style: TextStyle(fontSize: 13, color: Color(0xFF78350F))),
                  Text('• Include both sides of leaf if possible',
                      style: TextStyle(fontSize: 13, color: Color(0xFF78350F))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Analyze button
            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _analyzeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C2D12),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Analyzing...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.biotech_outlined, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Analyze Leaf',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}