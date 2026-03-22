// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'diagnosis_result_screen.dart';
import 'constants.dart';

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
      imagePath: matched.imagePath,
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
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB7FFBA),
        // Plant background image with white overlay
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/plant_bg.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: const Color(0xAAFFFFFF), // white overlay to lighten photo
            ),
          ],
        ),
        // Logo in AppBar
        title: Image.asset(
          'assets/images/plantdoc_logo.png',
          height: 120, // ← CHANGE THIS NUMBER to resize logo
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF166534)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Leaf Scanner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Take or upload a photo of a leaf to detect disease',
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
                        ? const Color(0xFF166534)
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
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // No chilli icon — using camera icon instead
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Color(0xFF166534),
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

            // Camera and Gallery buttons — glass effect
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: _pickFromCamera,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
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
                color: const Color(0xFFDCFCE7),
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
                      color: Color(0xFF166534),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Take photo in good lighting',
                      style: TextStyle(fontSize: 13, color: Color(0xFF166534))),
                  Text('• Focus on a single leaf clearly',
                      style: TextStyle(fontSize: 13, color: Color(0xFF166534))),
                  Text('• Avoid blurry or dark images',
                      style: TextStyle(fontSize: 13, color: Color(0xFF166534))),
                  Text('• Include both sides of leaf if possible',
                      style: TextStyle(fontSize: 13, color: Color(0xFF166534))),
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
                    backgroundColor: const Color(0xFF166534),
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

  // Glass effect button for Camera and Gallery
  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF166534).withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF166534).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF166534), size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF166534),
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