// symptom_model.dart

class Symptom {
  final int id;
  final String name;

  Symptom({required this.id, required this.name});

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['symptomId'],
      name: json['name'],
    );
  }
}

class SymptomCategory {
  final int id;
  final String name;
  final List<Symptom> symptoms;

  SymptomCategory(
      {required this.id, required this.name, required this.symptoms});

  factory SymptomCategory.fromJson(Map<String, dynamic> json) {
    final symptoms = (json['symptoms'] as List)
        .map((s) => Symptom.fromJson(s))
        .toList();

    return SymptomCategory(
      id: json['symptomCategoryId'],
      name: json['categoryName'],
      symptoms: symptoms,
    );
  }
}
class ChronicDiseaseModel {
  final int id;
  final String name;

  ChronicDiseaseModel({required this.id, required this.name});

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
class SymptomSubmissionResponse {
  final bool succeeded;
  final String message;
  final List<dynamic> data;

  SymptomSubmissionResponse({
    required this.succeeded,
    required this.message,
    required this.data,
  });

  factory SymptomSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return SymptomSubmissionResponse(
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? [],
    );
  }
}
