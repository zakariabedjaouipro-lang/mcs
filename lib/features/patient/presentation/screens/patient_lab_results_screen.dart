/// Patient Lab Results Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient lab results screen
class PatientLabResultsScreen extends StatefulWidget {
  const PatientLabResultsScreen({super.key});

  @override
  State<PatientLabResultsScreen> createState() => _PatientLabResultsScreenState();
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
        title: Text(AppLocalizations.of(context).translate('lab_results')),
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LabResultsLoaded) {
            if (state.results.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildLabResultsList(state.results);
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
            Icons.science_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('no_lab_results'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).translate('no_lab_results_description'),
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
    // Sort by date (most recent first)
    final sortedResults = List<LabResultModel>.from(results)
      ..sort((a, b) => b.resultDate.compareTo(a.resultDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedResults.length,
      itemBuilder: (context, index) {
        final result = sortedResults[index];
        return _buildLabResultCard(result);
      },
    );
  }

  Widget _buildLabResultCard(LabResultModel result) {
    Color statusColor;
    String statusText;
    
    switch (result.status) {
      case 'normal':
        statusColor = Colors.green;
        statusText = AppLocalizations.of(context).translate('normal');
        break;
      case 'abnormal':
        statusColor = Colors.orange;
        statusText = AppLocalizations.of(context).translate('abnormal');
        break;
      case 'critical':
        statusColor = Colors.red;
        statusText = AppLocalizations.of(context).translate('critical');
        break;
      default:
        statusColor = Colors.grey;
        statusText = result.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to lab result details
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
                    result.testName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
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
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${result.resultDate.day}/${result.resultDate.month}/${result.resultDate.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    result.doctorName ?? 'Doctor Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
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
                    Text(
                      result.labName!,
                      style: Theme.of(context).textTheme.bodyMedium,
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<PatientBloc>().add(DownloadLabResult(result.id));
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: Text(AppLocalizations.of(context).translate('download')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Share result
                      },
                      icon: const Icon(Icons.share, size: 16),
                      label: Text(AppLocalizations.of(context).translate('share')),
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
              context.read<PatientBloc>().add(LoadLabResults());
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context).translate('retry')),
          ),
        ],
      ),
    );
  }
}