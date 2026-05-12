import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class CompanyHeaderCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const CompanyHeaderCard({super.key, this.aboutUs, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary.withAlpha(30), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: aboutUs?.companyPhoto != null
                      ? Image.network(
                          aboutUs!.companyPhoto!.startsWith('http')
                              ? aboutUs!.companyPhoto!
                              : '${ApiUrls.baseUrl}${aboutUs!.companyPhoto!.startsWith('/') ? aboutUs!.companyPhoto!.substring(1) : aboutUs!.companyPhoto}',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(IconsaxPlusLinear.building, size: 48, color: AppColors.primary),
                        )
                      : const Icon(IconsaxPlusLinear.building, size: 48, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 40),
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aboutUs?.companyName ?? 'Company Name Placeholder',
                      style: AppTextStyles.header.copyWith(fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      aboutUs?.companyTagline ?? 'Define your company tagline here',
                      style: AppTextStyles.tagline.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (aboutUs?.website != null)
                      Row(
                        children: [
                          const Icon(IconsaxPlusLinear.global, size: 16, color: AppColors.textTertiary),
                          const SizedBox(width: 8),
                          Text(
                            aboutUs!.website!,
                            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(IconsaxPlusLinear.edit, color: AppColors.primary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withAlpha(20),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
