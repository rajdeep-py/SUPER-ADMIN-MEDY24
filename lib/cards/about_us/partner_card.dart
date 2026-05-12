import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class PartnerCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const PartnerCard({super.key, this.aboutUs, required this.onEdit});

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
                    child: const Icon(IconsaxPlusLinear.ranking, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Strategic Partners',
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
          const SizedBox(height: 32),
          if (aboutUs?.partners == null || aboutUs!.partners!.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No partners listed yet. Showcase your collaborations here.',
                  style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            )
          else
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: aboutUs!.partners!.map((partner) => _buildPartnerTile(partner)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPartnerTile(Partner partner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider.withAlpha(30)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: partner.logo != null && partner.logo!.isNotEmpty
                  ? Image.network(
                      partner.logo!,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(IconsaxPlusLinear.building_3, size: 16, color: AppColors.primary),
                    )
                  : const Icon(IconsaxPlusLinear.building_3, size: 16, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                partner.name,
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              if (partner.website != null && partner.website!.isNotEmpty)
                Text(
                  partner.website!,
                  style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
