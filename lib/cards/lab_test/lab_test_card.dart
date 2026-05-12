import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class LabTestCard extends StatelessWidget {
  final LabTest test;
  final VoidCallback onTap;

  const LabTestCard({super.key, required this.test, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Test Photo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  image: test.testPhotoUrl != null && test.testPhotoUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            test.testPhotoUrl!.startsWith('http')
                                ? test.testPhotoUrl!
                                : '${ApiUrls.baseUrl}${test.testPhotoUrl!.startsWith('/') ? test.testPhotoUrl!.substring(1) : test.testPhotoUrl}',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: test.testPhotoUrl == null || test.testPhotoUrl!.isEmpty
                    ? const Icon(IconsaxPlusLinear.microscope,
                        color: AppColors.primary, size: 32)
                    : null,
              ),
              const SizedBox(width: 20),

              // Test Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.testName,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test.testCategory,
                      style: AppTextStyles.tagline.copyWith(
                        fontSize: 12,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge(
                          IconsaxPlusLinear.box,
                          '${test.parameters.length} Params',
                          AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _buildBadge(
                          IconsaxPlusLinear.glass,
                          test.sampleType,
                          AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                IconsaxPlusLinear.arrow_right_3,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
