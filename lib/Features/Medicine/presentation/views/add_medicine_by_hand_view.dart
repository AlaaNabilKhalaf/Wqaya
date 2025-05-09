import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';

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

// Dosage Form Options (English values to send directly to backend)
const List<String> dosageFormOptions = [
  'Tablet',
  'Capsule',
  'Liquid',
  'Syrup',
  'Injection',
  'Cream',
  'Ointment',
  'Drops',
  'Inhaler',
  'Patch',
];

// Arabic translations for display
const Map<String, String> dosageFormDisplayTranslations = {
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

class AddMedicineByHandView extends StatefulWidget {
  const AddMedicineByHandView({super.key});

  @override
  State<AddMedicineByHandView> createState() => _AddMedicineByHandViewState();
}

class _AddMedicineByHandViewState extends State<AddMedicineByHandView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();

  // Dropdown values - store the backend enum values directly
  String? _selectedDosageForm;
  String? _selectedUnit;
  String? _selectedMedicineType;

  // Helper methods to convert between display and backend values
  String? getBackendUnit(String? translatedValue) {
    if (translatedValue == null) return null;

    for (var entry in unitTranslations.entries) {
      if (entry.value == translatedValue) {
        return entry.key;
      }
    }
    return null;
  }

  String? getBackendMedicineType(String? translatedValue) {
    if (translatedValue == null) return null;

    for (var entry in medicineTypeTranslations.entries) {
      if (entry.value == translatedValue) {
        return entry.key;
      }
    }
    return null;
  }

  // Helper methods to get display values
  String? getDisplayForDosageForm(String? backendValue) {
    if (backendValue == null) return null;
    return dosageFormDisplayTranslations[backendValue];
  }

  String? getDisplayForUnit(String? backendValue) {
    if (backendValue == null) return null;
    return unitTranslations[backendValue];
  }

  String? getDisplayForMedicineType(String? backendValue) {
    if (backendValue == null) return null;
    return medicineTypeTranslations[backendValue];
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
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

  // For Dosage Form - display Arabic but store English
  Widget _buildDosageFormDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDosageForm,
      onChanged: (value) {
        setState(() {
          _selectedDosageForm = value;
        });
      },
      validator: (value) => value == null ? 'مطلوب' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFormBackgroundColor,
        labelText: "شكل الدواء",
        labelStyle: const TextStyle(fontFamily: regular, color: subTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontFamily: medium, color: Colors.black),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: dosageFormOptions.map((dosageForm) {
        return DropdownMenuItem<String>(
          value: dosageForm, // Store English value directly
          child: Text(
            dosageFormDisplayTranslations[dosageForm] ?? dosageForm, // Display Arabic translation
            style: const TextStyle(fontFamily: medium),
          ),
        );
      }).toList(),
    );
  }

  // For Unit and Medicine Type dropdowns
  Widget _buildTranslatedDropdownField<T>({
    required String label,
    required String? selectedBackendValue,
    required Map<String, String> translationMap,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedBackendValue,
      onChanged: onChanged,
      validator: (value) => value == null ? 'مطلوب' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFormBackgroundColor,
        labelText: label,
        labelStyle: const TextStyle(fontFamily: regular, color: subTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontFamily: medium, color: Colors.black),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: translationMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key, // Store backend value (English)
          child: Text(
            entry.value, // Display translated value (Arabic)
            style: const TextStyle(fontFamily: medium),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("إضافة دواء",
            style: TextStyle(fontFamily: bold, fontSize: 20, color: primaryColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(label: "اسم الدواء", controller: _nameController),
              const SizedBox(height: 12),

              _buildDosageFormDropdown(),
              const SizedBox(height: 12),

              _buildTextField(
                label: "الجرعة",
                controller: _strengthController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _buildTranslatedDropdownField(
                label: "وحدة القياس",
                selectedBackendValue: _selectedUnit,
                translationMap: unitTranslations,
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              _buildTranslatedDropdownField(
                label: "نوع الدواء",
                selectedBackendValue: _selectedMedicineType,
                translationMap: medicineTypeTranslations,
                onChanged: (value) {
                  setState(() {
                    _selectedMedicineType = value;
                  });
                },
              ),
              const SizedBox(height: 30),

              BlocConsumer<MedicineCubit, MedicineState>(
                listener: (context, state) {
                  if (state is AddMedicineSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم إضافة الدواء بنجاح", style: TextStyle(fontFamily: regular)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is AddMedicineError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.errorMessage, style: const TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AddMedicineLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: primaryColor,
                      ))
                      : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Convert strength to double
                        double? strength = double.tryParse(_strengthController.text);
                        if (strength == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'الرجاء إدخال رقم صحيح للجرعة',
                                style: TextStyle(fontFamily: regular),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: errorColor,
                            ),
                          );
                          return;
                        }

                        // Ensure we have values for all fields
                        if (_selectedDosageForm == null || _selectedUnit == null || _selectedMedicineType == null) {
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
                        }

                        // Send the English values directly to the backend
                        context.read<MedicineCubit>().addMedicineByHand(
                          name: _nameController.text,
                          dosageForm: _selectedDosageForm!, // Already in English format
                          strength: strength,
                          unit: _selectedUnit!, // Already in English format
                          medicineType: _selectedMedicineType!, // Already in English format
                        );
                      } else {
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
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "إضافة الدواء",
                      style: TextStyle(
                          fontFamily: bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
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
    _nameController.dispose();
    _strengthController.dispose();
    super.dispose();
  }
}