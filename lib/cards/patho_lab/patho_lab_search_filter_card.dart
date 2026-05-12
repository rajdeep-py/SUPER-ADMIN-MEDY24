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
    ref.read(pathoLabProvider.notifier).loadLabs(
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
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
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(IconsaxPlusLinear.filter_search, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Filter Ecosystem',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _resetFilter,
                icon: const Icon(IconsaxPlusLinear.refresh, size: 14),
                label: const Text('Reset'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: AppColors.error.withAlpha(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Responsive Grid for Inputs
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildDashboardInput('Lab Name', _nameController, IconsaxPlusLinear.hospital)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDashboardInput('Email Address', _emailController, IconsaxPlusLinear.sms)),
                      if (isWide) ...[
                        const SizedBox(width: 16),
                        Expanded(child: _buildDashboardInput('Contact No', _phoneController, IconsaxPlusLinear.call)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (!isWide) ...[
                        Expanded(child: _buildDashboardInput('Contact No', _phoneController, IconsaxPlusLinear.call)),
                        const SizedBox(width: 16),
                      ],
                      Expanded(child: _buildDashboardInput('WhatsApp', _whatsappController, IconsaxPlusLinear.sms)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatusDropdown()),
                    ],
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _applyFilter,
              icon: const Icon(IconsaxPlusLinear.search_normal_1, size: 18),
              label: const Text('SEARCH PARTNERS', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: (_) => _applyFilter(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 16, color: AppColors.textTertiary),
            hintText: 'Type to search...',
            hintStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operational Status',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Icon(IconsaxPlusLinear.arrow_down_1, size: 16),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                _applyFilter();
              },
              items: ['All', 'Active', 'Suspended', 'Terminated'].map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
