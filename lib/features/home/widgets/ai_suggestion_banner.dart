import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AiSuggestionBanner extends StatelessWidget {
  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  const AiSuggestionBanner({
    super.key,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x0F2E7D52)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D52).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelS.copyWith(
                    color: green400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: AppTextStyles.bodyM.copyWith(color: ink700),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionText,
                    style: AppTextStyles.bodyM.copyWith(
                      color: green500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
