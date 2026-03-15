import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientPrescriptionsScreen extends StatefulWidget {
  const PatientPrescriptionsScreen({super.key});

  @override
  State<PatientPrescriptionsScreen> createState() =>
      _PatientPrescriptionsScreenState();
}

class _PatientPrescriptionsScreenState
    extends State<PatientPrescriptionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPrescriptions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('prescriptions')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'active') {
                context.read<PatientBloc>().add(LoadActivePrescriptions());
              } else {
                context.read<PatientBloc>().add(LoadPrescriptions());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Text(context.translateSafe('all_prescriptions')),
              ),
              PopupMenuItem(
                value: 'active',
                child: Text(context.translateSafe('active_prescriptions')),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrescriptionsLoaded) {
            if (state.prescriptions.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildPrescriptionsList(context, state.prescriptions);
          }

          if (state is ActivePrescriptionsLoaded) {
            if (state.prescriptions.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildPrescriptionsList(context, state.prescriptions);
          }

          if (state is PatientError) {
            return _buildErrorState(context, state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.translateSafe('no_prescriptions'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translateSafe('no_prescriptions_description'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList(
    BuildContext context,
    List<PrescriptionModel> prescriptions,
  ) {
    final sorted = List<PrescriptionModel>.from(prescriptions)
      ..sort((a, b) => b.prescriptionDate.compareTo(a.prescriptionDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        return _buildPrescriptionCard(context, sorted[index]);
      },
    );
  }

  Widget _buildPrescriptionCard(
    BuildContext context,
    PrescriptionModel prescription,
  ) {
    final now = DateTime.now();
    final isActive = prescription.prescriptionDate
        .add(const Duration(days: 30))
        .isAfter(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${prescription.prescriptionDate.day}/${prescription.prescriptionDate.month}/${prescription.prescriptionDate.year}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.translateSafe('active'),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              /// Doctor
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      prescription.doctorName ?? 'Doctor',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Diagnosis
              if (prescription.diagnosis != null) ...[
                Row(
                  children: [
                    const Icon(Icons.medical_information, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        prescription.diagnosis!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              /// Medications
              if (prescription.medications.isNotEmpty) ...[
                Text(
                  context.translateSafe('medications'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...prescription.getMedicationDisplay().take(3).map((med) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 8),
                        Expanded(child: Text(med)),
                      ],
                    ),
                  );
                }),
                if (prescription.medications.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${prescription.medications.length - 3} ${context.translateSafe('more')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
              ],

              const SizedBox(height: 16),

              /// Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16),
                      label: Text(context.translateSafe('download')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PatientBloc>().add(LoadPrescriptions());
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.translateSafe('retry')),
          ),
        ],
      ),
    );
  }
}
