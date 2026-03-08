/// Patients Screen with Tab Navigation
/// Displays patients with tabs for Patient List, Medical Records, and Prescriptions
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/components/empty_error_state.dart';
import 'package:mcs/core/components/medical_info_card.dart';
import 'package:mcs/core/components/skeleton_loaders.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPatientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patients',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : MedicalColors.mediumGrey,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: MedicalColors.primary,
              labelColor: MedicalColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Patient List'),
                Tab(text: 'Medical Records'),
                Tab(text: 'Prescriptions'),
              ],
            ),
          ),
        ),
      ),
      body: _hasError
          ? Center(
              child: ErrorStateWidget(
                message: 'Unable to fetch patient data',
                onRetry: _loadPatientData,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPatientListTab(),
                _buildMedicalRecordsTab(),
                _buildPrescriptionsTab(),
              ],
            ),
    );
  }

  /// Tab 1: Patient List
  Widget _buildPatientListTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(itemCount: 6),
      );
    }

    // Demo data - Replace with actual data
    final patients = [
      {
        'name': 'Fatima Al-Mazrouei',
        'age': '28',
        'condition': 'Regular Checkup',
        'icon': Icons.person,
      },
      {
        'name': 'Mohammed Al-Qasimi',
        'age': '45',
        'condition': 'Diabetes Management',
        'icon': Icons.person,
      },
      {
        'name': 'Amira Al-Dhaheri',
        'age': '32',
        'condition': 'Post-Operative Care',
        'icon': Icons.person,
      },
      {
        'name': 'Hassan Al-Mansouri',
        'age': '55',
        'condition': 'Hypertension Monitoring',
        'icon': Icons.person,
      },
      {
        'name': 'Layla Al-Kaabi',
        'age': '38',
        'condition': 'Allergy Treatment',
        'icon': Icons.person,
      },
      {
        'name': 'Rashid Al-Suwaidi',
        'age': '50',
        'condition': 'Routine Consultation',
        'icon': Icons.person,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return MedicalInfoCard(
          icon: patient['icon']! as IconData,
          title: patient['name']! as String,
          subtitle: patient['condition']! as String,
          iconColor: MedicalColors.primary,
          trailing: Text(
            '${patient['age']} yrs',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            // Navigate to patient details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing ${patient['name']}')),
            );
          },
        );
      },
    );
  }

  /// Tab 2: Medical Records
  Widget _buildMedicalRecordsTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(itemCount: 6),
      );
    }

    final records = [
      {
        'title': 'Blood Test Results',
        'subtitle': 'Glucose: 98 mg/dL, Hemoglobin: 14.5 g/dL',
        'date': '2024-01-15',
        'icon': Icons.assignment,
      },
      {
        'title': 'X-Ray Report',
        'subtitle': 'Chest X-Ray - Normal findings',
        'date': '2024-01-10',
        'icon': Icons.image,
      },
      {
        'title': 'ECG Results',
        'subtitle': 'Normal sinus rhythm',
        'date': '2024-01-05',
        'icon': Icons.favorite,
      },
      {
        'title': 'Ultrasound Report',
        'subtitle': 'Abdominal ultrasound - No abnormalities',
        'date': '2023-12-28',
        'icon': Icons.medical_services,
      },
      {
        'title': 'Vaccination Record',
        'subtitle': 'Influenza vaccine administered',
        'date': '2023-12-20',
        'icon': Icons.medical_services,
      },
    ];

    return records.isEmpty
        ? Center(
            child: EmptyStateWidget(
              icon: Icons.folder_open,
              title: 'No Medical Records',
              message: 'Medical records will appear here',
              onRefresh: _loadPatientData,
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];
              return MedicalInfoCard(
                icon: record['icon']! as IconData,
                title: record['title']! as String,
                subtitle: record['subtitle']! as String,
                iconColor: MedicalColors.secondary,
                trailing: Text(
                  record['date']! as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Viewing ${record['title']}'),
                    ),
                  );
                },
              );
            },
          );
  }

  /// Tab 3: Prescriptions
  Widget _buildPrescriptionsTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(itemCount: 6),
      );
    }

    final prescriptions = [
      {
        'title': 'Aspirin 500mg',
        'subtitle': 'Twice daily for 30 days - Pain relief',
        'date': '2024-01-20',
        'icon': Icons.medication,
      },
      {
        'title': 'Metformin 1000mg',
        'subtitle': 'Twice daily - Diabetes management',
        'date': '2024-01-15',
        'icon': Icons.medication,
      },
      {
        'title': 'Lisinopril 10mg',
        'subtitle': 'Once daily - Blood pressure control',
        'date': '2024-01-10',
        'icon': Icons.medication,
      },
      {
        'title': 'Amoxicillin 500mg',
        'subtitle': 'Three times daily for 7 days - Antibiotic',
        'date': '2024-01-05',
        'icon': Icons.medication,
      },
      {
        'title': 'Vitamin D3 1000IU',
        'subtitle': 'Once daily - Supplement',
        'date': '2023-12-28',
        'icon': Icons.health_and_safety,
      },
    ];

    return prescriptions.isEmpty
        ? Center(
            child: EmptyStateWidget(
              icon: Icons.description,
              title: 'No Prescriptions',
              message: 'Prescriptions will appear here',
              onRefresh: _loadPatientData,
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: prescriptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return MedicalInfoCard(
                icon: prescription['icon']! as IconData,
                title: prescription['title']! as String,
                subtitle: prescription['subtitle']! as String,
                iconColor: MedicalColors.accent,
                trailing: Text(
                  prescription['date']! as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Viewing ${prescription['title']}'),
                    ),
                  );
                },
              );
            },
          );
  }
}
