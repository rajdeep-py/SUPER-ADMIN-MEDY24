import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../notifiers/patho_lab_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/patho_lab/patho_lab_card.dart';
import '../../cards/patho_lab/patho_lab_search_filter_card.dart';
import '../../providers/patho_lab_provider.dart';
import '../../routes/app_router.dart';

class PathoLabListScreen extends ConsumerStatefulWidget {
  const PathoLabListScreen({super.key});

  @override
  ConsumerState<PathoLabListScreen> createState() => _PathoLabListScreenState();
}

class _PathoLabListScreenState extends ConsumerState<PathoLabListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final pathoLabState = ref.watch(pathoLabProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Partners',
        subtitle: 'Laboratory Ecosystem Management',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isSearchVisible
                ? IconsaxPlusLinear.search_status
                : IconsaxPlusLinear.search_normal_1,
            iconColor: _isSearchVisible ? AppColors.primaryAccent : null,
            onTap: () => setState(() => _isSearchVisible = !_isSearchVisible),
          ),
          CustomAppBar.buildActionButton(
            icon: IconsaxPlusLinear.document_download,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _buildOnboardButton(),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: pathoLabState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(pathoLabProvider.notifier).loadLabs(),
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: 24,
                ),
                children: [
                  _buildStatsSummary(pathoLabState),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[
                    const PathoLabSearchFilterCard(),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Laboratories',
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${pathoLabState.filteredLabs.length} Results',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (pathoLabState.filteredLabs.isEmpty)
                    _buildEmptyState()
                  else
                    ...pathoLabState.filteredLabs.map(
                      (lab) => PathoLabCard(
                        lab: lab,
                        onTap: () =>
                            context.push(AppRouter.pathoLabDetails, extra: lab),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildOnboardButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.push(AppRouter.createPathoLab),
        icon: const Icon(IconsaxPlusLinear.add_square, size: 18),
        label: const Text('Onboard New'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(PathoLabState state) {
    final activeCount = state.labs
        .where((l) => l.status.toLowerCase() == 'active')
        .length;
    final suspendedCount = state.labs
        .where((l) => l.status.toLowerCase() == 'suspended')
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Partners',
            state.totalCount.toString(),
            IconsaxPlusLinear.hospital,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Active',
            activeCount.toString(),
            IconsaxPlusLinear.verify,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Alerts',
            suspendedCount.toString(),
            IconsaxPlusLinear.info_circle,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [Colors.white, color.withAlpha(5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.header.copyWith(
              fontSize: 28,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(13),
                    blurRadius: 40,
                  ),
                ],
              ),
              child: const Icon(
                IconsaxPlusLinear.search_status,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text('No Laboratories Found', style: AppTextStyles.subHeader),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: AppTextStyles.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
