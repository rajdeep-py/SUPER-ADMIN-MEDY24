import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/terms_conditions.dart';
import '../../providers/terms_conditions_provider.dart';
import '../../theme/app_theme.dart';
import 'create_edit_terms_conditions_card.dart';

class TermsConditionsCard extends ConsumerWidget {
  final TermsConditions term;
  const TermsConditionsCard({super.key, required this.term});

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CreateEditTermsConditionsCard(term: term),
      ),
    );
  }

  void _deleteTerm(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Term'),
        content: const Text('Are you sure you want to delete this term?'),
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
      final success = await ref.read(termsConditionsNotifierProvider.notifier).deleteTerm(term.termId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Term deleted successfully')));
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
                  term.termHeader,
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
                    onPressed: () => _deleteTerm(context, ref),
                    icon: const Icon(IconsaxPlusLinear.trash, size: 20, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            term.termDescription,
            style: AppTextStyles.description.copyWith(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'ID: ${term.termId}',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
