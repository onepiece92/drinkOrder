import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ServiceIcon extends StatelessWidget {
  final dynamic icon; // Can be a String (emoji) or IconData
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  const ServiceIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 44,
    this.iconSize = 20,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: backgroundColor == null
              ? AppColors.gold.withValues(alpha: 0.12)
              : Colors.transparent,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: icon is String
          ? Text(icon as String, style: TextStyle(fontSize: iconSize))
          : Icon(
              icon as IconData,
              color: iconColor ?? AppColors.gold,
              size: iconSize,
            ),
    );
  }
}
