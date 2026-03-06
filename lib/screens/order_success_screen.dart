import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
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

  late final List<({String desc, IconData icon, String label})> _steps = [
    (
      icon: Icons.auto_awesome,
      label: 'Acquisition Secured',
      desc: 'Exclusive selection confirmed by boutique'
    ),
    (
      icon: Icons.wine_bar,
      label: 'Sommelier Appraisal',
      desc: 'Ensuring vintage and quality standards'
    ),
    (
      icon: Icons.local_shipping,
      label: 'Private Dispatch',
      desc:
          'Bespoke delivery estimated at ${DateFormat('h:mm a').format(DateTime.now().add(const Duration(minutes: 45)))}'
    ),
  ];

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 64),
            // Success icon
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(44),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.35),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check_rounded,
                    color: Colors.black, size: 70),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  Text('RESERVATION SECURED',
                      style: AppTextStyles.h1
                          .copyWith(fontSize: 26, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  Text(
                    'REFERENCE #LG-${1000 + DateTime.now().minute} • Processed with Discretion',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gold.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
            // Progress
            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 25,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VAULT PROGRESS',
                            style: AppTextStyles.h3.copyWith(fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Step 1 of 3',
                              style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ..._steps.asMap().entries.map((e) {
                      final i = e.key;
                      final s = e.value;
                      final isActive = i == 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.gold.withValues(alpha: 0.1)
                                    : AppColors.background
                                        .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.gold.withValues(alpha: 0.3)
                                      : AppColors.gold.withValues(alpha: 0.05),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(s.icon,
                                  size: 22,
                                  color: isActive
                                      ? AppColors.gold
                                      : AppColors.gold.withValues(alpha: 0.5)),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.label,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: isActive
                                            ? AppColors.text
                                            : AppColors.textTertiary,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 15,
                                      )),
                                  const SizedBox(height: 2),
                                  Text(s.desc,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                            if (isActive)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.gold, blurRadius: 8)
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
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
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: 1.0 - _countdownCtrl.value,
                            strokeWidth: 3,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.gold),
                          ),
                        ),
                        Text(
                          '$_secondsLeft',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Returning to boutique...',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
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
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
