import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import 'app_shell.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/recent_orders_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/profile_sub_screens.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _favouritesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'favourites');
final GlobalKey<NavigatorState> _cartNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'cart');
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      title: Text('Lost in Cellar', style: AppTextStyles.h3),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.gold,
                size: 150,
              ),
            ),
            const SizedBox(height: 32),
            Text('Vintage Not Found', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Text(
                "We couldn't locate the premium experience you're looking for.",
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.gold, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.go('/home');
                },
                child: Text('Return to Boutique',
                    style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.gold, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'product',
                  builder: (context, state) {
                    final product = state.extra as Product;
                    return ProductDetailScreen(product: product);
                  },
                ),
                GoRoute(
                  path: 'recent_orders',
                  builder: (context, state) => const RecentOrdersScreen(),
                ),
              ],
            ),
          ],
        ),

        // Branch 1: Favourites
        StatefulShellBranch(
          navigatorKey: _favouritesNavigatorKey,
          routes: [
            GoRoute(
              path: '/favourites',
              builder: (context, state) => const FavouritesScreen(),
              routes: [
                GoRoute(
                  path: 'product',
                  builder: (context, state) {
                    final product = state.extra as Product;
                    return ProductDetailScreen(product: product);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Cart & Checkout flow
        StatefulShellBranch(
          navigatorKey: _cartNavigatorKey,
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
              routes: [
                GoRoute(
                  path: 'checkout',
                  builder: (context, state) => const CheckoutScreen(),
                  routes: [
                    GoRoute(
                      path: 'success',
                      builder: (context, state) => const OrderSuccessScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Branch 3: Profile
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'addresses',
                  builder: (context, state) => const SavedAddressesScreen(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const AddNewAddressScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'payments',
                  builder: (context, state) => const PaymentMethodsScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: 'orders',
                  builder: (context, state) => const RecentOrdersScreen(),
                ),
                GoRoute(
                  path: 'favourites',
                  builder: (context, state) => const FavouritesScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
