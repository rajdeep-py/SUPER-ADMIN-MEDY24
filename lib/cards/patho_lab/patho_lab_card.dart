import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/patho_lab.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class PathoLabCard extends StatelessWidget {
  final PathoLab lab;
  final VoidCallback onTap;

  const PathoLabCard({super.key, required this.lab, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (lab.status.toLowerCase()) {
      case 'active':
        statusColor = AppColors.success;
        break;
      case 'suspended':
        statusColor = AppColors.warning;
        break;
      case 'terminated':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textTertiary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard.copyWith(
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lab Logo/Photo with Gradient Border
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [statusColor, statusColor.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: lab.labLogoUrl != null && lab.labLogoUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(lab.labLogoUrl!.startsWith('http')
                                ? lab.labLogoUrl!
                                : '${ApiUrls.baseUrl}${lab.labLogoUrl!.startsWith('/') ? lab.labLogoUrl!.substring(1) : lab.labLogoUrl}'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: lab.labLogoUrl == null || lab.labLogoUrl!.isEmpty
                      ? Icon(IconsaxPlusLinear.hospital, color: statusColor, size: 32)
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              
              // Lab Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lab.labName,
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            lab.status.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ID: ${lab.labId}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryAccent.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(IconsaxPlusLinear.location, lab.address),
                    const SizedBox(height: 6),
                    _buildInfoRow(IconsaxPlusLinear.call, lab.mobileNumber),
                  ],
                ),
              ),
              
              // Arrow Indicator
              const SizedBox(width: 8),
              Center(
                child: Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: AppColors.textTertiary.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.description.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
