import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/privacy_policy.dart';
import '../../providers/privacy_policy_provider.dart';
import '../../theme/app_theme.dart';

class CreateEditPrivacyPolicyCard extends ConsumerStatefulWidget {
  final PrivacyPolicy? policy;
  const CreateEditPrivacyPolicyCard({super.key, this.policy});

  @override
  ConsumerState<CreateEditPrivacyPolicyCard> createState() => _CreateEditPrivacyPolicyCardState();
}

class _CreateEditPrivacyPolicyCardState extends ConsumerState<CreateEditPrivacyPolicyCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _headerController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _headerController = TextEditingController(text: widget.policy?.privacyHeader);
    _descriptionController = TextEditingController(text: widget.policy?.privacyDescription);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success;
    if (widget.policy == null) {
      success = await ref.read(privacyPolicyNotifierProvider.notifier).createPolicy(
            _headerController.text,
            _descriptionController.text,
          );
    } else {
      success = await ref.read(privacyPolicyNotifierProvider.notifier).updatePolicy(
            widget.policy!.privacyId,
            _headerController.text,
            _descriptionController.text,
          );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.policy == null ? 'Policy Created Successfully' : 'Policy Updated Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Operation Failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.policy == null ? 'New Privacy Policy' : 'Update Policy',
                  style: AppTextStyles.subHeader.copyWith(fontWeight: FontWeight.w900),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(IconsaxPlusLinear.close_circle, color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _headerController,
              decoration: AppTheme.inputDecoration('Policy Header').copyWith(
                prefixIcon: const Icon(IconsaxPlusLinear.shield_tick, size: 20, color: AppColors.primary),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: AppTheme.inputDecoration('Policy Description').copyWith(
                prefixIcon: const Icon(IconsaxPlusLinear.text_block, size: 20, color: AppColors.primary),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                    : Text(
                        widget.policy == null ? 'PUBLISH POLICY' : 'UPDATE POLICY',
                        style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
