import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

/// Grid-view product card with live qty counter on the add button for Liquid Gold.
class GridProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const GridProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onQuickAdd,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final qty = context.select<CartProvider, int>((cart) => cart.items
        .where((i) => i.product.id == product.id)
        .fold(0, (sum, i) => sum + i.quantity));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image area
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: Text(
                    product.image,
                    style: const TextStyle(fontSize: 52),
                  ),
                ),

                // Favourite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onToggleFavourite,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavourite ? AppColors.gold : Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info + counter
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.h3
                        .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(
                              color: AppColors.gold,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _GridAddCounter(
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
/// Compact "+" that expands to "−  N  +" once qty > 0 (grid variant) for Liquid Gold.
class _GridAddCounter extends StatelessWidget {
  final int qty;
  final int productId;
  final VoidCallback onAdd;

  const _GridAddCounter({
    required this.qty,
    required this.productId,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 28,
      width: hasItems ? 76 : 28,
      decoration: BoxDecoration(
        color:
            hasItems ? AppColors.gold : AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: hasItems
                ? AppColors.goldDark
                : AppColors.gold.withValues(alpha: 0.12)),
      ),
      child: hasItems
          ? Row(
              children: [
                // − decrement
                Expanded(
                  child: InkWell(
                    onTap: () => context
                        .read<CartProvider>()
                        .updateById(productId, qty - 1),
                    child: const Icon(Icons.remove_rounded,
                        color: Colors.black, size: 14),
                  ),
                ),
                // Animated count
                Text(
                  '$qty',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                // + increment
                Expanded(
                  child: InkWell(
                    onTap: onAdd,
                    child: const Icon(Icons.add_rounded,
                        color: Colors.black, size: 14),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: onAdd,
              child: const Icon(Icons.add_rounded,
                  color: AppColors.gold, size: 16),
            ),
    );
  }
}
