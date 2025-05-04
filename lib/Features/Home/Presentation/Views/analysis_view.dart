import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  final List<AnalysisRecord> _analysisList = [
    AnalysisRecord(
      type: 'Blood Test',
      date: DateTime(2025, 4, 15),
      results: {
        'Hemoglobin': '14.2 g/dL',
        'WBC': '7.5 K/uL',
        'RBC': '5.1 M/uL',
        'Platelets': '250 K/uL',
        'Cholesterol': '180 mg/dL',
      },
      normalRanges: {
        'Hemoglobin': '13.5-17.5 g/dL',
        'WBC': '4.5-11.0 K/uL',
        'RBC': '4.5-5.9 M/uL',
        'Platelets': '150-450 K/uL',
        'Cholesterol': '<200 mg/dL',
      },
      laboratory: 'LifeLabs Medical',
      documentUrl: 'assets/reports/blood_test_apr2025.pdf',
    ),
    AnalysisRecord(
      type: 'Urinalysis',
      date: DateTime(2025, 3, 22),
      results: {
        'pH': '6.0',
        'Protein': 'Negative',
        'Glucose': 'Negative',
        'Ketones': 'Negative',
        'Specific Gravity': '1.020',
      },
      normalRanges: {
        'pH': '4.5-8.0',
        'Protein': 'Negative',
        'Glucose': 'Negative',
        'Ketones': 'Negative',
        'Specific Gravity': '1.005-1.030',
      },
      laboratory: 'City Hospital Lab',
      documentUrl: 'assets/reports/urinalysis_mar2025.pdf',
    ),
    AnalysisRecord(
      type: 'Liver Function Test',
      date: DateTime(2025, 2, 10),
      results: {
        'ALT': '25 U/L',
        'AST': '27 U/L',
        'ALP': '72 U/L',
        'Bilirubin': '0.8 mg/dL',
        'Albumin': '4.2 g/dL',
      },
      normalRanges: {
        'ALT': '7-56 U/L',
        'AST': '10-40 U/L',
        'ALP': '44-147 U/L',
        'Bilirubin': '0.1-1.2 mg/dL',
        'Albumin': '3.4-5.4 g/dL',
      },
      laboratory: 'HealthFirst Diagnostics',
      documentUrl: 'assets/reports/liver_test_feb2025.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xff0094FD),
        title: const Text(
          'Analysis Records',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
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
                  'Your Health Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total records: ${_analysisList.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search analysis records...',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1678F2),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show filter/sort options
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Filter',
                        style: TextStyle(color: Color(0xff0094FD)),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.filter_list,
                        color: Color(0xff0094FD),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _analysisList.length,
              itemBuilder: (context, index) {
                final analysis = _analysisList[index];
                return AnalysisCard(analysis: analysis);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          // Add new analysis record
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  final AnalysisRecord analysis;

  const AnalysisCard({Key? key, required this.analysis}) : super(key: key);

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
                    analysis.type,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff1678F2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${DateFormat('MMM d, yyyy').format(analysis.date)}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Lab: ${analysis.laboratory}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          const Divider(),
          ...analysis.results.entries.map((entry) {
            final paramName = entry.key;
            final value = entry.value;
            final normalRange = analysis.normalRanges[paramName];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    paramName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0094FD),
                        ),
                      ),
                      Text(
                        'Normal: $normalRange',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Open PDF viewer
                },
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
              IconButton(
                onPressed: () {
                  // Share report
                },
                icon: const Icon(
                  Icons.share,
                  color: Color(0xff7EB8FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnalysisRecord {
  final String type;
  final DateTime date;
  final Map<String, String> results;
  final Map<String, String> normalRanges;
  final String laboratory;
  final String documentUrl;

  AnalysisRecord({
    required this.type,
    required this.date,
    required this.results,
    required this.normalRanges,
    required this.laboratory,
    required this.documentUrl,
  });
}