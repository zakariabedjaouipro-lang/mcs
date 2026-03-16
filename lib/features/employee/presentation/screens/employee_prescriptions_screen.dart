import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Employee Prescriptions Screen
class EmployeePrescriptionsScreen extends StatefulWidget {
  const EmployeePrescriptionsScreen({super.key});

  @override
  State<EmployeePrescriptionsScreen> createState() =>
      _EmployeePrescriptionsScreenState();
}

class _EmployeePrescriptionsScreenState
    extends State<EmployeePrescriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('prescriptions')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translateSafe('search_prescriptions'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildPrescriptionsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getPrescriptions().length,
      itemBuilder: (context, index) {
        final prescription = _getPrescriptions()[index];
        return _buildPrescriptionCard(context, prescription);
      },
    );
  }

  Widget _buildPrescriptionCard(
      BuildContext context, Prescription prescription) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${prescription.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  '${prescription.date.day}/${prescription.date.month}/${prescription.date.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prescription.patientName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prescription.diagnosis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMedicationsList(prescription.medications),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(context.translateSafe('view_details')),
                    onPressed: () {
                      // View prescription details
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.print, size: 16),
                    label: Text(context.translateSafe('print')),
                    onPressed: () {
                      // Print prescription
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

  Widget _buildMedicationsList(List<Medication> medications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medications:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...medications.take(3).map(_buildMedicationItem),
        if (medications.length > 3)
          Text(
            '+${medications.length - 3} more medications',
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildMedicationItem(Medication medication) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${medication.name} - ${medication.dosage}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock data classes
class Prescription {
  Prescription({
    required this.id,
    required this.patientName,
    required this.diagnosis,
    required this.date,
    required this.medications,
    required this.status,
  });
  final String id;
  final String patientName;
  final String diagnosis;
  final DateTime date;
  final List<Medication> medications;
  final String status;
}

class Medication {
  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
  });
  final String name;
  final String dosage;
  final String frequency;
  final int duration;
}

List<Prescription> _getPrescriptions() {
  return [
    Prescription(
      id: 'PR-001',
      patientName: 'Ahmed Ali',
      diagnosis: 'Hypertension',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Active',
      medications: [
        Medication(
          name: 'Lisinopril',
          dosage: '10mg',
          frequency: 'Once daily',
          duration: 30,
        ),
        Medication(
          name: 'Amlodipine',
          dosage: '5mg',
          frequency: 'Once daily',
          duration: 30,
        ),
      ],
    ),
    Prescription(
      id: 'PR-002',
      patientName: 'Fatima Mohamed',
      diagnosis: 'Diabetes Type 2',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Active',
      medications: [
        Medication(
          name: 'Metformin',
          dosage: '500mg',
          frequency: 'Twice daily',
          duration: 30,
        ),
      ],
    ),
    Prescription(
      id: 'PR-003',
      patientName: 'Omar Hassan',
      diagnosis: 'Allergic Rhinitis',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Active',
      medications: [
        Medication(
          name: 'Cetirizine',
          dosage: '10mg',
          frequency: 'Once daily',
          duration: 14,
        ),
      ],
    ),
  ];
}
