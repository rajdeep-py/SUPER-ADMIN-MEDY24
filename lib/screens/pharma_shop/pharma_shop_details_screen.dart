import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/pharma_shop.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/pharma_shop_provider.dart';
import '../../services/api_url.dart';

class PharmaShopDetailsScreen extends ConsumerStatefulWidget {
  final PharmaShop shop;
  const PharmaShopDetailsScreen({super.key, required this.shop});

  @override
  ConsumerState<PharmaShopDetailsScreen> createState() =>
      _PharmaShopDetailsScreenState();
}

class _PharmaShopDetailsScreenState
    extends ConsumerState<PharmaShopDetailsScreen> {
  late String _status;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.shop.status ?? 'pending';
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    try {
      await ref
          .read(pharmaShopProvider.notifier)
          .updateShopStatus(widget.shop.shopId!, newStatus);
      setState(() {
        _status = newStatus;
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${newStatus.toUpperCase()}'),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (_status.toLowerCase()) {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Pharma Shop Intelligence',
        subtitle: 'Entity # ${widget.shop.shopId}',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header Card
            _buildProfileHeader(statusColor),
            const SizedBox(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Credentials & Legal
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildSectionCard(
                        'Shop Credentials',
                        IconsaxPlusLinear.personalcard,
                        [
                          _buildReadOnlyField(
                            'Official Shop Name',
                            widget.shop.shopName ?? 'N/A',
                            IconsaxPlusLinear.shop,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildReadOnlyField(
                                  'Primary Mobile',
                                  widget.shop.shopPhoneNo ?? 'N/A',
                                  IconsaxPlusLinear.call,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildReadOnlyField(
                                  'Alternative Phone',
                                  widget.shop.shopAlternativePhoneNo ?? 'N/A',
                                  IconsaxPlusLinear.call,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildReadOnlyField(
                                  'WhatsApp No',
                                  widget.shop.whatsappNumber ?? 'N/A',
                                  IconsaxPlusLinear.sms,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildReadOnlyField(
                                  'Email Address',
                                  widget.shop.shopEmail ?? 'N/A',
                                  IconsaxPlusLinear.sms,
                                ),
                              ),
                            ],
                          ),
                          _buildReadOnlyField(
                            'Physical Operation Address',
                            widget.shop.shopAddress ?? 'N/A',
                            IconsaxPlusLinear.location,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionCard(
                        'Compliance & Documentation',
                        IconsaxPlusLinear.verify,
                        [
                          _buildReadOnlyField(
                            'GSTIN No',
                            widget.shop.gstinNo ?? 'N/A',
                            IconsaxPlusLinear.percentage_square,
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentSection(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right Column: Status Control
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildStatusControlCard(statusColor),
                      const SizedBox(height: 24),
                      _buildQuickActionsCard(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 6),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withAlpha(20),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child:
                  widget.shop.shopPhoto != null &&
                      widget.shop.shopPhoto!.isNotEmpty
                  ? Image.network(
                      widget.shop.shopPhoto!.startsWith('http')
                          ? widget.shop.shopPhoto!
                          : '${ApiUrls.baseUrl}${widget.shop.shopPhoto!.startsWith('/') ? widget.shop.shopPhoto!.substring(1) : widget.shop.shopPhoto}',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: AppColors.background,
                        child: Icon(
                          IconsaxPlusLinear.shop,
                          color: statusColor,
                          size: 50,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.background,
                      child: Icon(
                        IconsaxPlusLinear.shop,
                        color: statusColor,
                        size: 50,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shop.shopName ?? 'N/A',
                  style: AppTextStyles.header.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.location,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.shop.shopAddress ?? 'N/A',
                        style: AppTextStyles.description,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildHeaderTag('PHARMACY', AppColors.primary),
                    _buildHeaderTag('VERIFIED PARTNER', AppColors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildStatusControlCard(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Administrative Control',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (_isUpdating)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Operational Status',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withAlpha(50)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _status,
                isExpanded: true,
                icon: const Icon(IconsaxPlusLinear.arrow_down_1, size: 20),
                onChanged: _isUpdating ? null : (v) => _updateStatus(v!),
                items: ['active', 'pending', 'inactive', 'rejected']
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s.toUpperCase(),
                          style: TextStyle(
                            color: s == _status
                                ? statusColor
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Updating status will immediately affect the shop\'s ability to operate within the platform.',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: AppColors.textTertiary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uploaded Documents',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        _buildDocumentTile('Drug License', widget.shop.drugLicenseUpload),
        const SizedBox(height: 12),
        _buildDocumentTile('PAN Card', widget.shop.panCardUpload),
        const SizedBox(height: 12),
        _buildDocumentTile('Bank Passbook', widget.shop.bankPassbookUpload),
        const SizedBox(height: 12),
        _buildDocumentTile(
          'Registration Certificate',
          widget.shop.registrationCertificateUpload,
        ),
      ],
    );
  }

  Widget _buildDocumentTile(String label, String? url) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(
            IconsaxPlusLinear.document_text,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          if (url != null && url.isNotEmpty)
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.export_1,
                size: 18,
                color: AppColors.primary,
              ),
              onPressed: () => _launchURL(url),
              tooltip: 'View Document',
            )
          else
            const Text(
              'N/A',
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
            ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String path) async {
    final fullUrl = path.startsWith('http')
        ? path
        : '${ApiUrls.baseUrl}${path.startsWith('/') ? path.substring(1) : path}';
    if (await canLaunchUrl(Uri.parse(fullUrl))) {
      await launchUrl(Uri.parse(fullUrl));
    }
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Communication',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            'Email Merchant',
            IconsaxPlusLinear.sms,
            () => _launchURL('mailto:${widget.shop.shopEmail}'),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Call Merchant',
            IconsaxPlusLinear.call,
            () => _launchURL('tel:${widget.shop.shopPhoneNo}'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider.withAlpha(80)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const Spacer(),
            const Icon(
              IconsaxPlusLinear.arrow_right_3,
              size: 14,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
