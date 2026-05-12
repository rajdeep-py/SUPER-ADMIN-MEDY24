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
      padding: const EdgeInsets.all(32),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withOpacity(0.01),
          ],
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.search_status,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advanced Search',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                      ),
                      Text(
                        'Filter laboratories by specific criteria',
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              _buildResetButton(),
            ],
          ),
          const SizedBox(height: 32),

          // Search Grid
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildCompactField(
                'Laboratory Name',
                _nameController,
                IconsaxPlusLinear.hospital,
              ),
              _buildCompactField(
                'Registered Email',
                _emailController,
                IconsaxPlusLinear.sms,
              ),
              _buildCompactField(
                'Contact Number',
                _phoneController,
                IconsaxPlusLinear.call,
              ),
              _buildCompactField(
                'WhatsApp Number',
                _whatsappController,
                IconsaxPlusLinear.sms,
              ),
              _buildCompactField(
                'Physical Address',
                _addressController,
                IconsaxPlusLinear.location,
              ),
              _buildStatusPicker(),
            ],
          ),

          const SizedBox(height: 40),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return TextButton.icon(
      onPressed: _resetFilter,
      icon: const Icon(IconsaxPlusLinear.refresh, size: 16),
      label: const Text('Clear All'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.error,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: AppColors.error.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _applyFilter,
        icon: const Icon(IconsaxPlusLinear.filter, size: 20),
        label: const Text(
          'Apply Refined Search',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 120) / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            onChanged: (_) => _applyFilter(),
            style: AppTextStyles.description.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
              hintText: 'Search...',
              filled: true,
              fillColor: AppColors.background.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(IconsaxPlusLinear.close_circle, size: 16),
                      onPressed: () {
                        controller.clear();
                        _applyFilter();
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPicker() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 120) / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operational Status',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus,
                isExpanded: true,
                icon: const Icon(IconsaxPlusLinear.arrow_down_1, size: 18),
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
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary,
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
