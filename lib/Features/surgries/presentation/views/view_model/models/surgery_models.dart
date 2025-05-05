// lib/Features/Surgery/data/models/surgery_model.dart

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:wqaya/Core/cache/cache_helper.dart';

class Surgery {
  final int id;
  final String surgeryName;
  final String surgeryReason;
  final DateTime surgeryDate;
  final String surgeryOutcome;
  final String notes;
  final int medicalHistoryId;

  Surgery({
    required this.id,
    required this.surgeryName,
    required this.surgeryReason,
    required this.surgeryDate,
    required this.surgeryOutcome,
    required this.notes,
    required this.medicalHistoryId,
  });

  factory Surgery.fromJson(Map<String, dynamic> json) {
    return Surgery(
      id: json['id'],
      surgeryName: json['surgeryName'],
      surgeryReason: json['surgeryreaseon'],
      surgeryDate: DateTime.parse(json['surgeryDate']),
      surgeryOutcome: json['surgeryoutcome'],
      notes: json['notes'],
      medicalHistoryId: json['medicalHistoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surgeryname': surgeryName,
      'surgeryreaseon': surgeryReason,
      'surgeryDate': surgeryDate.toIso8601String(),
      'surgeryoutcome': surgeryOutcome,
      'notes': notes,
      'medicalHistoryId': medicalHistoryId,
    };
  }
}
class AddSurgery {
  final String surgeryName;
  final String surgeryReason;
  final String surgeryDate;
  final String surgeryOutcome;
  final String notes;
  final int medicalHistoryId;

  AddSurgery({
    required this.surgeryName,
    required this.surgeryReason,
    required this.surgeryDate,
    required this.surgeryOutcome,
    required this.notes,
    required this.medicalHistoryId,
  });

  factory AddSurgery.fromJson(Map<String, dynamic> json) {
    return AddSurgery(
      surgeryName: json['surgeryname'],
      surgeryReason: json['surgeryreaseon'],
      surgeryDate: DateTime.parse(json['surgeryDate']).toString(),
      surgeryOutcome: json['surgeryoutcome'],
      notes: json['notes'],
      medicalHistoryId: json['medicalHistoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surgeryname': surgeryName,
      'surgeryreaseon': surgeryReason,
      'surgeryDate': surgeryDate,
      'surgeryoutcome': surgeryOutcome,
      'notes': notes,
      'medicalHistoryId': medicalHistoryId,
    };
  }
}

class SurgeryRepository {
  final baseUrl = 'https://wqaya.runasp.net/api/Surgery';

  Future<List<Surgery>> getUserSurgeries() async {
    try {

      if (CacheHelper().getData(key: 'token') == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse("https://wqaya.runasp.net/api/Surgery/GetByMhId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['succeeded'] == true) {
          final List<dynamic> surgeryJsonList = jsonResponse['data'];
          return surgeryJsonList.map((json) => Surgery.fromJson(json)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load surgeries');
        }
      } else {
        throw Exception('Failed to load surgeries: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surgeries: $e');
    }
  }

  Future<bool> addUserSurgery(AddSurgery surgery) async {
    try {

      if (CacheHelper().getData(key: 'token') == null) {
        throw Exception('Authentication token not found');
      }
      print(surgery);
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
        },
        body: json.encode(surgery.toJson()),
      );
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['succeeded'] == true) {
          return true;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to add surgery');
        }
      } else {
        throw Exception('Failed to add surgery: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add surgery: $e');
    }
  }

  Future<bool> editUserSurgery(Surgery surgery) async {
    try {
      if (CacheHelper().getData(key: 'token') == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
        },
        body: json.encode(surgery.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['succeeded'] == true) {
          return true;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to update surgery');
        }
      } else {
        throw Exception('Failed to update surgery: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update surgery: $e');
    }
  }

  Future<bool> deleteUserSurgery(int surgeryId) async {
    try {
      if (CacheHelper().getData(key: 'token') == null) {
        throw Exception('Authentication token not found');
      }
      print(surgeryId);
      print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      final response = await http.delete(
        Uri.parse('$baseUrl/$surgeryId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['succeeded'] == true) {
          return true;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to delete surgery');
        }
      } else {
        throw Exception('Failed to delete surgery: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete surgery: $e');
    }
  }
}