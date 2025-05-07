import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/surgries/presentation/views/add_surgery_view.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';

class EditSurgeriesView extends StatefulWidget {
  final Surgery surgery;

  const EditSurgeriesView({super.key, required this.surgery});

  @override
  State<EditSurgeriesView> createState() => _EditSurgeriesViewState();
}

class _EditSurgeriesViewState extends State<EditSurgeriesView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _surgeryTypeController;
  late final TextEditingController _nameController;
  late final TextEditingController _reasonController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;
  late SurgeryResult? _selectedSurgeryResult;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _surgeryTypeController = TextEditingController(text: widget.surgery.surgeryOutcome);
    _nameController = TextEditingController(text: widget.surgery.surgeryName);
    _reasonController = TextEditingController(text: widget.surgery.surgeryReason);
    _dateController = TextEditingController(
        text: "${widget.surgery.surgeryDate.year}-${widget.surgery.surgeryDate.month.toString().padLeft(2, '0')}-${widget.surgery.surgeryDate.day.toString().padLeft(2, '0')}"
    );
    _noteController = TextEditingController(text: widget.surgery.notes);

    // Set the selected surgery result based on existing data
    _selectedSurgeryResult = _getSurgeryResultFromString(widget.surgery.surgeryOutcome);
  }

  @override
  void dispose() {
    _surgeryTypeController.dispose();
    _nameController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  SurgeryResult? _getSurgeryResultFromString(String outcome) {
    print("OUTCOME: $outcome");
    // First try case-insensitive match with enum names
    for (var result in SurgeryResult.values) {
      print("Checking against: ${result.name}");
      if (result.name.toLowerCase() == outcome.toLowerCase()) {
        print("Match found with: ${result.name}");
        return result;
      }
    }

    // If no match by name, try to match based on Arabic label
    for (var entry in surgeryResultLabels.entries) {
      if (entry.value == outcome) {
        print("Match found with Arabic label: ${entry.value}");
        return entry.key;
      }
    }

    // If still no match, try to match the first letter
    if (outcome.isNotEmpty) {
      final firstChar = outcome[0].toLowerCase();
      for (var result in SurgeryResult.values) {
        if (result.name.startsWith(firstChar)) {
          print("Partial match by first letter: ${result.name}");
          return result;
        }
      }
    }

    print("No match found, defaulting to null");
    return null;
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

  final List<String> surgeryResults = [
    'ناجحة',
    'مستقرة',
    'مع مضاعفات',
    'فشلت',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("تعديل العملية",
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
              _buildTextField(label: "اسم العملية", controller: _nameController),
              const SizedBox(height: 12),
              _buildTextField(label: "سبب العملية", controller: _reasonController),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.surgery.surgeryDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: "اختر تاريخ العملية",
                    confirmText: "تم",
                    cancelText: "إلغاء",
                    locale: const Locale("ar", "EG"),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                style: const TextStyle(fontFamily: medium),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "تاريخ العملية",
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
                  label: "ملحوظة", controller: _noteController),
              const SizedBox(height: 20),
              DropdownButtonFormField<SurgeryResult>(
                value: _selectedSurgeryResult,
                onChanged: (value) {
                  setState(() {
                    _selectedSurgeryResult = value;
                    _surgeryTypeController.text = value!.name; // this sends enum name to backend
                  });
                },
                validator: (value) =>
                value == null ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "نوع العملية",
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
                items: SurgeryResult.values.map((result) {
                  return DropdownMenuItem<SurgeryResult>(
                    value: result,
                    child: Text(
                      surgeryResultLabels[result]!,
                      style: const TextStyle(fontFamily: medium),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30,),
              BlocConsumer<SurgeryCubit, SurgeryState>(
                listener: (context, state){
                  if (state is EditSurgerySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم تعديل العملية بنجاح",style: TextStyle(fontFamily: regular),),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    context.read<SurgeryCubit>().getUserSurgeries();
                  } else if (state is EditSurgeryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("حدث خلال أثناء التعديل",style: TextStyle(fontFamily: regular),),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  var sCubit = context.read<SurgeryCubit>();
                  return state is EditSurgeryLoading
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
                        final surgery = Surgery(
                          id: widget.surgery.id,
                          surgeryName: _nameController.text,
                          surgeryReason: _reasonController.text,
                          surgeryDate: DateTime.parse(_dateController.text),
                          surgeryOutcome: _surgeryTypeController.text,
                          notes: _noteController.text,
                          medicalHistoryId: widget.surgery.medicalHistoryId,
                        );
                        await sCubit.editUserSurgery(surgery);
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
}