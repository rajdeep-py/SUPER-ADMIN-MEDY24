import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../providers/terms_conditions_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/terms_conditions/terms_conditions_card.dart';
import '../../cards/terms_conditions/create_edit_terms_conditions_card.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: CreateEditTermsConditionsCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsState = ref.watch(termsConditionsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Terms & Conditions',
        subtitle: 'Manage Legal Guidelines',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: IconsaxPlusLinear.add_circle,
            onTap: () => _showCreateDialog(context),
          ),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: termsState.isLoading && termsState.terms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(termsConditionsNotifierProvider.notifier).fetchTerms(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  if (termsState.terms.isEmpty)
                    _buildEmptyState()
                  else
                    ...termsState.terms.map((term) => TermsConditionsCard(term: term)),
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
          'Legal Framework 👋',
          style: AppTextStyles.header.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Define the terms of service and legal conditions for users.',
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
            const Icon(IconsaxPlusLinear.document_text, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 24),
            Text('No Terms Found', style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Click the + button to add your first term and condition.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
