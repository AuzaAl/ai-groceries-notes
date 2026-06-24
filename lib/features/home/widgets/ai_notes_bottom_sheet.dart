import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiNotesBottomSheet extends StatefulWidget {
  const AiNotesBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiNotesBottomSheet(),
    );
  }

  @override
  State<AiNotesBottomSheet> createState() => _AiNotesBottomSheetState();
}

class _AiNotesBottomSheetState extends State<AiNotesBottomSheet> {
  final TextEditingController _urlController = TextEditingController();
  String? _selectedSource;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onSourceTap(String source) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedSource = _selectedSource == source ? null : source;
    });
  }

  void _onGenerate() {
    HapticFeedback.mediumImpact();
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      Navigator.of(context).pop(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF232326), Color(0x0D0D0D0D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.15), // fully transparent
              width: 1,
            ),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(),
                const SizedBox(height: 20),
                _buildSourceButtons(),
                const SizedBox(height: 20),
                _buildUrlInputField(),
                const SizedBox(height: 16),
                _buildHowAiWorks(),
                const SizedBox(height: 24),
                _buildGenerateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildSourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SourceButton(
          icon: 'assets/icons/Youtube_Icon.svg',
          label: 'YouTube',
          isSelected: _selectedSource == 'YouTube',
          onTap: () => _onSourceTap('YouTube'),
        ),
        _SourceButton(
          icon: 'assets/icons/Tiktok_Icon.svg',
          label: 'TikTok',
          isSelected: _selectedSource == 'TikTok',
          onTap: () => _onSourceTap('TikTok'),
        ),
        _SourceButton(
          icon: 'assets/icons/Instagram_Icon.svg',
          label: 'Instagram',
          isSelected: _selectedSource == 'Instagram',
          onTap: () => _onSourceTap('Instagram'),
        ),
        _SourceButton(
          icon: null,
          label: 'Link',
          isSelected: _selectedSource == 'Link',
          onTap: () => _onSourceTap('Link'),
        ),
      ],
    );
  }

  Widget _buildUrlInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '🔗',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _urlController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Paste a recipe, grocery haul, or content URL…',
                hintStyle: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onGenerate(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowAiWorks() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How AI Works',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AI analyzes your content and automatically extracts ingredients, grocery items, quantities, and shopping essentials into organized grocery notes.',
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: _onGenerate,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/Blackstar_Icon.svg',
            height: 32,
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final String? icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3A3A3C)
              : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF4E6953), width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon!,
                width: 22,
                height: 22,
              )
            else
              const Text(
                '🔗',
                style: TextStyle(fontSize: 20),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
