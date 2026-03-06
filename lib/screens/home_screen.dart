import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../data/drinks_data.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/address_provider.dart';
import '../components/address_selector.dart';
import '../components/category_pill.dart';
import '../components/product_card.dart';
import '../components/grid_product_card.dart';
import '../components/editor_slider.dart';
import '../components/section_header.dart';
import '../providers/nav_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _sortBy = 'default';
  bool _gridView = true;
  final _searchCtrl = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _quickAdd(Product product) {
    context.read<CartProvider>().addProduct(product);
  }

  void _showAddressSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => AddressBottomSheet(
        selectedId: context.read<AddressProvider>().selectedId,
        onSelect: (id) => context.read<AddressProvider>().select(id),
        onAddNew: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Product> get _filtered {
    List<Product> list = _selectedCategory == 'all'
        ? List.of(DrinksData.products)
        : DrinksData.products
            .where((p) => p.category == _selectedCategory)
            .toList();

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    switch (_sortBy) {
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
        list.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final addrProv = context.watch<AddressProvider>();
    final filtered = _filtered;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: AddressSelector(
                    selectedId: addrProv.selectedId,
                    onTap: _showAddressSheet,
                    variant: AddressSelectorVariant.header,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => context.push('/profile/notifications'),
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.card,
                    foregroundColor: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Search ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _SearchBar(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              onClear: () {
                _searchCtrl.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Category Pills ───────────────────────────────────────
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              children: [
                CategoryPill(
                  label: 'All',
                  icon: '✦',
                  active: _selectedCategory == 'all',
                  onTap: () {
                    setState(() => _selectedCategory = 'all');
                    context.read<NavProvider>().triggerCategoryChange();
                  },
                ),
                const SizedBox(width: 10),
                ...DrinksData.categories.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CategoryPill(
                      label: c.label,
                      icon: c.icon,
                      active: _selectedCategory == c.id,
                      onTap: () {
                        setState(() => _selectedCategory = c.id);
                        context.read<NavProvider>().triggerCategoryChange();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Scrollable content ───────────────────────────────────
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              children: [
                EditorSlider(
                  picks: DrinksData.products.take(4).toList(),
                  onSelect: (p) => context.push('/home/product', extra: p),
                ),
                const SizedBox(height: 24),

                // Section title + Sort + View toggle
                SectionHeader(
                  title: _selectedCategory == 'all'
                      ? 'Premium Selection'
                      : DrinksData.categories
                          .firstWhere((c) => c.id == _selectedCategory)
                          .label,
                  trailing: Row(
                    children: [
                      _SortButton(
                        sortBy: _sortBy,
                        onChanged: (v) => setState(() => _sortBy = v),
                      ),
                      const SizedBox(width: 6),
                      _ViewToggle(
                        isGrid: _gridView,
                        onToggle: (v) => setState(() => _gridView = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Results
                if (filtered.isEmpty)
                  _EmptyState(
                    onClear: () => setState(() {
                      _searchQuery = '';
                      _searchCtrl.clear();
                      _sortBy = 'default';
                      _selectedCategory = 'all';
                    }),
                  )
                else if (_gridView)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return GridProductCard(
                        product: p,
                        onTap: () => context.push('/home/product', extra: p),
                        onQuickAdd: () => _quickAdd(p),
                        isFavourite: favProv.isFavourite(p.id),
                        onToggleFavourite: () => favProv.toggle(p.id),
                      );
                    },
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return ProductCard(
                        product: p,
                        onTap: () => context.push('/home/product', extra: p),
                        onQuickAdd: () => _quickAdd(p),
                        isFavourite: favProv.isFavourite(p.id),
                        onToggleFavourite: () => favProv.toggle(p.id),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        hintText: 'Search collection...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textTertiary,
          size: 20,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String> onChanged;

  const _SortButton({required this.sortBy, required this.onChanged});

  static const _options = [
    ('default', 'Default'),
    ('price_low', 'Price: Low → High'),
    ('price_high', 'Price: High → Low'),
    ('rating', 'Top Rated'),
    ('popular', 'Most Popular'),
  ];

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sort by',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ..._options.map(
                  (opt) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      onChanged(opt.$1);
                      Navigator.pop(context);
                    },
                    title: Text(opt.$2),
                    trailing: sortBy == opt.$1
                        ? const Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.sort_rounded, size: 20),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isGrid;
  final ValueChanged<bool> onToggle;

  const _ViewToggle({required this.isGrid, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onToggle(false),
          icon: Icon(
            Icons.view_list_rounded,
            color: !isGrid ? AppColors.gold : AppColors.textTertiary,
          ),
        ),
        IconButton(
          onPressed: () => onToggle(true),
          icon: Icon(
            Icons.grid_view_rounded,
            color: isGrid ? AppColors.gold : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No items found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          OutlinedButton(onPressed: onClear, child: const Text('Clear all')),
        ],
      ),
    );
  }
}
