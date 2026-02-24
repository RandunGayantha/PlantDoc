// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class ChilliDisease {
  final String id;
  final String name;
  final String emoji;
  final String confidence;
  final double confidenceValue;
  final String severity;
  final Color severityColor;
  final String description;
  final List<String> symptoms;
  final List<Map<String, String>> treatments;
  final Color accentColor;
  final Color lightColor;

  const ChilliDisease({
    required this.id,
    required this.name,
    required this.emoji,
    required this.confidence,
    required this.confidenceValue,
    required this.severity,
    required this.severityColor,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.accentColor,
    required this.lightColor,
  });
}

final List<ChilliDisease> chilliDiseases = [
  ChilliDisease(
    id: 'healthy',
    name: 'Healthy Leaf',
    emoji: '🌿',
    confidence: '98.2%',
    confidenceValue: 0.982,
    severity: 'Healthy',
    severityColor: Color(0xFF22C55E),
    description:
        'Your chilli plant appears to be in excellent health. Leaves show vibrant green coloration with no signs of infection, discoloration, or structural damage. Continue your current care routine.',
    symptoms: [
      'Deep green uniform leaf color',
      'Firm and smooth leaf texture',
      'No spots, curling, or lesions',
      'Normal leaf size and shape',
    ],
    treatments: [
      {'title': 'Maintain Watering Schedule', 'desc': 'Water consistently without waterlogging the roots'},
      {'title': 'Regular Fertilization', 'desc': 'Apply balanced NPK fertilizer every 3–4 weeks'},
      {'title': 'Monitor Regularly', 'desc': 'Check weekly for early signs of pest or disease'},
      {'title': 'Adequate Sunlight', 'desc': 'Ensure 6–8 hours of direct sunlight daily'},
    ],
    accentColor: Color(0xFF16A34A),
    lightColor: Color(0xFFDCFCE7),
  ),
  ChilliDisease(
    id: 'bacterial_spot',
    name: 'Bacterial Spot',
    emoji: '🔴',
    confidence: '90.3%',
    confidenceValue: 0.903,
    severity: 'Severe',
    severityColor: Color(0xFFEF4444),
    description:
        'Bacterial Spot is caused by Xanthomonas campestris and appears as small, water-soaked spots on leaves that turn dark brown or black. It spreads rapidly in warm, wet conditions and can cause severe defoliation.',
    symptoms: [
      'Small water-soaked spots on leaves',
      'Spots turn dark brown or black',
      'Yellow halo around lesions',
      'Premature leaf drop in severe cases',
    ],
    treatments: [
      {'title': 'Copper-based Bactericide', 'desc': 'Spray copper hydroxide or copper oxychloride weekly'},
      {'title': 'Avoid Overhead Watering', 'desc': 'Use drip irrigation to keep foliage dry'},
      {'title': 'Remove Infected Leaves', 'desc': 'Prune and destroy heavily infected plant parts'},
      {'title': 'Crop Rotation', 'desc': 'Rotate crops to prevent soil-borne bacterial buildup'},
    ],
    accentColor: Color(0xFFDC2626),
    lightColor: Color(0xFFFFECEC),
  ),
  ChilliDisease(
    id: 'cercospora',
    name: 'Cercospora Leaf Spot',
    emoji: '🍂',
    confidence: '88.6%',
    confidenceValue: 0.886,
    severity: 'Moderate',
    severityColor: Color(0xFFF59E0B),
    description:
        'Cercospora leaf spot is a fungal disease caused by Cercospora capsici. It produces circular spots with white/gray centers and dark brown borders on chilli leaves, leading to premature defoliation.',
    symptoms: [
      'Circular spots with gray centers',
      'Dark brown to purple borders',
      'Premature yellowing and leaf drop',
      'Spots enlarge in humid conditions',
    ],
    treatments: [
      {'title': 'Fungicide Application', 'desc': 'Spray mancozeb or chlorothalonil at 0.25% concentration'},
      {'title': 'Improve Air Circulation', 'desc': 'Prune dense foliage to reduce leaf wetness'},
      {'title': 'Avoid Overhead Irrigation', 'desc': 'Use drip irrigation to keep leaves dry'},
      {'title': 'Crop Rotation', 'desc': 'Rotate with non-solanaceous crops each season'},
    ],
    accentColor: Color(0xFFD97706),
    lightColor: Color(0xFFFEF3C7),
  ),
  ChilliDisease(
    id: 'anthracnose',
    name: 'Chilli Anthracnose',
    emoji: '🍁',
    confidence: '93.1%',
    confidenceValue: 0.931,
    severity: 'Severe',
    severityColor: Color(0xFFEF4444),
    description:
        'Anthracnose is caused by Colletotrichum species and affects both leaves and fruits. Dark, sunken lesions appear on leaves and spread rapidly in warm, wet weather causing significant crop losses.',
    symptoms: [
      'Dark sunken lesions on leaves',
      'Orange-pink spore masses visible',
      'Lesions coalesce in wet weather',
      'Tip dieback and defoliation',
    ],
    treatments: [
      {'title': 'Copper-based Fungicide', 'desc': 'Apply copper oxychloride spray every 10–14 days'},
      {'title': 'Seed Treatment', 'desc': 'Treat seeds with carbendazim before sowing'},
      {'title': 'Remove Debris', 'desc': 'Clear fallen leaves and infected material from field'},
      {'title': 'Hot Water Seed Treatment', 'desc': 'Soak seeds in 52°C water for 30 minutes'},
    ],
    accentColor: Color(0xFFB91C1C),
    lightColor: Color(0xFFFFE4E4),
  ),
  ChilliDisease(
    id: 'curl_virus',
    name: 'Curl Virus',
    emoji: '🦠',
    confidence: '91.4%',
    confidenceValue: 0.914,
    severity: 'Severe',
    severityColor: Color(0xFFEF4444),
    description:
        'Leaf Curl Virus (ChiLCV) is transmitted by whiteflies and causes severe curling, crinkling, and stunting of chilli leaves. Infected plants show reduced yield and fruit quality significantly.',
    symptoms: [
      'Upward or downward curling of leaves',
      'Yellowing and mosaic patterns',
      'Stunted plant growth',
      'Distorted and brittle leaves',
    ],
    treatments: [
      {'title': 'Control Whiteflies', 'desc': 'Apply imidacloprid or thiamethoxam insecticide spray'},
      {'title': 'Remove Infected Plants', 'desc': 'Uproot and destroy infected plants immediately'},
      {'title': 'Use Reflective Mulch', 'desc': 'Silver mulch repels whitefly vectors effectively'},
      {'title': 'Resistant Varieties', 'desc': 'Replant using virus-resistant chilli cultivars'},
    ],
    accentColor: Color(0xFFDC2626),
    lightColor: Color(0xFFFFECEC),
  ),
  ChilliDisease(
    id: 'nutrition_deficiency',
    name: 'Nutrition Deficiency',
    emoji: '🌱',
    confidence: '87.5%',
    confidenceValue: 0.875,
    severity: 'Mild',
    severityColor: Color(0xFF10B981),
    description:
        'Nutritional deficiency in chilli plants occurs when essential minerals like nitrogen, potassium, or magnesium are lacking. Leaves show yellowing, browning, or abnormal coloration patterns depending on the deficient nutrient.',
    symptoms: [
      'Yellowing between leaf veins (chlorosis)',
      'Brown or necrotic leaf edges',
      'Stunted or slow plant growth',
      'Pale or discolored new leaves',
    ],
    treatments: [
      {'title': 'Soil Testing', 'desc': 'Test soil pH and nutrient levels before treatment'},
      {'title': 'Balanced Fertilizer', 'desc': 'Apply NPK 19:19:19 fertilizer as foliar spray'},
      {'title': 'Magnesium Supplement', 'desc': 'Apply Epsom salt (MgSO4) solution 1% spray'},
      {'title': 'Adjust Soil pH', 'desc': 'Maintain soil pH between 6.0–6.8 for nutrient uptake'},
    ],
    accentColor: Color(0xFF059669),
    lightColor: Color(0xFFD1FAE5),
  ),
  ChilliDisease(
    id: 'white_spot',
    name: 'White Spot',
    emoji: '⚪',
    confidence: '89.2%',
    confidenceValue: 0.892,
    severity: 'Moderate',
    severityColor: Color(0xFFF59E0B),
    description:
        'White spot disease in chilli is caused by the fungus Phloeospora capsici. It produces small white to pale gray circular spots on leaves, which can merge and cause significant leaf area loss if left untreated.',
    symptoms: [
      'Small white to pale gray circular spots',
      'Spots have distinct dark borders',
      'Affected tissue may fall out (shot-hole effect)',
      'Yellowing around affected spots',
    ],
    treatments: [
      {'title': 'Fungicide Spray', 'desc': 'Apply carbendazim or propiconazole fungicide spray'},
      {'title': 'Neem Oil Treatment', 'desc': 'Spray neem oil 5ml/L as organic control method'},
      {'title': 'Remove Affected Leaves', 'desc': 'Prune and burn infected leaves to stop spread'},
      {'title': 'Reduce Leaf Wetness', 'desc': 'Avoid evening watering and improve air circulation'},
    ],
    accentColor: Color(0xFF7C3AED),
    lightColor: Color(0xFFF3E8FF),
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class DiagnosisResultScreen extends StatefulWidget {
  final ChilliDisease? disease;
  final String? imagePath;

  const DiagnosisResultScreen({super.key, this.disease, this.imagePath});

  @override
  State<DiagnosisResultScreen> createState() => _DiagnosisResultScreenState();
}

class _DiagnosisResultScreenState extends State<DiagnosisResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late ChilliDisease _selectedDisease;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _selectedDisease = widget.disease ?? chilliDiseases[0];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchDisease(ChilliDisease d) {
    setState(() => _selectedDisease = d);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final d = _selectedDisease;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(d),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show scanned image if available
                      if (widget.imagePath != null) _buildScannedImage(),
                      if (widget.imagePath != null) const SizedBox(height: 20),
                      _buildDiseaseSelector(),
                      const SizedBox(height: 20),
                      _buildResultCard(d),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Symptoms Detected"),
                      const SizedBox(height: 12),
                      _buildSymptomsList(d),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Recommended Treatments"),
                      const SizedBox(height: 12),
                      _buildTreatmentList(d),
                      const SizedBox(height: 24),
                      _buildActionButtons(d),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Scanned Image ─────────────────────────────────────────────────────────

  Widget _buildScannedImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.file(
              File(widget.imagePath!),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '📸  Scanned Leaf',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────

  Widget _buildAppBar(ChilliDisease d) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF7C2D12),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            _saved ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
          ),
          onPressed: () => setState(() => _saved = !_saved),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Diagnosis Result",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              "🌶️  Chilli Plant Analysis",
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C2D12), Color(0xFFEA580C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: 10,
                child: Opacity(
                  opacity: 0.08,
                  child: const Text("🌶️", style: TextStyle(fontSize: 180)),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 60,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "🤖  AI-Powered Plant Doctor",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Disease Selector ─────────────────────────────────────────────────────────

  Widget _buildDiseaseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Diagnosis",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF888888),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: chilliDiseases.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final d = chilliDiseases[i];
              final selected = d.id == _selectedDisease.id;
              return GestureDetector(
                onTap: () => _switchDisease(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? d.accentColor : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? d.accentColor : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: d.accentColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    "${d.emoji}  ${d.name}",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF444444),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Result Card ──────────────────────────────────────────────────────────────

  Widget _buildResultCard(ChilliDisease d) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: d.lightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(d.emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: d.accentColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: [
                        _buildBadge(d.severity, d.severityColor),
                        _buildBadge("🌶️ Chilli", const Color(0xFFEA580C)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Confidence Level",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                d.confidence,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: d.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: d.confidenceValue,
              minHeight: 9,
              backgroundColor: d.lightColor,
              valueColor: AlwaysStoppedAnimation<Color>(d.accentColor),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: d.lightColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              d.description,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF444444),
                height: 1.65,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildSymptomsList(ChilliDisease d) {
    final icons = ["🔍", "🧬", "📍", "⚠️"];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: d.symptoms.asMap().entries.map((entry) {
          final i = entry.key;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Text(icons[i % icons.length],
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                            fontSize: 13.5, color: Color(0xFF333333)),
                      ),
                    ),
                    Icon(Icons.check_circle, color: d.accentColor, size: 18),
                  ],
                ),
              ),
              if (i < d.symptoms.length - 1)
                const Divider(height: 1, color: Color(0xFFF5F5F5), indent: 48),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTreatmentList(ChilliDisease d) {
    return Column(
      children: d.treatments.asMap().entries.map((entry) {
        final i = entry.key;
        final t = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: d.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${i + 1}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t["title"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t["desc"]!,
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF777777)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: d.accentColor.withOpacity(0.4)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ChilliDisease d) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.agriculture_outlined, size: 20),
            label: const Text(
              "Get Expert Advice",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: d.accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.camera_alt_outlined, size: 20),
            label: const Text(
              "Scan Another Leaf",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: d.accentColor,
              side: BorderSide(color: d.accentColor, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}