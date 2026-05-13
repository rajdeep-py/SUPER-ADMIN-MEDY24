import 'dart:convert';

class Medicine {
  final String medicineId;
  final String medicineName;
  final String medicineCategory;
  final String medicineQuantity;
  final double mrp;
  final String? medicineDescription;
  final String? medicineComposition;
  final List<dynamic> precautions;
  final String? medicinePhoto;

  Medicine({
    required this.medicineId,
    required this.medicineName,
    required this.medicineCategory,
    required this.medicineQuantity,
    required this.mrp,
    this.medicineDescription,
    this.medicineComposition,
    required this.precautions,
    this.medicinePhoto,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineId: json['medicine_id'] ?? '',
      medicineName: json['medicine_name'] ?? '',
      medicineCategory: json['medicine_category'] ?? '',
      medicineQuantity: json['medicine_quantity'] ?? '',
      mrp: json['mrp'] is int ? (json['mrp'] as int).toDouble() : (json['mrp'] ?? 0.0),
      medicineDescription: json['medicine_description'],
      medicineComposition: json['medicine_composition'],
      precautions: json['precautions'] is String 
          ? jsonDecode(json['precautions']) 
          : (json['precautions'] ?? []),
      medicinePhoto: json['medicine_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'medicine_name': medicineName,
      'medicine_category': medicineCategory,
      'medicine_quantity': medicineQuantity,
      'mrp': mrp,
      'medicine_description': medicineDescription,
      'medicine_composition': medicineComposition,
      'precautions': precautions,
      'medicine_photo': medicinePhoto,
    };
  }
}
