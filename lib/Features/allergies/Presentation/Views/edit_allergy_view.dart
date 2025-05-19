import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/add_medicine_for_complaints.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/allergy_cubit.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/models/allergy_model.dart';

class EditAllergyView extends StatefulWidget {
  final AllergyModel allergy;

  const EditAllergyView({
    super.key,
    required this.allergy,
  });

  @override
  State<EditAllergyView> createState() => _EditAllergyViewState();
}

class _EditAllergyViewState extends State<EditAllergyView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _allergenNameController;
  late final TextEditingController _allergenTypeController;
  late final TextEditingController _severityLevelController;
  late final TextEditingController _reactionController;
  late final TextEditingController _diagnosisDateController;
  late final TextEditingController _lastOccurrenceController;
  late final TextEditingController _addedMedicinesController;
  late final TextEditingController _notesController;

  AllergenType? _selectedAllergenType;
  SeverityLevel? _selectedSeverityLevel;

  // List to store parsed medicines
  List<String> _medicinesList = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _allergenNameController = TextEditingController(text: widget.allergy.allergenName);
    _allergenTypeController = TextEditingController(text: widget.allergy.allergenType);
    _severityLevelController = TextEditingController(text: widget.allergy.severityLevel);
    _reactionController = TextEditingController(text: widget.allergy.reaction);
    _diagnosisDateController = TextEditingController(
        text: widget.allergy.diagnosisDate != null
            ? "${widget.allergy.diagnosisDate!.year}-${widget.allergy.diagnosisDate!.month.toString().padLeft(2, '0')}-${widget.allergy.diagnosisDate!.day.toString().padLeft(2, '0')}"
            : ""
    );
    _lastOccurrenceController = TextEditingController(
        text: widget.allergy.lastOccurrence != null
            ? "${widget.allergy.lastOccurrence!.year}-${widget.allergy.lastOccurrence!.month.toString().padLeft(2, '0')}-${widget.allergy.lastOccurrence!.day.toString().padLeft(2, '0')}"
            : ""
    );
    _addedMedicinesController = TextEditingController();
    _notesController = TextEditingController(text: widget.allergy.notes);

    // Set default values for dropdowns
    _selectedAllergenType = _getAllergenTypeFromString(widget.allergy.allergenType);
    _selectedSeverityLevel = _getSeverityLevelFromString(widget.allergy.severityLevel);

    // Parse medicines from the dash-separated string
    if (widget.allergy.addedmedicines != null && widget.allergy.addedmedicines!.isNotEmpty) {
      _medicinesList = widget.allergy.addedmedicines!.split('-')
          .map((medicine) => medicine.trim())
          .where((medicine) => medicine.isNotEmpty)
          .toList();

      // Add each medicine to the cubit for selection tracking
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   context.read<MedicineCubit>().selectedMedicineName.clear();
      //   for (String medicine in _medicinesList) {
      //     context.read<MedicineCubit>().addMedicineSelectionByName(medicine);
      //   }
      // });
    }
  }

  AllergenType? _getAllergenTypeFromString(String? typeString) {
    if (typeString == null || typeString.isEmpty) return null;

    try {
      return AllergenType.values.firstWhere(
            (type) => type.name == typeString,
        orElse: () => AllergenType.Other,
      );
    } catch (e) {
      return AllergenType.Other;
    }
  }

  SeverityLevel? _getSeverityLevelFromString(String? levelString) {
    if (levelString == null || levelString.isEmpty) return null;

    try {
      return SeverityLevel.values.firstWhere(
            (level) => level.name == levelString,
        orElse: () => SeverityLevel.Moderate,
      );
    } catch (e) {
      return SeverityLevel.Moderate;
    }
  }

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
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("تعديل الحساسية",
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
                    initialDate: widget.allergy.diagnosisDate ?? DateTime.now(),
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
                    initialDate: widget.allergy.lastOccurrence ?? DateTime.now(),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicineForComplaints(
                        isEditing: true,
                        onMedicinesSelected: (newMedicines) {
                          setState(() {
                            _medicinesList.addAll(newMedicines);
                          });
                        },
                      ),));
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
              if (_medicinesList.isNotEmpty)
                BlocBuilder<MedicineCubit, MedicineState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: _medicinesList.length,
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
                                  _medicinesList[index],
                                  style: const TextStyle(fontFamily: medium),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: errorColor),
                                onPressed: () {
                                  setState(() {
                                    context.read<MedicineCubit>().removeMedicineSelectionByName(_medicinesList[index]);
                                    _medicinesList.removeAt(index);
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
                  if (state is EditAllergySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم تعديل الحساسية بنجاح", style: TextStyle(fontFamily: regular)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    context.read<AllergyCubit>().getUserAllergies();
                  } else if (state is EditAllergyError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("حدث خطأ أثناء التعديل", style: TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  var allergyCubit = context.read<AllergyCubit>();
                  return state is EditAllergyLoading
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
                        // Join the medicines list with dashes for saving
                        final selectedMedicinesString = _medicinesList.join('-');

                        await allergyCubit.editAllergy(
                          id: widget.allergy.id!,
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
                          notes: _notesController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("تحديث",
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

  @override
  void dispose() {
    _allergenNameController.dispose();
    _allergenTypeController.dispose();
    _severityLevelController.dispose();
    _reactionController.dispose();
    _diagnosisDateController.dispose();
    _lastOccurrenceController.dispose();
    _addedMedicinesController.dispose();
    _notesController.dispose();
    super.dispose();
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

// MapS to translate enum values to Arabic - You may need to add these
