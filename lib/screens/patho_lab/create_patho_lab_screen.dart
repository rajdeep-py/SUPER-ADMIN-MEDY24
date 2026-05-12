import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/patho_lab_provider.dart';

class CreatePathoLabScreen extends ConsumerStatefulWidget {
  const CreatePathoLabScreen({super.key});

  @override
  ConsumerState<CreatePathoLabScreen> createState() =>
      _CreatePathoLabScreenState();
}

class _CreatePathoLabScreenState extends ConsumerState<CreatePathoLabScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gstController = TextEditingController();
  final _panController = TextEditingController();
  final _nablController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _whatsappController = TextEditingController();

  PlatformFile? _logoFile;
  PlatformFile? _certFile;
  PlatformFile? _passbookFile;

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
      withData: kIsWeb, // Important for web
    );

    if (result != null) {
      setState(() {
        if (type == 'logo') {
          _logoFile = result.files.single;
        } else if (type == 'cert') {
          _certFile = result.files.single;
        } else if (type == 'passbook') {
          _passbookFile = result.files.single;
        }
      });
    }
  }

  void _onboardLab() async {
    if (_formKey.currentState!.validate()) {
      if (_certFile == null || _passbookFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload required documents')),
        );
        return;
      }

      final Map<String, dynamic> data = {
        'lab_name': _nameController.text,
        'mobile_number': _mobileController.text,
        'email_address': _emailController.text,
        'password': _passwordController.text,
        'pan_number': _panController.text,
        'nabl_accreditation_number': _nablController.text,
        'address': _addressController.text,
        'terms_conditions_accepted': true,
        'privacy_policy_accepted': true,
        if (_gstController.text.isNotEmpty) 'gst_number': _gstController.text,
        if (_emergencyController.text.isNotEmpty)
          'emergency_contact_number': _emergencyController.text,
        if (_whatsappController.text.isNotEmpty)
          'whatsapp_number': _whatsappController.text,
      };

      final formData = FormData.fromMap(data);

      // Add files
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'registration_certificate',
            MultipartFile.fromBytes(
              _certFile!.bytes!,
              filename: _certFile!.name,
            ),
          ),
        );
        formData.files.add(
          MapEntry(
            'bank_passbook',
            MultipartFile.fromBytes(
              _passbookFile!.bytes!,
              filename: _passbookFile!.name,
            ),
          ),
        );
        if (_logoFile != null) {
          formData.files.add(
            MapEntry(
              'lab_logo',
              MultipartFile.fromBytes(
                _logoFile!.bytes!,
                filename: _logoFile!.name,
              ),
            ),
          );
        }
      } else {
        formData.files.add(
          MapEntry(
            'registration_certificate',
            await MultipartFile.fromFile(_certFile!.path!),
          ),
        );
        formData.files.add(
          MapEntry(
            'bank_passbook',
            await MultipartFile.fromFile(_passbookFile!.path!),
          ),
        );
        if (_logoFile != null) {
          formData.files.add(
            MapEntry(
              'lab_logo',
              await MultipartFile.fromFile(_logoFile!.path!),
            ),
          );
        }
      }

      try {
        await ref.read(pathoLabProvider.notifier).onboardLab(formData);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Laboratory onboarded successfully')),
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
        title: 'Onboard Laboratory',
        subtitle: 'Add a new partner pathology lab',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: AppCardStyles.sleekCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Information',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Laboratory Name *',
                      _nameController,
                      IconsaxPlusLinear.hospital,
                      true,
                    ),
                    _buildInputField(
                      'Mobile Number *',
                      _mobileController,
                      IconsaxPlusLinear.call,
                      true,
                    ),
                    _buildInputField(
                      'Email Address *',
                      _emailController,
                      IconsaxPlusLinear.sms,
                      true,
                    ),
                    _buildInputField(
                      'Password *',
                      _passwordController,
                      IconsaxPlusLinear.lock,
                      true,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    // Logo Picker
                    Text(
                      'Laboratory Logo',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: _logoFile == null
                                ? const Icon(
                                    IconsaxPlusLinear.hospital,
                                    color: AppColors.textTertiary,
                                    size: 40,
                                  )
                                : ClipOval(
                                    child: kIsWeb
                                        ? Image.memory(
                                            _logoFile!.bytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'file://${_logoFile!.path}',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickFile('logo'),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  IconsaxPlusLinear.camera,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Compliance Details',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'GST Number',
                      _gstController,
                      IconsaxPlusLinear.percentage_square,
                      false,
                    ),
                    _buildInputField(
                      'PAN Number *',
                      _panController,
                      IconsaxPlusLinear.card_pos,
                      true,
                    ),
                    _buildInputField(
                      'NABL Accreditation *',
                      _nablController,
                      IconsaxPlusLinear.award,
                      true,
                    ),
                    const SizedBox(height: 16),
                    _buildFileUploadTile(
                      'Registration Certificate *',
                      _certFile?.name ?? 'No file selected',
                      () => _pickFile('cert'),
                      true,
                    ),
                    const SizedBox(height: 12),
                    _buildFileUploadTile(
                      'Bank Passbook *',
                      _passbookFile?.name ?? 'No file selected',
                      () => _pickFile('passbook'),
                      true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Location & Support',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Full Address *',
                      _addressController,
                      IconsaxPlusLinear.location,
                      true,
                      maxLines: 3,
                    ),
                    _buildInputField(
                      'Emergency Contact',
                      _emergencyController,
                      IconsaxPlusLinear.call_calling,
                      false,
                    ),
                    _buildInputField(
                      'WhatsApp Number',
                      _whatsappController,
                      IconsaxPlusLinear.sms,
                      false,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onboardLab,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: const Text('Confirm Onboarding'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadTile(
    String label,
    String fileName,
    VoidCallback onTap,
    bool required,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const Icon(
                IconsaxPlusLinear.document_text,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  fileName,
                  style: AppTextStyles.description.copyWith(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: onTap,
                child: Text(
                  'Upload',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool required, {
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            maxLines: maxLines,
            validator: (value) => required && (value == null || value.isEmpty)
                ? 'This field is required'
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
}
