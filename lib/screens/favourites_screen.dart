import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/drinks_data.dart';
import '../providers/favourites_provider.dart';
import '../providers/cart_provider.dart';
import '../components/grid_product_card.dart';
import '../components/browse_menu_button.dart';
import '../components/gold_back_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final cart = context.read<CartProvider>();
    final favs =
        DrinksData.products.where((p) => favProv.isFavourite(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: GoldBackButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Favourites',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${favs.length} saved item${favs.length != 1 ? 's' : ''}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: favs.isEmpty
                  ? _EmptyFavourites()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: favs.length,
                      itemBuilder: (_, i) {
                        final p = favs[i];
                        return GridProductCard(
                          product: p,
                          onTap: () =>
                              context.push('/favourites/product', extra: p),
                          onQuickAdd: () => cart.addProduct(p),
                          isFavourite: favProv.isFavourite(p.id),
                          onToggleFavourite: () => favProv.toggle(p.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Icon(
                Icons.favorite_border_rounded,
                size: 150,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No favourites yet',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the ♡ on any item to save it here",
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const BrowseMenuButton(),
          ],
        ),
      ),
    );
  }
}
