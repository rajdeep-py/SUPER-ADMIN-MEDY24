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
  ConsumerState<CreateLabTestScreen> createState() =>
      _CreateLabTestScreenState();
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
    if (_formKey.currentState!.validate()) {
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
          formData.files.add(
            MapEntry(
              'test_photo',
              MultipartFile.fromBytes(
                _testPhoto!.bytes!,
                filename: _testPhoto!.name,
              ),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'test_photo',
              await MultipartFile.fromFile(_testPhoto!.path!),
            ),
          );
        }
      }

      try {
        await ref.read(labTestProvider.notifier).createTest(formData);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lab Test created successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'New Core Test',
        subtitle: 'Configure a new laboratory investigation',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSectionHeader(
                '1',
                'Primary Intelligence',
                'Basic test identification details',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                _buildInputField(
                  'Test Name',
                  _nameController,
                  IconsaxPlusLinear.hospital,
                  true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Category',
                        _categoryController,
                        IconsaxPlusLinear.category,
                        true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        'Sample Type',
                        _sampleTypeController,
                        IconsaxPlusLinear.glass,
                        true,
                      ),
                    ),
                  ],
                ),
                _buildInputField(
                  'Clinical Description',
                  _descriptionController,
                  IconsaxPlusLinear.document_text,
                  true,
                  maxLines: 3,
                ),
              ]),

              const SizedBox(height: 32),
              _buildSectionHeader(
                '2',
                'Visual Reference',
                'Instructional photo for the test',
              ),
              const SizedBox(height: 24),
              _buildModernCard([_buildPhotoPicker()]),

              const SizedBox(height: 32),
              _buildSectionHeader(
                '3',
                'Operational Parameters',
                'Specific investigation metrics',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                ..._parameterControllers.asMap().entries.map((entry) {
                  return _buildDynamicField(
                    'Parameter ${entry.key + 1}',
                    entry.value,
                    IconsaxPlusLinear.setting_4,
                    onDelete: entry.key > 0
                        ? () => setState(
                            () => _parameterControllers.removeAt(entry.key),
                          )
                        : null,
                  );
                }),
                _buildAddButton('Add Parameter', _addParameter),
              ]),

              const SizedBox(height: 32),
              _buildSectionHeader(
                '4',
                'Safety & Precautions',
                'Critical handling instructions',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                ..._precautionControllers.asMap().entries.map((entry) {
                  return _buildDynamicField(
                    'Precaution ${entry.key + 1}',
                    entry.value,
                    IconsaxPlusLinear.info_circle,
                    onDelete: entry.key > 0
                        ? () => setState(
                            () => _precautionControllers.removeAt(entry.key),
                          )
                        : null,
                  );
                }),
                _buildAddButton('Add Precaution', _addPrecaution),
              ]),

              const SizedBox(height: 48),
              _buildSubmitButton(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String step, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: AppCardStyles.sleekCard,
      child: Column(children: children),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool required, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: (value) => required && (value == null || value.isEmpty)
                ? 'Required'
                : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
              hintText: 'Enter $label',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(
    String label,
    TextEditingController controller,
    IconData icon, {
    VoidCallback? onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
                hintText: label,
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.trash,
                color: AppColors.error,
                size: 20,
              ),
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

  Widget _buildPhotoPicker() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickPhoto,
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.divider,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                image: _testPhoto != null
                    ? DecorationImage(
                        image: kIsWeb
                            ? MemoryImage(_testPhoto!.bytes!)
                            : FileImage(File(_testPhoto!.path!))
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _testPhoto == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.camera,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Upload Test Photo',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
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
            color: AppColors.primary.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Publish Core Lab Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
