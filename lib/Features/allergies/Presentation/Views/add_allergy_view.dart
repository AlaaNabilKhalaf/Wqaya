import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/add_medicine_for_complaints.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/allergy_cubit.dart';

class AddAllergyView extends StatefulWidget {
  const AddAllergyView({super.key});

  @override
  State<AddAllergyView> createState() => _AddAllergyViewState();
}

class _AddAllergyViewState extends State<AddAllergyView> {
  final _formKey = GlobalKey<FormState>();
  final _allergenNameController = TextEditingController();
  final _allergenTypeController = TextEditingController();
  final _severityLevelController = TextEditingController();
  final _reactionController = TextEditingController();
  final _diagnosisDateController = TextEditingController();
  final _lastOccurrenceController = TextEditingController();
  final _notesController = TextEditingController();

  AllergenType? _selectedAllergenType;
  SeverityLevel? _selectedSeverityLevel;

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: const TextStyle(fontFamily: medium),
      validator: (value) => value!.isEmpty ? 'مطلوبة' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFormBackgroundColor,
        labelText: label,
        labelStyle: const TextStyle(fontFamily: regular, color: subTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedMedicineName = context.watch<MedicineCubit>().selectedMedicineName.toList();
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("إضافة حساسية",
            style:
            TextStyle(fontFamily: bold, fontSize: 20, color: primaryColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: "اسم مسبب الحساسية",
                controller: _allergenNameController,
              ),
              const SizedBox(height: 12),

              // Allergen Type Dropdown
              DropdownButtonFormField<AllergenType>(
                value: _selectedAllergenType,
                onChanged: (value) {
                  setState(() {
                    _selectedAllergenType = value;
                    _allergenTypeController.text = value!.name; // sends enum name to backend
                  });
                },
                validator: (value) => value == null ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "نوع مسبب الحساسية",
                  labelStyle:
                  const TextStyle(fontFamily: regular, color: subTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontFamily: medium, color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: AllergenType.values.map((type) {
                  return DropdownMenuItem<AllergenType>(
                    value: type,
                    child: Text(
                      allergenTypeTranslations[type.name]!,
                      style: const TextStyle(fontFamily: medium),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Severity Level Dropdown
              DropdownButtonFormField<SeverityLevel>(
                value: _selectedSeverityLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedSeverityLevel = value;
                    _severityLevelController.text = value!.name; // sends enum name to backend
                  });
                },
                validator: (value) => value == null ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "مستوى الشدة",
                  labelStyle:
                  const TextStyle(fontFamily: regular, color: subTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontFamily: medium, color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: SeverityLevel.values.map((level) {
                  return DropdownMenuItem<SeverityLevel>(
                    value: level,
                    child: Text(
                      severityLevelTranslations[level.name]!,
                      style: const TextStyle(fontFamily: medium),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              _buildTextField(
                label: "ردة الفعل",
                controller: _reactionController,
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Diagnosis Date
              TextFormField(
                controller: _diagnosisDateController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: "اختر تاريخ التشخيص",
                    confirmText: "تم",
                    cancelText: "إلغاء",
                    locale: const Locale("ar", "EG"),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _diagnosisDateController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                style: const TextStyle(fontFamily: medium),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "تاريخ التشخيص",
                  labelStyle:
                  const TextStyle(fontFamily: regular, color: subTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon:
                  const Icon(Icons.calendar_today, color: subTextColor),
                ),
              ),

              const SizedBox(height: 12),

              // Last Occurrence Date
              TextFormField(
                controller: _lastOccurrenceController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: "اختر تاريخ آخر ظهور",
                    confirmText: "تم",
                    cancelText: "إلغاء",
                    locale: const Locale("ar", "EG"),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _lastOccurrenceController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                style: const TextStyle(fontFamily: medium),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "تاريخ آخر ظهور",
                  labelStyle:
                  const TextStyle(fontFamily: regular, color: subTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon:
                  const Icon(Icons.calendar_today, color: subTextColor),
                ),
              ),

              const SizedBox(height: 12),
              _buildTextField(
                label: "ملاحظات",
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "اضافة دواء",
                    style: TextStyle(
                        fontFamily: bold,
                        fontSize: 20,
                        color: primaryColor),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicineForComplaints(),));
                    },
                    child: const CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: myWhiteColor,
                        )),
                  ),
                ],
              ),
              if (selectedMedicineName.isNotEmpty)
                BlocBuilder<MedicineCubit, MedicineState>(
                  builder: (context, state) {
                    final medicines = context.watch<MedicineCubit>().selectedMedicineName.toList();
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: textFormBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.medication, color: primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  medicines[index],
                                  style: const TextStyle(fontFamily: medium),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: errorColor),
                                onPressed: () {
                                  context.read<MedicineCubit>().removeMedicineSelectionByName(selectedMedicineName[index].toString());
                                  setState(() {
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 30),

              BlocConsumer<AllergyCubit, AllergyState>(
                listener: (context, state) {
                  if (state is AddAllergySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم إضافة الحساسية بنجاح", style: TextStyle(fontFamily: regular)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    context.read<AllergyCubit>().getUserAllergies();
                  } else if (state is AddAllergyError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("حدث خطأ أثناء الإضافة", style: TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  var allergyCubit = context.read<AllergyCubit>();
                  return state is AddAllergyLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: primaryColor,
                      ))
                      : ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'يجب ملئ كل الخانات',
                              style: TextStyle(fontFamily: regular),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: errorColor,
                          ),
                        );
                        return;
                      } else {
                        final selectedMedicines = context.read<MedicineCubit>().selectedMedicineName.toList();
                        final selectedMedicinesString = selectedMedicines.join('-');

                        await allergyCubit.addAllergy(
                          allergenName: _allergenNameController.text,
                          allergenType: _allergenTypeController.text,
                          severityLevel: _severityLevelController.text,
                          reaction: _reactionController.text,
                          diagnosisDate: _diagnosisDateController.text.isNotEmpty
                              ? DateTime.parse(_diagnosisDateController.text).toIso8601String()
                              : "",
                          lastOccurrence: _lastOccurrenceController.text.isNotEmpty
                              ? DateTime.parse(_lastOccurrenceController.text).toIso8601String()
                              : "",
                          medicines: selectedMedicinesString,
                          notes: _notesController.text,);
                        print(_allergenNameController.text);
                        print(_allergenTypeController.text);
                        print(_severityLevelController.text);
                        print(DateTime.parse(_diagnosisDateController.text).toString());
                        print(DateTime.parse(_lastOccurrenceController.text).toString());
                        print(_notesController.text);
                        print(selectedMedicinesString);
                                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("إرسال",
                        style: TextStyle(
                            fontFamily: bold,
                            fontSize: 16,
                            color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AllergenType {
  Food,
  Drug,
  Environmental,
  Insect,
  Latex,
  Other,
}

enum SeverityLevel {
  Trivial,
  Mild,
  Moderate,
  Severe,
  Fatal,
}

const Map<String, String> allergenTypeTranslations = {
  'Food': 'طعام',
  'Drug': 'دواء',
  'Environmental': 'بيئي',
  'Insect': 'حشرات',
  'Latex': 'لاتكس',
  'Other': 'أخرى',
};

const Map<String, String> severityLevelTranslations = {
  'Trivial': 'بسيط',
  'Mild': 'خفيف',
  'Moderate': 'متوسط',
  'Severe': 'شديد',
  'Fatal': 'خطير',
};