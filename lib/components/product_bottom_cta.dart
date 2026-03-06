import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism-style floating bottom CTA for the Product Detail screen.
/// A frosted-glass card with a quantity stepper, animated price, and a
/// pulsing basket-icon checkout button for Liquid Gold.
class ProductBottomCta extends StatefulWidget {
  final int quantity;
  final double totalPrice;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCheckout;

  const ProductBottomCta({
    super.key,
    required this.quantity,
    required this.totalPrice,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCheckout,
  });

  @override
  State<ProductBottomCta> createState() => _ProductBottomCtaState();
}

class _ProductBottomCtaState extends State<ProductBottomCta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.card.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Price
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOTAL VALUATION',
                              style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 9,
                                  letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Text(
                              '\$${widget.totalPrice.toStringAsFixed(2)}',
                              key: ValueKey(widget.totalPrice),
                              style: AppTextStyles.h2.copyWith(
                                  color: AppColors.gold,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stepper
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          _StepperButton(
                            icon: Icons.remove_rounded,
                            onTap: widget.onDecrement,
                            enabled: widget.quantity > 0,
                          ),
                          SizedBox(
                            width: 36,
                            child: Center(
                              child: Text(
                                '${widget.quantity}',
                                style: AppTextStyles.h3.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          _StepperButton(
                            icon: Icons.add_rounded,
                            onTap: widget.onIncrement,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Checkout Button
                    GestureDetector(
                      onTap: widget.onCheckout,
                      child: ScaleTransition(
                        scale: _pulseAnim,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag_rounded,
                                  color: Colors.black, size: 22),
                              const SizedBox(width: 10),
                              Text(
                                'RESERVE',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stepper button ────────────────────────────────────────────────────────────

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.gold : AppColors.textTertiary,
        ),
      ),
    );
  }
}
