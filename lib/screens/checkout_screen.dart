import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../models/address.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/orders_provider.dart';
import '../models/order.dart';
import '../components/product_card.dart';
import '../components/primary_button.dart';
import '../components/gold_back_button.dart';
import '../components/empty_cart_view.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 1; // 1 = delivery, 2 = payment & confirm
  int _selectedPayment = 2; // Default to Cash

  static const _paymentMethods = [
    (icon: '💳', label: '•••• 4289', sub: 'Visa ending in 4289'),
    (icon: '🍎', label: 'Apple Pay', sub: 'Express checkout'),
    (icon: '💵', label: 'Cash', sub: 'Pay on delivery or pickup'),
  ];

  String _stepLabel(Address addr) =>
      addr.type == 'Pickup' ? 'Pickup' : 'Delivery';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addr = context.watch<AddressProvider>().selected;
    final step1Label = _stepLabel(addr);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: GoldBackButton(),
        ),
        title: Text('Checkout', style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: cart.items.isEmpty
            ? const EmptyCartView()
            : Stack(
                children: [
                  Column(
                    children: [
                      // Step indicator
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Row(
                          children: [
                            _StepIndicator(
                                label: step1Label, step: 1, current: _step),
                            const SizedBox(width: 6),
                            _StepIndicator(
                                label: 'Payment & Confirm',
                                step: 2,
                                current: _step),
                          ],
                        ),
                      ),

                      // Step content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _step == 1
                                ? _Step1(addr: addr, key: const ValueKey(1))
                                : _Step2(
                                    cart: cart,
                                    addr: addr,
                                    methods: _paymentMethods,
                                    selected: _selectedPayment,
                                    onSelect: (i) =>
                                        setState(() => _selectedPayment = i),
                                    key: const ValueKey(2),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // CTA Button
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                          24, 16, 24, 42), // padding for safe area
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
                        label: _step < 2
                            ? 'Continue'
                            : 'Place Order — \$${cart.total.toStringAsFixed(2)}',
                        onTap: () {
                          if (_step < 2) {
                            setState(() => _step++);
                          } else {
                            // Create and save order
                            final orderItems = cart.items
                                .map((item) => OrderItem(
                                      name: item.product.name,
                                      image: item.product.image,
                                      qty: item.quantity,
                                      rate: item.product.price,
                                    ))
                                .toList();

                            final newOrder = Order(
                              id: '#LG-${DateFormat('SSSmm').format(DateTime.now())}',
                              date: 'Just now',
                              items: orderItems,
                              subtotal: cart.total,
                              discount: 0.0,
                              grandTotal: cart.total,
                              status: 'Processing',
                              paymentMode:
                                  _paymentMethods[_selectedPayment].label,
                            );

                            context.read<OrdersProvider>().addOrder(newOrder);
                            context.go('/cart/checkout/success');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final int step;
  final int current;

  const _StepIndicator(
      {required this.label, required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    final active = step <= current;
    final isCurrent = step == current;
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 3,
            decoration: BoxDecoration(
              color: active ? AppColors.gold : AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: active ? AppColors.gold : AppColors.textSecondary,
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  final dynamic addr;

  const _Step1({required this.addr, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${addr.type == 'Pickup' ? 'Pickup' : 'Delivery'} Details',
            style: AppTextStyles.h2),
        const SizedBox(height: 16),
        _InfoTile(
          label: addr.type == 'Pickup' ? 'PICKUP LOCATION' : 'DELIVERY ADDRESS',
          icon: addr.icon,
          title: addr.label,
          subtitle: addr.address,
        ),
        const SizedBox(height: 12),
        _InfoTile(
          label: '${addr.type == 'Pickup' ? 'PICKUP' : 'DELIVERY'} TIME',
          icon: '🕐',
          title:
              'Today, ${DateFormat('h:mm a').format(DateTime.now().add(const Duration(minutes: 25)))}',
          subtitle: null,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SPECIAL INSTRUCTIONS',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.gold,
                        fontSize: 11,
                        letterSpacing: 0.5)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Any special requests for your order...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    isDense: false,
                    contentPadding: const EdgeInsets.only(top: 8),
                  ),
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String icon;
  final String title;
  final String? subtitle;

  const _InfoTile({
    required this.label,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.gold, fontSize: 11, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.text)),
                      if (subtitle != null)
                        Text(subtitle!,
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  final CartProvider cart;
  final dynamic addr;
  final List<({String icon, String label, String sub})> methods;
  final int selected;
  final ValueChanged<int> onSelect;

  const _Step2(
      {required this.cart,
      required this.addr,
      required this.methods,
      required this.selected,
      required this.onSelect,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        // Product list section
        ...cart.items.map((item) {
          final favProv = context.watch<FavouritesProvider>();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductCard(
              product: item.product,
              onTap: () => context.push('/home/product', extra: item.product),
              onQuickAdd: () => cart.addProduct(item.product),
              isFavourite: favProv.isFavourite(item.product.id),
              onToggleFavourite: () => favProv.toggle(item.product.id),
            ),
          );
        }),
        const SizedBox(height: 24),

        // Total summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  Text('\$${cart.total.toStringAsFixed(2)}',
                      style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w900, color: AppColors.gold)),
                ],
              ),
              Icon(Icons.receipt_long_rounded,
                  color: AppColors.gold.withValues(alpha: 0.5), size: 32),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Payment Method', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        ...methods.asMap().entries.map((e) {
          final i = e.key;
          final m = e.value;
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isSelected ? AppColors.gold : AppColors.border,
                    width: 1.5),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.gold.withValues(alpha: 0.1)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(m.icon, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.label,
                              style: AppTextStyles.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(m.sub,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            color: AppColors.gold, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.check_rounded,
                            color: Colors.black, size: 14),
                      )
                    else
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.border, width: 2)),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
