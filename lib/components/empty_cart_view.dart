import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import './browse_menu_button.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback? onBack;

  const EmptyCartView({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: const Icon(
              Icons.shopping_basket_rounded,
              size: 150,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cellar is empty',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 12),
          Text(
            "Explore our collection of premium spirits\nand fine wines.",
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          BrowseMenuButton(onTap: onBack),
        ],
      ),
    );
  }
}
