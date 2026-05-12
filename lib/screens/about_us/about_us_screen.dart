import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../models/about_us.dart';
import '../../providers/about_us_provider.dart';
import '../../cards/about_us/company_header_card.dart';
import '../../cards/about_us/company_description_card.dart';
import '../../cards/about_us/mission_vision_card.dart';
import '../../cards/about_us/director_message_card.dart';
import '../../cards/about_us/partner_card.dart';
import '../../cards/about_us/contact_card.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    final aboutUsState = ref.watch(aboutUsProvider);
    final AboutUs? aboutUs = aboutUsState.entries.isNotEmpty
        ? aboutUsState.entries.first
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Company Intelligence',
        subtitle: 'Manage Corporate Branding & Identity',
        showDrawer: true,
        actions: [
          if (aboutUs != null)
            CustomAppBar.buildActionButton(
              icon: IconsaxPlusLinear.trash,
              iconColor: AppColors.error,
              onTap: () => _confirmDelete(aboutUs.id!),
            ),
          const SizedBox(width: 8),
          _buildPrimaryAction(aboutUs),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      body: aboutUsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(aboutUsProvider.notifier).loadAboutUs(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    _buildGreeting(),
                    const SizedBox(height: 40),
                    if (aboutUs == null)
                      _buildEmptyState()
                    else
                      Column(
                        children: [
                          CompanyHeaderCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 32),
                          CompanyDescriptionCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 32),
                          MissionVisionCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 32),
                          DirectorMessageCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 32),
                          PartnerCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 32),
                          ContactCard(
                            aboutUs: aboutUs,
                            onEdit: () => _showEditDialog(aboutUs),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Corporate Identity',
              style: AppTextStyles.header.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'LIVE',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Configure the public-facing brand information for the Medy24 ecosystem.',
          style: AppTextStyles.description,
        ),
      ],
    );
  }

  Widget _buildPrimaryAction(AboutUs? aboutUs) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showEditDialog(aboutUs),
        icon: Icon(
          aboutUs == null
              ? IconsaxPlusLinear.add_circle
              : IconsaxPlusLinear.edit,
          size: 18,
        ),
        label: Text(
          aboutUs == null ? 'INITIALIZE PROFILE' : 'EDIT ALL SECTIONS',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 40),
                ],
              ),
              child: const Icon(
                IconsaxPlusLinear.building_4,
                size: 80,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Company Profile Found',
              style: AppTextStyles.header.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t initialized your company\'s "About Us" information yet.\nInitialize now to showcase your brand to users and partners.',
              textAlign: TextAlign.center,
              style: AppTextStyles.description,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _showEditDialog(null),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'CREATE CORPORATE PROFILE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: const Text(
          'This will permanently remove all company information. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(aboutUsProvider.notifier).deleteAboutUs(id);
              if (mounted) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile deleted successfully')),
                );
              }
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(AboutUs? aboutUs) {
    showDialog(
      context: context,
      builder: (context) => AboutUsFormDialog(aboutUs: aboutUs),
    );
  }
}

class AboutUsFormDialog extends ConsumerStatefulWidget {
  final AboutUs? aboutUs;
  const AboutUsFormDialog({super.key, this.aboutUs});

  @override
  ConsumerState<AboutUsFormDialog> createState() => _AboutUsFormDialogState();
}

class _AboutUsFormDialogState extends ConsumerState<AboutUsFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _taglineController;
  late TextEditingController _descController;
  late TextEditingController _missionController;
  late TextEditingController _visionController;
  late TextEditingController _directorNameController;
  late TextEditingController _directorMessageController;
  late TextEditingController _officeController;
  late TextEditingController _regController;
  late TextEditingController _email1Controller;
  late TextEditingController _phone1Controller;
  late TextEditingController _websiteController;

  PlatformFile? _companyPhoto;
  PlatformFile? _directorPhoto;
  late List<Partner> _partners;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.aboutUs?.companyName);
    _taglineController = TextEditingController(
      text: widget.aboutUs?.companyTagline,
    );
    _descController = TextEditingController(
      text: widget.aboutUs?.companyDescriptionText,
    );
    _missionController = TextEditingController(text: widget.aboutUs?.mission);
    _visionController = TextEditingController(text: widget.aboutUs?.vision);
    _directorNameController = TextEditingController(
      text: widget.aboutUs?.directorName,
    );
    _directorMessageController = TextEditingController(
      text: widget.aboutUs?.directorMessage,
    );
    _officeController = TextEditingController(
      text: widget.aboutUs?.officeAddress,
    );
    _regController = TextEditingController(
      text: widget.aboutUs?.registeredAddress,
    );
    _email1Controller = TextEditingController(text: widget.aboutUs?.email1);
    _phone1Controller = TextEditingController(text: widget.aboutUs?.phone1);
    _websiteController = TextEditingController(text: widget.aboutUs?.website);
    _partners = widget.aboutUs?.partners != null
        ? List.from(widget.aboutUs!.partners!)
        : [];
  }

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        if (type == 'company') _companyPhoto = result.files.single;
        if (type == 'director') _directorPhoto = result.files.single;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final Map<String, dynamic> data = {
      'company_name': _nameController.text,
      'company_tagline': _taglineController.text,
      'company_description_text': _descController.text,
      'mission': _missionController.text,
      'vision': _visionController.text,
      'director_name': _directorNameController.text,
      'director_message': _directorMessageController.text,
      'office_address': _officeController.text,
      'registered_address': _regController.text,
      'email1': _email1Controller.text,
      'phone1': _phone1Controller.text,
      'website': _websiteController.text,
      'partners': jsonEncode(_partners.map((p) => p.toJson()).toList()),
    };

    final formData = FormData.fromMap(data);

    if (_companyPhoto != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'company_photo',
            MultipartFile.fromBytes(
              _companyPhoto!.bytes!,
              filename: _companyPhoto!.name,
            ),
          ),
        );
      } else {
        formData.files.add(
          MapEntry(
            'company_photo',
            await MultipartFile.fromFile(_companyPhoto!.path!),
          ),
        );
      }
    }

    if (_directorPhoto != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'director_photo',
            MultipartFile.fromBytes(
              _directorPhoto!.bytes!,
              filename: _directorPhoto!.name,
            ),
          ),
        );
      } else {
        formData.files.add(
          MapEntry(
            'director_photo',
            await MultipartFile.fromFile(_directorPhoto!.path!),
          ),
        );
      }
    }

    try {
      if (widget.aboutUs == null) {
        await ref.read(aboutUsProvider.notifier).createAboutUs(formData);
      } else {
        await ref
            .read(aboutUsProvider.notifier)
            .updateAboutUs(widget.aboutUs!.id!, formData);
      }
      if (mounted) {
        Navigator.pop(context);
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.aboutUs == null
                          ? 'Initialize Corporate Profile'
                          : 'Edit Corporate Profile',
                      style: AppTextStyles.header.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in the details to update your company identity across the platform.',
                      style: AppTextStyles.description,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(IconsaxPlusLinear.close_circle),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSection(
                        'Core Identity',
                        IconsaxPlusLinear.building,
                        [
                          _buildInputField(
                            'Company Legal Name',
                            _nameController,
                            IconsaxPlusLinear.building,
                          ),
                          _buildInputField(
                            'Brand Tagline',
                            _taglineController,
                            IconsaxPlusLinear.flash,
                          ),
                          _buildInputField(
                            'Company Story / Description',
                            _descController,
                            IconsaxPlusLinear.document_text,
                            maxLines: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilePicker(
                                  'Company Logo',
                                  _companyPhoto,
                                  () => _pickFile('company'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection('Mission & Vision', IconsaxPlusLinear.eye, [
                        _buildInputField(
                          'Our Mission',
                          _missionController,
                          IconsaxPlusLinear.flash,
                          maxLines: 3,
                        ),
                        _buildInputField(
                          'Our Vision',
                          _visionController,
                          IconsaxPlusLinear.eye,
                          maxLines: 3,
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildSection('Leadership', IconsaxPlusLinear.user, [
                        _buildInputField(
                          'Director Name',
                          _directorNameController,
                          IconsaxPlusLinear.user,
                        ),
                        _buildInputField(
                          'Director Message',
                          _directorMessageController,
                          IconsaxPlusLinear.quote_down,
                          maxLines: 4,
                        ),
                        _buildFilePicker(
                          'Director Photo',
                          _directorPhoto,
                          () => _pickFile('director'),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Contact & Presence',
                        IconsaxPlusLinear.location,
                        [
                          _buildInputField(
                            'HQ Address',
                            _officeController,
                            IconsaxPlusLinear.location,
                            maxLines: 2,
                          ),
                          _buildInputField(
                            'Registered Address',
                            _regController,
                            IconsaxPlusLinear.building,
                            maxLines: 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  'Primary Email',
                                  _email1Controller,
                                  IconsaxPlusLinear.sms,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildInputField(
                                  'Primary Phone',
                                  _phone1Controller,
                                  IconsaxPlusLinear.call,
                                ),
                              ),
                            ],
                          ),
                          _buildInputField(
                            'Corporate Website',
                            _websiteController,
                            IconsaxPlusLinear.global,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Strategic Partners',
                        IconsaxPlusLinear.ranking,
                        [
                          ..._partners.asMap().entries.map((entry) {
                            int idx = entry.key;
                            Partner p = entry.value;
                            return _buildPartnerField(idx, p);
                          }),
                          const SizedBox(height: 12),
                          _buildAddButton(
                            'Add Strategic Partner',
                            () => setState(
                              () => _partners.add(Partner(name: '')),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(
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
            validator: (v) => v!.isEmpty ? 'Field required' : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background.withAlpha(128),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerField(int index, Partner partner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withAlpha(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: partner.name,
                  onChanged: (val) => _partners[index] = Partner(
                    name: val,
                    website: _partners[index].website,
                    logo: _partners[index].logo,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Partner Name',
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.building_3,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.background.withAlpha(128),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => setState(() => _partners.removeAt(index)),
                icon: const Icon(
                  IconsaxPlusLinear.trash,
                  color: AppColors.error,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withAlpha(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: partner.logo,
                  onChanged: (val) => _partners[index] = Partner(
                    name: _partners[index].name,
                    website: _partners[index].website,
                    logo: val,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Logo URL',
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.link,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.background.withAlpha(128),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: partner.website,
                  onChanged: (val) => _partners[index] = Partner(
                    name: _partners[index].name,
                    website: val,
                    logo: _partners[index].logo,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Website URL',
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.global,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.background.withAlpha(128),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          border: Border.all(
            color: AppColors.primary.withAlpha(100),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary.withAlpha(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              IconsaxPlusLinear.add_circle,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker(
    String label,
    PlatformFile? file,
    VoidCallback onTap,
  ) {
    return Column(
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withAlpha(128),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(
                  file == null
                      ? IconsaxPlusLinear.document_upload
                      : IconsaxPlusLinear.tick_circle,
                  color: file == null
                      ? AppColors.textTertiary
                      : AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  file?.name ?? 'Choose File...',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: file == null
                        ? AppColors.textTertiary
                        : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
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
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'SAVE CORPORATE IDENTITY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
