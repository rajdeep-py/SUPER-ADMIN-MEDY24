import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/customer/customer_table_card.dart';
import '../../cards/customer/customer_search_filter_card.dart';
import '../../providers/customer_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Customer Management',
        subtitle: 'User Ecosystem Control',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isSearchVisible
                ? IconsaxPlusLinear.search_status
                : IconsaxPlusLinear.search_normal_1,
            iconColor: _isSearchVisible ? AppColors.primaryAccent : null,
            onTap: () => setState(() => _isSearchVisible = !_isSearchVisible),
          ),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: customerState.isLoading && customerState.customers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(customerProvider.notifier).loadCustomers(),
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 32),
                  if (_isSearchVisible) ...[
                    const CustomerSearchFilterCard(),
                    const SizedBox(height: 32),
                  ],
                  _buildTableHeader(),
                  const SizedBox(height: 12),
                  if (customerState.filteredCustomers.isEmpty)
                    _buildEmptyState()
                  else
                    ...customerState.filteredCustomers.map(
                      (customer) => CustomerTableCard(customer: customer),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Intelligence 👋',
          style: AppTextStyles.header.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage and oversee your customer base and their activities.',
          style: AppTextStyles.description.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: _HeaderText('CUSTOMER ID')),
          Expanded(
            flex: 1,
            child: _HeaderText('PHOTO', textAlign: TextAlign.center),
          ),
          Expanded(flex: 3, child: _HeaderText('FULL NAME')),
          Expanded(flex: 2, child: _HeaderText('PHONE')),
          Expanded(flex: 2, child: _HeaderText('ALT PHONE')),
          Expanded(flex: 3, child: _HeaderText('EMAIL')),
          Expanded(flex: 2, child: _HeaderText('ADDRESSES')),
          Expanded(
            flex: 2,
            child: _HeaderText('STATUS', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 40),
                ],
              ),
              child: const Icon(
                IconsaxPlusLinear.user_search,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Customers Found',
              style: AppTextStyles.subHeader.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your current network filter returned zero results.\nTry resetting your search parameters.',
              style: AppTextStyles.description.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const _HeaderText(this.text, {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppTextStyles.caption.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 10,
        letterSpacing: 1,
      ),
    );
  }
}
