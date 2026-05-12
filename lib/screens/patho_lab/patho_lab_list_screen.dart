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
        title: 'Laboratory Ecosystem',
        subtitle: 'Network Intelligence Control',
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
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 32),
                  _buildStatsGrid(pathoLabState),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[
                    const PathoLabSearchFilterCard(),
                    const SizedBox(height: 32),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Partner Directory',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Real-time status of all onboarded labs',
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
                          '${pathoLabState.filteredLabs.length} TOTAL',
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
                  if (pathoLabState.filteredLabs.isEmpty)
                    _buildEmptyState()
                  else
                    ...pathoLabState.filteredLabs.map(
                      (lab) => PathoLabCard(
                        lab: lab,
                        onTap: () => context.push(AppRouter.pathoLabDetails, extra: lab),
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
          'Command Center 👋',
          style: AppTextStyles.header.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Overview of your laboratory network and operational health.',
          style: AppTextStyles.description.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildOnboardButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.push(AppRouter.createPathoLab),
        icon: const Icon(IconsaxPlusLinear.add_square, size: 18),
        label: const Text('ONBOARD'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(PathoLabState state) {
    final activeCount = state.labs.where((l) => l.status.toLowerCase() == 'active').length;
    final suspendedCount = state.labs.where((l) => l.status.toLowerCase() == 'suspended').length;
    final terminatedCount = state.labs.where((l) => l.status.toLowerCase() == 'terminated').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Nodes',
            activeCount.toString(),
            IconsaxPlusLinear.radar,
            AppColors.success,
            'Healthy Connectivity',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Risk Alerts',
            suspendedCount.toString(),
            IconsaxPlusLinear.info_circle,
            AppColors.warning,
            'Immediate Attention',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Terminated',
            terminatedCount.toString(),
            IconsaxPlusLinear.shield_cross,
            AppColors.error,
            'Access Revoked',
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
              child: const Icon(IconsaxPlusLinear.search_status, size: 64, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 24),
            Text('No Laboratory Units Found', style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900)),
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
