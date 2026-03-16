import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Doctor Patients Screen
class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('patients')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sorting/filtering
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'name',
                child: Text(context.translateSafe('sort_by_name')),
              ),
              PopupMenuItem(
                value: 'date',
                child: Text(context.translateSafe('sort_by_date')),
              ),
              PopupMenuItem(
                value: 'last_visit',
                child: Text(context.translateSafe('sort_by_last_visit')),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translateSafe('search_patients'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildPatientsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getPatients().length,
      itemBuilder: (context, index) {
        final patient = _getPatients()[index];
        return _buildPatientCard(context, patient);
      },
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to patient details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          patient.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getGenderColor(context, patient.gender),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            patient.gender,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.cake, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${patient.age} ${context.translateSafe('years_old')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.phone, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          patient.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${context.translateSafe('last_visit')}: ${patient.lastVisit}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getGenderColor(BuildContext context, String gender) {
    if (gender.toLowerCase().contains('male') ||
        gender.toLowerCase().contains('ذكر')) {
      return Colors.blue;
    } else if (gender.toLowerCase().contains('female') ||
        gender.toLowerCase().contains('أنثى')) {
      return Colors.pink;
    }
    return Colors.grey;
  }
}

// Mock data classes
class Patient {
  Patient({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.lastVisit,
    required this.nextAppointment,
  });
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String lastVisit;
  final String nextAppointment;
}

List<Patient> _getPatients() {
  return [
    Patient(
      name: 'Ahmed Ali',
      age: 35,
      gender: 'Male',
      phone: '+971 50 123 4567',
      lastVisit: '2024-01-15',
      nextAppointment: '2024-02-15',
    ),
    Patient(
      name: 'Fatima Mohamed',
      age: 28,
      gender: 'Female',
      phone: '+971 50 987 6543',
      lastVisit: '2024-01-10',
      nextAppointment: '2024-02-10',
    ),
    Patient(
      name: 'Omar Hassan',
      age: 45,
      gender: 'Male',
      phone: '+971 50 555 1234',
      lastVisit: '2024-01-05',
      nextAppointment: '2024-02-05',
    ),
    Patient(
      name: 'Layla Ahmed',
      age: 32,
      gender: 'Female',
      phone: '+971 50 777 8888',
      lastVisit: '2024-01-01',
      nextAppointment: '2024-02-01',
    ),
    Patient(
      name: 'Khalid Omar',
      age: 50,
      gender: 'Male',
      phone: '+971 50 999 0000',
      lastVisit: '2023-12-25',
      nextAppointment: '2024-01-25',
    ),
  ];
}
