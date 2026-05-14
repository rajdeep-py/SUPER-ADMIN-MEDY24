class TermsConditions {
  final String termId;
  final String termHeader;
  final String termDescription;

  TermsConditions({
    required this.termId,
    required this.termHeader,
    required this.termDescription,
  });

  factory TermsConditions.fromJson(Map<String, dynamic> json) {
    return TermsConditions(
      termId: json['term_id'] ?? '',
      termHeader: json['term_header'] ?? '',
      termDescription: json['term_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term_id': termId,
      'term_header': termHeader,
      'term_description': termDescription,
    };
  }
}
