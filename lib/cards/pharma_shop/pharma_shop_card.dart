import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/pharma_shop.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class PharmaShopCard extends StatefulWidget {
  final PharmaShop shop;
  final VoidCallback onTap;

  const PharmaShopCard({super.key, required this.shop, required this.onTap});

  @override
  State<PharmaShopCard> createState() => _PharmaShopCardState();
}

class _PharmaShopCardState extends State<PharmaShopCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (widget.shop.status?.toLowerCase() ?? 'pending') {
      case 'active':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'rejected':
      case 'inactive':
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
        transform: _isHovered ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        decoration: AppCardStyles.sleekCard.copyWith(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: statusColor.withAlpha(_isHovered ? 25 : 10),
              blurRadius: _isHovered ? 30 : 20,
              offset: Offset(0, _isHovered ? 10 : 5),
            ),
          ],
          border: Border.all(
            color: _isHovered ? statusColor.withAlpha(100) : AppColors.divider.withAlpha(100),
            width: _isHovered ? 1.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Shop Photo Section
                    _buildShopPhoto(statusColor),
                    const SizedBox(width: 20),
                    
                    // Shop Info Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.shop.shopName ?? 'N/A',
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
                            'SHOP ID: ${widget.shop.shopId ?? 'N/A'}',
                            style: AppTextStyles.tagline.copyWith(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Address
                          Row(
                            children: [
                              const Icon(IconsaxPlusLinear.location, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.shop.shopAddress ?? 'No Address',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Contact Info Bar
                          Row(
                            children: [
                              _buildQuickInfo(IconsaxPlusLinear.call, widget.shop.shopPhoneNo ?? 'N/A'),
                              const SizedBox(width: 16),
                              _buildQuickInfo(IconsaxPlusLinear.sms, widget.shop.shopEmail ?? 'N/A'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Icon
                    const VerticalDivider(width: 32, thickness: 1, indent: 8, endIndent: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        IconsaxPlusLinear.arrow_right_3,
                        color: AppColors.textTertiary,
                        size: 16,
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

  Widget _buildShopPhoto(Color statusColor) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.shop.shopPhoto != null && widget.shop.shopPhoto!.isNotEmpty
            ? Image.network(
                widget.shop.shopPhoto!.startsWith('http')
                    ? widget.shop.shopPhoto!
                    : '${ApiUrls.baseUrl}${widget.shop.shopPhoto!.startsWith('/') ? widget.shop.shopPhoto!.substring(1) : widget.shop.shopPhoto}',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => _buildPhotoPlaceholder(statusColor),
              )
            : _buildPhotoPlaceholder(statusColor),
      ),
    );
  }

  Widget _buildPhotoPlaceholder(Color statusColor) {
    return Icon(IconsaxPlusLinear.shop, color: statusColor.withAlpha(150), size: 36);
  }

  Widget _buildStatusIndicator(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: statusColor),
          const SizedBox(width: 6),
          Text(
            (widget.shop.status ?? 'PENDING').toUpperCase(),
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
