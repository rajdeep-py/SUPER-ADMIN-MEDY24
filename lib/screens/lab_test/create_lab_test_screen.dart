import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/lab_test_provider.dart';

class CreateLabTestScreen extends ConsumerStatefulWidget {
  const CreateLabTestScreen({super.key});

  @override
  ConsumerState<CreateLabTestScreen> createState() => _CreateLabTestScreenState();
}

class _CreateLabTestScreenState extends ConsumerState<CreateLabTestScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _sampleTypeController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<TextEditingController> _parameterControllers = [];
  final List<TextEditingController> _precautionControllers = [];

  PlatformFile? _testPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addParameter();
    _addPrecaution();
  }

  void _addParameter() {
    setState(() {
      _parameterControllers.add(TextEditingController());
    });
  }

  void _addPrecaution() {
    setState(() {
      _precautionControllers.add(TextEditingController());
    });
  }

  Future<void> _pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        _testPhoto = result.files.single;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

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

    if (_testPhoto != null) {
      if (kIsWeb) {
        formData.files.add(MapEntry('test_photo', MultipartFile.fromBytes(_testPhoto!.bytes!, filename: _testPhoto!.name)));
      } else {
        formData.files.add(MapEntry('test_photo', await MultipartFile.fromFile(_testPhoto!.path!)));
      }
    }

    try {
      await ref.read(labTestProvider.notifier).createTest(formData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Diagnostic Protocol Published')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Protocol Formulation',
        subtitle: 'Configure New Core Lab Test',
        showBackButton: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 40),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Main Details
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildSectionCard(
                              'Primary Intelligence',
                              IconsaxPlusLinear.personalcard,
                              [
                                _buildInputField('Clinical Test Name', _nameController, IconsaxPlusLinear.hospital, validator: (v) => v!.isEmpty ? 'Required' : null),
                                Row(
                                  children: [
                                    Expanded(child: _buildInputField('Medical Category', _categoryController, IconsaxPlusLinear.category)),
                                    const SizedBox(width: 20),
                                    Expanded(child: _buildInputField('Biological Sample', _sampleTypeController, IconsaxPlusLinear.glass)),
                                  ],
                                ),
                                _buildInputField('Diagnostic Description', _descriptionController, IconsaxPlusLinear.document_text, maxLines: 4),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              'Visual Reference',
                              IconsaxPlusLinear.camera,
                              [_buildPhotoPicker()],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Right: Dynamic Specs
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildSectionCard(
                              'Investigation Specs',
                              IconsaxPlusLinear.setting_4,
                              [
                                ..._parameterControllers.asMap().entries.map((entry) {
                                  return _buildDynamicField(
                                    'Metric ${entry.key + 1}',
                                    entry.value,
                                    onDelete: entry.key > 0 ? () => setState(() => _parameterControllers.removeAt(entry.key)) : null,
                                  );
                                }),
                                _buildAddButton('Add Investigation Metric', _addParameter),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              'Safety Protocols',
                              IconsaxPlusLinear.info_circle,
                              [
                                ..._precautionControllers.asMap().entries.map((entry) {
                                  return _buildDynamicField(
                                    'Protocol ${entry.key + 1}',
                                    entry.value,
                                    onDelete: entry.key > 0 ? () => setState(() => _precautionControllers.removeAt(entry.key)) : null,
                                  );
                                }),
                                _buildAddButton('Add Handling Instruction', _addPrecaution),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test Formulation', style: AppTextStyles.header.copyWith(fontSize: 32, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
          'Register a new diagnostic protocol into the core medical intelligence repository.',
          style: AppTextStyles.description.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider.withAlpha(80)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background.withAlpha(128),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.divider.withAlpha(50))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(String label, TextEditingController controller, {VoidCallback? onDelete}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: label,
                prefixIcon: const Icon(IconsaxPlusLinear.arrow_right_1, size: 16, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background.withAlpha(128),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(IconsaxPlusLinear.minus_cirlce, color: AppColors.error, size: 20),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(IconsaxPlusLinear.add_circle, size: 18, color: AppColors.primary),
      label: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }

  Widget _buildPhotoPicker() {
    return InkWell(
      onTap: _pickPhoto,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider.withAlpha(100), style: BorderStyle.solid),
          image: _testPhoto != null
              ? DecorationImage(
                  image: kIsWeb ? MemoryImage(_testPhoto!.bytes!) : FileImage(File(_testPhoto!.path!)) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _testPhoto == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(IconsaxPlusLinear.camera, color: AppColors.textTertiary, size: 40),
                  const SizedBox(height: 12),
                  Text('Upload Reference Photo', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                  Text('JPG, PNG (Max 5MB)', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryAccent]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withAlpha(60), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: const Text('PUBLISH TEST PROTOCOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 15)),
      ),
    );
  }
}
