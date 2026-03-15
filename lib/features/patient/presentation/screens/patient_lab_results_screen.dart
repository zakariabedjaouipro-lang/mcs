/// Patient Lab Results Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientLabResultsScreen extends StatefulWidget {
  const PatientLabResultsScreen({super.key});

  @override
  State<PatientLabResultsScreen> createState() =>
      _PatientLabResultsScreenState();
}

class _PatientLabResultsScreenState extends State<PatientLabResultsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadLabResults());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('lab_results')),
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LabResultsLoaded) {
            if (state.results.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildLabResultsList(state.results);
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
          Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.translateSafe('no_lab_results'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translateSafe('no_lab_results_description'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultsList(List<LabResultModel> results) {
    final sortedResults = List<LabResultModel>.from(results)
      ..sort((a, b) => b.resultDate.compareTo(a.resultDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedResults.length,
      itemBuilder: (context, index) {
        final result = sortedResults[index];
        return _buildLabResultCard(context, result);
      },
    );
  }

  Widget _buildLabResultCard(BuildContext context, LabResultModel result) {
    Color statusColor;
    String statusText;

    switch (result.status) {
      case 'normal':
        statusColor = Colors.green;
        statusText = context.translateSafe('normal');

      case 'abnormal':
        statusColor = Colors.orange;
        statusText = context.translateSafe('abnormal');

      case 'critical':
        statusColor = Colors.red;
        statusText = context.translateSafe('critical');

      default:
        statusColor = Colors.grey;
        statusText = result.status;
    }

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
                  Expanded(
                    child: Text(
                      result.testName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Date + Doctor
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${result.resultDate.day}/${result.resultDate.month}/${result.resultDate.year}',
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      result.doctorName ?? 'Doctor',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              if (result.labName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        result.labName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              if (result.notes != null && result.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  result.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 16),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<PatientBloc>()
                            .add(DownloadLabResult(result.id));
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: Text(context.translateSafe('download')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, size: 16),
                      label: Text(context.translateSafe('share')),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PatientBloc>().add(LoadLabResults());
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.translateSafe('retry')),
          ),
        ],
      ),
    );
  }
}
