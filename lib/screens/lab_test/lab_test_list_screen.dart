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
        title: 'Core Lab Tests',
        subtitle: 'Manage central laboratory test catalog',
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
                  horizontal: AppSpacing.screenPadding,
                  vertical: 24,
                ),
                children: [
                  _buildStatsSummary(labTestState),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[const LabTestSearchCard()],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Test Catalog',
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${labTestState.filteredTests.length} Tests Available',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (labTestState.filteredTests.isEmpty)
                    _buildEmptyState()
                  else
                    ...labTestState.filteredTests.map(
                      (test) => LabTestCard(
                        test: test,
                        onTap: () =>
                            context.push(AppRouter.labTestDetails, extra: test),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.push(AppRouter.createLabTest),
        icon: const Icon(IconsaxPlusLinear.add_square, size: 18),
        label: const Text('New Lab Test'),
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

  Widget _buildStatsSummary(LabTestState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Tests',
            state.totalCount.toString(),
            IconsaxPlusLinear.microscope,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Categories',
            state.tests.map((t) => t.testCategory).toSet().length.toString(),
            IconsaxPlusLinear.category,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'High Priority',
            '0', // Placeholder
            IconsaxPlusLinear.flash,
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
          colors: [Colors.white, color.withOpacity(0.02)],
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
              color: color.withOpacity(0.1),
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
                    color: AppColors.primary.withOpacity(0.05),
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
            Text('No Tests Found', style: AppTextStyles.subHeader),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: AppTextStyles.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
