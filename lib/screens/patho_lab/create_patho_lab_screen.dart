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
        title: 'Partner Onboarding',
        subtitle: 'Add a new high-precision laboratory',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStepHeader(
                '1',
                'General Information',
                'Basic credentials and contact details',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                _buildInputField(
                  'Laboratory Name',
                  _nameController,
                  IconsaxPlusLinear.hospital,
                  true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Mobile Number',
                        _mobileController,
                        IconsaxPlusLinear.call,
                        true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        'WhatsApp Number',
                        _whatsappController,
                        IconsaxPlusLinear.sms,
                        false,
                      ),
                    ),
                  ],
                ),
                _buildInputField(
                  'Email Address',
                  _emailController,
                  IconsaxPlusLinear.sms,
                  true,
                ),
                _buildInputField(
                  'Account Password',
                  _passwordController,
                  IconsaxPlusLinear.lock,
                  true,
                  isPassword: true,
                ),
              ]),
              const SizedBox(height: 32),
              _buildStepHeader(
                '2',
                'Visual Branding',
                'Identity and logo for the laboratory',
              ),
              const SizedBox(height: 24),
              _buildModernCard([_buildLogoPicker()]),
              const SizedBox(height: 32),
              _buildStepHeader(
                '3',
                'Compliance & Verification',
                'Required legal and accreditation documents',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'PAN Number',
                        _panController,
                        IconsaxPlusLinear.card_pos,
                        true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        'GST Number',
                        _gstController,
                        IconsaxPlusLinear.percentage_square,
                        false,
                      ),
                    ),
                  ],
                ),
                _buildInputField(
                  'NABL Accreditation ID',
                  _nablController,
                  IconsaxPlusLinear.award,
                  true,
                ),
                const SizedBox(height: 12),
                _buildFileUploadTile(
                  'Registration Certificate',
                  _certFile?.name ?? 'No file selected',
                  () => _pickFile('cert'),
                  true,
                ),
                const SizedBox(height: 16),
                _buildFileUploadTile(
                  'Bank Passbook Copy',
                  _passbookFile?.name ?? 'No file selected',
                  () => _pickFile('passbook'),
                  true,
                ),
              ]),
              const SizedBox(height: 32),
              _buildStepHeader(
                '4',
                'Location & Support',
                'Operational address and emergency contact',
              ),
              const SizedBox(height: 24),
              _buildModernCard([
                _buildInputField(
                  'Operational Address',
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

  Widget _buildStepHeader(String step, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLogoPicker() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: _logoFile == null
                    ? const Icon(
                        IconsaxPlusLinear.hospital,
                        color: AppColors.textTertiary,
                        size: 48,
                      )
                    : ClipOval(
                        child: kIsWeb
                            ? Image.memory(_logoFile!.bytes!, fit: BoxFit.cover)
                            : Image.network(
                                'file://${_logoFile!.path}',
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _pickFile('logo'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.camera,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Upload Brand Logo',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
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
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _onboardLab,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Confirm Laboratory Onboarding',
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
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(
              IconsaxPlusLinear.document_text,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                fileName,
                style: AppTextStyles.description.copyWith(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: onTap,
                child: Text(
                  'Upload',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w800,
                  ),
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
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (required ? ' *' : ''),
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          maxLines: maxLines,
          validator: (value) =>
              required && (value == null || value.isEmpty) ? 'Required' : null,
          style: AppTextStyles.description.copyWith(
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
            hintText: 'Enter $label',
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
          ),
        ),
      ],
    ),
  );
}
