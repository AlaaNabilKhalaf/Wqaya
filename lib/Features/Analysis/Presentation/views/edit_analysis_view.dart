import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_cubit.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_model.dart';

class EditAnalysisView extends StatefulWidget {
  final AnalysisRecord analysisRecord;

  const EditAnalysisView({super.key, required this.analysisRecord});

  @override
  State<EditAnalysisView> createState() => _EditAnalysisViewState();
}

class _EditAnalysisViewState extends State<EditAnalysisView> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _labNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _resultSummaryController = TextEditingController();

  File? _selectedPdfFile;
  String? _resultStatus;
  bool _isPdfChanged = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from analysisRecord
    _testNameController.text = widget.analysisRecord.testName;
    _labNameController.text = widget.analysisRecord.labName;
    _dateController.text =
        "${widget.analysisRecord.date.year}-${widget.analysisRecord.date.month.toString().padLeft(2, '0')}-${widget.analysisRecord.date.day.toString().padLeft(2, '0')}";
    _resultSummaryController.text = widget.analysisRecord.resultSummary ?? '';
    _resultStatus = widget.analysisRecord.resultStatus;
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _labNameController.dispose();
    _dateController.dispose();
    _resultSummaryController.dispose();
    super.dispose();
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedPdfFile = File(result.files.single.path!);
        _isPdfChanged = true;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: const TextStyle(fontFamily: medium),
      validator: (value) => required && value!.isEmpty ? 'مطلوبة' : null,
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
    var aCubit = context.read<AnalysisCubit>();
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: AppBar(
        backgroundColor: myWhiteColor,
        elevation: 0,
        title: const Text("تعديل التحليل",
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
                  label: "اسم التحليل", controller: _testNameController),
              const SizedBox(height: 12),
              _buildTextField(
                  label: "اسم المعمل", controller: _labNameController),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.analysisRecord.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: "اختر تاريخ التحليل",
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
                  labelText: "تاريخ التحليل",
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
                label: "ملخص النتائج",
                controller: _resultSummaryController,
                maxLines: 3,
                required: false,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _resultStatus,
                onChanged: (value) {
                  setState(() {
                    _resultStatus = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFormBackgroundColor,
                  labelText: "حالة النتيجة",
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
                items: aCubit.resultStatusMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key, // Backend value (English)
                    child: Text(entry.value,
                        style: const TextStyle(
                            fontFamily: medium)), // Arabic label
                  );
                }).toList(),
                validator: (value) => value == null ? 'مطلوب' : null,
              ),
              const SizedBox(height: 20),

              // Current PDF file display
              if (!_isPdfChanged)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: textFormBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_present, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "الملف الحالي: ${widget.analysisRecord.reportUrl.split('/').last}",
                          style: const TextStyle(fontFamily: medium),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              ElevatedButton.icon(
                      onPressed: _pickPdfFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("اختر ملف PDF جديد",
                          style: TextStyle(fontFamily: medium)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: unselectedContainerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

              if (_selectedPdfFile != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: textFormBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_present, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedPdfFile!.path.split('/').last,
                          style: const TextStyle(fontFamily: medium),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: errorColor),
                        onPressed: () {
                          setState(() {
                            _selectedPdfFile = null;
                            _isPdfChanged = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              BlocConsumer<AnalysisCubit, AnalysisState>(
                listener: (context, state) {
                  if (state is AnalysisUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("تم تعديل التحليل بنجاح",
                            style: TextStyle(fontFamily: regular)),
                        backgroundColor: primaryColor,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is AnalysisError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message,
                            style: const TextStyle(fontFamily: regular)),
                        backgroundColor: errorColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AnalysisUpdateLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ))
                      : ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يجب ملئ كل الخانات المطلوبة',
                                    style: TextStyle(fontFamily: regular),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: errorColor,
                                ),
                              );
                              return;
                            } else {
                              context
                                  .read<AnalysisCubit>()
                                  .updateAnalysisRecord(
                                    id: widget.analysisRecord.id,
                                    testName: _testNameController.text,
                                    labName: _labNameController.text,
                                    date: DateTime.parse(_dateController.text),
                                    resultSummary:
                                        _resultSummaryController.text.isNotEmpty
                                            ? _resultSummaryController.text
                                            : null,
                                    resultStatus: _resultStatus,
                                    medicalHistoryId:
                                        widget.analysisRecord.medicalHistoryId,
                                    pdfFile:
                                        _isPdfChanged ? _selectedPdfFile : null,
                                  );
                            }
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
