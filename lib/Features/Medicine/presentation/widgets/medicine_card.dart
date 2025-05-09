import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

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

  @override
  Widget build(BuildContext context) {
    var mCubit = context.watch<MedicineCubit>();

    // Check if this medicine is already in the selectedIds set
    isSelected = mCubit.selectedIds.contains(widget.medicine.id);

    if (widget.canBeChosen == false) {
      return buildNormalCard();
    } else {
      return InkWell(
        onTap: () {
          // Toggle the selection status using the cubit method directly
          mCubit.toggleMedicineSelection(widget.medicine.id);
        },
        child: isSelected ? buildSelectedCard() : buildNormalCard(),
      );
    }
  }

  Widget buildNormalCard() {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: buildCardContent(isSelected: false),
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

        // Dosage form
        Text(
          "شكل الجرعة: ${widget.medicine.dosageForm}",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: semiBold,
          ),
        ),

        // Strength + Unit
        Text(
          "التركيز: ${widget.medicine.strength} ${widget.medicine.unit}",
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
    Color chipColor;
    String label;

    switch (widget.medicine.dosageForm.toLowerCase()) {
      case "antibiotic":
        chipColor = Colors.green;
        label = 'مضاد حيوي';
        break;
      case "blood pressure":
      case "bp":
        chipColor = Colors.red;
        label = 'دواء ضغط';
        break;
      case "supplement":
        chipColor = Colors.orange;
        label = 'مكمل غذائي';
        break;
      case "steroid":
        chipColor = Colors.purple;
        label = 'ستيرويد';
        break;
      default:
        chipColor = Colors.blue;
        label = 'دواء';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: .5)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: chipColor,
            fontFamily: regular
        ),
      ),
    );
  }
}