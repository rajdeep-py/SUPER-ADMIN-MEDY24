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
          const SnackBar(content: Text('Diagnostic Protocol Updated')),
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
        title: 'Diagnostic Intelligence',
        subtitle: 'Core Medical Data Management',
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
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 40),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildInfoSection(
                        'Medical Identity',
                        IconsaxPlusLinear.personalcard,
                        [
                          _buildInputField('Clinical Nomenclature', _nameController, IconsaxPlusLinear.hospital),
                          Row(
                            children: [
                              Expanded(child: _buildInputField('Medical Category', _categoryController, IconsaxPlusLinear.category)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildInputField('Biological Sample', _sampleTypeController, IconsaxPlusLinear.glass)),
                            ],
                          ),
                          _buildInputField('Diagnostic Description', _descriptionController, IconsaxPlusLinear.document_text, maxLines: 4),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildInfoSection(
                        'Investigation Parameters',
                        IconsaxPlusLinear.setting_4,
                        [
                          ..._parameterControllers.asMap().entries.map((entry) {
                            return _buildDynamicField(
                              'Parameter ${entry.key + 1}',
                              entry.value,
                              IconsaxPlusLinear.minus_cirlce,
                              onDelete: _isEditing ? () => setState(() => _parameterControllers.removeAt(entry.key)) : null,
                            );
                          }),
                          if (_isEditing)
                            _buildAddButton('Add Investigation Metric', () => setState(() => _parameterControllers.add(TextEditingController()))),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildInfoSection(
                        'Pre-Diagnostic Protocols',
                        IconsaxPlusLinear.info_circle,
                        [
                          ..._precautionControllers.asMap().entries.map((entry) {
                            return _buildDynamicField(
                              'Safety Protocol ${entry.key + 1}',
                              entry.value,
                              IconsaxPlusLinear.minus_cirlce,
                              onDelete: _isEditing ? () => setState(() => _precautionControllers.removeAt(entry.key)) : null,
                            );
                          }),
                          if (_isEditing)
                            _buildAddButton('Add Handling Instruction', () => setState(() => _precautionControllers.add(TextEditingController()))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primary.withAlpha(30), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: widget.test.testPhotoUrl != null && widget.test.testPhotoUrl!.isNotEmpty
                  ? Image.network(
                      widget.test.testPhotoUrl!.startsWith('http')
                          ? widget.test.testPhotoUrl!
                          : '${ApiUrls.baseUrl}${widget.test.testPhotoUrl!.startsWith('/') ? widget.test.testPhotoUrl!.substring(1) : widget.test.testPhotoUrl}',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(IconsaxPlusLinear.microscope, size: 48, color: AppColors.primary),
                    )
                  : const Icon(IconsaxPlusLinear.microscope, size: 48, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    widget.test.testCategory.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.test.testName,
                  style: AppTextStyles.header.copyWith(fontSize: 36, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'MASTER DIAGNOSTIC PROTOCOL ID: ${widget.test.coreTestId}',
                  style: AppTextStyles.tagline.copyWith(color: AppColors.textTertiary, letterSpacing: 2, fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            enabled: _isEditing,
            maxLines: maxLines,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: _isEditing ? AppColors.primary : AppColors.textTertiary),
              filled: true,
              fillColor: _isEditing ? Colors.white : AppColors.background.withAlpha(128),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.divider.withAlpha(50))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                prefixIcon: const Icon(IconsaxPlusLinear.arrow_right_1, size: 16, color: AppColors.primary),
                hintText: label,
                filled: true,
                fillColor: _isEditing ? Colors.white : AppColors.background.withAlpha(128),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider.withAlpha(50))),
              ),
            ),
          ),
          if (_isEditing && onDelete != null) ...[
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error, size: 20),
              onPressed: onDelete,
              style: IconButton.styleFrom(backgroundColor: AppColors.error.withAlpha(20)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withAlpha(100), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary.withAlpha(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(IconsaxPlusLinear.add_circle, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
