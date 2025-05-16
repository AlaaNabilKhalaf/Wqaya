import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/edit_medicine_view.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

// Medicine Type Translations
const Map<String, String> medicineTypeTranslations = {
  // Backend enum values -> Arabic translations
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
  // Backend enum values -> Arabic translations
  'Mg': 'ملغ', // Milligram
  'Ml': 'مل', // Milliliter
  'G': 'غم', // Gram
  'L': 'لتر', // Liter
  'Mcg': 'ميكروغرام', // Microgram
  'IU': 'وحدة دولية', // International Units
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
  const MedicineCard({
    super.key,
    required this.medicine,
    required this.canBeChosen,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool isSelected = false;

  // Helper methods to translate values
  String getTranslatedDosageForm(String englishValue) {
    return dosageFormTranslations[englishValue] ?? englishValue;
  }

  String getTranslatedUnit(String englishValue) {
    return unitTranslations[englishValue] ?? englishValue;
  }

  String getTranslatedMedicineType(String englishValue) {
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
              widget.medicine.source=="Added By User" ?
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserMedicineView(medicineModel: widget.medicine),));
                },
              ) :const SizedBox.shrink(),
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
                  if (widget.medicine.source=="Added By System"){
                    await mCubit.deleteMedicineAddedBySystem(medicineId: widget.medicine.id);
                    await mCubit.getUserMedicine();
                  } else if (widget.medicine.source=="Added By User"){
                    await mCubit.deleteMedicineAddedByUser(medicineId: widget.medicine.id);
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
    // Check if this medicine is already in the selectedIds set
    isSelected = mCubit.selectedIds.contains(widget.medicine.id);

    if (widget.canBeChosen) {
      // Selectable card
      return InkWell(
        onTap: () {
          mCubit.toggleMedicineSelection(widget.medicine.id);
          mCubit.toggleMedicineSelectionByName(widget.medicine.name);
        },
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
    } else {
      // Non-selectable card with long press option
      return InkWell(
        onLongPress: () => showOptionsMenu(context),
        child: Card(
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: buildCardContent(isSelected: false),
          ),
        ),
      );
    }
  }
  Widget buildNormalCard() {
    return InkWell(
      onLongPress: () => showOptionsMenu(context),
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: buildCardContent(isSelected: false),
        ),
      ),
    );
  }

  Widget buildSelectedCard() {
    return Card(
      color: primaryColor,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: buildCardContent(isSelected: true),
      ),
    );
  }

  Widget buildCardContent({required bool isSelected}) {
    // Translate values
    final translatedDosageForm = getTranslatedDosageForm(widget.medicine.dosageForm);
    final translatedUnit = getTranslatedUnit(widget.medicine.unit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicine name + type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.medicine.name,
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
        // Dosage form (translated)
        Text(
          "شكل الجرعة: $translatedDosageForm",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        // Strength + Unit (translated)
        Text(
          "التركيز: ${widget.medicine.strength} $translatedUnit",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        widget.medicine.source=="Added By System"?
        Text(
          "المصدر: تم اضافته بواسطتنا",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ): Text(
          "المصدر: تم اضافته بواسطتك",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        if (widget.medicine.duration.toString()!="null")
        Text(
          "المدة: ${widget.medicine.duration.toString()} $translatedUnit",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),
        if (widget.medicine.frequency.toString()!="null")
          Text(
            "التكرار: ${widget.medicine.frequency.toString()} $translatedUnit",
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
    // Use the medicine type for the chip, not dosage form
    String? medicineType = widget.medicine.medicineType;
    String translatedType = getTranslatedMedicineType(medicineType!);

    // Determine chip color based on medicine type
    Color chipColor;

    switch (medicineType) {
      case "Antibiotic":
        chipColor = Colors.green;
        break;
      case "Antihypertensive":
        chipColor = Colors.red;
        break;
      case "Antihistamine":
        chipColor = Colors.purple;
        break;
      case "Antidepressant":
        chipColor = Colors.indigo;
        break;
      case "Analgesic":
        chipColor = Colors.orange;
        break;
      case "Antipyretic":
        chipColor = Colors.amber;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: .5)),
      ),
      child: Text(
        translatedType,
        style: TextStyle(
            fontSize: 12,
            color: chipColor,
            fontFamily: black
        ),
      ),
    );
  }
}