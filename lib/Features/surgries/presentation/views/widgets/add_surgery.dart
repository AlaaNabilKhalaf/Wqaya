import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';

class AddSurgeriesScreen extends StatefulWidget {
  const AddSurgeriesScreen({super.key});

  @override
  State<AddSurgeriesScreen> createState() => _AddSurgeriesScreenState();
}

class _AddSurgeriesScreenState extends State<AddSurgeriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surgeryTypeController = TextEditingController();
  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();


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

  SurgeryResult? _selectedSurgeryResult;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("إضافة عملية",
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
                    initialDate: DateTime.now(),
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
                  if (state is AddSurgerySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم اضافة العملية بنجاح",style: TextStyle(fontFamily: regular),),backgroundColor: Colors.green,),
                    );
                    Navigator.pop(context);
                    context.read<SurgeryCubit>().getUserSurgeries();
                  } else if (state is AddSurgeryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("حدث خلال أثناء الاضافة",style: TextStyle(fontFamily: regular),),backgroundColor: errorColor,),
                    );
                  }
                },
                builder: (context, state) {
                  var sCubit = context.read<SurgeryCubit>();
                  return state is AddSurgeryLoading
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
                              'يجب ملئ كل الخانات و رفع صورة',
                              style: TextStyle(fontFamily: regular),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: errorColor,
                          ),
                        );
                        return;
                      } else {
                        print(_surgeryTypeController.text);
                        print(_reasonController.text);
                        print(_noteController.text);
                        print(_dateController.text);
                        print(_nameController.text);
                        final surgery = AddSurgery(
                          medicalHistoryId: 0,
                          notes: _noteController.text,
                          surgeryDate: _dateController.text ,
                          surgeryName: _nameController.text,
                          surgeryOutcome: _surgeryTypeController.text,
                          surgeryReason: _reasonController.text
                        );
                        await sCubit.addUserSurgery(surgery);
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
enum SurgeryResult {
  successful,
  stable,
  complications,
  failed
}
const Map<SurgeryResult, String> surgeryResultLabels = {
  SurgeryResult.successful: 'ناجحة',
  SurgeryResult.stable: 'مستقرة',
  SurgeryResult.complications: 'مع مضاعفات',
  SurgeryResult.failed: 'فشلت',
};