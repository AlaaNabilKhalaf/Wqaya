import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_cubit.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/models.dart';


class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard({
    super.key,
    required this.complaint,
  });

  String _getArabicType(String type) {
    switch (type.toLowerCase()) {
      case 'active':
        return 'حالية';
      case 'inactive':
        return 'قديمة';

      default:
        return 'غير معروف';
    }
  }

  String _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'trivial':
        return 'تافه'; // أقل من منخفض
      case 'low':
        return 'منخفض';
      case 'moderate':
        return 'متوسط'; // بين متوسط ومنخفض
      case 'medium':
        return 'متوسط'; // احتفظ بها كما هي
      case 'significant':
        return 'هام'; // بين متوسط وعالي
      case 'high':
        return 'مرتفع';
      case 'severe':
        return 'شديد'; // أعلى من مرتفع
      case 'critical':
        return 'حرج';
      case 'blocker':
        return 'حاجز'; // يمنع التقدم
      case 'fatal':
        return 'مميت'; // يؤدي لانهيار تام
      default:
        return 'غير معروف';
    }
  }
  @override
  Widget build(BuildContext context) {
    var complaintCubit = context.read<ComplaintsCubit>();
    void showOptionsMenu() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: primaryColor),
                      SizedBox(
                        width: 10,
                      ),
                      Text('تعديل', style: TextStyle(fontFamily: regular)),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditComplaintView(complaint: complaint),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: errorColor),
                      SizedBox(
                        width: 10,
                      ),
                      Text('حذف', style: TextStyle(fontFamily: regular)),
                    ],
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await complaintCubit.deleteUserComplaint(complaint.id);
                    await complaintCubit.getUserComplaints();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onLongPress: () => showOptionsMenu(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.reason,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getTypeColor(complaint.type),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getArabicType(complaint.type),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: regular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    'الموقع:',
                    complaint.location,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('المدة:', EnumTranslations.getDurationUnitArabic(complaint.duration)),
                  const SizedBox(height: 8),
                  _buildSeverityRow('الحدة:', complaint.severity),
                  const SizedBox(height: 8),
                  if (complaint.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('ملاحظات:', complaint.notes),
                  ],
                  if (complaint.medicines.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'الأدوية:',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontFamily: medium,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMedicinesList(complaint.medicines),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontFamily: medium,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontFamily: regular,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityRow(String label, String severity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontFamily: medium,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getSeverityBgColor(severity),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _getSeverityColor(severity),
            style: TextStyle(
              color: _getSeverityTextColor(severity),
              fontFamily: medium,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesList(List<String> medicines) {
    // Split each medicine string by dash and flatten the list
    final allMedicines = medicines
        .expand((medicine) => medicine.split('-').map((e) => e.trim()))
        .where((element) => element.isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: allMedicines
            .map((medicine) => _buildMedicineChip(medicine))
            .toList(),
      ),
    );
  }
  Widget _buildMedicineChip(String medicine) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: .3)),
      ),
      child: Text(
        medicine,
        style: const TextStyle(
          color: primaryColor,
          fontFamily: regular,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'active':
        return Colors.blue;
      case 'inactive':
        return Colors.grey;
      case 'chronic':
        return Colors.purple;
      case 'acute':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  Color _getSeverityBgColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'trivial':
      case 'low':
        return Colors.green.withValues(alpha: .15);
      case 'moderate':
      case 'medium':
        return Colors.orange.withValues(alpha: .15);
      case 'significant':
      case 'high':
        return Colors.deepOrange.withValues(alpha: .15);
      case 'severe':
        return Colors.red.withValues(alpha: .15);
      case 'critical':
      case 'blocker':
        return Colors.purple.withValues(alpha: .15);
      case 'fatal':
        return Colors.black.withValues(alpha: .15);
      default:
        return Colors.grey.withValues(alpha: .15);
    }
  }
  Color _getSeverityTextColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'trivial':
      case 'low':
        return Colors.green.shade800;
      case 'moderate':
      case 'medium':
        return Colors.orange.shade800;
      case 'significant':
      case 'high':
        return Colors.deepOrange.shade800;
      case 'severe':
        return Colors.red.shade800;
      case 'critical':
      case 'blocker':
        return Colors.purple.shade800;
      case 'fatal':
        return Colors.black;
      default:
        return Colors.grey.shade800;
    }
  }
}