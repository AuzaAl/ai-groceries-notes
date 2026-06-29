import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NoteCard extends StatelessWidget {
  final int totalItems;
  final String noteName;
  final String emoji;
  final int completedItems;

  const NoteCard({
    super.key,
    required this.totalItems,
    required this.noteName,
    required this.emoji,
    required this.completedItems,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;
    
    return Container(
      width: 162,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1F3E7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D52).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalItems item',
                      style: AppTextStyles.labelS.copyWith(
                        color: green500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      noteName,
                      style: AppTextStyles.bodyM.copyWith(
                        color: ink900,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '$completedItems dari $totalItems dibeli',
            style: AppTextStyles.bodyS.copyWith(color: ink500),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ink100,
              valueColor: const AlwaysStoppedAnimation<Color>(green500),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
