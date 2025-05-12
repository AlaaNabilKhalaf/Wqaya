import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class AnalysisRecord extends Equatable {
  final int id;
  final String testName;
  final String labName;
  final DateTime date;
  final String? resultSummary;
  final String reportUrl;
  final String? resultStatus;
  final int medicalHistoryId;

  const AnalysisRecord({
    required this.id,
    required this.testName,
    required this.labName,
    required this.date,
    this.resultSummary,
    required this.reportUrl,
    this.resultStatus,
    required this.medicalHistoryId,
  });

  factory AnalysisRecord.fromJson(Map<String, dynamic> json) {
    return AnalysisRecord(
      id: json['id'],
      testName: json['testName'],
      labName: json['labName'],
      date: DateTime.parse(json['date']),
      resultSummary: json['resultSummary'],
      reportUrl: json['reportUrl'],
      resultStatus: json['resultStatus'],
      medicalHistoryId: json['medicalHistoryId'],
    );
  }

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);

  @override
  List<Object?> get props => [
    id,
    testName,
    labName,
    date,
    resultSummary,
    reportUrl,
    resultStatus,
    medicalHistoryId
  ];
}