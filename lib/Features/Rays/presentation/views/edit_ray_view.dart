import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Rays/presentation/views/view_model/ray_cubit.dart';
import 'package:wqaya/Features/Rays/presentation/views/view_model/models/ray_model.dart';

class EditRayScreen extends StatefulWidget {
  final RayModel rayModel;

  const EditRayScreen({super.key, required this.rayModel});

  @override
  State<EditRayScreen> createState() => _EditRayScreenState();
}

class _EditRayScreenState extends State<EditRayScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _rayTypeController;
  late final TextEditingController _reasonController;
  late final TextEditingController _dateController;
  late final TextEditingController _bodyPartController;
  File? _selectedImage;
  String? _existingImageUrl;
  bool _imageChanged = false;
  @override
  void initState() {
    super.initState();

    // Format the date string to remove time
    final rayDate = DateTime.tryParse(widget.rayModel.rayDate);
    final formattedDate = rayDate != null
        ? "${rayDate.year}-${rayDate.month.toString().padLeft(2, '0')}-${rayDate.day.toString().padLeft(2, '0')}"
        : widget.rayModel.rayDate;

    _rayTypeController = TextEditingController(text: widget.rayModel.rayType);
    _reasonController = TextEditingController(text: widget.rayModel.reason);
    _dateController = TextEditingController(text: formattedDate);
    _bodyPartController = TextEditingController(text: widget.rayModel.bodyPart);
    _selectedRayType = widget.rayModel.rayType;
    _existingImageUrl = widget.rayModel.imageUrl;
  }

  @override
  void dispose() {
    _rayTypeController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    _bodyPartController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _imageChanged = true;
      });
    }
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

  final List<String> rayTypes = [
    'XRay',
    'MRI',
    'CT Scan',
    'Ultrasound',
    'PET Scan',
    'Mammogram',
    'Bone Scan',
    'Fluoroscopy',
  ];

  String? _selectedRayType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("تعديل أشعة",
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
              DropdownButtonFormField<String>(
                value: _selectedRayType,
                onChanged: (value) {
                  setState(() {
                    _selectedRayType = value;
                    _rayTypeController.text = value!;
                  });
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'مطلوب' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "نوع الأشعة",
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
                items: rayTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child:
                    Text(type, style: const TextStyle(fontFamily: medium)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              _buildTextField(label: "السبب", controller: _reasonController),
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
                    helpText: "اختر تاريخ الأشعة",
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
                  labelText: "تاريخ الأشعة",
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
                  label: "العضو المصاب", controller: _bodyPartController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text("تغيير الصورة",
                    style: TextStyle(fontFamily: medium)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: unselectedContainerColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),

              // Display either the selected new image or the existing image
              if (_selectedImage != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(_existingImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 10),
              BlocConsumer<RayCubit, RayCubitState>(
                listener: (context, state) {
                  if (state is EditRaySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم تعديل الاشعة بنجاح", style: TextStyle(fontFamily: regular)),
                        backgroundColor: primaryColor,
                      ),
                    );
                    Navigator.pop(context);
                    context.read<RayCubit>().getUserRays();
                  } else if (state is EditRayError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message ?? "حدث خلل أثناء التعديل", style: const TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  var rCubit = context.read<RayCubit>();
                  return state is EditRayLoading
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
                      }

                      MultipartFile? imageFile;
                      if (_imageChanged && _selectedImage != null) {
                        imageFile = await MultipartFile.fromFile(
                            _selectedImage!.path,
                            filename: _selectedImage!.path.split('/').last
                        );
                      }
                      print(widget.rayModel.id);
                      print(_rayTypeController.text);
                      print(_reasonController.text);
                      print(_dateController.text);
                      print(_dateController.text);
                      print(imageFile?.filename);
                      rCubit.editUserRay(
                        rayId: widget.rayModel.id,
                        rayType: _rayTypeController.text,
                        reason: _reasonController.text,
                        rayDate: _dateController.text,
                        bodyPart: _dateController.text,
                        image: imageFile,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("حفظ التعديلات",
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