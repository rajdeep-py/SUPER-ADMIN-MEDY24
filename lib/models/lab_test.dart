import 'dart:convert';

class LabTest {
  final String coreTestId;
  final String testName;
  final String testCategory;
  final String sampleType;
  final String? description;
  final List<dynamic> parameters;
  final List<dynamic> precautions;
  final String? testPhotoUrl;

  LabTest({
    required this.coreTestId,
    required this.testName,
    required this.testCategory,
    required this.sampleType,
    this.description,
    required this.parameters,
    required this.precautions,
    this.testPhotoUrl,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      coreTestId: json['core_test_id'] ?? '',
      testName: json['test_name'] ?? '',
      testCategory: json['test_category'] ?? '',
      sampleType: json['sample_type'] ?? '',
      description: json['description'],
      parameters: json['parameters'] is String 
          ? jsonDecode(json['parameters']) 
          : (json['parameters'] ?? []),
      precautions: json['precautions'] is String 
          ? jsonDecode(json['precautions']) 
          : (json['precautions'] ?? []),
      testPhotoUrl: json['test_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'core_test_id': coreTestId,
      'test_name': testName,
      'test_category': testCategory,
      'sample_type': sampleType,
      'description': description,
      'parameters': parameters,
      'precautions': precautions,
      'test_photo_url': testPhotoUrl,
    };
  }
}
