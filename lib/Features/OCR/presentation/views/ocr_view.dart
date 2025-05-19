import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/OCR/presentation/views/view_model/ocr_cubit.dart';

class OCRView extends StatefulWidget {
  const OCRView({Key? key}) : super(key: key);

  @override
  State<OCRView> createState() => _OCRViewState();
}

class _OCRViewState extends State<OCRView> {
  File? _prescriptionImage;
  final ImagePicker _picker = ImagePicker();
  String _errorMessage = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _prescriptionImage = File(pickedFile.path);
          _errorMessage = '';
        });

        // Reset the cubit state when a new image is selected
        context.read<OcrCubit>().reset();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء اختيار الصورة';
      });
    }
  }

  Future<void> _processImage() async {
    if (_prescriptionImage == null) {
      setState(() {
        _errorMessage = 'الرجاء اختيار صورة أولاً';
      });
      return;
    }

    // Upload the image to the server using the cubit
    await context.read<OcrCubit>().uploadPicture(_prescriptionImage!);
  }

  void _resetProcess() {
    setState(() {
      _prescriptionImage = null;
      _errorMessage = '';
    });

    // Reset the cubit state
    context.read<OcrCubit>().reset();
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xff0094FD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white)),
                const Spacer(),
                const Text(
                  'ارفع صورة',
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: regular),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: textFormBackgroundColor,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocConsumer<OcrCubit, OcrState>(
                  listener: (context, state) {
                    if (state is OcrError) {
                      setState(() {
                        _errorMessage = state.message;
                      });
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          // Main instruction text
                          const Text(
                            'قم بتحميل صورة للروشتة الطبية وسنقوم بقراءتها لك',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: subTextColor,
                                fontFamily: bold),
                          ),
                          const SizedBox(height: 30),
                          // Image preview container
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: myWhiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: _prescriptionImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _prescriptionImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 70,
                                        color: unselectedContainerColor,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'قم بتحميل صورة واضحة للروشتة الطبية',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: subTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: regular),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 20),
                          // Upload buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildImageSourceButton(
                                context: context,
                                icon: Icons.camera_alt,
                                title: 'الكاميرا',
                                onTap: () => _pickImage(ImageSource.camera),
                              ),
                              const SizedBox(width: 30),
                              _buildImageSourceButton(
                                context: context,
                                icon: Icons.photo_library,
                                title: 'المعرض',
                                onTap: () =>
                                    _pickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: errorColor.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "لم نستطع القراءة ارسل صورة أوضح",
                                style: TextStyle(
                                  color: errorColor,
                                  fontFamily: bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          // Process button
                          state is OcrLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  ),
                              )
                              : ElevatedButton(
                                  onPressed: (_prescriptionImage != null
                                      ? _processImage
                                      : null),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    disabledBackgroundColor:
                                        _prescriptionImage != null
                                            ? primaryColor.withValues(alpha: .7)
                                            : unselectedContainerColor,
                                  ),
                                  child: const Text(
                                    'تحليل الروشتة',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: myWhiteColor,
                                      fontFamily: black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          if (state is OcrSuccess) ...[
                            const SizedBox(height: 30),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: myWhiteColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'نتائج التحليل:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontFamily: black),
                                  ),
                                  const SizedBox(height: 12),
                                  ...state.medicines.map((medicine) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '- ${medicine.name}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                fontFamily: semiBold),
                                          ),
                                          if (medicine.dosageForm != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 15.0,
                                                      top: 4.0),
                                              child: Text(
                                                'الشكل الدوائي: ${medicine.dosageForm}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                    fontFamily: regular),
                                              ),
                                            ),
                                          if (medicine.frequency != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 15.0,
                                                      top: 4.0),
                                              child: Text(
                                                'التكرار: ${medicine.frequency}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                    fontFamily: regular),
                                              ),
                                            ),
                                          if (medicine.duration != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 15.0,
                                                      top: 4.0),
                                              child: Text(
                                                'المدة: ${medicine.duration}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                    fontFamily: regular),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'تمت اضافة الأدوية في سجلك الطبي !',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: bold),
                                  ),
                                  TextButton.icon(
                                    onPressed: _resetProcess,
                                    icon: const Icon(Icons.refresh,
                                        color: subTextColor),
                                    label: const Text(
                                      'إعادة رفع جديدة',
                                      style: TextStyle(
                                          color: subTextColor,
                                          fontFamily: regular),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: myWhiteColor, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  color: myWhiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: black),
            ),
          ],
        ),
      ),
    );
  }
}
