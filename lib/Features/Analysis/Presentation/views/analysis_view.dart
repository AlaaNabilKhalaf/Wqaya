import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/analysis_cubit.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_model.dart';
import 'package:url_launcher/url_launcher.dart';
class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  File? _selectedPdfFile;
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _labNameController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // Load analysis records when the view is initialized
    context.read<AnalysisCubit>().fetchAnalysisRecords();
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _labNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickPdfFile() async {
    final file = await context.read<AnalysisCubit>().pickPdfFile();
    if (file != null) {
      setState(() {
        _selectedPdfFile = file;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedPdfFile != null) {
      context.read<AnalysisCubit>().uploadAnalysisRecord(
        testName: _testNameController.text,
        labName: _labNameController.text,
        date: _selectedDate,
        medicalHistoryId: 56, // This would typically come from user context or previous screen
        pdfFile: _selectedPdfFile!,
      );
    } else if (_selectedPdfFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file')),
      );
    }
  }

  void _showAddAnalysisSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Analysis Record',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1678F2),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _testNameController,
                  decoration: const InputDecoration(
                    labelText: 'Test Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter test name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _labNameController,
                  decoration: const InputDecoration(
                    labelText: 'Laboratory Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter laboratory name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _pickDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(DateFormat('MMM d, yyyy').format(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7EB8FF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _pickPdfFile,
                  icon: const Icon(Icons.file_upload),
                  label: Text(_selectedPdfFile != null
                      ? 'Selected: ${_selectedPdfFile!.path.split('/').last}'
                      : 'Select PDF File'),
                ),
                const SizedBox(height: 16),
                BlocConsumer<AnalysisCubit, AnalysisState>(
                  listener: (context, state) {
                    if (state is AnalysisUploadSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      Navigator.pop(context);
                      _testNameController.clear();
                      _labNameController.clear();
                      setState(() {
                        _selectedPdfFile = null;
                        _selectedDate = DateTime.now();
                      });
                    } else if (state is AnalysisError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0094FD),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: state is AnalysisUploading ? null : _submitForm,
                      child: state is AnalysisUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit', style: TextStyle(fontSize: 16)),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPdfUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the report')),
        );
      }
    }
  }

  String _getSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xff0094FD),
        title: const Text(
          'التحاليل الطبية',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: black),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xff0094FD),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تحاليلكم الطبية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: regular
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state is AnalysisLoaded
                          ? 'عدد التحاليل : ${state.totalCount}'
                          : 'عدد التحاليل: 0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: regular
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _getSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'البحث في تحاليلكم الطبية',
                        filled: true,
                        fillColor: const Color(0xffF1F6FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff1678F2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التحاليل ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1678F2),
                        fontFamily: black
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     // Show filter/sort options
                    //   },
                    //   child: const Row(
                    //     children: [
                    //       Text(
                    //         'Filter',
                    //         style: TextStyle(color: Color(0xff0094FD)),
                    //       ),
                    //       SizedBox(width: 4),
                    //       Icon(
                    //         Icons.filter_list,
                    //         color: Color(0xff0094FD),
                    //         size: 18,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: state is AnalysisLoading
                    ? const Center(child: CircularProgressIndicator(backgroundColor: primaryColor,))
                    : state is AnalysisLoaded
                    ? _buildAnalysisList(state.records)
                    : const Center(child: Text("لا تحاليل متاحة",style: TextStyle(fontFamily: semiBold),)),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: _showAddAnalysisSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAnalysisList(List<AnalysisRecord> records) {
    if (records.isEmpty) {
      return const Center(child: Text("لا تحاليل متاحة",style: TextStyle(fontFamily: semiBold),));
    }

    final filteredRecords = _getSearchQuery.isEmpty
        ? records
        : records.where((record) =>
    record.testName.toLowerCase().contains(_getSearchQuery.toLowerCase()) ||
        record.labName.toLowerCase().contains(_getSearchQuery.toLowerCase())).toList();

    if (filteredRecords.isEmpty) {
      return const Center(child: Text("لا تحاليل متاحة",style: TextStyle(fontFamily: semiBold),));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<AnalysisCubit>().fetchAnalysisRecords(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredRecords.length,
        itemBuilder: (context, index) {
          final analysis = filteredRecords[index];
          return AnalysisCard(
            analysis: analysis,
            onViewReport: () => _openPdfUrl(analysis.reportUrl),
          );
        },
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  final AnalysisRecord analysis;
  final VoidCallback onViewReport;

  const AnalysisCard({
    super.key,
    required this.analysis,
    required this.onViewReport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff7EB8FF).withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.science_outlined,
                color: Color(0xff0094FD),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.testName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff1678F2),
                        fontFamily: bold

                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'التاريخ: ${analysis.formattedDate}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontFamily: regular
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'المعمل: ${analysis.labName}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                        fontFamily: regular
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          const Divider(),
          if (analysis.resultSummary != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Results Summary:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(analysis.resultSummary!),
                ],
              ),
            ),
          ],
          if (analysis.resultStatus != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    analysis.resultStatus!,
                    style: TextStyle(
                      color: analysis.resultStatus!.toLowerCase() == 'normal'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onViewReport,
                icon: const Icon(
                  Icons.remove_red_eye,
                  size: 16,
                  color: Color(0xff0094FD),
                ),
                label: const Text(
                  'View Full Report',
                  style: TextStyle(color: Color(0xff0094FD)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff0094FD)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}