/// Patient Medical History Screen
///
/// Displays the patient's medical history including visits,
/// diagnoses and treatments.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/extensions/date_extensions.dart';

class PatientMedicalHistoryScreen extends StatefulWidget {
  const PatientMedicalHistoryScreen({super.key});

  @override
  State<PatientMedicalHistoryScreen> createState() =>
      _PatientMedicalHistoryScreenState();
}

class _PatientMedicalHistoryScreenState
    extends State<PatientMedicalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('medical_history')),
        elevation: 0,
      ),
      body: Column(
        children: [
          /// Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorSchemeSafe.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translateSafe('your_medical_history'),
                  style: context.textThemeSafe.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.translateSafe('medical_history_description'),
                  style: context.textThemeSafe.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Medical History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                final visitDate =
                    DateTime.now().subtract(Duration(days: index * 30));
                final nextVisit = visitDate.add(const Duration(days: 90));

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: context.colorSchemeSafe.primary,
                      child: Text(
                        '${visitDate.safeDay}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      context.translateSafe('visit_date'),
                      style: context.textThemeSafe.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          visitDate.formatDateSafe(),
                          style: context.textThemeSafe.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${context.translateSafe('next_visit')}: ${nextVisit.formatDateSafe()}',
                          style: context.textThemeSafe.bodySmall?.copyWith(
                            color: context.colorSchemeSafe.primary,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.colorSchemeSafe.primary,
                    ),
                    onTap: () {
                      _showVisitDetails(context, visitDate);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showVisitDetails(BuildContext context, DateTime visitDate) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.translateSafe('visit_details')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.translateSafe('date')}: ${visitDate.formatDateSafe()}',
                style: context.textThemeSafe.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${context.translateSafe('time')}: ${visitDate.formatTimeSafe()}',
                style: context.textThemeSafe.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                context.translateSafe('diagnosis_example'),
                style: context.textThemeSafe.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                context.translateSafe('treatment_example'),
                style: context.textThemeSafe.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.translateSafe('close')),
            ),
          ],
        );
      },
    );
  }
}

