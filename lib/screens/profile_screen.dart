import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/loyalty_card.dart';
import '../components/service_icon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          children: [
            Text('Cellar Account', style: AppTextStyles.h1),
            const SizedBox(height: 24),

            // Profile card
            GestureDetector(
              onTap: () => context.push('/profile/edit'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'A',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alexander Grant',
                              style: AppTextStyles.h3.copyWith(fontSize: 20)),
                          const SizedBox(height: 2),
                          Text('alexander.g@premium.com',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.stars_rounded,
                                    color: AppColors.gold, size: 14),
                                const SizedBox(width: 6),
                                Text('✦ Gold Reserve Member',
                                    style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.gold,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColors.textTertiary, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Loyalty card
            const LoyaltyCard(),
            const SizedBox(height: 32),

            // Menu sections
            const _SectionHeader(label: 'EXPERIENCE & HISTORY'),
            const SizedBox(height: 12),
            _MenuTile(
                icon: Icons.history_rounded,
                label: 'Previous Vintages',
                sub: 'Recent drink orders',
                onTap: () => context.push('/profile/orders')),
            _MenuTile(
                icon: Icons.star_rounded,
                label: 'The Cellar List',
                sub: 'Favourite premium spirits',
                onTap: () => context.push('/profile/favourites')),

            const SizedBox(height: 28),
            const _SectionHeader(label: 'CURATED ACCOUNT'),
            const SizedBox(height: 12),
            _MenuTile(
                icon: Icons.location_on_outlined,
                label: 'Delivery Vaults',
                sub: 'Manage saved addresses',
                onTap: () => context.push('/profile/addresses')),
            _MenuTile(
                icon: Icons.credit_card_rounded,
                label: 'Payment Treasury',
                sub: 'Cards & digital assets',
                onTap: () => context.push('/profile/payments')),

            const SizedBox(height: 28),
            const _SectionHeader(label: 'PREFERENCES'),
            const SizedBox(height: 12),
            _MenuTile(
                icon: Icons.notifications_outlined,
                label: 'Concierge Notifications',
                sub: 'Stay updated on new releases',
                onTap: () => context.push('/profile/notifications')),
            _MenuTile(
                icon: Icons.settings_outlined,
                label: 'Boutique Settings',
                sub: 'App preferences & security',
                onTap: () => context.push('/profile/settings')),

            const SizedBox(height: 40),

            // Sign out
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2C1A1A),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.redAccent.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const ServiceIcon(
                    icon: Icons.logout_rounded,
                    backgroundColor: Color(0xFF452020),
                    iconColor: Colors.redAccent,
                  ),
                  const SizedBox(width: 16),
                  Text('Exit Boutique',
                      style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Icon(Icons.power_settings_new_rounded,
                      color: Colors.redAccent.withValues(alpha: 0.5), size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.gold.withValues(alpha: 0.6),
        letterSpacing: 1.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String? sub;
  final VoidCallback? onTap;

  const _MenuTile(
      {required this.icon, required this.label, this.sub, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ServiceIcon(
              icon: icon,
              size: 48,
              iconSize: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  if (sub != null)
                    Text(sub!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        )),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiary, size: 14),
          ],
        ),
      ),
    );
  }
}
