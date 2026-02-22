import 'package:flutter/material.dart';

class DiagnosisResultScreen extends StatefulWidget {
  const DiagnosisResultScreen({super.key});

  @override
  State<DiagnosisResultScreen> createState() => _DiagnosisResultScreenState();
}

class _DiagnosisResultScreenState extends State<DiagnosisResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  // Sample diagnosis data
  final String diseaseName = "Bacterial Leaf Blight";
  final String confidence = "94.7%";
  final String severity = "Moderate";
  final Color severityColor = const Color(0xFFF59E0B);
  final String description =
      "Bacterial Leaf Blight (BLB) is a serious rice disease caused by Xanthomonas oryzae. It causes yellowing and wilting of leaves, reducing photosynthesis and yield significantly.";

  final List<Map<String, String>> symptoms = [
    {"icon": "🍃", "text": "Yellow to white lesions on leaf edges"},
    {"icon": "💧", "text": "Bacterial ooze on leaf surface"},
    {"icon": "🌾", "text": "Wilting of whole tillers"},
    {"icon": "📉", "text": "Reduced grain filling"},
  ];

  final List<Map<String, String>> treatments = [
    {
      "title": "Copper-based Bactericide",
      "desc": "Apply copper oxychloride 0.3% spray"
    },
    {
      "title": "Seed Treatment",
      "desc": "Treat seeds with Streptomycin before sowing"
    },
    {
      "title": "Field Drainage",
      "desc": "Improve drainage to reduce humidity levels"
    },
    {
      "title": "Remove Infected Plants",
      "desc": "Uproot and destroy infected plant material"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResultCard(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Symptoms Detected"),
                      const SizedBox(height: 12),
                      _buildSymptomsList(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Recommended Treatments"),
                      const SizedBox(height: 12),
                      _buildTreatmentList(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF2D6A4F),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Diagnosis Result",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B4332), Color(0xFF52B788)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.eco,
                      size: 200, color: Colors.white),
                ),
              ),
              const Positioned(
                bottom: 60,
                left: 20,
                child: Text(
                  "🌾  Plant Health Analysis",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8F3DC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text("🦠", style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B4332),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildBadge(severity, severityColor),
                        const SizedBox(width: 8),
                        _buildBadge("AI Detected", const Color(0xFF52B788)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Confidence bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Confidence Level",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              Text(confidence,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D6A4F))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.947,
              minHeight: 8,
              backgroundColor: const Color(0xFFD8F3DC),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF52B788)),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF555555),
              height: 1.6,
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
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.9),
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
        color: Color(0xFF1B4332),
      ),
    );
  }

  Widget _buildSymptomsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: symptoms.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Text(s["icon"]!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        s["text"]!,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF333333)),
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: Color(0xFF52B788), size: 18),
                  ],
                ),
              ),
              if (i < symptoms.length - 1)
                const Divider(
                    height: 1, color: Color(0xFFF5F5F5), indent: 52),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTreatmentList() {
    return Column(
      children: treatments.asMap().entries.map((entry) {
        final i = entry.key;
        final t = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  color: const Color(0xFF2D6A4F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${i + 1}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t["title"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1B4332)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      t["desc"]!,
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF777777)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.local_pharmacy_outlined, size: 20),
            label: const Text(
              "Get Expert Advice",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 20),
            label: const Text(
              "Scan Again",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2D6A4F),
              side: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
} 

//test