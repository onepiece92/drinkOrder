import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../components/gold_back_button.dart';
import '../components/product_bottom_cta.dart';

import 'package:go_router/go_router.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 0;
  int _selectedVariant = 0;
  final Set<int> _selectedExtras = {};
  final TextEditingController _instructionsCtrl = TextEditingController();

  static const _mockVariants = [
    (name: 'Standard Bottle', price: 0.0),
    (name: 'Large (1.5L)', price: 35.0),
    (name: 'Collector Reserve', price: 125.0),
  ];

  static const _mockExtras = [
    (name: 'Premium Gift Wrap', price: 10.00),
    (name: 'Exotic Chilled Case', price: 15.00),
    (name: 'Crystal Glass Set', price: 45.00),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartItem = context
          .read<CartProvider>()
          .items
          .where((i) => i.product.id == widget.product.id)
          .firstOrNull;
      if (cartItem != null && mounted) {
        setState(() {
          _quantity = cartItem.quantity;
        });
      }
    });
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final isFav = favProv.isFavourite(widget.product.id);

    final double variantPrice =
        _mockVariants.isNotEmpty ? _mockVariants[_selectedVariant].price : 0.0;

    final double extrasPrice = _selectedExtras
        .map((i) => _mockExtras[i].price)
        .fold(0.0, (sum, price) => sum + price);

    final double totalPrice =
        (widget.product.price + variantPrice + extrasPrice) *
            (_quantity == 0 ? 1 : _quantity);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero ──────────────────────────────────────
              SliverAppBar(
                expandedHeight: 440,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.background,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: GoldBackButton(),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => favProv.toggle(widget.product.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card.withValues(alpha: 0.8),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.1)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.gold,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.surfaceGradient,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 120,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.background.withValues(alpha: 0),
                                  AppColors.background,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'product-${widget.product.id}',
                          child: Text(
                            widget.product.image,
                            style: const TextStyle(fontSize: 220, shadows: [
                              Shadow(
                                  color: Colors.black45,
                                  blurRadius: 40,
                                  offset: Offset(0, 20))
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      if (widget.product.badge != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.product.badge!.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.gold,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w900),
                          ),
                        ),

                      // Name & Meta
                      Text(widget.product.name,
                          style: AppTextStyles.h1.copyWith(fontSize: 32)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 6),
                          Text('4.9',
                              style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Text('(1.2k reviews)',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textSecondary)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.gold.withValues(alpha: 0.1)),
                            ),
                            child: Text(widget.product.time,
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Description
                      Text('RESERVE DETAILS',
                          style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.gold.withValues(alpha: 0.6),
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Text(
                        widget.product.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 40),

                      // Variants
                      _SectionHeader(title: 'Selection Size'),
                      const SizedBox(height: 16),
                      ...List.generate(_mockVariants.length, (i) {
                        return _OptionItem(
                          name: _mockVariants[i].name,
                          price: _mockVariants[i].price,
                          isActive: _selectedVariant == i,
                          onTap: () => setState(() => _selectedVariant = i),
                        );
                      }),
                      const SizedBox(height: 32),

                      // Extras
                      _SectionHeader(title: 'Boutique Services'),
                      const SizedBox(height: 16),
                      ...List.generate(_mockExtras.length, (i) {
                        final isActive = _selectedExtras.contains(i);
                        return _OptionItem(
                          name: _mockExtras[i].name,
                          price: _mockExtras[i].price,
                          isActive: isActive,
                          onTap: () {
                            setState(() {
                              if (isActive) {
                                _selectedExtras.remove(i);
                              } else {
                                _selectedExtras.add(i);
                              }
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 48),

                      // Special Instructions
                      _SectionHeader(title: 'Concierge Note'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _instructionsCtrl,
                        maxLines: 4,
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText:
                              'Any special requirements for our boutique delivery team?',
                          hintStyle: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textTertiary),
                          filled: true,
                          fillColor: AppColors.card,
                          contentPadding: const EdgeInsets.all(24),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: AppColors.gold.withValues(alpha: 0.1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: AppColors.gold.withValues(alpha: 0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: AppColors.gold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom CTA ───────────────────────────────────────────
          ProductBottomCta(
            quantity: _quantity,
            totalPrice: totalPrice,
            onDecrement: () {
              if (_quantity > 0) {
                setState(() => _quantity--);
                final cart = context.read<CartProvider>();
                if (cart.contains(widget.product)) {
                  cart.updateById(widget.product.id, _quantity);
                }
              }
            },
            onIncrement: () {
              setState(() => _quantity++);
              final cart = context.read<CartProvider>();
              if (cart.contains(widget.product)) {
                cart.updateById(widget.product.id, _quantity);
              } else {
                cart.addProduct(widget.product, quantity: _quantity);
              }
            },
            onCheckout: () {
              if (_quantity > 0) {
                final cart = context.read<CartProvider>();
                if (!cart.contains(widget.product)) {
                  cart.addProduct(widget.product, quantity: _quantity);
                }
                context.push('/cart');
              } else {
                // Auto add 1 if they hit checkout anyway
                setState(() => _quantity = 1);
                final cart = context.read<CartProvider>();
                cart.addProduct(widget.product, quantity: 1);
                context.push('/cart');
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Private Helper Widgets ───────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(fontSize: 18, letterSpacing: 0.5),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String name;
  final double price;
  final bool isActive;
  final VoidCallback onTap;

  const _OptionItem({
    required this.name,
    required this.price,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.08)
              : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.gold
                : AppColors.gold.withValues(alpha: 0.05),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.gold : AppColors.textTertiary,
                  width: isActive ? 7 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.text : AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              price == 0 ? 'Inc.' : '+\$${price.toInt()}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.gold : AppColors.textTertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
