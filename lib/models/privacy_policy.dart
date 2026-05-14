class PrivacyPolicy {
  final String privacyId;
  final String privacyHeader;
  final String privacyDescription;

  PrivacyPolicy({
    required this.privacyId,
    required this.privacyHeader,
    required this.privacyDescription,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      privacyId: json['privacy_id'] ?? '',
      privacyHeader: json['privacy_header'] ?? '',
      privacyDescription: json['privacy_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacy_id': privacyId,
      'privacy_header': privacyHeader,
      'privacy_description': privacyDescription,
    };
  }
}
