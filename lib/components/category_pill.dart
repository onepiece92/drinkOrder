import 'package:flutter/material.dart';

/// Category filter pill chip.
class CategoryPill extends StatelessWidget {
  final String label;
  final String icon;
  final bool active;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
      scale: active ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: ChoiceChip(
        label: Text.rich(
          TextSpan(
            children: [
              if (label == 'All') ...[
                TextSpan(
                  text: '$icon ',
                  style: theme.textTheme.labelLarge?.copyWith(
                    height: 1.2,
                    color:
                        active ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
              ],
              TextSpan(
                text: label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: active ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        selected: active,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        backgroundColor: theme.cardColor,
        selectedColor: colorScheme.primary,
        side: BorderSide(
          color: active ? colorScheme.primary : theme.dividerColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: active ? 4 : 1,
        shadowColor: active ? colorScheme.primary : theme.shadowColor,
      ),
    );
  }
}
