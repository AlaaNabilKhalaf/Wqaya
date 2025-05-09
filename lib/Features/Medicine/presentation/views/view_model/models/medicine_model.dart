class MedicineModel {
  final int id;
  final String name;
  final String dosageForm;
  final int strength;
  final String unit;
  final String? status; // optional
  final String? source; // optional
  final String? medicineType; // optional

  MedicineModel({
    required this.id,
    required this.name,
    required this.dosageForm,
    required this.strength,
    required this.unit,
    this.status,
    this.source,
    this.medicineType,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      dosageForm: json['dosageForm'],
      strength: json['strength'],
      unit: json['unit'],
      status: json['status'], // might be missing
      source: json['source'], // might be missing
      medicineType: json['medicineType'] ?? json['medicinetype'], // handle both spellings
    );
  }
}
