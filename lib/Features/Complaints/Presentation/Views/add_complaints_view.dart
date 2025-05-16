import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_cubit.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_state.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/add_medicine_for_complaints.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/pain_widgets.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';


class AddComplaintView extends StatefulWidget {
  const AddComplaintView({super.key});

  @override
  State<AddComplaintView> createState() => _AddComplaintViewState();
}

class _AddComplaintViewState extends State<AddComplaintView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _howAffectsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();
  final List<String> _typeOptions = ['Active', 'Inactive'];


  String _selectedType = 'Active';
  String _selectedDuration = 'Days';
  String _selectedSeverity = 'Moderate';
  double _painLevel = 3; // Default pain level

  // Map to convert pain level (0-10) to severity options
  String _mapPainLevelToSeverity(double painLevel) {
    // Round to nearest integer for simplicity
    int painInt = painLevel.round();

    // Map the 0-10 pain scale to the 10 severity options
    switch (painInt) {
      case 0: return 'Trivial';
      case 1: return 'Low';
      case 2: return 'Moderate';
      case 3: return 'Medium';
      case 4: return 'Significant';
      case 5: return 'High';
      case 6: return 'High';
      case 7: return 'Severe';
      case 8: return 'Critical';
      case 9: return 'Blocker';
      case 10: return 'Fatal';
      default: return 'Moderate'; // Default fallback
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<MedicineCubit>().selectedMedicineName.toList().clear();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _howAffectsController.dispose();
    _notesController.dispose();
    _medicineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text("إضافة شكوى",
            style:
            TextStyle(fontFamily: bold, fontSize: 20, color: primaryColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: BlocConsumer<ComplaintsCubit, ComplaintState>(
        listener: (context, state) {
          if (state is AddComplaintSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: regular),
                ),
                backgroundColor: primaryColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is AddComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: regular),
                ),
                backgroundColor: errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          var selectedMedicineName = context.read<MedicineCubit>().selectedMedicineName.toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PainWidgets(
                      onDurationChanged: (duration) {
                        setState(() {
                          _selectedDuration = duration;
                        });
                      },
                      onPainLevelChanged: (painLevel) {
                        setState(() {
                          _painLevel = painLevel;
                          // Update the selected severity based on pain level
                          _selectedSeverity = _mapPainLevelToSeverity(painLevel);
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: textFormBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                ComplaintEnums.severityOptionsArabic[_selectedSeverity] ?? _selectedSeverity,
                                style: const TextStyle(
                                  fontFamily: medium,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "مستوى الألم: ${_painLevel.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  fontFamily: regular,
                                  fontSize: 14,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _buildFormSection("معلومات الشكوى", [
                      _buildTextField(
                        controller: _reasonController,
                        labelText: "سبب الشكوى",
                        hintText: "أدخل سبب الشكوى",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال سبب الشكوى';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _locationController,
                        labelText: "الموقع",
                        hintText: "أدخل موقع الشكوى",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال موقع الشكوى';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: "نوع الشكوى",
                        value: _selectedType,
                        translations: ComplaintEnums.typeOptionsArabic,
                        items: _typeOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _notesController,
                        labelText: "كيف تؤثر الشكوى عليك",
                        hintText: "أدخل كيفية تأثير الشكوى أو الأعراض",
                        maxLines: 3,
                      ),
                    ]),
                    const SizedBox(height: 24),
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
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemCount: selectedMedicineName.length,
                          itemBuilder:(context, index) =>  Container(
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
                                    selectedMedicineName[index],
                                    style: const TextStyle(fontFamily: medium),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: errorColor),
                                  onPressed: () {
                                    setState(() {
                                      // Remove the medicine at this index
                                      context.read<MedicineCubit>().selectedMedicineName.toList().removeAt(index);
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Get the selected medicines from the MedicineCubit
                            final selectedMedicines = context.read<MedicineCubit>().selectedMedicineName.toList();

                            // Include pain level in notes with additional notes
                            final String fullNotes = _notesController.text;

                            // Call the updated addComplaint method with the correct parameters
                            context.read<ComplaintsCubit>().addComplaint(
                              type: _selectedType,
                              reason: _reasonController.text,
                              location: _locationController.text,
                              duration: _selectedDuration,  // Now using the value from PainWidgets
                              severity: _selectedSeverity, // Now using the mapped value from pain level
                              medicines: selectedMedicines,
                              notes: fullNotes, // Include pain level in notes
                            );
                          }
                        },
                        child: state is AddComplaintLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'إضافة الشكوى',
                          style: TextStyle(
                            fontFamily: semiBold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: const TextStyle(fontFamily: medium),
      validator:
      validator ?? (value) => required && value!.isEmpty ? 'مطلوبة' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFormBackgroundColor,
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(fontFamily: regular, color: subTextColor),
        hintStyle: const TextStyle(fontFamily: regular, color: subTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Map<String, String> translations,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: regular,
            fontSize: 16,
            color: subTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: textFormBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            style: const TextStyle(
              fontFamily: medium,
              fontSize: 16,
              color: Colors.black,
            ),
            dropdownColor: textFormBackgroundColor,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(translations[value] ?? value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}