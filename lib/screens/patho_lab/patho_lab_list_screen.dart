import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/patho_lab/patho_lab_card.dart';
import '../../cards/patho_lab/patho_lab_search_filter_card.dart';
import '../../providers/patho_lab_provider.dart';
import '../../routes/app_router.dart';

class PathoLabListScreen extends ConsumerStatefulWidget {
  const PathoLabListScreen({super.key});

  @override
  ConsumerState<PathoLabListScreen> createState() => _PathoLabListScreenState();
}

class _PathoLabListScreenState extends ConsumerState<PathoLabListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final pathoLabState = ref.watch(pathoLabProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Pathology Labs',
        subtitle: 'Manage all partner laboratories',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isSearchVisible ? IconsaxPlusLinear.search_status : IconsaxPlusLinear.search_normal_1,
            iconColor: _isSearchVisible ? AppColors.primaryAccent : null,
            onTap: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
          ),
          CustomAppBar.buildActionButton(
            icon: IconsaxPlusLinear.document_download,
            onTap: () {
              // Handle download report
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () => context.push(AppRouter.createPathoLab),
                icon: const Icon(IconsaxPlusLinear.add_square, color: Colors.white, size: 20),
                label: const Text(
                  'Onboard Lab',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: pathoLabState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Refresh logic
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                children: [
                  if (_isSearchVisible) const PathoLabSearchFilterCard(),
                  const SizedBox(height: 8),
                  if (pathoLabState.filteredLabs.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(IconsaxPlusLinear.search_status, size: 64, color: AppColors.textTertiary),
                            const SizedBox(height: 16),
                            Text('No laboratories found', style: AppTextStyles.description),
                          ],
                        ),
                      ),
                    )
                  else
                    ...pathoLabState.filteredLabs.map((lab) => PathoLabCard(
                          lab: lab,
                          onTap: () => context.push(AppRouter.pathoLabDetails, extra: lab),
                        )),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
