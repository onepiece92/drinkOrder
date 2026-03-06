import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Star rating display for Liquid Gold.
class StarRating extends StatelessWidget {
  final double rating;
  final int total;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.total = 5,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return Icon(
          i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < rating.round()
              ? AppColors.gold
              : AppColors.gold.withValues(alpha: 0.2),
          size: size,
        );
      }),
    );
  }
}

/// Horizontal rating bar showing per-star distribution for Liquid Gold.
class RatingBar extends StatelessWidget {
  final double rating;
  final int reviews;

  const RatingBar({
    super.key,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    // Simulated distribution
    const Map<int, int> dist = {5: 85, 4: 10, 3: 3, 2: 2, 1: 0};
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Avg score
          Column(
            children: [
              Text(
                rating.toString(),
                style: AppTextStyles.h1.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 4),
              StarRating(rating: rating, size: 14),
              const SizedBox(height: 6),
              Text(
                '$reviews reviews',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Per-star bars
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((s) {
                final pct = dist[s] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text('$s',
                            style: AppTextStyles.caption
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: pct / 100,
                            backgroundColor:
                                AppColors.gold.withValues(alpha: 0.05),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.gold),
                            minHeight: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
