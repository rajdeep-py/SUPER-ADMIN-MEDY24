import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                  isSelected: true, // Defaulting to dashboard for demo
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.microscope,
                  label: 'Lab Test Management',
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.labTestList,
                  onTap: () => context.push(AppRouter.labTestList),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.health,
                  label: 'Medicine Management',
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.medicineManagement,
                  onTap: () => context.push(AppRouter.medicineManagement),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.hospital,
                  label: 'Patho Lab Management',
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.pathoLabList,
                  onTap: () => context.push(AppRouter.pathoLabList),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.shop,
                  label: 'Pharmacy Shop Management',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.wallet,
                  label: 'Payments & Subscriptions',
                  onTap: () {},
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
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.aboutUs,
                  onTap: () => context.push(AppRouter.aboutUs),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.document_text,
                  label: 'Terms & Conditions',
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.termsConditions,
                  onTap: () => context.push(AppRouter.termsConditions),
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.shield_tick,
                  label: 'Privacy Policy',
                  isSelected:
                      GoRouterState.of(context).uri.toString() ==
                      AppRouter.privacyPolicy,
                  onTap: () => context.push(AppRouter.privacyPolicy),
                ),
              ],
            ),
          ),

          // Footer / Logout
          _buildFooter(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo/logo.png',
                    width: 32,
                    height: 32,
                  ),
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    IconsaxPlusLinear.logout,
                    color: AppColors.error,
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Logout',
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.error,
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
