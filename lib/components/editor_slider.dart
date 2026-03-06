import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/product.dart';

class EditorSlider extends StatefulWidget {
  final List<Product> picks;
  final ValueChanged<Product> onSelect;

  const EditorSlider({
    super.key,
    required this.picks,
    required this.onSelect,
  });

  @override
  State<EditorSlider> createState() => _EditorSliderState();
}

class _EditorSliderState extends State<EditorSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_currentPage < widget.picks.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<LinearGradient> _backgrounds = [
    const LinearGradient(
      colors: [Color(0xFF1A1510), Color(0xFF2A2015), Color(0xFF1A1510)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF101A15), Color(0xFF152A20), Color(0xFF101A15)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF15101A), Color(0xFF201520), Color(0xFF15101A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF1A1015), Color(0xFF2A1520), Color(0xFF1A1015)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.picks.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: widget.picks.length,
            itemBuilder: (context, index) {
              final product = widget.picks[index];
              return _SliderCard(
                product: product,
                gradient: _backgrounds[index % _backgrounds.length],
                onTap: () => widget.onSelect(product),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.picks.length, (index) {
            final active = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: active
                    ? AppColors.gold
                    : AppColors.gold.withValues(alpha: 0.25),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SliderCard extends StatelessWidget {
  final Product product;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _SliderCard({
    required this.product,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Radial Glow
            Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              width: 200,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 1,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "EDITOR'S PICK",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      product.name,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.text,
                        fontSize: 22,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(0)}",
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.gold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "750ml",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottle Image/Emoji Placeholder
            Positioned(
              right: 12,
              bottom: -15,
              child: Hero(
                tag: 'slider-item-${product.id}',
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    product.image,
                    style: const TextStyle(fontSize: 130),
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
