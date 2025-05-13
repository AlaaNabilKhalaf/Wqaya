import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/add_analysis_view.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/analysis_cubit.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/pdf_viewer_screen.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_model.dart';
class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  final _testNameController = TextEditingController();
  final _labNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load analysis records when the view is initialized
    context.read<AnalysisCubit>().fetchAnalysisRecords();
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _labNameController.dispose();
    super.dispose();
  }





  void _openPdfUrl(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(url: url),
      ),
    );
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
        leading: IconButton(onPressed: () => Navigator.pop(context),icon : const Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: BlocConsumer<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message,style: const TextStyle(fontFamily: regular),),backgroundColor: Colors.red,),
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
                        hintStyle: const TextStyle(fontFamily: regular),
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
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAnalysisView(medicalHistoryId: 0),)),
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
                  'فتح التحليل الطبي',
                  style: TextStyle(color: Color(0xff0094FD),fontFamily: semiBold),
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