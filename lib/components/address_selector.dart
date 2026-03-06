import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/address.dart';
import '../data/drinks_data.dart';
import '../theme/app_decorations.dart';

/// Address selector row in multiple variants for Liquid Gold.
enum AddressSelectorVariant { header, compact, full }

class AddressSelector extends StatelessWidget {
  final int selectedId;
  final VoidCallback onTap;
  final AddressSelectorVariant variant;

  const AddressSelector({
    super.key,
    required this.selectedId,
    required this.onTap,
    this.variant = AddressSelectorVariant.full,
  });

  Address get _address => DrinksData.savedAddresses.firstWhere(
        (a) => a.id == selectedId,
        orElse: () => DrinksData.savedAddresses.first,
      );

  @override
  Widget build(BuildContext context) {
    final addr = _address;
    final isHeader = variant == AddressSelectorVariant.header;
    final isCompact = variant == AddressSelectorVariant.compact;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isCompact
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
            : isHeader
                ? const EdgeInsets.symmetric(vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isCompact
            ? BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              )
            : null,
        child: Row(
          mainAxisSize: isHeader ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (!isHeader) ...[
              Container(
                width: isCompact ? 32 : 44,
                height: isCompact ? 32 : 44,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: Text(
                  addr.icon,
                  style: TextStyle(fontSize: isCompact ? 14 : 20),
                ),
              ),
              SizedBox(width: isCompact ? 8 : 12),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isHeader)
                    Text(
                      'Deliver to ✦',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isHeader) ...[
                        Text(addr.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          isHeader ? addr.address.split(',').first : addr.label,
                          style: isHeader
                              ? AppTextStyles.h3.copyWith(fontSize: 16)
                              : AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isCompact ? 13 : 15,
                                ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isHeader) ...[
                        const SizedBox(width: 8),
                        _typeBadge(addr.type),
                      ],
                    ],
                  ),
                  if (!isHeader)
                    Text(
                      addr.address,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.gold.withValues(alpha: 0.6),
              size: isHeader ? 18 : 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Text(
        type.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.gold,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AddressBottomSheet extends StatelessWidget {
  final int selectedId;
  final ValueChanged<int> onSelect;
  final VoidCallback onAddNew;

  const AddressBottomSheet({
    super.key,
    required this.selectedId,
    required this.onSelect,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      decoration: AppDecorations.bottomSheet,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Select Delivery Address', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ...DrinksData.savedAddresses.map((addr) {
            final isSelected = addr.id == selectedId;
            return GestureDetector(
              onTap: () {
                onSelect(addr.id);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.gold.withValues(alpha: 0.1)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.gold : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.gold.withValues(alpha: 0.2)
                            : AppColors.textTertiary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        addr.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addr.label,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(addr.address, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.gold,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          // Add new
          GestureDetector(
            onTap: onAddNew,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_location_alt_rounded,
                    color: AppColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add a new location',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
