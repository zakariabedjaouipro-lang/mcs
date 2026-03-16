import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Admin Clinics Screen
class AdminClinicsScreen extends StatefulWidget {
  const AdminClinicsScreen({super.key});

  @override
  State<AdminClinicsScreen> createState() => _AdminClinicsScreenState();
}

class _AdminClinicsScreenState extends State<AdminClinicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('clinics')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new clinic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translateSafe('search_clinics'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildClinicsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getClinics().length,
      itemBuilder: (context, index) {
        final clinic = _getClinics()[index];
        return _buildClinicCard(context, clinic);
      },
    );
  }

  Widget _buildClinicCard(BuildContext context, Clinic clinic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    clinic.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: clinic.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    clinic.isActive ? context.translateSafe('active') : context.translateSafe('inactive'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    clinic.address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Text(
                  clinic.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    clinic.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(context, Icons.people, clinic.doctorsCount.toString(), context.translateSafe('doctors')),
                _buildStatItem(context, Icons.medical_services, clinic.patientsCount.toString(), context.translateSafe('patients')),
                _buildStatItem(context, Icons.pending_actions, clinic.appointmentsCount.toString(), context.translateSafe('appointments')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(context.translateSafe('view_details')),
                    onPressed: () {
                      // View clinic details
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(context.translateSafe('edit')),
                    onPressed: () {
                      // Edit clinic
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

// Mock data classes
class Clinic {
  final String name;
  final String address;
  final String phone;
  final String email;
  final bool isActive;
  final int doctorsCount;
  final int patientsCount;
  final int appointmentsCount;

  Clinic({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.doctorsCount,
    required this.patientsCount,
    required this.appointmentsCount,
  });
}

List<Clinic> _getClinics() {
  return [
    Clinic(
      name: 'Al Noor Medical Center',
      address: 'Sheikh Zayed Road, Dubai, UAE',
      phone: '+971 4 123 4567',
      email: 'info@alnoorclinic.com',
      isActive: true,
      doctorsCount: 12,
      patientsCount: 1250,
      appointmentsCount: 45,
    ),
    Clinic(
      name: 'Family Care Clinic',
      address: 'Al Barsha, Dubai, UAE',
      phone: '+971 4 987 6543',
      email: 'info@familycare.com',
      isActive: true,
      doctorsCount: 8,
      patientsCount: 890,
      appointmentsCount: 32,
    ),
    Clinic(
      name: 'Specialist Medical Center',
      address: 'Jumeirah, Dubai, UAE',
      phone: '+971 4 555 1234',
      email: 'info@specialist.com',
      isActive: false,
      doctorsCount: 5,
      patientsCount: 420,
      appointmentsCount: 18,
    ),
  ];
}