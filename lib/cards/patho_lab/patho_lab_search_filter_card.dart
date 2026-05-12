import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/patho_lab_provider.dart';

class PathoLabSearchFilterCard extends ConsumerStatefulWidget {
  const PathoLabSearchFilterCard({super.key});

  @override
  ConsumerState<PathoLabSearchFilterCard> createState() =>
      _PathoLabSearchFilterCardState();
}

class _PathoLabSearchFilterCardState
    extends ConsumerState<PathoLabSearchFilterCard> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedStatus = 'All';

  void _applyFilter() {
    ref
        .read(pathoLabProvider.notifier)
        .loadLabs(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          whatsapp: _whatsappController.text,
          address: _addressController.text,
          status: _selectedStatus,
        );
  }

  void _resetFilter() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _whatsappController.clear();
    _addressController.clear();
    setState(() => _selectedStatus = 'All');
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.background.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.search_status,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Search & Filter', style: AppTextStyles.cardTitle),
                ],
              ),
              TextButton.icon(
                onPressed: _resetFilter,
                icon: const Icon(IconsaxPlusLinear.refresh, size: 16),
                label: const Text('Reset'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Responsive Grid for filters
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildCompactField(
                'Lab Name',
                _nameController,
                IconsaxPlusLinear.hospital,
              ),
              _buildCompactField(
                'Email Address',
                _emailController,
                IconsaxPlusLinear.sms,
              ),
              _buildCompactField(
                'Phone Number',
                _phoneController,
                IconsaxPlusLinear.call,
              ),
              _buildCompactField(
                'WhatsApp No',
                _whatsappController,
                IconsaxPlusLinear.sms,
              ),
              _buildCompactField(
                'Location',
                _addressController,
                IconsaxPlusLinear.location,
              ),
              _buildStatusPicker(),
            ],
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _applyFilter,
              icon: const Icon(IconsaxPlusLinear.filter, size: 18),
              label: const Text('Apply Advanced Filters'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - 80) /
          2, // 2 items per row in ideal scenario
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: (_) => _applyFilter(),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.textTertiary),
              hintText: label,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPicker() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 80) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab Status',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus,
                isExpanded: true,
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                  _applyFilter();
                },
                items: ['All', 'Active', 'Suspended', 'Terminated'].map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s,
                      style: AppTextStyles.description.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
