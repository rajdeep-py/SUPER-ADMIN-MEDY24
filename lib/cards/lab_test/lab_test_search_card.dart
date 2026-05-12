import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/lab_test_provider.dart';

class LabTestSearchCard extends ConsumerWidget {
  const LabTestSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  IconsaxPlusLinear.search_status,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Tests',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                  ),
                  Text(
                    'Search by name or category',
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) {
              ref.read(labTestProvider.notifier).searchTests(value);
            },
            decoration: InputDecoration(
              hintText: 'Search for laboratory tests...',
              prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1, size: 20),
              filled: true,
              fillColor: AppColors.background.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
