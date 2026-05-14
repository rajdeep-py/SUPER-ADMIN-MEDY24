import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/terms_conditions.dart';
import '../../providers/terms_conditions_provider.dart';
import '../../theme/app_theme.dart';

class CreateEditTermsConditionsCard extends ConsumerStatefulWidget {
  final TermsConditions? term;
  const CreateEditTermsConditionsCard({super.key, this.term});

  @override
  ConsumerState<CreateEditTermsConditionsCard> createState() => _CreateEditTermsConditionsCardState();
}

class _CreateEditTermsConditionsCardState extends ConsumerState<CreateEditTermsConditionsCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _headerController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _headerController = TextEditingController(text: widget.term?.termHeader);
    _descriptionController = TextEditingController(text: widget.term?.termDescription);
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
    if (widget.term == null) {
      success = await ref.read(termsConditionsNotifierProvider.notifier).createTerm(
            _headerController.text,
            _descriptionController.text,
          );
    } else {
      success = await ref.read(termsConditionsNotifierProvider.notifier).updateTerm(
            widget.term!.termId,
            _headerController.text,
            _descriptionController.text,
          );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.term == null ? 'Term Created Successfully' : 'Term Updated Successfully')),
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
                  widget.term == null ? 'New Term' : 'Update Term',
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
              decoration: AppTheme.inputDecoration('Term Header').copyWith(
                prefixIcon: const Icon(IconsaxPlusLinear.document_text, size: 20, color: AppColors.primary),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: AppTheme.inputDecoration('Term Description').copyWith(
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
                        widget.term == null ? 'PUBLISH TERM' : 'UPDATE TERM',
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
