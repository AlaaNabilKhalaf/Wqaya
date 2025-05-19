// lib/Features/Complaints/Presentation/Views/view_model/models.dart

class Complaint {
  final int id;
  final String type;
  final int medicalHistoryId;
  final String reason;
  final String location;
  final String duration;
  final String severity;
  final List<String> medicines;
  final String notes;
  final String howAffects; // Added to maintain compatibility with UI

  const Complaint({
    required this.id,
    required this.type,
    required this.medicalHistoryId,
    required this.reason,
    required this.location,
    required this.duration,
    required this.severity,
    required this.medicines,
    required this.notes,
    this.howAffects = '', // Default value as it's not in the API response
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    List<String> medicinesList = [];

    if (json['addedmedicines'] != null && json['addedmedicines'].toString().isNotEmpty) {
      // Split by comma if it's a comma-separated string
      if (json['addedmedicines'] is String) {
        medicinesList = json['addedmedicines'].toString().split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return Complaint(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      medicalHistoryId: json['medicalHistoryId'] ?? 0,
      reason: json['reason'] ?? '',
      location: json['location'] ?? '',
      duration: json['duration'] ?? '',
      severity: json['severity'] ?? '',
      medicines: medicinesList,
      notes: json['notes'] ?? '',
      howAffects: json['howAffects'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'medicalHistoryId': medicalHistoryId,
      'reason': reason,
      'location': location,
      'duration': duration,
      'severity': severity,
      'addedmedicines': medicines.join(', '),
      'notes': notes,
    };
  }
}

// Enum translations
class EnumTranslations {
  static String getDurationUnitArabic(String durationUnit) {
    switch (durationUnit) {
      case 'Hours':
        return 'ساعات';
      case 'Days':
        return 'أيام';
      case 'Weeks':
        return 'أسابيع';
      case 'Months':
        return 'شهور';
      case 'Years':
        return 'سنوات';
      default:
        return 'غير محدد';
    }
  }

  static String getComplaintTypeArabic(String complaintType) {
    switch (complaintType) {
      case 'Active':
        return 'حالية';
      case 'Inactive':
        return 'قديمة';
      default:
        return 'غير محدد';
    }
  }

  static String getSeverityLevelArabic(String severityLevel) {
    switch (severityLevel) {
      case 'Trivial':
        return 'خفيف جداً';
      case 'Low':
        return 'خفيف';
      case 'Moderate':
        return 'متوسط الشدة';
      case 'Medium':
        return 'متوسط';
      case 'Significant':
        return 'ملحوظ';
      case 'High':
        return 'شديد';
      case 'Severe':
        return 'حاد';
      case 'Critical':
        return 'خطير';
      case 'Blocker':
        return 'معيق';
      case 'Fatal':
        return 'قاتل';
      default:
        return 'غير محدد';
    }
  }

  static List<Map<String, String>> getAllComplaintTypes() {
    return [
      {'value': 'Active', 'label': 'نشط'},
      {'value': 'Inactive', 'label': 'غير نشط'},
      {'value': 'DayToWeek', 'label': 'يوم إلى أسبوع'},
    ];
  }

  static List<Map<String, String>> getAllDurationUnits() {
    return [
      {'value': 'Hours', 'label': 'ساعات'},
      {'value': 'Days', 'label': 'أيام'},
      {'value': 'Weeks', 'label': 'أسابيع'},
      {'value': 'Months', 'label': 'شهور'},
      {'value': 'Years', 'label': 'سنوات'},
    ];
  }

  static List<Map<String, String>> getAllSeverityLevels() {
    return [
      {'value': 'Trivial', 'label': 'خفيف جداً'},
      {'value': 'Low', 'label': 'خفيف'},
      {'value': 'Moderate', 'label': 'متوسط الشدة'},
      {'value': 'Medium', 'label': 'متوسط'},
      {'value': 'Significant', 'label': 'ملحوظ'},
      {'value': 'High', 'label': 'شديد'},
      {'value': 'Severe', 'label': 'حاد'},
      {'value': 'Critical', 'label': 'خطير'},
      {'value': 'Blocker', 'label': 'معيق'},
      {'value': 'Fatal', 'label': 'قاتل'},
    ];
  }
}