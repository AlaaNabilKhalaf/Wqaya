import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Medicine> _currentMedicines = [
    Medicine(
      name: 'Amoxicillin',
      dosage: '500mg',
      frequency: '3 times daily',
      startDate: DateTime(2025, 4, 25),
      endDate: DateTime(2025, 5, 10),
      instructions: 'Take with food',
      imageUrl: 'assets/medicines/amoxicillin.png',
      prescribedBy: 'Dr. Richard Brown',
      pillsRemaining: 15,
      type: MedicineType.antibiotic,
    ),
    Medicine(
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      startDate: DateTime(2025, 1, 15),
      endDate: null, // Ongoing
      instructions: 'Take in the morning',
      imageUrl: 'assets/medicines/lisinopril.png',
      prescribedBy: 'Dr. Maria Lopez',
      pillsRemaining: 45,
      type: MedicineType.bloodPressure,
    ),
    Medicine(
      name: 'Vitamin D3',
      dosage: '1000 IU',
      frequency: 'Once daily',
      startDate: DateTime(2025, 2, 10),
      endDate: null, // Ongoing
      instructions: 'Take with a meal',
      imageUrl: 'assets/medicines/vitamin_d.png',
      prescribedBy: 'Self',
      pillsRemaining: 60,
      type: MedicineType.supplement,
    ),
  ];

  final List<Medicine> _pastMedicines = [
    Medicine(
      name: 'Prednisone',
      dosage: '20mg',
      frequency: 'Once daily, tapering dose',
      startDate: DateTime(2025, 1, 5),
      endDate: DateTime(2025, 2, 2),
      instructions: 'Take in the morning with food',
      imageUrl: 'assets/medicines/prednisone.png',
      prescribedBy: 'Dr. James Wilson',
      pillsRemaining: 0,
      type: MedicineType.steroid,
    ),
    Medicine(
      name: 'Azithromycin',
      dosage: '250mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 12, 10),
      endDate: DateTime(2024, 12, 15),
      instructions: 'Take on an empty stomach',
      imageUrl: 'assets/medicines/azithromycin.png',
      prescribedBy: 'Dr. Sarah Johnson',
      pillsRemaining: 0,
      type: MedicineType.antibiotic,
    ),
  ];

  final List<bool> _todayMedicationsTaken = [false, false, true];
  final List<Reminder> _medicationReminders = [
    Reminder(time: '08:00 AM', taken: true),
    Reminder(time: '01:00 PM', taken: false),
    Reminder(time: '08:00 PM', taken: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xff0094FD),
        title: const Text(
          'Medications',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
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
          _buildHeader(),
          _buildReminderSection(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentMedicinesList(),
                _buildPastMedicinesList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          // Add new medication
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            'Your Medications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Active medications: ${_currentMedicines.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Track adherence',
                  style: TextStyle(
                    color: Color(0xff1678F2),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search medications...',
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
    );
  }

  Widget _buildReminderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1678F2),
                ),
              ),
              Text(
                DateFormat('EEE, MMM d').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _medicationReminders.length,
                  (index) => _buildReminderTime(_medicationReminders[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTime(Reminder reminder) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: reminder.taken
                ? const Color(0xff0094FD).withValues(alpha: .1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: reminder.taken
                  ? const Color(0xff0094FD)
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: reminder.taken
                ? const Icon(
              Icons.check,
              color: Color(0xff0094FD),
            )
                : const Icon(
              Icons.medication_outlined,
              color: Color(0xff7EB8FF),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          reminder.time,
          style: TextStyle(
            color: reminder.taken ? const Color(0xff0094FD) : Colors.grey[600],
            fontWeight: reminder.taken ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffEBF0F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xff0094FD),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xff1678F2),
        tabs: const [
          Tab(text: 'Current'),
          Tab(text: 'Past'),
        ],
      ),
    );
  }

  Widget _buildCurrentMedicinesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentMedicines.length,
      itemBuilder: (context, index) {
        final medicine = _currentMedicines[index];
        return MedicineCard(
          medicine: medicine,
          isActive: true,
          onTakenToggle: (value) {
            setState(() {
              _todayMedicationsTaken[index] = value;
            });
          },
          isTaken: _todayMedicationsTaken[index],
        );
      },
    );
  }

  Widget _buildPastMedicinesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pastMedicines.length,
      itemBuilder: (context, index) {
        final medicine = _pastMedicines[index];
        return MedicineCard(
          medicine: medicine,
          isActive: false,
          onTakenToggle: null, // No toggle for past medicines
          isTaken: false,
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final bool isActive;
  final bool isTaken;
  final Function(bool)? onTakenToggle;

  const MedicineCard({
    Key? key,
    required this.medicine,
    required this.isActive,
    required this.isTaken,
    this.onTakenToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMedicineImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              medicine.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff1678F2),
                              ),
                            ),
                          ),
                          _buildMedicineTypeChip(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medicine.dosage}, ${medicine.frequency}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Prescribed by: ${medicine.prescribedBy}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDurationInfo(),
            if (isActive) _buildPillsRemainingBar(),
            const SizedBox(height: 12),
            _buildInstructions(),
            if (isActive) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff7EB8FF).withValues(alpha: .2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          medicine.imageUrl,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.medication,
              size: 30,
              color: Color(0xff0094FD),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMedicineTypeChip() {
    Color chipColor;
    String label;

    switch (medicine.type) {
      case MedicineType.antibiotic:
        chipColor = Colors.green;
        label = 'Antibiotic';
        break;
      case MedicineType.bloodPressure:
        chipColor = Colors.red;
        label = 'BP Med';
        break;
      case MedicineType.supplement:
        chipColor = Colors.orange;
        label = 'Supplement';
        break;
      case MedicineType.steroid:
        chipColor = Colors.purple;
        label = 'Steroid';
        break;
      default:
        chipColor = Colors.blue;
        label = 'Medication';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: .5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    final startDateStr = DateFormat('MMM d, yyyy').format(medicine.startDate);
    final endDateStr = medicine.endDate != null
        ? DateFormat('MMM d, yyyy').format(medicine.endDate!)
        : 'Ongoing';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF1F6FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: Color(0xff0094FD),
          ),
          const SizedBox(width: 8),
          Text(
            'From: $startDateStr',
            style: const TextStyle(fontSize: 13),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward,
            size: 16,
            color: Color(0xff7EB8FF),
          ),
          const SizedBox(width: 8),
          Text(
            'To: $endDateStr',
            style: TextStyle(
              fontSize: 13,
              fontWeight: medicine.endDate == null ? FontWeight.bold : FontWeight.normal,
              color: medicine.endDate == null ? const Color(0xff1678F2) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillsRemainingBar() {
    final percentage = (medicine.pillsRemaining / 100).clamp(0.0, 1.0);
    Color barColor;

    if (percentage > 0.6) {
      barColor = Colors.green;
    } else if (percentage > 0.3) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pills remaining: ${medicine.pillsRemaining}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            if (medicine.pillsRemaining < 10)
              GestureDetector(
                onTap: () {
                  // Refill functionality
                },
                child: const Text(
                  'Refill',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0094FD),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (percentage * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Expanded(
                flex: ((1 - percentage) * 100).toInt(),
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff0094FD).withValues(alpha: .05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff7EB8FF).withValues(alpha: .3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff1678F2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            medicine.instructions,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (onTakenToggle != null) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  onTakenToggle!(!isTaken);
                },
                icon: Icon(
                  isTaken ? Icons.check_circle : Icons.check_circle_outline,
                  size: 16,
                ),
                label: Text(isTaken ? 'Taken' : 'Mark as taken'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTaken ? Colors.green : const Color(0xff0094FD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          IconButton(
            onPressed: () {
              // Set reminder
            },
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xff7EB8FF),
            ),
          ),
          IconButton(
            onPressed: () {
              // More options
            },
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xff7EB8FF),
            ),
          ),
        ],
      ),
    );
  }
}

enum MedicineType {
  antibiotic,
  bloodPressure,
  painkiller,
  supplement,
  steroid,
  other,
}

class Medicine {
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate; // null means ongoing
  final String instructions;
  final String imageUrl;
  final String prescribedBy;
  final int pillsRemaining;
  final MedicineType type;

  Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.instructions,
    required this.imageUrl,
    required this.prescribedBy,
    required this.pillsRemaining,
    required this.type,
  });
}

class Reminder {
  final String time;
  final bool taken;

  Reminder({required this.time, required this.taken});
}