import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../notifiers/lab_test_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/lab_test/lab_test_card.dart';
import '../../cards/lab_test/lab_test_search_card.dart';
import '../../providers/lab_test_provider.dart';
import '../../routes/app_router.dart';

class LabTestListScreen extends ConsumerStatefulWidget {
  const LabTestListScreen({super.key});

  @override
  ConsumerState<LabTestListScreen> createState() => _LabTestListScreenState();
}

class _LabTestListScreenState extends ConsumerState<LabTestListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final labTestState = ref.watch(labTestProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Diagnostic Catalogue',
        subtitle: 'Core Medical Intelligence',
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
          _buildCreateButton(),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: labTestState.isLoading && labTestState.tests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(labTestProvider.notifier).loadTests(),
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 32),
                  _buildStatsGrid(labTestState),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[
                    const LabTestSearchCard(),
                    const SizedBox(height: 32),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medical Tests',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Central repository of all available diagnostics',
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
                          '${labTestState.filteredTests.length} PROTOCOLS',
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
                  if (labTestState.filteredTests.isEmpty)
                    _buildEmptyState()
                  else
                    ...labTestState.filteredTests.map(
                      (test) => LabTestCard(
                        test: test,
                        onTap: () => context.push(AppRouter.labTestDetails, extra: test),
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
          'Test Inventory 👋',
          style: AppTextStyles.header.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage and curate the master diagnostic test catalogue.',
          style: AppTextStyles.description.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
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
        onPressed: () => context.push(AppRouter.createLabTest),
        icon: const Icon(IconsaxPlusLinear.add_square, size: 18),
        label: const Text('NEW TEST'),
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

  Widget _buildStatsGrid(LabTestState state) {
    final categoryCount = state.tests.map((t) => t.testCategory).toSet().length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Protocols',
            state.totalCount.toString(),
            IconsaxPlusLinear.microscope,
            AppColors.primary,
            'Global Diagnostic Range',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Categories',
            categoryCount.toString(),
            IconsaxPlusLinear.category,
            AppColors.success,
            'Medical Classifications',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Operational High',
            '100%',
            IconsaxPlusLinear.flash,
            AppColors.warning,
            'Service Uptime',
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
              const Icon(IconsaxPlusLinear.chart_3, color: AppColors.success, size: 14),
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
            Text('No Diagnostic Tests Found', style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different term or category.',
              style: AppTextStyles.description.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
