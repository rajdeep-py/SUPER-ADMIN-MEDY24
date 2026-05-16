import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSpacing.borderRadius),
          bottomRight: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      child: Column(
        children: [
          // Header Section
          _buildHeader(),

          const SizedBox(height: AppSpacing.elementGap),

          // Navigation Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.element_3,
                  label: 'Dashboard',
                  isSelected: currentRoute == '/',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.microscope,
                  label: 'Lab Test Management',
                  isSelected: currentRoute == AppRouter.labTestList,
                  onTap: () => context.push(AppRouter.labTestList),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.health,
                  label: 'Medicine Management',
                  isSelected: currentRoute == AppRouter.medicineManagement,
                  onTap: () => context.push(AppRouter.medicineManagement),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.user_search,
                  label: 'Customer Management',
                  isSelected: currentRoute == AppRouter.customerList,
                  onTap: () => context.push(AppRouter.customerList),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.hospital,
                  label: 'Patho Lab Management',
                  isSelected: currentRoute == AppRouter.pathoLabList,
                  onTap: () => context.push(AppRouter.pathoLabList),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.shop,
                  label: 'Pharmacy Shop Management',
                  isSelected: currentRoute == AppRouter.pharmaShopList,
                  onTap: () => context.push(AppRouter.pharmaShopList),
                ),

                // Nested Order Management
                _buildNestedNavItem(
                  context,
                  icon: IconsaxPlusLinear.box,
                  label: 'Order Management',
                  children: [
                    _buildSubNavItem(
                      context,
                      icon: IconsaxPlusLinear.receipt_item,
                      label: 'Lab Test Orders',
                      onTap: () {},
                    ),
                    _buildSubNavItem(
                      context,
                      icon: IconsaxPlusLinear.bag_tick,
                      label: 'Medicine Orders',
                      onTap: () {},
                    ),
                  ],
                ),

                // Nested Payments & Subscriptions
                _buildNestedNavItem(
                  context,
                  icon: IconsaxPlusLinear.wallet,
                  label: 'Payments & Subscriptions',
                  children: [
                    _buildSubNavItem(
                      context,
                      icon: IconsaxPlusLinear.hospital,
                      label: 'Patho Lab',
                      onTap: () {},
                    ),
                    _buildSubNavItem(
                      context,
                      icon: IconsaxPlusLinear.shop,
                      label: 'Pharmacy Shops',
                      onTap: () {},
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Divider(color: AppColors.divider),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.building,
                  label: 'Company Profile Management',
                  isSelected: currentRoute == AppRouter.aboutUs,
                  onTap: () => context.push(AppRouter.aboutUs),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.document_text,
                  label: 'Terms & Conditions',
                  isSelected: currentRoute == AppRouter.termsConditions,
                  onTap: () => context.push(AppRouter.termsConditions),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.shield_tick,
                  label: 'Privacy Policy',
                  isSelected: currentRoute == AppRouter.privacyPolicy,
                  onTap: () => context.push(AppRouter.privacyPolicy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset('assets/logo/logo.png', width: 32, height: 32),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MEDY24',
                style: AppTextStyles.header.copyWith(
                  fontSize: 20,
                  color: AppColors.primaryAccent,
                ),
              ),
              Text(
                'Super Admin',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(20)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
          size: 22,
        ),
        title: Text(
          label,
          style: AppTextStyles.description.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primaryAccent : AppColors.textPrimary,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildNestedNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ExpansionTile(
          leading: Icon(icon, color: AppColors.textSecondary, size: 22),
          title: Text(
            label,
            style: AppTextStyles.description.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.primaryAccent,
          collapsedIconColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          childrenPadding: const EdgeInsets.only(left: 12),
          children: children,
        ),
      ),
    );
  }

  Widget _buildSubNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryAccent : AppColors.textTertiary,
          size: 18,
        ),
        title: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? AppColors.primaryAccent
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
