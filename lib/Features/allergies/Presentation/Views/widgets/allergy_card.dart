import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/edit_allergy_view.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/allergy_cubit.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/models/allergy_model.dart';


class AllergyCard extends StatefulWidget {
  final AllergyModel allergy;
  final bool canBeChosen;
  final bool isEditing;

  const AllergyCard({
    super.key,
    required this.allergy,
    required this.canBeChosen,
    this.isEditing = false,
  });

  @override
  State<AllergyCard> createState() => _AllergyCardState();
}

class _AllergyCardState extends State<AllergyCard> {
  bool isSelected = false;

  String getTranslatedAllergenType(String? englishValue) {
    if (englishValue == null) return '';
    return allergenTypeTranslations[englishValue] ?? englishValue;
  }

  String getTranslatedSeverityLevel(String? englishValue) {
    if (englishValue == null) return '';
    return severityLevelTranslations[englishValue] ?? englishValue;
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void showOptionsMenu(BuildContext context) {
    var allergyCubit = context.read<AllergyCubit>();
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
                    SizedBox(width: 10),
                    Text('تعديل', style: TextStyle(fontFamily: regular)),
                  ],
                ),
                onTap: () {
                  if (!widget.isEditing) {
                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditAllergyView(allergy: widget.allergy),));
                  }
                },
              ),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: errorColor),
                    SizedBox(width: 10),
                    Text('حذف', style: TextStyle(fontFamily: regular)),
                  ],
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await allergyCubit.deleteAllergy(allergyId: widget.allergy.id!);
                  await allergyCubit.getUserAllergies();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var allergyCubit = context.watch<AllergyCubit>();
    isSelected = allergyCubit.tempSelectedIds.contains(widget.allergy.medicalHistoryId);

    return InkWell(
      onTap: widget.canBeChosen
          ? () {
        allergyCubit.toggleAllergySelection(widget.allergy.medicalHistoryId!);
        allergyCubit.toggleAllergySelectionByName(widget.allergy.allergenName ?? '');
      }
          : null,
      onLongPress: widget.canBeChosen ? null : () => showOptionsMenu(context),
      child: Card(
        color: isSelected ? primaryColor : Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: buildCardContent(isSelected: isSelected),
        ),
      ),
    );
  }

  Widget buildCardContent({required bool isSelected}) {
    final translatedAllergenType = getTranslatedAllergenType(widget.allergy.allergenType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.allergy.allergenName ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: black,
                  color: isSelected ? Colors.white : const Color(0xff1678F2),
                ),
              ),
            ),
            _buildSeverityLevelChip(),
          ],
        ),
        const SizedBox(height: 8),

        Text(
          "نوع الحساسية: $translatedAllergenType",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        Text(
          "رد الفعل: ${widget.allergy.reaction ?? ''}",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        if (widget.allergy.diagnosisDate != null)
          Text(
            "تاريخ التشخيص: ${formatDate(widget.allergy.diagnosisDate)}",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontFamily: semiBold,
            ),
          ),
        if (widget.allergy.lastOccurrence != null)
          Text(
            "آخر ظهور: ${formatDate(widget.allergy.lastOccurrence)}",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontFamily: semiBold,
            ),
          ),
        if (widget.allergy.addedmedicines != null && widget.allergy.addedmedicines!.isNotEmpty)
          Text(
            "الأدوية المضافة: ${widget.allergy.addedmedicines}",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontFamily: semiBold,
            ),
          ),
        if (widget.allergy.notes != null && widget.allergy.notes!.isNotEmpty)
          Text(
            "ملاحظات: ${widget.allergy.notes}",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontFamily: semiBold,
            ),
          ),
      ],
    );
  }

  Widget _buildSeverityLevelChip() {
    final translatedSeverity = getTranslatedSeverityLevel(widget.allergy.severityLevel);
    return translatedSeverity == ""
        ? const SizedBox.shrink()
        : Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getSeverityColor(widget.allergy.severityLevel).withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        translatedSeverity,
        style: TextStyle(
          color: _getSeverityColor(widget.allergy.severityLevel),
          fontSize: 12,
          fontFamily: semiBold,
        ),
      ),
    );
  }

  Color _getSeverityColor(String? severityLevel) {
    if (severityLevel == null) return const Color(0xff1678F2);

    switch (severityLevel) {
      case 'Trivial':
        return Colors.green;
      case 'Low':
        return Colors.blue;
      case 'Moderate':
        return Colors.orange;
      case 'Severe':
        return Colors.deepOrange;
      case 'Fatal':
        return Colors.red;
      default:
        return const Color(0xff1678F2);
    }
  }
}