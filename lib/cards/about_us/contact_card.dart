import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class ContactCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const ContactCard({super.key, this.aboutUs, required this.onEdit});

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
                    child: const Icon(IconsaxPlusLinear.location, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Corporate Reach',
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildContactSection(
                  'Offices',
                  [
                    _buildContactItem(IconsaxPlusLinear.location, 'HQ: ${aboutUs?.officeAddress ?? "N/A"}'),
                    _buildContactItem(IconsaxPlusLinear.building, 'Registered: ${aboutUs?.registeredAddress ?? "N/A"}'),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildContactSection(
                  'Communication',
                  [
                    _buildContactItem(IconsaxPlusLinear.sms, aboutUs?.email1 ?? 'N/A'),
                    _buildContactItem(IconsaxPlusLinear.call, aboutUs?.phone1 ?? 'N/A'),
                    _buildContactItem(IconsaxPlusLinear.global, aboutUs?.website ?? 'N/A'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.tagline.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        ...items,
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary.withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
