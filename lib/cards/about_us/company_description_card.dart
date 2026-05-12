import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class CompanyDescriptionCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const CompanyDescriptionCard({super.key, this.aboutUs, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(IconsaxPlusLinear.document_text, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Company Profile',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(IconsaxPlusLinear.edit, size: 20, color: AppColors.primary),
                style: IconButton.styleFrom(backgroundColor: AppColors.primary.withAlpha(15)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            aboutUs?.companyDescriptionText ?? 'No description provided. Click edit to add information about your company, its history, and values.',
            style: AppTextStyles.description.copyWith(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textPrimary.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}
