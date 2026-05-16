import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/customer_provider.dart';

class CustomerSearchFilterCard extends ConsumerStatefulWidget {
  const CustomerSearchFilterCard({super.key});

  @override
  ConsumerState<CustomerSearchFilterCard> createState() =>
      _CustomerSearchFilterCardState();
}

class _CustomerSearchFilterCardState extends ConsumerState<CustomerSearchFilterCard> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';

  void _applyFilter() {
    ref.read(customerProvider.notifier).filterCustomers(
          _searchController.text,
          _selectedStatus,
        );
  }

  void _resetFilter() {
    _searchController.clear();
    setState(() => _selectedStatus = 'All');
    _applyFilter();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                    child: const Icon(IconsaxPlusLinear.filter_search,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search & Filter',
                    style: AppTextStyles.cardTitle
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w800),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Search Bar
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Customer',
                      style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => _applyFilter(),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1,
                            size: 16, color: AppColors.textTertiary),
                        hintText: 'Search by name, email or phone...',
                        hintStyle: const TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status Filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: AppColors.textSecondary),
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
                          items: ['All', 'Active', 'Suspended'].map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(s,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w700)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
