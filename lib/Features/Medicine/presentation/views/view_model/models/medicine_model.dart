class MedicineModel {
  final int? id;
  final String name;
  final String? dosageForm;
  final int? strength;
  final String? unit;
  final String? status;
  final String? source;
  final String? medicineType;
  final String? frequency;
  final String? duration;

  MedicineModel({
    this.id,
    required this.name,
    this.dosageForm,
    this.strength,
    this.unit,
    this.status,
    this.source,
    this.medicineType,
    this.duration,
    this.frequency,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] is int ? json['id'] : null,
      name: json['name'] ?? 'Unknown Medicine',
      dosageForm: json['dosageForm'],
      strength: json['strength'] is int ? json['strength'] : null,
      unit: json['unit'],
      status: json['status'],
      source: json['source'],
      frequency: json['frequency'],
      duration: json['duration'],
      medicineType: json['medicineType'] ?? json['medicinetype'],
    );
  }
}