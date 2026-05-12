// ignore_for_file: curly_braces_in_flow_control_structures

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
  final _gstController = TextEditingController();
  final _panController = TextEditingController();
  final _nablController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();

  PlatformFile? _logoFile;
  PlatformFile? _certFile;
  PlatformFile? _passbookFile;

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        if (type == 'logo') {
          _logoFile = result.files.single;
        } else if (type == 'cert')
          _certFile = result.files.single;
        else if (type == 'passbook')
          _passbookFile = result.files.single;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_logoFile == null || _certFile == null || _passbookFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> data = {
      'lab_name': _nameController.text,
      'mobile_number': _mobileController.text,
      'email_address': _emailController.text,
      'gst_number': _gstController.text,
      'pan_number': _panController.text,
      'nabl_accreditation_number': _nablController.text,
      'address': _addressController.text,
      'emergency_contact_number': _emergencyController.text,
      'whatsapp_number': _whatsappController.text,
      'password': _passwordController.text,
      'status': 'active',
    };

    final formData = FormData.fromMap(data);

    // Add Files
    for (var fileData in [
      {'key': 'lab_logo', 'file': _logoFile},
      {'key': 'registration_certificate', 'file': _certFile},
      {'key': 'bank_passbook', 'file': _passbookFile},
    ]) {
      final file = fileData['file'] as PlatformFile?;
      if (file != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              fileData['key'] as String,
              MultipartFile.fromBytes(file.bytes!, filename: file.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              fileData['key'] as String,
              await MultipartFile.fromFile(file.path!),
            ),
          );
        }
      }
    }

    try {
      await ref.read(pathoLabProvider.notifier).onboardLab(formData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laboratory onboarded successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
        title: 'Partner Onboarding',
        subtitle: 'Initiate New Laboratory Node',
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
                        // Left Column: Business & Identity
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildSectionCard(
                                'Identity & Access',
                                IconsaxPlusLinear.personalcard,
                                [
                                  _buildInputField(
                                    'Laboratory Legal Name',
                                    _nameController,
                                    IconsaxPlusLinear.hospital,
                                    validator: (v) =>
                                        v!.isEmpty ? 'Required' : null,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInputField(
                                          'Primary Mobile',
                                          _mobileController,
                                          IconsaxPlusLinear.call,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _buildInputField(
                                          'WhatsApp Number',
                                          _whatsappController,
                                          IconsaxPlusLinear.sms,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildInputField(
                                    'Corporate Email',
                                    _emailController,
                                    IconsaxPlusLinear.sms,
                                  ),
                                  _buildInputField(
                                    'Portal Access Password',
                                    _passwordController,
                                    IconsaxPlusLinear.key,
                                    isPassword: true,
                                    obscureText: _obscurePassword,
                                    onToggle: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              _buildSectionCard(
                                'Regulatory & Operations',
                                IconsaxPlusLinear.verify,
                                [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInputField(
                                          'GST Identification',
                                          _gstController,
                                          IconsaxPlusLinear.percentage_square,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _buildInputField(
                                          'PAN Number',
                                          _panController,
                                          IconsaxPlusLinear.card_pos,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildInputField(
                                    'NABL Accreditation ID',
                                    _nablController,
                                    IconsaxPlusLinear.award,
                                  ),
                                  _buildInputField(
                                    'Operating Address',
                                    _addressController,
                                    IconsaxPlusLinear.location,
                                    maxLines: 3,
                                  ),
                                  _buildInputField(
                                    'Emergency Protocol Contact',
                                    _emergencyController,
                                    IconsaxPlusLinear.call_calling,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        // Right Column: Documents
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildSectionCard(
                                'Verification Documents',
                                IconsaxPlusLinear.document_upload,
                                [
                                  _buildFilePickerTile(
                                    'Business Logo / Avatar',
                                    _logoFile,
                                    () => _pickFile('logo'),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildFilePickerTile(
                                    'Registration Certificate',
                                    _certFile,
                                    () => _pickFile('cert'),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildFilePickerTile(
                                    'Bank Passbook Copy',
                                    _passbookFile,
                                    () => _pickFile('passbook'),
                                  ),
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
        Text(
          'Digital Onboarding',
          style: AppTextStyles.header.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in the required information to register a new laboratory partner into the Medy24 ecosystem.',
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
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
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
            obscureText: isPassword && obscureText,
            validator: validator,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? IconsaxPlusLinear.eye_slash
                            : IconsaxPlusLinear.eye,
                        size: 18,
                      ),
                      onPressed: onToggle,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background.withAlpha(128),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.divider.withAlpha(50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePickerTile(
    String label,
    PlatformFile? file,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: file == null
                  ? AppColors.background
                  : AppColors.success.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: file == null
                    ? AppColors.divider
                    : AppColors.success.withAlpha(50),
                style: file == null ? BorderStyle.solid : BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  file == null
                      ? IconsaxPlusLinear.document_upload
                      : IconsaxPlusLinear.document_favorite,
                  color: file == null
                      ? AppColors.textTertiary
                      : AppColors.success,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  file?.name ?? 'Click to upload document',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: file == null
                        ? AppColors.textSecondary
                        : AppColors.success,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (file == null)
                  Text(
                    'PDF, JPG, PNG (Max 5MB)',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'FINALIZE ONBOARDING',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
