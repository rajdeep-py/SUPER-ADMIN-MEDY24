import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/privacy_policy.dart';
import '../../providers/privacy_policy_provider.dart';
import '../../theme/app_theme.dart';
import 'create_edit_privacy_policy_card.dart';

class PrivacyPolicyCard extends ConsumerWidget {
  final PrivacyPolicy policy;
  const PrivacyPolicyCard({super.key, required this.policy});

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CreateEditPrivacyPolicyCard(policy: policy),
      ),
    );
  }

  void _deletePolicy(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Policy'),
        content: const Text('Are you sure you want to delete this policy?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(privacyPolicyNotifierProvider.notifier).deletePolicy(policy.privacyId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Policy deleted successfully')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  policy.privacyHeader,
                  style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showEditDialog(context),
                    icon: const Icon(IconsaxPlusLinear.edit, size: 20, color: AppColors.primary),
                  ),
                  IconButton(
                    onPressed: () => _deletePolicy(context, ref),
                    icon: const Icon(IconsaxPlusLinear.trash, size: 20, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            policy.privacyDescription,
            style: AppTextStyles.description.copyWith(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'ID: ${policy.privacyId}',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
