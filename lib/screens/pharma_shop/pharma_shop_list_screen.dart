import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../notifiers/pharma_shop_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/pharma_shop/pharma_shop_card.dart';
import '../../cards/pharma_shop/pharma_shop_search_filter_card.dart';
import '../../providers/pharma_shop_provider.dart';
import '../../routes/app_router.dart';

class PharmaShopListScreen extends ConsumerStatefulWidget {
  const PharmaShopListScreen({super.key});

  @override
  ConsumerState<PharmaShopListScreen> createState() => _PharmaShopListScreenState();
}

class _PharmaShopListScreenState extends ConsumerState<PharmaShopListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final pharmaShopState = ref.watch(pharmaShopProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Pharma Shop Management',
        subtitle: 'Pharmacy Network Intelligence',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isSearchVisible
                ? IconsaxPlusLinear.search_status
                : IconsaxPlusLinear.search_normal_1,
            iconColor: _isSearchVisible ? AppColors.primaryAccent : null,
            onTap: () => setState(() => _isSearchVisible = !_isSearchVisible),
          ),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: pharmaShopState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(pharmaShopProvider.notifier).loadShops(),
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 32),
                  _buildStatsGrid(pharmaShopState),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[
                    const PharmaShopSearchFilterCard(),
                    const SizedBox(height: 32),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pharmacy Directory',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Real-time status of all registered pharmacies',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${pharmaShopState.filteredShops.length} TOTAL',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (pharmaShopState.filteredShops.isEmpty)
                    _buildEmptyState()
                  else
                    ...pharmaShopState.filteredShops.map(
                      (shop) => PharmaShopCard(
                        shop: shop,
                        onTap: () => context.push(AppRouter.pharmaShopDetails, extra: shop),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pharmacy Command Center 👋',
          style: AppTextStyles.header.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Oversee and manage your pharmacy network operations.',
          style: AppTextStyles.description.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(PharmaShopState state) {
    final activeCount = state.shops.where((s) => s.status?.toLowerCase() == 'active').length;
    final pendingCount = state.shops.where((s) => s.status?.toLowerCase() == 'pending').length;
    final inactiveCount = state.shops.where((s) => s.status?.toLowerCase() == 'inactive' || s.status?.toLowerCase() == 'rejected').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Shops',
            activeCount.toString(),
            IconsaxPlusLinear.shop,
            AppColors.success,
            'Operational & Verified',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Pending Review',
            pendingCount.toString(),
            IconsaxPlusLinear.timer_1,
            AppColors.warning,
            'Awaiting Approval',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Inactive/Rejected',
            inactiveCount.toString(),
            IconsaxPlusLinear.slash,
            AppColors.error,
            'Access Restricted',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, String tagline) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(10),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Icon(IconsaxPlusLinear.arrow_up_3, color: AppColors.success, size: 14),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: AppTextStyles.header.copyWith(fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          Text(
            tagline,
            style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 40),
                ],
              ),
              child: const Icon(IconsaxPlusLinear.shop, size: 64, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 24),
            Text('No Pharmacies Found', style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              'Your current network filter returned zero results.\nTry resetting your search parameters.',
              style: AppTextStyles.description.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
