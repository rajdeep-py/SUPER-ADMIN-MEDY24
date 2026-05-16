import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/customer.dart';
import '../../theme/app_theme.dart';
import '../../providers/customer_provider.dart';
import '../../services/api_url.dart';

class CustomerTableCard extends ConsumerWidget {
  final Customer customer;

  const CustomerTableCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor;
    switch (customer.status?.toLowerCase() ?? 'active') {
      case 'active':
        statusColor = AppColors.success;
        break;
      case 'suspended':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textTertiary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Customer ID
          Expanded(
            flex: 2,
            child: Text(
              customer.customerId ?? 'N/A',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Profile Photo
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 1),
                  image: customer.profilePhoto != null &&
                          customer.profilePhoto!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            customer.profilePhoto!.startsWith('http')
                                ? customer.profilePhoto!
                                : '${ApiUrls.baseUrl}${customer.profilePhoto!.startsWith('/') ? customer.profilePhoto!.substring(1) : customer.profilePhoto}',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: customer.profilePhoto == null ||
                        customer.profilePhoto!.isEmpty
                    ? const Icon(IconsaxPlusLinear.user,
                        size: 20, color: AppColors.textTertiary)
                    : null,
              ),
            ),
          ),

          // Name
          Expanded(
            flex: 3,
            child: Text(
              customer.fullName ?? 'N/A',
              style: AppTextStyles.description.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Phone No
          Expanded(
            flex: 2,
            child: Text(
              customer.phoneNumber ?? 'N/A',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Alt Phone No
          Expanded(
            flex: 2,
            child: Text(
              customer.alternativePhoneNo ?? 'N/A',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ),

          // Email
          Expanded(
            flex: 3,
            child: Text(
              customer.email ?? 'N/A',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Saved Addresses
          Expanded(
            flex: 2,
            child: Text(
              customer.savedAddresses != null && customer.savedAddresses!.isNotEmpty
                  ? customer.savedAddresses!.first.address1 ?? 'No Address'
                  : 'No Address',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Status & Action
          Expanded(
            flex: 2,
            child: Center(
              child: _buildStatusDropdown(ref, statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(WidgetRef ref, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withAlpha(50)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: customer.status?.toLowerCase() ?? 'active',
          isDense: true,
          icon: Icon(IconsaxPlusLinear.arrow_down_1, size: 14, color: statusColor),
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(customerProvider.notifier)
                  .updateStatus(customer.customerId!, value);
            }
          },
          items: ['active', 'suspended'].map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(
                s.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
