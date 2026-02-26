// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'diagnosis_result_screen.dart';
import 'camera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  // ── Quick-scan helpers ────────────────────────────────────────────────────

  Future<void> _quickScan(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );
    if (photo == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await _classifier.predict(File(photo.path));
      final String label = result['label'] ?? 'Unknown';
      final double confidence = result['confidence'] ?? 0.0;

      final ChilliDisease matched = _matchDisease(label, confidence);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiagnosisResultScreen(
              disease: matched,
              imagePath: photo.path,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  ChilliDisease _matchDisease(String label, double confidence) {
    final lowerLabel = label.toLowerCase();
    ChilliDisease matched = chilliDiseases[0]; // default: healthy

    if (lowerLabel.contains('bacterial')) {
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C2D12),
        elevation: 0,
        title: const Text(
          '🌶️  PlantDoc',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF7C2D12)),
          SizedBox(height: 16),
          Text(
            'Analyzing leaf...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF7C2D12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting ────────────────────────────────────────────────────
          const Text(
            'Welcome 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Diagnose your chilli plant in seconds',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 24),

          // ── Big scan card ────────────────────────────────────────────────
          _buildScanCard(),
          const SizedBox(height: 20),

          // ── Quick-action row ─────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  subtitle: 'Take a photo now',
                  color: const Color(0xFF7C2D12),
                  onTap: () => _quickScan(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  subtitle: 'Pick from gallery',
                  color: const Color(0xFF059669),
                  onTap: () => _quickScan(ImageSource.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Disease quick-reference ──────────────────────────────────────
          const Text(
            'Detectable Diseases',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...chilliDiseases.map((d) => _buildDiseaseChip(d)),
        ],
      ),
    );
  }

  // ── Hero scan card ────────────────────────────────────────────────────────

  Widget _buildScanCard() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Camera()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C2D12), Color(0xFFB91C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C2D12).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AI-Powered',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Scan Chilli Leaf',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Point camera at a leaf\nand get instant diagnosis',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.biotech_outlined,
                            color: Color(0xFF7C2D12), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Start Scanning',
                          style: TextStyle(
                            color: Color(0xFF7C2D12),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text('🌶️', style: TextStyle(fontSize: 72)),
          ],
        ),
      ),
    );
  }

  // ── Quick-action tile ─────────────────────────────────────────────────────

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF888888)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Disease chip row ──────────────────────────────────────────────────────

  Widget _buildDiseaseChip(ChilliDisease d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(d.emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  d.description.length > 60
                      ? '${d.description.substring(0, 60)}…'
                      : d.description,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: d.severityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              d.severity,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: d.severityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}