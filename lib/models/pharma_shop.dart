class PharmaShop {
  final String? shopId;
  final String? shopName;
  final String? shopAddress;
  final String? shopPhoto;
  final String? shopPhoneNo;
  final String? shopAlternativePhoneNo;
  final String? shopEmail;
  final String? shopPassword;
  final String? whatsappNumber;
  final String? gstinNo;
  final String? drugLicenseUpload;
  final String? panCardUpload;
  final String? bankPassbookUpload;
  final String? registrationCertificateUpload;
  final String? status;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PharmaShop({
    this.shopId,
    this.shopName,
    this.shopAddress,
    this.shopPhoto,
    this.shopPhoneNo,
    this.shopAlternativePhoneNo,
    this.shopEmail,
    this.shopPassword,
    this.whatsappNumber,
    this.gstinNo,
    this.drugLicenseUpload,
    this.panCardUpload,
    this.bankPassbookUpload,
    this.registrationCertificateUpload,
    this.status,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PharmaShop.fromJson(Map<String, dynamic> json) {
    return PharmaShop(
      shopId: json['shop_id'],
      shopName: json['shop_name'],
      shopAddress: json['shop_address'],
      shopPhoto: json['shop_photo'],
      shopPhoneNo: json['shop_phone_no'],
      shopAlternativePhoneNo: json['shop_alternative_phone_no'],
      shopEmail: json['shop_email'],
      shopPassword: json['shop_password'],
      whatsappNumber: json['whatsapp_number'],
      gstinNo: json['gstin_no'],
      drugLicenseUpload: json['drug_license_upload'],
      panCardUpload: json['pan_card_upload'],
      bankPassbookUpload: json['bank_passbook_upload'],
      registrationCertificateUpload: json['registration_certificate_upload'],
      status: json['status'],
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_photo': shopPhoto,
      'shop_phone_no': shopPhoneNo,
      'shop_alternative_phone_no': shopAlternativePhoneNo,
      'shop_email': shopEmail,
      'shop_password': shopPassword,
      'whatsapp_number': whatsappNumber,
      'gstin_no': gstinNo,
      'drug_license_upload': drugLicenseUpload,
      'pan_card_upload': panCardUpload,
      'bank_passbook_upload': bankPassbookUpload,
      'registration_certificate_upload': registrationCertificateUpload,
      'status': status,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PharmaShop copyWith({
    String? shopId,
    String? shopName,
    String? shopAddress,
    String? shopPhoto,
    String? shopPhoneNo,
    String? shopAlternativePhoneNo,
    String? shopEmail,
    String? shopPassword,
    String? whatsappNumber,
    String? gstinNo,
    String? drugLicenseUpload,
    String? panCardUpload,
    String? bankPassbookUpload,
    String? registrationCertificateUpload,
    String? status,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PharmaShop(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      shopPhoto: shopPhoto ?? this.shopPhoto,
      shopPhoneNo: shopPhoneNo ?? this.shopPhoneNo,
      shopAlternativePhoneNo: shopAlternativePhoneNo ?? this.shopAlternativePhoneNo,
      shopEmail: shopEmail ?? this.shopEmail,
      shopPassword: shopPassword ?? this.shopPassword,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      gstinNo: gstinNo ?? this.gstinNo,
      drugLicenseUpload: drugLicenseUpload ?? this.drugLicenseUpload,
      panCardUpload: panCardUpload ?? this.panCardUpload,
      bankPassbookUpload: bankPassbookUpload ?? this.bankPassbookUpload,
      registrationCertificateUpload: registrationCertificateUpload ?? this.registrationCertificateUpload,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
