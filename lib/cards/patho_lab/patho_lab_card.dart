import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/patho_lab.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class PathoLabCard extends StatefulWidget {
  final PathoLab lab;
  final VoidCallback onTap;

  const PathoLabCard({super.key, required this.lab, required this.onTap});

  @override
  State<PathoLabCard> createState() => _PathoLabCardState();
}

class _PathoLabCardState extends State<PathoLabCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (widget.lab.status.toLowerCase()) {
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        decoration: AppCardStyles.sleekCard.copyWith(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: statusColor.withAlpha(_isHovered ? 30 : 15),
              blurRadius: _isHovered ? 40 : 24,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
          border: Border.all(
            color: _isHovered ? statusColor.withAlpha(80) : AppColors.divider.withAlpha(128),
            width: _isHovered ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Enhanced Logo Section
                    _buildLogo(statusColor),
                    const SizedBox(width: 20),
                    
                    // Main Info Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.lab.labName,
                                  style: AppTextStyles.cardTitle.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildStatusIndicator(statusColor),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'PARTNER ID: ${widget.lab.labId}',
                            style: AppTextStyles.tagline.copyWith(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Quick Info Bar
                          Row(
                            children: [
                              _buildQuickInfo(IconsaxPlusLinear.call, widget.lab.mobileNumber),
                              const SizedBox(width: 16),
                              _buildQuickInfo(IconsaxPlusLinear.sms, widget.lab.emailAddress),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Decorative End Section
                    const VerticalDivider(width: 32, thickness: 1, indent: 10, endIndent: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        IconsaxPlusLinear.arrow_right_3,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Color statusColor) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: widget.lab.labLogoUrl != null && widget.lab.labLogoUrl!.isNotEmpty
            ? Image.network(
                widget.lab.labLogoUrl!.startsWith('http')
                    ? widget.lab.labLogoUrl!
                    : '${ApiUrls.baseUrl}${widget.lab.labLogoUrl!.startsWith('/') ? widget.lab.labLogoUrl!.substring(1) : widget.lab.labLogoUrl}',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => _buildLogoPlaceholder(statusColor),
              )
            : _buildLogoPlaceholder(statusColor),
      ),
    );
  }

  Widget _buildLogoPlaceholder(Color statusColor) {
    return Icon(IconsaxPlusLinear.hospital, color: statusColor.withAlpha(150), size: 32);
  }

  Widget _buildStatusIndicator(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: statusColor),
          const SizedBox(width: 6),
          Text(
            widget.lab.status.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w800,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
