import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/patho_lab.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/patho_lab_provider.dart';
import '../../services/api_url.dart';

class PathoLabDetailsScreen extends ConsumerStatefulWidget {
  final PathoLab lab;
  const PathoLabDetailsScreen({super.key, required this.lab});

  @override
  ConsumerState<PathoLabDetailsScreen> createState() =>
      _PathoLabDetailsScreenState();
}

class _PathoLabDetailsScreenState extends ConsumerState<PathoLabDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _gstController;
  late TextEditingController _panController;
  late TextEditingController _nablController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyController;
  late TextEditingController _whatsappController;
  String _status = 'active';

  PlatformFile? _logoFile;
  PlatformFile? _certFile;
  PlatformFile? _passbookFile;

  String? _currentLogoUrl;
  String? _currentCertName;
  String? _currentPassbookName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lab.labName);
    _mobileController = TextEditingController(text: widget.lab.mobileNumber);
    _emailController = TextEditingController(text: widget.lab.emailAddress);
    _gstController = TextEditingController(text: widget.lab.gstNumber);
    _panController = TextEditingController(text: widget.lab.panNumber);
    _nablController = TextEditingController(
      text: widget.lab.nablAccreditationNumber,
    );
    _addressController = TextEditingController(text: widget.lab.address);
    _emergencyController = TextEditingController(
      text: widget.lab.emergencyContactNumber,
    );
    _whatsappController = TextEditingController(
      text: widget.lab.whatsappNumber,
    );
    _status = widget.lab.status;
    _currentLogoUrl = widget.lab.labLogoUrl;
    _currentCertName = widget.lab.registrationCertificateUrl.split('/').last;
    _currentPassbookName = widget.lab.bankPassbookUrl.split('/').last;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _nablController.dispose();
    _addressController.dispose();
    _emergencyController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

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
        } else if (type == 'cert') {
          _certFile = result.files.single;
        } else if (type == 'passbook') {
          _passbookFile = result.files.single;
        }
      });
    }
  }

  void _saveChanges() async {
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
      'status': _status,
    };

    final formData = FormData.fromMap(data);

    if (_logoFile != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'lab_logo',
            MultipartFile.fromBytes(
              _logoFile!.bytes!,
              filename: _logoFile!.name,
            ),
          ),
        );
      } else {
        formData.files.add(
          MapEntry('lab_logo', await MultipartFile.fromFile(_logoFile!.path!)),
        );
      }
    }

    if (_certFile != null) {
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
      } else {
        formData.files.add(
          MapEntry(
            'registration_certificate',
            await MultipartFile.fromFile(_certFile!.path!),
          ),
        );
      }
    }

    if (_passbookFile != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'bank_passbook',
            MultipartFile.fromBytes(
              _passbookFile!.bytes!,
              filename: _passbookFile!.name,
            ),
          ),
        );
      } else {
        formData.files.add(
          MapEntry(
            'bank_passbook',
            await MultipartFile.fromFile(_passbookFile!.path!),
          ),
        );
      }
    }

    try {
      await ref
          .read(pathoLabProvider.notifier)
          .updateLab(widget.lab.labId, formData);
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
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

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (_status.toLowerCase()) {
      case 'active':
        statusColor = AppColors.success;
        break;
      case 'suspended':
        statusColor = AppColors.warning;
        break;
      case 'terminated':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textTertiary;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: _isEditing ? 'Edit Laboratory' : 'Lab Profile',
        subtitle: widget.lab.labName,
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
              onTap: () {
                // Confirmation dialog could go here
              },
            ),
          ] else ...[
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.tick_square,
              iconColor: AppColors.success,
              onTap: _saveChanges,
            ),
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.close_square,
              iconColor: AppColors.error,
              onTap: () => setState(() => _isEditing = false),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Profile Header with Modern Look
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: AppCardStyles.sleekCard.copyWith(
                gradient: LinearGradient(
                  colors: [Colors.white, statusColor.withOpacity(0.05)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                        child:
                            _logoFile == null &&
                                (_currentLogoUrl == null ||
                                    _currentLogoUrl!.isEmpty)
                            ? Icon(
                                IconsaxPlusLinear.hospital,
                                color: statusColor,
                                size: 48,
                              )
                            : ClipOval(
                                child: _logoFile != null
                                    ? (kIsWeb
                                          ? Image.memory(
                                              _logoFile!.bytes!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'file://${_logoFile!.path}',
                                              fit: BoxFit.cover,
                                            ))
                                    : Image.network(
                                        _currentLogoUrl!.startsWith('http')
                                            ? _currentLogoUrl!
                                            : '${ApiUrls.baseUrl}${_currentLogoUrl!.startsWith('/') ? _currentLogoUrl!.substring(1) : _currentLogoUrl}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  IconsaxPlusLinear.hospital,
                                                  color: statusColor,
                                                  size: 48,
                                                ),
                                      ),
                              ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _pickFile('logo'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
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
                  const SizedBox(height: 20),
                  Text(
                    widget.lab.labName,
                    style: AppTextStyles.subHeader.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      _status.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Details Sections
            Container(
              padding: const EdgeInsets.all(32),
              decoration: AppCardStyles.sleekCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Basic Information',
                    IconsaxPlusLinear.info_circle,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailField(
                    'Laboratory Name',
                    _nameController,
                    IconsaxPlusLinear.hospital,
                  ),
                  _buildDetailField(
                    'Mobile Number',
                    _mobileController,
                    IconsaxPlusLinear.call,
                  ),
                  _buildDetailField(
                    'Email Address',
                    _emailController,
                    IconsaxPlusLinear.sms,
                  ),

                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    'Compliance & Records',
                    IconsaxPlusLinear.verify,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailField(
                    'GST Number',
                    _gstController,
                    IconsaxPlusLinear.percentage_square,
                  ),
                  _buildDetailField(
                    'PAN Number',
                    _panController,
                    IconsaxPlusLinear.card_pos,
                  ),
                  _buildDetailField(
                    'NABL Number',
                    _nablController,
                    IconsaxPlusLinear.award,
                  ),
                  const SizedBox(height: 16),
                  _buildFileUploadTile(
                    'Registration Certificate',
                    _certFile?.name ?? _currentCertName ?? 'Document not available',
                    () => _pickFile('cert'),
                    url: widget.lab.registrationCertificateUrl,
                  ),
                  const SizedBox(height: 12),
                  _buildFileUploadTile(
                    'Bank Passbook',
                    _passbookFile?.name ??
                        _currentPassbookName ??
                        'Document not available',
                    () => _pickFile('passbook'),
                    url: widget.lab.bankPassbookUrl,
                  ),

                  const SizedBox(height: 32),
                  _buildSectionHeader('Location', IconsaxPlusLinear.location),
                  const SizedBox(height: 24),
                  _buildDetailField(
                    'Full Address',
                    _addressController,
                    IconsaxPlusLinear.location,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    'Operational Controls',
                    IconsaxPlusLinear.setting_4,
                  ),
                  const SizedBox(height: 24),
                  _buildStatusDropdown(),

                  const SizedBox(height: 24),
                  _buildDetailField(
                    'Emergency Contact',
                    _emergencyController,
                    IconsaxPlusLinear.call_calling,
                  ),
                  _buildDetailField(
                    'WhatsApp Number',
                    _whatsappController,
                    IconsaxPlusLinear.sms,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 22),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryAccent,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailField(
    String label,
    TextEditingController controller,
    IconData icon, {
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
          TextField(
            controller: controller,
            enabled: _isEditing,
            maxLines: maxLines,
            style: AppTextStyles.description.copyWith(
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                size: 20,
                color: _isEditing ? AppColors.primary : AppColors.textTertiary,
              ),
              filled: true,
              fillColor: _isEditing
                  ? Colors.white
                  : AppColors.background.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadTile(
      String label, String fileName, VoidCallback onTap,
      {String? url}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
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
              const Icon(IconsaxPlusLinear.document_text,
                  color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  fileName,
                  style: AppTextStyles.description
                      .copyWith(fontSize: 13, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isEditing)
                TextButton(
                  onPressed: onTap,
                  child: Text('Change',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800)),
                )
              else if (url != null && url.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final fullUrl = url.startsWith('http')
                        ? url
                        : '${ApiUrls.baseUrl}${url.startsWith('/') ? url.substring(1) : url}';
                    final uri = Uri.parse(fullUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(IconsaxPlusLinear.eye, size: 16),
                  label: Text('View',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Laboratory Status',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _isEditing
                ? Colors.white
                : AppColors.background.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isEditing ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _status,
              isExpanded: true,
              onChanged: _isEditing
                  ? (value) => setState(() => _status = value!)
                  : null,
              items: ['active', 'suspended', 'terminated'].map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(
                    s.toUpperCase(),
                    style: AppTextStyles.description.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
