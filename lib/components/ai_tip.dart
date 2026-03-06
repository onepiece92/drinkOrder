import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/nav_provider.dart';

class AiTip extends StatefulWidget {
  const AiTip({super.key});

  @override
  State<AiTip> createState() => _AiTipState();
}

class _AiTipState extends State<AiTip> with SingleTickerProviderStateMixin {
  late String _currentTip;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final List<String> _tips = [
    "Single malt whiskeys are often aged in ex-bourbon or sherry casks, which significantly influence their final flavor profile.",
    "A drop of water can open up the aromas of a high-proof whiskey, revealing hidden notes of vanilla, spice, or peat.",
    "Vintage Champagnes are only produced in exceptional years, ensuring a unique and prestigious tasting experience.",
    "The 'botanicals' in gin, like juniper, coriander, and citrus peel, are what create its distinct and refreshing character.",
    "Ultra-premium tequilas are made from 100% Blue Agave and slow-cooked for days to achieve a smooth, rich complexity.",
    "Proper glassware, like a Glencairn for whiskey or a tulip glass for Champagne, enhances the sensory experience of fine spirits.",
    "The 'angel's share' refers to the small amount of spirit that evaporates from the barrel during the aging process.",
    "Sipping a fine spirit slowly allows you to appreciate the layers of complexity and the long, satisfying finish.",
  ];

  NavProvider? _navProvider;

  @override
  void initState() {
    super.initState();
    _currentTip = _tips[Random().nextInt(_tips.length)];
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navProvider ??= context.read<NavProvider>()..addListener(_generateNewTip);
  }

  @override
  void dispose() {
    _navProvider?.removeListener(_generateNewTip);
    _animCtrl.dispose();
    super.dispose();
  }

  void _generateNewTip() {
    if (_animCtrl.isAnimating) return;
    _animCtrl.reverse().then((_) {
      setState(() {
        String newTip;
        do {
          newTip = _tips[Random().nextInt(_tips.length)];
        } while (newTip == _currentTip && _tips.length > 1);
        _currentTip = newTip;
      });
      _animCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _generateNewTip,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome_rounded,
                  color: Theme.of(context).colorScheme.tertiary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cellar Master\'s Tip',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 6),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      _currentTip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.4,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
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
