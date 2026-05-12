import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.health,
                  label: 'Medicine Management',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.hospital,
                  label: 'Patho Lab Management',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: IconsaxPlusLinear.shop,
                  label: 'Pharmacy Shop Management',
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
                  icon: IconsaxPlusLinear.setting_2,
                  label: 'Settings',
                  onTap: () {},
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
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.blush,
                child: Icon(
                  IconsaxPlusLinear.user,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'admin@medy24.com',
                      style: AppTextStyles.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
