class MedicineModel {
  final int id;
  final String name;
  final String dosageForm;
  final int strength;
  final String unit;
  final String status;

  MedicineModel({
    required this.id,
    required this.name,
    required this.dosageForm,
    required this.strength,
    required this.unit,
    required this.status,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      dosageForm: json['dosageForm'],
      strength: json['strength'],
      unit: json['unit'],
      status: json['status'],
    );
  }
}
