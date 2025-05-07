import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/surgries/presentation/views/edit_surgeries_view.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';

class SurgeryCard extends StatelessWidget {
  final Surgery surgery;

  const SurgeryCard({
    super.key,
    required this.surgery,
  });
  String _getArabicOutcome(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'successful':
        return 'ناجحة';
      case 'stable':
        return 'مستقرة';
      case 'complications':
        return 'مع مضاعفات';
      case 'failed':
        return 'فشلت';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    var sCubit = context.read<SurgeryCubit>();
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditSurgeriesView(surgery: surgery,),));
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
                     await sCubit.deleteUserSurgery(surgery.id);
                      await sCubit.getUserSurgeries();

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
                      surgery.surgeryName,
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
                      color: _getStatusColor(surgery.surgeryOutcome),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getArabicOutcome(surgery.surgeryOutcome),
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
                    'التاريخ:',
                    DateFormat('yyyy/MM/dd').format(surgery.surgeryDate),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('سبب الجراحة:', surgery.surgeryReason),
                  if (surgery.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('ملاحظات:', surgery.notes),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'stable':
        return Colors.deepOrange;
      default:
        return Colors.purple;
    }
  }
}