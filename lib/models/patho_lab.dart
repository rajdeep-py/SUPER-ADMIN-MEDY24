class PathoLab {
  final String labId;
  final String labName;
  final String mobileNumber;
  final String emailAddress;
  final String? password;
  final String? gstNumber;
  final String panNumber;
  final String nablAccreditationNumber;
  final String address;
  final String? labLogoUrl;
  final String registrationCertificateUrl;
  final String bankPassbookUrl;
  final String? emergencyContactNumber;
  final String? whatsappNumber;
  final bool termsConditionsAccepted;
  final bool privacyPolicyAccepted;
  final String status; // active, suspended, terminated

  PathoLab({
    required this.labId,
    required this.labName,
    required this.mobileNumber,
    required this.emailAddress,
    this.password,
    this.gstNumber,
    required this.panNumber,
    required this.nablAccreditationNumber,
    required this.address,
    this.labLogoUrl,
    required this.registrationCertificateUrl,
    required this.bankPassbookUrl,
    this.emergencyContactNumber,
    this.whatsappNumber,
    this.termsConditionsAccepted = false,
    this.privacyPolicyAccepted = false,
    this.status = "active",
  });

  factory PathoLab.fromJson(Map<String, dynamic> json) {
    return PathoLab(
      labId: json['lab_id'] as String,
      labName: json['lab_name'] as String,
      mobileNumber: json['mobile_number'] as String,
      emailAddress: json['email_address'] as String,
      password: json['password'] as String?,
      gstNumber: json['gst_number'] as String?,
      panNumber: json['pan_number'] as String,
      nablAccreditationNumber: json['nabl_accreditation_number'] as String,
      address: json['address'] as String,
      labLogoUrl: json['lab_logo_url'] as String?,
      registrationCertificateUrl: json['registration_certificate_url'] as String,
      bankPassbookUrl: json['bank_passbook_url'] as String,
      emergencyContactNumber: json['emergency_contact_number'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      termsConditionsAccepted: json['terms_conditions_accepted'] as bool? ?? false,
      privacyPolicyAccepted: json['privacy_policy_accepted'] as bool? ?? false,
      status: json['status'] as String? ?? "active",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lab_id': labId,
      'lab_name': labName,
      'mobile_number': mobileNumber,
      'email_address': emailAddress,
      'password': password,
      'gst_number': gstNumber,
      'pan_number': panNumber,
      'nabl_accreditation_number': nablAccreditationNumber,
      'address': address,
      'lab_logo_url': labLogoUrl,
      'registration_certificate_url': registrationCertificateUrl,
      'bank_passbook_url': bankPassbookUrl,
      'emergency_contact_number': emergencyContactNumber,
      'whatsapp_number': whatsappNumber,
      'terms_conditions_accepted': termsConditionsAccepted,
      'privacy_policy_accepted': privacyPolicyAccepted,
      'status': status,
    };
  }

  PathoLab copyWith({
    String? labId,
    String? labName,
    String? mobileNumber,
    String? emailAddress,
    String? password,
    String? gstNumber,
    String? panNumber,
    String? nablAccreditationNumber,
    String? address,
    String? labLogoUrl,
    String? registrationCertificateUrl,
    String? bankPassbookUrl,
    String? emergencyContactNumber,
    String? whatsappNumber,
    bool? termsConditionsAccepted,
    bool? privacyPolicyAccepted,
    String? status,
  }) {
    return PathoLab(
      labId: labId ?? this.labId,
      labName: labName ?? this.labName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      nablAccreditationNumber: nablAccreditationNumber ?? this.nablAccreditationNumber,
      address: address ?? this.address,
      labLogoUrl: labLogoUrl ?? this.labLogoUrl,
      registrationCertificateUrl: registrationCertificateUrl ?? this.registrationCertificateUrl,
      bankPassbookUrl: bankPassbookUrl ?? this.bankPassbookUrl,
      emergencyContactNumber: emergencyContactNumber ?? this.emergencyContactNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      termsConditionsAccepted: termsConditionsAccepted ?? this.termsConditionsAccepted,
      privacyPolicyAccepted: privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      status: status ?? this.status,
    );
  }
}
