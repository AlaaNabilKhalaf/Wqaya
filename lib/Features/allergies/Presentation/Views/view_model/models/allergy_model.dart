class AllergyModel {
  int? medicalHistoryId;
  int? id;
  String? allergenName;
  String? allergenType;
  String? severityLevel;
  String? reaction;
  DateTime? diagnosisDate;
  DateTime? lastOccurrence;
  String? addedmedicines;
  String? notes;
  String? source; // Added for consistency with MedicineModel

  AllergyModel({
    this.medicalHistoryId,
    this.allergenName,
    this.allergenType,
    this.severityLevel,
    this.reaction,
    this.diagnosisDate,
    this.lastOccurrence,
    this.addedmedicines,
    this.notes,
    this.source, this.id,
  });

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      medicalHistoryId: json['medicalHistoryId'],
      id: json['id'],
      allergenName: json['allergenName'],
      allergenType: json['allergenType'],
      severityLevel: json['severityLevel'],
      reaction: json['reaction'],
      diagnosisDate: json['diagnosisDate'] != null
          ? DateTime.parse(json['diagnosisDate'])
          : null,
      lastOccurrence: json['lastOccurrence'] != null
          ? DateTime.parse(json['lastOccurrence'])
          : null,
      addedmedicines: json['addedmedicines'],
      notes: json['notes'],
      source: json['source'] ?? "Added By User", // Default to user-added if not specified
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalHistoryId': medicalHistoryId ?? 0,
      'allergenName': allergenName,
      'allergenType': allergenType,
      'severityLevel': severityLevel,
      'reaction': reaction,
      'diagnosisDate': diagnosisDate?.toIso8601String(),
      'lastOccurrence': lastOccurrence?.toIso8601String(),
      'addedmedicines': addedmedicines,
      'notes': notes,
    };
  }
}

// Constants for translation
const Map<String, String> allergenTypeTranslations = {
  'Food': 'طعام',
  'Drug': 'دواء',
  'Environmental': 'بيئي',
  'Insect': 'حشرات',
  'Latex': 'لاتكس',
  'Other': 'أخرى',
};

const Map<String, String> severityLevelTranslations = {
  'Trivial': 'بسيط',
  'Mild': 'خفيف',
  'Moderate': 'متوسط',
  'Severe': 'شديد',
  'Fatal': 'خطير',
};
enum AllergyType {
  food,
  drug,
  environmental,
}

String getAllergyTypeInArabic(AllergyType type) {
  switch (type) {
    case AllergyType.food:
      return 'طعام';
    case AllergyType.drug:
      return 'دواء';
    case AllergyType.environmental:
      return 'بيئي';
    }
}