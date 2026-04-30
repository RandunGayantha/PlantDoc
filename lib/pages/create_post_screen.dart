// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdoc/services/post_service.dart';

/// ─────────────────────────────────────────────────────────────────
/// CreatePostScreen  –  "Ask an Expert" form
/// ─────────────────────────────────────────────────────────────────
/// Allows farmers to compose a post with a title, description,
/// category, and photo. Uses [PostService] for all Firebase writes
/// so the UI stays clean.
///
/// Data lands in the Firestore `posts` collection that Member 6's
/// Community Feed reads from.
/// ─────────────────────────────────────────────────────────────────
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  // ── Controllers & State ──────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _postService = PostService();

  File? _selectedImage;
  String _selectedCategory = PostService.categories.first;
  bool _isSubmitting = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── Brand colours (shared with Home / main.dart) ─────────────
  static const _primaryDark = Color(0xFF2E7D32);
  static const _primaryLight = Color(0xFF4CAF50);
  static const _accentGreen = Color(0xFF81C784);
  static const _bgColor = Color(0xFFF8F9FA);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF64748B);

  // ── Image picking ────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Photo',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primaryDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: _primaryDark),
                ),
                title: const Text('Take a photo'),
                subtitle: const Text('Use your camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primaryDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: _primaryDark),
                ),
                title: const Text('Choose from gallery'),
                subtitle: const Text('Pick an existing photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Submit ───────────────────────────────────────────────────
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      _showSnackbar('Please select an image of the plant', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Delegate ALL Firebase work to PostService
      await _postService.createPost(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        imageFile: _selectedImage!,
        category: _selectedCategory,
      );

      _showSnackbar('Post submitted successfully! 🌱');

      // Reset form
      _titleCtrl.clear();
      _descCtrl.clear();
      setState(() {
        _selectedImage = null;
        _selectedCategory = PostService.categories.first;
      });

      // Return to previous screen after short delay
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      _showSnackbar('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : _primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── BUILD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: _buildFormBody(),
                ),
              ),
            ],
          ),
          // Full-screen loading overlay
          if (_isSubmitting) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // ── Gradient App Bar ─────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: const Text(
          'Ask an Expert',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), _primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -20,
                child: Icon(Icons.eco_rounded,
                    size: 150, color: Colors.white.withOpacity(0.08)),
              ),
              Positioned(
                right: 50,
                bottom: 10,
                child: Icon(Icons.local_florist_rounded,
                    size: 80, color: Colors.white.withOpacity(0.06)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Form body ────────────────────────────────────────────────
  Widget _buildFormBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruction card
            _buildInfoCard(),
            const SizedBox(height: 24),

            // Category selector
            _buildSectionLabel('Category', Icons.category_rounded),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 24),

            // Title field
            _buildSectionLabel('Title', Icons.title_rounded),
            const SizedBox(height: 10),
            _buildTitleField(),
            const SizedBox(height: 24),

            // Description field
            _buildSectionLabel('Description', Icons.description_rounded),
            const SizedBox(height: 10),
            _buildDescriptionField(),
            const SizedBox(height: 24),

            // Photo picker
            _buildSectionLabel('Photo', Icons.add_a_photo_rounded),
            const SizedBox(height: 10),
            _buildImagePicker(),
            const SizedBox(height: 32),

            // Submit button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ── Info card at the top ─────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accentGreen.withOpacity(0.15),
            _primaryLight.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentGreen.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              color: _primaryDark, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share your plant concern',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _textDark)),
                SizedBox(height: 4),
                Text(
                  'Add a clear photo and description so our experts can help you quickly.',
                  style: TextStyle(fontSize: 13, color: _textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────
  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _primaryDark),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  // ── Category chips ───────────────────────────────────────────
  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PostService.categories.map((cat) {
        final selected = cat == _selectedCategory;
        return ChoiceChip(
          label: Text(cat),
          selected: selected,
          onSelected: (_) => setState(() => _selectedCategory = cat),
          selectedColor: _primaryDark,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: selected ? Colors.white : _textMuted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: selected ? _primaryDark : Colors.grey.shade300,
            ),
          ),
          elevation: selected ? 2 : 0,
        );
      }).toList(),
    );
  }

  // ── Styled title field ───────────────────────────────────────
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleCtrl,
      maxLength: 100,
      textCapitalization: TextCapitalization.sentences,
      decoration: _inputDecoration(
        hint: 'e.g. Yellow spots on my tomato leaves',
        prefixIcon: Icons.edit_note_rounded,
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
    );
  }

  // ── Styled description field ─────────────────────────────────
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descCtrl,
      maxLines: 4,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      decoration: _inputDecoration(
        hint: 'Describe what you see on the plant…',
        prefixIcon: Icons.notes_rounded,
        alignTop: true,
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Please enter a description' : null,
    );
  }

  /// Shared [InputDecoration] factory for consistent styling.
  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    bool alignTop = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Padding(
        padding: EdgeInsets.only(top: alignTop ? 12 : 0),
        child: Icon(prefixIcon, color: _primaryDark, size: 22),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  // ── Image picker area ────────────────────────────────────────
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedImage != null
                ? _primaryDark.withOpacity(0.4)
                : Colors.grey.shade300,
            width: _selectedImage != null ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _selectedImage != null
            ? _buildImagePreview()
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(14)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
            alignment: Alignment.center,
            child: const Text('Tap to change photo',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ),
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _selectedImage = null),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.close_rounded, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _primaryDark.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_a_photo_rounded,
              size: 36, color: _primaryDark),
        ),
        const SizedBox(height: 12),
        const Text('Tap to add a photo',
            style: TextStyle(
                color: _textDark, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Camera or gallery',
            style: TextStyle(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }

  // ── Submit button ────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primaryDark.withOpacity(0.5),
          elevation: 3,
          shadowColor: _primaryDark.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, size: 20),
            SizedBox(width: 10),
            Text('Submit Post',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // ── Loading overlay ──────────────────────────────────────────
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  color: _primaryDark, strokeWidth: 3),
              SizedBox(height: 20),
              Text('Uploading your post…',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textDark)),
              SizedBox(height: 6),
              Text('This may take a moment',
                  style: TextStyle(fontSize: 13, color: _textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}