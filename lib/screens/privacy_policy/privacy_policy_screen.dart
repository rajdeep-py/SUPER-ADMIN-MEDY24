import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../providers/privacy_policy_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/privacy_policy/privacy_policy_card.dart';
import '../../cards/privacy_policy/create_edit_privacy_policy_card.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: CreateEditPrivacyPolicyCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policyState = ref.watch(privacyPolicyNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        subtitle: 'Data Protection Rules',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: IconsaxPlusLinear.add_circle,
            onTap: () => _showCreateDialog(context),
          ),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: policyState.isLoading && policyState.policies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(privacyPolicyNotifierProvider.notifier).fetchPolicies(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  if (policyState.policies.isEmpty)
                    _buildEmptyState()
                  else
                    ...policyState.policies.map((policy) => PrivacyPolicyCard(policy: policy)),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Control 👋',
          style: AppTextStyles.header.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage the data protection and privacy policies for your application.',
          style: AppTextStyles.description.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            const Icon(IconsaxPlusLinear.shield_tick, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 24),
            Text('No Policies Found', style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Click the + button to add your first privacy policy.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
