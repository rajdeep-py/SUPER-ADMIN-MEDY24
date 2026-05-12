import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:dio/dio.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/lab_test_provider.dart';
import '../../services/api_url.dart';

class LabTestDetailsScreen extends ConsumerStatefulWidget {
  final LabTest test;
  const LabTestDetailsScreen({super.key, required this.test});

  @override
  ConsumerState<LabTestDetailsScreen> createState() => _LabTestDetailsScreenState();
}

class _LabTestDetailsScreenState extends ConsumerState<LabTestDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _sampleTypeController;
  late TextEditingController _descriptionController;
  late List<TextEditingController> _parameterControllers;
  late List<TextEditingController> _precautionControllers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.test.testName);
    _categoryController = TextEditingController(text: widget.test.testCategory);
    _sampleTypeController = TextEditingController(text: widget.test.sampleType);
    _descriptionController = TextEditingController(text: widget.test.description);
    
    _parameterControllers = widget.test.parameters
        .map((p) => TextEditingController(text: p.toString()))
        .toList();
    
    _precautionControllers = widget.test.precautions
        .map((p) => TextEditingController(text: p.toString()))
        .toList();
  }

  void _save() async {
    final List<String> parameters = _parameterControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .toList();
    
    final List<String> precautions = _precautionControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .toList();

    final Map<String, dynamic> data = {
      'test_name': _nameController.text,
      'test_category': _categoryController.text,
      'sample_type': _sampleTypeController.text,
      'description': _descriptionController.text,
      'parameters': jsonEncode(parameters),
      'precautions': jsonEncode(precautions),
    };

    final formData = FormData.fromMap(data);

    try {
      await ref.read(labTestProvider.notifier).updateTest(widget.test.coreTestId, formData);
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Test Intelligence',
        subtitle: widget.test.testName,
        showBackButton: true,
        actions: [
          if (!_isEditing) ...[
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.edit,
              onTap: () => setState(() => _isEditing = true),
            ),
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.trash,
              iconColor: AppColors.error,
              onTap: () {},
            ),
          ] else ...[
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.tick_square,
              iconColor: AppColors.success,
              onTap: _save,
            ),
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.close_square,
              iconColor: AppColors.error,
              onTap: () => setState(() => _isEditing = false),
            ),
          ],
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 32),

            // Details
            _buildSectionHeader('Core Details', IconsaxPlusLinear.personalcard),
            const SizedBox(height: 20),
            _buildModernCard([
              _buildDetailField('Clinical Test Name', _nameController, IconsaxPlusLinear.hospital),
              Row(
                children: [
                  Expanded(child: _buildDetailField('Category', _categoryController, IconsaxPlusLinear.category)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailField('Sample Type', _sampleTypeController, IconsaxPlusLinear.glass)),
                ],
              ),
              _buildDetailField('Description', _descriptionController, IconsaxPlusLinear.document_text, maxLines: 4),
            ]),

            const SizedBox(height: 32),
            _buildSectionHeader('Investigation Metrics', IconsaxPlusLinear.setting_4),
            const SizedBox(height: 20),
            _buildModernCard([
              ..._parameterControllers.asMap().entries.map((entry) {
                return _buildDynamicField(
                  'Parameter ${entry.key + 1}',
                  entry.value,
                  IconsaxPlusLinear.setting_4,
                  onDelete: _isEditing ? () => setState(() => _parameterControllers.removeAt(entry.key)) : null,
                );
              }),
              if (_isEditing)
                _buildAddButton('Add Parameter', () => setState(() => _parameterControllers.add(TextEditingController()))),
            ]),

            const SizedBox(height: 32),
            _buildSectionHeader('Handling Instructions', IconsaxPlusLinear.info_circle),
            const SizedBox(height: 20),
            _buildModernCard([
              ..._precautionControllers.asMap().entries.map((entry) {
                return _buildDynamicField(
                  'Precaution ${entry.key + 1}',
                  entry.value,
                  IconsaxPlusLinear.info_circle,
                  onDelete: _isEditing ? () => setState(() => _precautionControllers.removeAt(entry.key)) : null,
                );
              }),
              if (_isEditing)
                _buildAddButton('Add Precaution', () => setState(() => _precautionControllers.add(TextEditingController()))),
            ]),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [AppColors.primary.withAlpha(13), Colors.white, AppColors.primary.withAlpha(5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withAlpha(26), width: 4),
              image: widget.test.testPhotoUrl != null && widget.test.testPhotoUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(
                        widget.test.testPhotoUrl!.startsWith('http')
                            ? widget.test.testPhotoUrl!
                            : '${ApiUrls.baseUrl}${widget.test.testPhotoUrl!.startsWith('/') ? widget.test.testPhotoUrl!.substring(1) : widget.test.testPhotoUrl}',
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.test.testPhotoUrl == null || widget.test.testPhotoUrl!.isEmpty
                ? const Icon(IconsaxPlusLinear.microscope, color: AppColors.primary, size: 56)
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            widget.test.testName,
            style: AppTextStyles.header.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'CORE TEST ID: ${widget.test.coreTestId}',
            style: AppTextStyles.tagline.copyWith(color: AppColors.textSecondary, letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 22),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryAccent)),
      ],
    );
  }

  Widget _buildModernCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: AppCardStyles.sleekCard,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildDetailField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            enabled: _isEditing,
            maxLines: maxLines,
            style: AppTextStyles.description.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: _isEditing ? AppColors.primary : AppColors.textTertiary),
              filled: true,
              fillColor: _isEditing ? Colors.white : AppColors.background.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(String label, TextEditingController controller, IconData icon, {VoidCallback? onDelete}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: _isEditing,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, size: 20, color: _isEditing ? AppColors.primary : AppColors.textTertiary),
                hintText: label,
                filled: true,
                fillColor: _isEditing ? Colors.white : AppColors.background.withAlpha(128),
              ),
            ),
          ),
          if (_isEditing && onDelete != null)
            IconButton(
              icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(IconsaxPlusLinear.add_circle, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
