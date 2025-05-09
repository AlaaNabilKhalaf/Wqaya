import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

class EditUserMedicineView extends StatefulWidget {
  final MedicineModel medicineModel;

  const EditUserMedicineView({Key? key, required this.medicineModel})
      : super(key: key);

  @override
  State<EditUserMedicineView> createState() => _EditUserMedicineViewState();
}

class _EditUserMedicineViewState extends State<EditUserMedicineView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _strengthController;

  // Dropdown values - store the backend enum values directly
  String? _selectedDosageForm;
  String? _selectedUnit;
  String? _selectedMedicineType;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    _nameController = TextEditingController(text: widget.medicineModel.name);
    _strengthController =
        TextEditingController(text: widget.medicineModel.strength.toString());

    // Set initial dropdown values
    _selectedDosageForm = widget.medicineModel.dosageForm;
    _selectedUnit = widget.medicineModel.unit;
    _selectedMedicineType = widget.medicineModel.medicineType;
  }

  // Medicine Type Translations
  static const Map<String, String> medicineTypeTranslations = {
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
  static const Map<String, String> unitTranslations = {
    // Backend enum values -> Arabic translations
    'Mg': 'ملغ', // Milligram
    'Ml': 'مل', // Milliliter
    'G': 'غم', // Gram
    'L': 'لتر', // Liter
    'Mcg': 'ميكروغرام', // Microgram
    'IU': 'وحدة دولية', // International Units
  };

  // Dosage Form Options (English values to send directly to backend)
  static const List<String> dosageFormOptions = [
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
  static const Map<String, String> dosageFormDisplayTranslations = {
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontFamily: medium, color: Colors.black),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: dosageFormOptions.map((dosageForm) {
        return DropdownMenuItem<String>(
          value: dosageForm, // Store English value directly
          child: Text(
            dosageFormDisplayTranslations[dosageForm] ?? dosageForm,
            // Display Arabic translation
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        title: const Text("تعديل دواء",
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
                  if (state is EditMedicineSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم تعديل الدواء بنجاح",
                            style: TextStyle(fontFamily: regular)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is EditMedicineError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.errorMessage,
                            style: const TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state is EditMedicineLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ))
                      : ElevatedButton(
                          onPressed: ()async {
                            if (_formKey.currentState!.validate()) {
                              // Convert strength to double
                              double? strength =
                                  double.tryParse(_strengthController.text);
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
                              if (_selectedDosageForm == null ||
                                  _selectedUnit == null ||
                                  _selectedMedicineType == null) {
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
                              final MedicineModel newEditedMedicine = MedicineModel(
                                  id: widget.medicineModel.id,
                                  name: _nameController.text.toString(),
                                  dosageForm: _selectedDosageForm.toString(),
                                  strength: int.parse(_strengthController.text),
                                  medicineType: _selectedMedicineType.toString(),
                                  unit: _selectedUnit.toString());
                              await context.read<MedicineCubit>().editUserMedicine(
                                  medicine: newEditedMedicine);
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
                            "حفظ التغييرات",
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
