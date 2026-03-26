// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'diagnosis_result_screen.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;
  bool _isLoading = false;
  bool _isTakingPhoto = false;
  File? _capturedImage;

  final Classifier _classifier = Classifier();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _classifier.loadModel();
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _classifier.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final backCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_isTakingPhoto) return;
    setState(() => _isTakingPhoto = true);
    try {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = File(file.path);
        _isTakingPhoto = false;
      });
    } catch (e) {
      setState(() => _isTakingPhoto = false);
      debugPrint('Take photo error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (photo != null) setState(() => _capturedImage = File(photo.path));
  }

  void _retake() => setState(() => _capturedImage = null);

  Future<void> _analyzeImage() async {
    if (_capturedImage == null) return;
    setState(() => _isLoading = true);
    try {
      final result = await _classifier.predict(_capturedImage!);
      final String label = result['label'] ?? 'Unknown';
      final double confidence = result['confidence'] ?? 0.0;
      ChilliDisease matchedDisease = _matchDisease(label, confidence);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisResultScreen(
              disease: matchedDisease,
              imagePath: _capturedImage!.path,
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

  ChilliDisease _matchDisease(String label, double confidence) {
    String lowerLabel = label.toLowerCase();
    ChilliDisease matched = chilliDiseases[0];
    if (lowerLabel.contains('bacterial_spot') ||
        (lowerLabel.contains('spot') && lowerLabel.contains('bacterial'))) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'bacterial_spot', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('cercospora')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'cercospora', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('anthracnose')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'anthracnose', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('curl') || lowerLabel.contains('virus')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'curl_virus', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('healthy')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'healthy', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('nutrition') ||
        lowerLabel.contains('deficiency')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'nutrition_deficiency', orElse: () => chilliDiseases[0]);
    } else if (lowerLabel.contains('white')) {
      matched = chilliDiseases.firstWhere(
          (d) => d.id == 'white_spot', orElse: () => chilliDiseases[0]);
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
    return _capturedImage != null ? _buildPreviewScreen() : _buildCameraScreen();
  }

  // ─── LIVE VIEWFINDER ─────────────────────────────────────────────────────
  Widget _buildCameraScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen live preview
          if (_isCameraReady && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // Top logo bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/plantdoc_logo.png',
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Center scan frame
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: CustomPaint(painter: _ScanFramePainter()),
            ),
          ),

          // Hint label
          Positioned(
            bottom: 160,
            left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Place leaf inside the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery — left
                  GestureDetector(
                    onTap: _pickFromGallery,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shutter — center
                  GestureDetector(
                    onTap: _isTakingPhoto ? null : _takePhoto,
                    child: AnimatedScale(
                      scale: _isTakingPhoto ? 0.88 : 1.0,
                      duration: const Duration(milliseconds: 120),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: _isTakingPhoto
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right spacer (same width as gallery for symmetry)
                  const SizedBox(width: 58),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PREVIEW SCREEN ───────────────────────────────────────────────────────
  Widget _buildPreviewScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(_capturedImage!, fit: BoxFit.cover),
          ),

          // Top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _retake,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Retake',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/plantdoc_logo.png',
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom analyze
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📸  Image captured — ready to analyze',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _analyzeImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF166534),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
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
                                Text('Analyzing leaf...',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.biotech_outlined, size: 22),
                                SizedBox(width: 10),
                                Text('Analyze Leaf',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Corner bracket scan frame painter ───────────────────────────────────────
class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double len = 28;
    const double r = 8;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, r)
        ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
        ..lineTo(len, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - len, 0)
        ..lineTo(w - r, 0)
        ..arcToPoint(Offset(w, r), radius: const Radius.circular(r))
        ..lineTo(w, len),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, h - len)
        ..lineTo(0, h - r)
        ..arcToPoint(Offset(r, h), radius: const Radius.circular(r), clockwise: false)
        ..lineTo(len, h),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w - len, h)
        ..lineTo(w - r, h)
        ..arcToPoint(Offset(w, h - r), radius: const Radius.circular(r), clockwise: false)
        ..lineTo(w, h - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}