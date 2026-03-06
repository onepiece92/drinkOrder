import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

/// List-view product card with live qty counter on the add button for Liquid Gold.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onQuickAdd,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final qty = context.select<CartProvider, int>(
      (cart) => cart.items
          .where((i) => i.product.id == product.id)
          .fold(0, (sum, i) => sum + i.quantity),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: AppColors.gold.withValues(alpha: 0.05)),
              ),
              alignment: Alignment.center,
              child: Text(
                product.image,
                style: const TextStyle(fontSize: 38),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyles.h3.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleFavourite,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavourite
                                ? AppColors.gold
                                : AppColors.textTertiary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.time,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(
                              color: AppColors.gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AddCounter(
                        qty: qty,
                        productId: product.id,
                        onAdd: onQuickAdd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Compact "+" that expands to "−  N  +" once qty > 0 for Liquid Gold.
class AddCounter extends StatelessWidget {
  final int qty;
  final int productId;
  final VoidCallback onAdd;

  const AddCounter({
    super.key,
    required this.qty,
    required this.productId,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 32,
      width: hasItems ? 86 : 32,
      decoration: BoxDecoration(
        color:
            hasItems ? AppColors.gold : AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: hasItems
                ? AppColors.goldDark
                : AppColors.gold.withValues(alpha: 0.12)),
      ),
      child: hasItems
          ? Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context
                        .read<CartProvider>()
                        .updateById(productId, qty - 1),
                    child: const Icon(Icons.remove_rounded,
                        color: Colors.black, size: 16),
                  ),
                ),
                Text(
                  '$qty',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onAdd,
                    child: const Icon(Icons.add_rounded,
                        color: Colors.black, size: 16),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: onAdd,
              child: const Icon(Icons.add_rounded,
                  color: AppColors.gold, size: 18),
            ),
    );
  }
}
