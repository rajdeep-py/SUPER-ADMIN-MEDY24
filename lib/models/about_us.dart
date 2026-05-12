class AboutUs {
  final int? id;
  final String companyName;
  final String? companyPhoto;
  final String? companyTagline;
  final String? companyDescriptionText;
  final String? mission;
  final String? vision;
  final String? directorName;
  final String? directorMessage;
  final String? directorPhoto;
  final List<Partner>? partners;
  final String? officeAddress;
  final String? registeredAddress;
  final String? email1;
  final String? email2;
  final String? phone1;
  final String? phone2;
  final String? website;

  AboutUs({
    this.id,
    required this.companyName,
    this.companyPhoto,
    this.companyTagline,
    this.companyDescriptionText,
    this.mission,
    this.vision,
    this.directorName,
    this.directorMessage,
    this.directorPhoto,
    this.partners,
    this.officeAddress,
    this.registeredAddress,
    this.email1,
    this.email2,
    this.phone1,
    this.phone2,
    this.website,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      id: json['id'],
      companyName: json['company_name'] ?? '',
      companyPhoto: json['company_photo'],
      companyTagline: json['company_tagline'],
      companyDescriptionText: json['company_description_text'],
      mission: json['mission'],
      vision: json['vision'],
      directorName: json['director_name'],
      directorMessage: json['director_message'],
      directorPhoto: json['director_photo'],
      partners: json['partners'] != null
          ? (json['partners'] as List).map((p) => Partner.fromJson(p)).toList()
          : null,
      officeAddress: json['office_address'],
      registeredAddress: json['registered_address'],
      email1: json['email1'],
      email2: json['email2'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'company_photo': companyPhoto,
      'company_tagline': companyTagline,
      'company_description_text': companyDescriptionText,
      'mission': mission,
      'vision': vision,
      'director_name': directorName,
      'director_message': directorMessage,
      'director_photo': directorPhoto,
      'partners': partners?.map((p) => p.toJson()).toList(),
      'office_address': officeAddress,
      'registered_address': registeredAddress,
      'email1': email1,
      'email2': email2,
      'phone1': phone1,
      'phone2': phone2,
      'website': website,
    };
  }
}

class Partner {
  final String name;
  final String? logo;
  final String? website;

  Partner({required this.name, this.logo, this.website});

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      name: json['name'] ?? '',
      logo: json['logo'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'logo': logo, 'website': website};
  }
}
