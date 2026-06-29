import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
          color: bgElevated,
          border: Border(
            top: BorderSide(color: ink100, width: 1),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0D1412),
              blurRadius: 40,
              offset: Offset(0, -4),
            ),
          ],
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
          color: ink300,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink300, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.link,
            size: 20,
            color: ink500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _urlController,
              style: AppTextStyles.bodyL.copyWith(color: ink900),
              decoration: InputDecoration(
                hintText: 'Paste a recipe, grocery haul, or content URL...',
                hintStyle: AppTextStyles.bodyL.copyWith(color: ink500),
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
        color: bgSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How AI Works',
            style: AppTextStyles.headingS.copyWith(color: ink900),
          ),
          const SizedBox(height: 8),
          Text(
            'AI analyzes your content and automatically extracts ingredients, grocery items, quantities, and shopping essentials into organized grocery notes.',
            style: AppTextStyles.bodyS.copyWith(color: ink500, height: 1.5),
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
        height: 52,
        decoration: BoxDecoration(
          color: green500,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/StarIcon.svg',
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
          color: isSelected ? green50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? green500 : ink300,
            width: isSelected ? 1.5 : 1,
          ),
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
              const Icon(
                Icons.link,
                size: 22,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelS.copyWith(
                color: isSelected ? green500 : ink500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
