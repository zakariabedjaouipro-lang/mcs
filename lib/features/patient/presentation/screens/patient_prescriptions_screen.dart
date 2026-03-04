/// Patient Prescriptions Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient prescriptions screen
class PatientPrescriptionsScreen extends StatefulWidget {
  const PatientPrescriptionsScreen({super.key});

  @override
  State<PatientPrescriptionsScreen> createState() => _PatientPrescriptionsScreenState();
}

class _PatientPrescriptionsScreenState extends State<PatientPrescriptionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPrescriptions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('prescriptions')),
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
                child: Text(AppLocalizations.of(context).translate('all_prescriptions')),
              ),
              PopupMenuItem(
                value: 'active',
                child: Text(AppLocalizations.of(context).translate('active_prescriptions')),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrescriptionsLoaded) {
            if (state.prescriptions.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildPrescriptionsList(state.prescriptions);
          } else if (state is ActivePrescriptionsLoaded) {
            if (state.prescriptions.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildPrescriptionsList(state.prescriptions);
          } else if (state is PatientError) {
            return _buildErrorState(state.message);
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
          Icon(
            Icons.medication_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('no_prescriptions'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).translate('no_prescriptions_description'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList(List<PrescriptionModel> prescriptions) {
    // Sort by date (most recent first)
    final sortedPrescriptions = List<PrescriptionModel>.from(prescriptions)
      ..sort((a, b) => b.prescriptionDate.compareTo(a.prescriptionDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedPrescriptions.length,
      itemBuilder: (context, index) {
        final prescription = sortedPrescriptions[index];
        return _buildPrescriptionCard(prescription);
      },
    );
  }

  Widget _buildPrescriptionCard(PrescriptionModel prescription) {
    final isActive = prescription.isActive;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to prescription details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('active'),
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
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    prescription.doctorName ?? 'Doctor Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (prescription.diagnosis != null) ...[
                Row(
                  children: [
                    const Icon(Icons.medical_information, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        prescription.diagnosis!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (prescription.medications != null && prescription.medications!.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context).translate('medications'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...prescription.medications!.take(3).map((med) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            med,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (prescription.medications!.length > 3) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+${prescription.medications!.length - 3} ${AppLocalizations.of(context).translate('more')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Download prescription
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: Text(AppLocalizations.of(context).translate('download')),
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PatientBloc>().add(LoadPrescriptions());
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context).translate('retry')),
          ),
        ],
      ),
    );
  }
}