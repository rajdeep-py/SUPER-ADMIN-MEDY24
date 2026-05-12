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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            statusColor.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha(13),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        hoverColor: statusColor.withAlpha(5),
        splashColor: statusColor.withAlpha(13),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Logo Container
              _buildModernLogo(statusColor),
              const SizedBox(width: 24),

              // Lab Detailed Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lab.labName,
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PARTNER #${lab.labId}',
                                style: AppTextStyles.tagline.copyWith(
                                  fontSize: 11,
                                  color: AppColors.primaryAccent,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(statusColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoGrid(),
                  ],
                ),
              ),

              // Navigate Icon
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernLogo(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: statusColor.withAlpha(38),
          width: 2,
        ),
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: statusColor.withAlpha(26),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: lab.labLogoUrl != null && lab.labLogoUrl!.isNotEmpty
              ? Image.network(
                  lab.labLogoUrl!.startsWith('http')
                      ? lab.labLogoUrl!
                      : '${ApiUrls.baseUrl}${lab.labLogoUrl!.startsWith('/') ? lab.labLogoUrl!.substring(1) : lab.labLogoUrl}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    IconsaxPlusLinear.hospital,
                    color: statusColor,
                    size: 32,
                  ),
                )
              : Icon(
                  IconsaxPlusLinear.hospital,
                  color: statusColor,
                  size: 32,
                ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: statusColor.withAlpha(51)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            lab.status.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        _buildInfoRow(IconsaxPlusLinear.location, lab.address),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(IconsaxPlusLinear.call, lab.mobileNumber),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoRow(IconsaxPlusLinear.sms, lab.emailAddress),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.description.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
