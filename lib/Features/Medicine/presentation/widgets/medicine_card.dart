import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/edit_medicine_view.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

// Medicine Type Translations
const Map<String, String> medicineTypeTranslations = {
  'Antibiotic': 'مضاد حيوي',
  'Analgesic': 'مسكن للألم',
  'Antipyretic': 'خافض للحرارة',
  'Antiseptic': 'مطهر',
  'Antihistamine': 'مضاد للهيستامين',
  'Antacid': 'مضاد للحموضة',
  'Antidepressant': 'مضاد للاكتئاب',
  'Antiviral': 'مضاد للفيروسات',
  'Antifungal': 'مضاد للفطريات',
  'Antidiabetic': 'مضاد للسكري',
  'Antihypertensive': 'خافض ضغط الدم',
  'Anticoagulant': 'مضاد للتخثر',
  'Bronchodilator': 'موسع للشعب الهوائية',
  'Sedative': 'مهدئ',
  'Hormone': 'هرمون',
  'Vaccine': 'لقاح',
};

// Unit Translations
const Map<String, String> unitTranslations = {
  'Mg': 'ملغ',
  'Ml': 'مل',
  'G': 'غم',
  'L': 'لتر',
  'Mcg': 'ميكروغرام',
  'IU': 'وحدة دولية',
};

// Dosage Form Translations
const Map<String, String> dosageFormTranslations = {
  'Tablet': 'أقراص',
  'Capsule': 'كبسولات',
  'Liquid': 'سائل',
  'Syrup': 'شراب',
  'Injection': 'حقن',
  'Cream': 'كريم',
  'Ointment': 'مرهم',
  'Drops': 'قطرات',
  'Inhaler': 'بخاخ',
  'Patch': 'لاصقة',
};

class MedicineCard extends StatefulWidget {
  final MedicineModel medicine;
  final bool canBeChosen;
  final bool isEditing;
  const MedicineCard({
    super.key,
    required this.medicine,
    required this.canBeChosen,
    this.isEditing = false,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool isSelected = false;

  String getTranslatedDosageForm(String? englishValue) {
    if (englishValue == null) return '';
    return dosageFormTranslations[englishValue] ?? englishValue;
  }

  String getTranslatedUnit(String? englishValue) {
    if (englishValue == null) return '';
    return unitTranslations[englishValue] ?? englishValue;
  }

  String getTranslatedMedicineType(String? englishValue) {
    if (englishValue == null) return '';
    return medicineTypeTranslations[englishValue] ?? englishValue;
  }

  void showOptionsMenu(BuildContext context) {
    var mCubit = context.read<MedicineCubit>();
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
              widget.medicine.source == "Added By User"
                  ? ListTile(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditUserMedicineView(medicineModel: widget.medicine),
                      ),
                    );
                  }
                },
              )
                  : const SizedBox.shrink(),
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
                  if (widget.medicine.source == "Added By System") {
                    await mCubit.deleteMedicineAddedBySystem(medicineId: widget.medicine.id!);
                    await mCubit.getUserMedicine();
                  } else if (widget.medicine.source == "Added By User") {
                    await mCubit.deleteMedicineAddedByUser(medicineId: widget.medicine.id!);
                    await mCubit.getUserMedicine();
                  }
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
    var mCubit = context.watch<MedicineCubit>();
    isSelected = mCubit.tempSelectedIds.contains(widget.medicine.id);

    return InkWell(
      onTap: widget.canBeChosen
          ? () {
        mCubit.toggleMedicineSelection(widget.medicine.id!);
        mCubit.toggleMedicineSelectionByName(widget.medicine.name);
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
    final translatedDosageForm = getTranslatedDosageForm(widget.medicine.dosageForm);
    final translatedUnit = getTranslatedUnit(widget.medicine.unit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.medicine.name ,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: black,
                  color: isSelected ? Colors.white : const Color(0xff1678F2),
                ),
              ),
            ),
            _buildMedicineTypeChip(),
          ],
        ),
        const SizedBox(height: 8),

        Text(
          "شكل الجرعة: $translatedDosageForm",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        Text(
          "التركيز: ${widget.medicine.strength ?? ''} $translatedUnit",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        Text(
          widget.medicine.source == "Added By System"
              ? "المصدر: تم اضافته بواسطتنا"
              : "المصدر: تم اضافته بواسطتك",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        if (widget.medicine.duration != null)
          Text(
            "المدة: ${widget.medicine.duration.toString()} $translatedUnit",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontFamily: semiBold,
            ),
          ),
      ],
    );
  }

  Widget _buildMedicineTypeChip() {
    final translatedType = getTranslatedMedicineType(widget.medicine.medicineType);
    return translatedType.toString() == "" ?
        const SizedBox.shrink():
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff1678F2).withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        translatedType,
        style: const TextStyle(
          color: Color(0xff1678F2),
          fontSize: 12,
          fontFamily: semiBold,
        ),
      ),
    );
  }
}
