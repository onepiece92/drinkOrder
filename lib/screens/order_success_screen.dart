import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _countdownCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  int _secondsLeft = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Clear the cart silently behind the scenes
    Future.microtask(() {
      if (mounted) {
        context.read<CartProvider>().clear();
      }
    });

    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _scaleAnim =
        CurvedAnimation(parent: _contentCtrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentCtrl.forward();
    });

    // Countdown ring animation
    _countdownCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    // Reliable per-second timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        GoRouter.of(context).go('/home/recent_orders');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiCtrl.dispose();
    _contentCtrl.dispose();
    _countdownCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final latestOrder = orders.isNotEmpty ? orders.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 48),
            // Success icon
            ScaleTransition(
              scale: _scaleAnim,
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check_rounded,
                      color: Colors.black, size: 54),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  Text('ORDER SUCCESSFUL',
                      style: AppTextStyles.h1
                          .copyWith(fontSize: 22, letterSpacing: 3)),
                  const SizedBox(height: 8),
                  Text(
                    'Your exquisite selection is being prepared',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gold.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Receipt Section
            if (latestOrder != null)
              FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Courier', // Receipt font feel
                      fontSize: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Business Name: Liquid Gold',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Boutique branch'),
                            Text(
                                'Paid Bill No.: ${latestOrder.id.replaceAll('#LG-', '')}'),
                          ],
                        ),
                        const Divider(color: Colors.black38, height: 24),
                        const Text('Items Ordered',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text('Name',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline))),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text('Qty',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline)))),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text('Rate',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline)))),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('Amt',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline)))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...latestOrder.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text(item.name)),
                                  Expanded(
                                      flex: 1,
                                      child:
                                          Center(child: Text('x ${item.qty}'))),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text(
                                              item.rate.toStringAsFixed(2)))),
                                  Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              item.amount.toStringAsFixed(2)))),
                                ],
                              ),
                            )),
                        const Divider(color: Colors.black38, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total'),
                            Text(latestOrder.subtotal.toStringAsFixed(2)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount'),
                            Text(latestOrder.discount.toStringAsFixed(2)),
                          ],
                        ),
                        const Divider(color: Colors.black38, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(latestOrder.grandTotal.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(color: Colors.black38, height: 24),
                        const Text('Cashier',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(latestOrder.cashier),
                            Text('Payment Mode: ${latestOrder.paymentMode}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Counter: ${latestOrder.counter}'),
                            Text(
                                'Date: ${latestOrder.date == 'Just now' ? DateFormat('MM/dd/yyyy h:mm:ss a').format(DateTime.now()) : latestOrder.date}'),
                          ],
                        ),
                        const Divider(color: Colors.black38, height: 24),
                        const Text('Buzz Points',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Current'),
                            Text('${latestOrder.buzzPoints}'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total'),
                            Text('0.00'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 40),
            // Auto-redirect countdown ring
            AnimatedBuilder(
              animation: _countdownCtrl,
              builder: (context, child) {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 1.0 - _countdownCtrl.value,
                            strokeWidth: 2,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.gold),
                          ),
                        ),
                        Text(
                          '$_secondsLeft',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Returning to boutique...',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => context.go('/home/recent_orders'),
                      child: Text(
                        'GO NOW',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 2,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
