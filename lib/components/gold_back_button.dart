import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoldBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final EdgeInsets? margin;

  const GoldBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: IconButton(
        onPressed: onPressed ?? () => context.pop(),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.card.withValues(alpha: 0.8),
          shadowColor: AppColors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
          ),
        ),
        icon: Icon(
          Icons.chevron_left_rounded,
          size: 28,
          color: color ?? AppColors.gold,
        ),
      ),
    );
  }
}
