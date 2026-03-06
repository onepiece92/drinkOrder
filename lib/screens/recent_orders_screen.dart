import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/reorder_card.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../components/gold_back_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class RecentOrdersScreen extends StatefulWidget {
  const RecentOrdersScreen({super.key});

  @override
  State<RecentOrdersScreen> createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _pageCtrl;
  late Animation<double> _pageFade;
  late Animation<Offset> _pageSlide;

  final List<AnimationController> _cardCtrls = [];

  @override
  void initState() {
    super.initState();

    _pageCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pageFade = CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut));

    final orders = context.read<OrdersProvider>().orders;
    for (var i = 0; i < orders.length; i++) {
      final ctrl = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      _cardCtrls.add(ctrl);
    }

    // Stagger card animations exactly like JSX (0.15 + i * 0.1s delay)
    Future.microtask(() async {
      _pageCtrl.forward();
      for (var i = 0; i < _cardCtrls.length; i++) {
        await Future.delayed(Duration(milliseconds: 150 + i * 100));
        if (mounted) _cardCtrls[i].forward();
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in _cardCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final totalSpent = orders.fold<double>(0, (sum, o) => sum + o.total);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: GoldBackButton(),
        ),
        title: Text('ORDER HISTORY',
            style: AppTextStyles.h3.copyWith(letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Scrollable body ──────────────────────────────────
            Expanded(
              child: FadeTransition(
                opacity: _pageFade,
                child: SlideTransition(
                  position: _pageSlide,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    children: [
                      // ── This Month summary card ──────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THIS MONTH',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                )),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${orders.length}',
                                      style:
                                          AppTextStyles.displayLarge.copyWith(
                                        color: Colors.black,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'acquisitions',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color:
                                            Colors.black.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${totalSpent.toStringAsFixed(2)}',
                                      style:
                                          AppTextStyles.displayLarge.copyWith(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'total worth',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color:
                                            Colors.black.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ── Order cards ──────────────────────────────
                      ...orders.asMap().entries.map((entry) {
                        final i = entry.key;
                        final order = entry.value;
                        final ctrl = _cardCtrls[i];
                        return FadeTransition(
                          opacity: CurvedAnimation(
                              parent: ctrl, curve: Curves.easeOut),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: ctrl, curve: Curves.easeOut)),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OrderCard(
                                order: order,
                                featured: false,
                                onReorder: () {
                                  context.read<CartProvider>().reorder(order);
                                  context.push('/cart');
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
