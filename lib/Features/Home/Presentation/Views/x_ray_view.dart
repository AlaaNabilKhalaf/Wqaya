import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class XRayScreen extends StatefulWidget {
  const XRayScreen({Key? key}) : super(key: key);

  @override
  State<XRayScreen> createState() => _XRayScreenState();
}

class _XRayScreenState extends State<XRayScreen> {
  final List<XRayRecord> _xrayList = [
    XRayRecord(
      type: 'Chest X-Ray',
      date: DateTime(2025, 4, 20),
      bodyPart: 'Chest',
      findings: 'Normal lung fields. Heart size within normal limits. No effusion or pneumothorax.',
      recommendation: 'No follow-up required.',
      imageUrl: 'assets/xrays/chest_xray_apr2025.jpg',
      radiologist: 'Dr. Sarah Johnson',
      facility: 'General Hospital Radiology',
    ),
    XRayRecord(
      type: 'Left Ankle X-Ray',
      date: DateTime(2025, 3, 5),
      bodyPart: 'Left Ankle',
      findings: 'No fracture or dislocation. Soft tissue swelling present lateral malleolus.',
      recommendation: 'Follow-up in 2 weeks if symptoms persist.',
      imageUrl: 'assets/xrays/ankle_xray_mar2025.jpg',
      radiologist: 'Dr. Michael Chen',
      facility: 'Orthopedic Imaging Center',
    ),
    XRayRecord(
      type: 'Dental Panoramic X-Ray',
      date: DateTime(2025, 2, 12),
      bodyPart: 'Jaw & Teeth',
      findings: 'Complete dentition. Impacted lower third molars bilaterally. No caries or periapical lesions visible.',
      recommendation: 'Consult with oral surgeon regarding wisdom teeth.',
      imageUrl: 'assets/xrays/dental_xray_feb2025.jpg',
      radiologist: 'Dr. Amanda Garcia',
      facility: 'Smile Dental Clinic',
    ),
    XRayRecord(
      type: 'Right Hand X-Ray',
      date: DateTime(2025, 1, 18),
      bodyPart: 'Right Hand',
      findings: 'Hairline fracture of 5th metacarpal. No displacement.',
      recommendation: 'Cast for 4 weeks. Follow-up imaging after cast removal.',
      imageUrl: 'assets/xrays/hand_xray_jan2025.jpg',
      radiologist: 'Dr. James Wilson',
      facility: 'Urgent Care Radiology',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xff0094FD),
        title: const Text(
          'X-Ray Records',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                  'Your X-Ray Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total records: ${_xrayList.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search X-ray records...',
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
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff7EB8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () {
                          // Show filter options
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', 0),
                _buildFilterChip('Chest', 1),
                _buildFilterChip('Bone', 2),
                _buildFilterChip('Dental', 3),
                _buildFilterChip('Spine', 4),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _xrayList.length,
              itemBuilder: (context, index) {
                final xray = _xrayList[index];
                return XRayCard(xray: xray);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          // Add new X-ray record
        },
        child: const Icon(Icons.add_photo_alternate, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedIndex == index,
        onSelected: (bool selected) {
          setState(() {
            _selectedIndex = selected ? index : 0;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xff0094FD),
        labelStyle: TextStyle(
          color: _selectedIndex == index ? Colors.white : const Color(0xff1678F2),
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class XRayCard extends StatelessWidget {
  final XRayRecord xray;

  const XRayCard({Key? key, required this.xray}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // X-ray image preview with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  xray.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: const Color(0xff7EB8FF).withValues(alpha: .3),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Color(0xff0094FD),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xff0094FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('MMM d, yyyy').format(xray.date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        xray.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff1678F2),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen,
                        color: Color(0xff0094FD),
                      ),
                      onPressed: () {
                        // Open full screen view
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, 'Radiologist', xray.radiologist),
                const SizedBox(height: 4),
                _buildInfoRow(Icons.local_hospital, 'Facility', xray.facility),
                const SizedBox(height: 4),
                _buildInfoRow(Icons.accessibility_new, 'Body Part', xray.bodyPart),
                const Divider(height: 24),
                const Text(
                  'Findings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff1678F2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  xray.findings,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Recommendation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff1678F2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  xray.recommendation,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Download X-ray image
                      },
                      icon: const Icon(
                        Icons.download,
                        size: 16,
                        color: Color(0xff0094FD),
                      ),
                      label: const Text(
                        'Download',
                        style: TextStyle(color: Color(0xff0094FD)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xff0094FD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Share X-ray record
                      },
                      icon: const Icon(
                        Icons.share,
                        size: 16,
                      ),
                      label: const Text('Share with Doctor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0094FD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xff7EB8FF),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class XRayRecord {
  final String type;
  final DateTime date;
  final String bodyPart;
  final String findings;
  final String recommendation;
  final String imageUrl;
  final String radiologist;
  final String facility;

  XRayRecord({
    required this.type,
    required this.date,
    required this.bodyPart,
    required this.findings,
    required this.recommendation,
    required this.imageUrl,
    required this.radiologist,
    required this.facility,
  });
}