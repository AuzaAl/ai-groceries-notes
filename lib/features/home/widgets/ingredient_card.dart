import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class IngredientCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;

  const IngredientCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ink100),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D52).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              height: 110,
              width: double.infinity,
              color: bgSurface,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, e, stack) => const Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      color: ink300, size: 36),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  );
                },
              ),
            ),
          ),
          // Text area
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyM.copyWith(
                    color: ink900,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyS.copyWith(color: ink500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
