import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class MissionVisionCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const MissionVisionCard({super.key, this.aboutUs, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoBox(
            'Our Mission',
            aboutUs?.mission ?? 'Defining the daily goals and the path to achieve our long-term vision.',
            IconsaxPlusLinear.flash,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildInfoBox(
            'Our Vision',
            aboutUs?.vision ?? 'The future aspirations and long-term impact we aim to create in the healthcare sector.',
            IconsaxPlusLinear.eye,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String title, String content, IconData icon, Color color) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              IconButton(
                onPressed: onEdit,
                icon: Icon(IconsaxPlusLinear.edit, size: 18, color: color),
                style: IconButton.styleFrom(backgroundColor: color.withAlpha(15)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.description.copyWith(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textPrimary.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
