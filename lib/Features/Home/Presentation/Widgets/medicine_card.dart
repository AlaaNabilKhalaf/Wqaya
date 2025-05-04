import 'package:flutter/material.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/model/home_models.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineCard({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// اسم الدواء + نوعه
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: black,
                      color: Color(0xff1678F2),
                    ),
                  ),
                ),
                _buildMedicineTypeChip(),
              ],
            ),
            const SizedBox(height: 8),

            /// شكل الجرعة
            Text(
              "شكل الجرعة: ${medicine.dosageForm}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: semiBold
              ),
            ),

            /// القوة + الوحدة
            Text(
              "التركيز: ${medicine.strength} ${medicine.unit}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: semiBold

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineTypeChip() {
    Color chipColor;
    String label;

    switch (medicine.dosageForm.toLowerCase()) {
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
        ),
      ),
    );
  }
}
