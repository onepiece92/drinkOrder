import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../data/drinks_data.dart';
import '../components/address_selector.dart';
import '../components/primary_button.dart';
import '../components/product_card.dart';
import '../components/grid_product_card.dart';
import '../components/gold_back_button.dart';
import '../providers/favourites_provider.dart';
import '../components/empty_cart_view.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddressBottomSheet(
        selectedId: context.read<AddressProvider>().selectedId,
        onSelect: (id) => context.read<AddressProvider>().select(id),
        onAddNew: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addrProv = context.watch<AddressProvider>();
    final favProv = context.watch<FavouritesProvider>();

    final cartIds = cart.items.map((i) => i.product.id).toSet();
    final suggestions = DrinksData.products
        .where((p) => !cartIds.contains(p.id))
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: GoldBackButton(),
        ),
        title: Text('Your Selection', style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: cart.items.isEmpty
                      ? const EmptyCartView()
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 160),
                          children: [
                            ...cart.items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ProductCard(
                                  product: item.product,
                                  onTap: () => context.push('/home/product',
                                      extra: item.product),
                                  onQuickAdd: () =>
                                      cart.addProduct(item.product),
                                  isFavourite:
                                      favProv.isFavourite(item.product.id),
                                  onToggleFavourite: () =>
                                      favProv.toggle(item.product.id),
                                ),
                              );
                            }),

                            // Suggestions
                            if (suggestions.isNotEmpty &&
                                cart.items.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text('Add something extra?',
                                  style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.gold,
                                      letterSpacing: 1.2)),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 225,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: suggestions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 16),
                                  itemBuilder: (_, i) {
                                    final p = suggestions[i];
                                    return SizedBox(
                                      width: 170,
                                      child: GridProductCard(
                                        product: p,
                                        onTap: () => context
                                            .push('/home/product', extra: p),
                                        onQuickAdd: () => cart.addProduct(p),
                                        isFavourite: favProv.isFavourite(p.id),
                                        onToggleFavourite: () =>
                                            favProv.toggle(p.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Address
                            Text('DELIVERY DETAILS',
                                style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.gold, letterSpacing: 1.2)),
                            const SizedBox(height: 12),
                            AddressSelector(
                              selectedId: addrProv.selectedId,
                              onTap: () => _showAddressSheet(context),
                              variant: AddressSelectorVariant.compact,
                            ),
                            const SizedBox(height: 32),

                            // Price summary
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  _PriceSummaryRow(
                                      label: 'Subtotal', value: cart.subtotal),
                                  const SizedBox(height: 12),
                                  const _PriceSummaryRow(
                                      label: 'Boutique Service Fee',
                                      value: 5.00),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Divider(
                                        height: 1, color: AppColors.border),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total', style: AppTextStyles.h3),
                                      Text(
                                        '\$${cart.total.toStringAsFixed(2)}',
                                        style: AppTextStyles.h2.copyWith(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
            if (cart.items.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 42),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    label:
                        'Proceed to Checkout — \$${cart.total.toStringAsFixed(2)}',
                    onTap: () => context.push('/cart/checkout'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const _PriceSummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary)),
        Text('\$${value.toStringAsFixed(2)}',
            style: AppTextStyles.bodyLarge
                .copyWith(fontWeight: FontWeight.w600, color: AppColors.text)),
      ],
    );
  }
}
