import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class LabTestCard extends StatefulWidget {
  final LabTest test;
  final VoidCallback onTap;

  const LabTestCard({super.key, required this.test, required this.onTap});

  @override
  State<LabTestCard> createState() => _LabTestCardState();
}

class _LabTestCardState extends State<LabTestCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        transform: _isHovered
            ? (Matrix4.identity()..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withAlpha(100)
                : AppColors.divider.withAlpha(100),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_isHovered ? 15 : 5),
              blurRadius: _isHovered ? 30 : 20,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Premium Image Container
                  _buildImageContainer(),
                  const SizedBox(width: 20),

                  // Content Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.test.testName,
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildCategoryBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'DIAGNOSTIC PROTOCOL: ${widget.test.coreTestId}',
                          style: AppTextStyles.tagline.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            _buildMiniInfo(
                              IconsaxPlusLinear.box,
                              '${widget.test.parameters.length} Parameters',
                            ),
                            const SizedBox(width: 16),
                            _buildMiniInfo(
                              IconsaxPlusLinear.glass,
                              widget.test.sampleType,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Decorative End
                  const VerticalDivider(
                    width: 32,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
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
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child:
            widget.test.testPhotoUrl != null &&
                widget.test.testPhotoUrl!.isNotEmpty
            ? Image.network(
                widget.test.testPhotoUrl!.startsWith('http')
                    ? widget.test.testPhotoUrl!
                    : '${ApiUrls.baseUrl}${widget.test.testPhotoUrl!.startsWith('/') ? widget.test.testPhotoUrl!.substring(1) : widget.test.testPhotoUrl}',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      IconsaxPlusLinear.microscope,
      color: AppColors.primary.withAlpha(100),
      size: 36,
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.test.testCategory.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
