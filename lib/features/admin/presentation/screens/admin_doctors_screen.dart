import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Admin Doctors Screen
class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('doctors')),
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
                value: 'specialty',
                child: Text(context.translateSafe('sort_by_specialty')),
              ),
              PopupMenuItem(
                value: 'status',
                child: Text(context.translateSafe('sort_by_status')),
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
                hintText: context.translateSafe('search_doctors'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildDoctorsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getDoctors().length,
      itemBuilder: (context, index) {
        final doctor = _getDoctors()[index];
        return _buildDoctorCard(context, doctor);
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to doctor details
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
                          'Dr. ${doctor.name}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(context, doctor.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            doctor.status,
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
                        const Icon(Icons.medical_services, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          doctor.specialty,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          doctor.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.email,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            overflow: TextOverflow.ellipsis,
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

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'on leave':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// Mock data classes
class Doctor {
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String status;
  final String clinic;
  final int yearsOfExperience;

  Doctor({
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    required this.status,
    required this.clinic,
    required this.yearsOfExperience,
  });
}

List<Doctor> _getDoctors() {
  return [
    Doctor(
      name: 'Mohamed Hassan',
      specialty: 'Cardiology',
      phone: '+971 50 123 4567',
      email: 'mohamed.hassan@hospital.com',
      status: 'Active',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 10,
    ),
    Doctor(
      name: 'Sarah Ahmed',
      specialty: 'Dermatology',
      phone: '+971 50 987 6543',
      email: 'sarah.ahmed@hospital.com',
      status: 'Active',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 8,
    ),
    Doctor(
      name: 'Ali Mohamed',
      specialty: 'Orthopedics',
      phone: '+971 50 555 1234',
      email: 'ali.mohamed@hospital.com',
      status: 'On Leave',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 12,
    ),
    Doctor(
      name: 'Fatima Khalid',
      specialty: 'Pediatrics',
      phone: '+971 50 777 8888',
      email: 'fatima.khalid@hospital.com',
      status: 'Active',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 6,
    ),
    Doctor(
      name: 'Ahmed Omar',
      specialty: 'Neurology',
      phone: '+971 50 999 0000',
      email: 'ahmed.omar@hospital.com',
      status: 'Pending',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 15,
    ),
  ];
}