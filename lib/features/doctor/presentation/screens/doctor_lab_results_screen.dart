import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Doctor Lab Results Screen
class DoctorLabResultsScreen extends StatefulWidget {
  const DoctorLabResultsScreen({super.key});

  @override
  State<DoctorLabResultsScreen> createState() => _DoctorLabResultsScreen();
}

class _DoctorLabResultsScreen extends State<DoctorLabResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('lab_results')),
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
                hintText: context.translateSafe('search_lab_results'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            child: _buildLabResultsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getLabResults().length,
      itemBuilder: (context, index) {
        final result = _getLabResults()[index];
        return _buildLabResultCard(context, result);
      },
    );
  }

  Widget _buildLabResultCard(BuildContext context, LabResult result) {
    final statusColor = _getStatusColor(result.status);

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
                SizedBox(
                  child: Text(
                    result.testName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.status,
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
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8),
                SizedBox(
                  child: Text(
                    result.patientName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${result.date.day}/${result.date.month}/${result.date.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (result.labName != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    result.labName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (result.results.isNotEmpty) ...[
              const Text(
                'Results:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...result.results.take(3).map(_buildResultItem),
              if (result.results.length > 3)
                Text(
                  '+${result.results.length - 3} more results',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(context.translateSafe('view_details')),
                    onPressed: () {
                      // View result details
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download, size: 16),
                    label: Text(context.translateSafe('download_report')),
                    onPressed: () {
                      // Download report
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

  Widget _buildResultItem(LabResultItem result) {
    var valueColor = Colors.black;
    if (result.isAbnormal) {
      valueColor = Colors.orange;
    } else if (result.isCritical) {
      valueColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              result.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              result.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              result.unit,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              result.range,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'abnormal':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Mock data classes
class LabResult {
  LabResult({
    required this.testName,
    required this.patientName,
    required this.date,
    required this.status,
    required this.results,
    this.labName,
  });
  final String testName;
  final String patientName;
  final DateTime date;
  final String status;
  final String? labName;
  final List<LabResultItem> results;
}

class LabResultItem {
  LabResultItem({
    required this.name,
    required this.value,
    required this.unit,
    required this.range,
    required this.isAbnormal,
    required this.isCritical,
  });
  final String name;
  final String value;
  final String unit;
  final String range;
  final bool isAbnormal;
  final bool isCritical;
}

List<LabResult> _getLabResults() {
  return [
    LabResult(
      testName: 'Complete Blood Count (CBC)',
      patientName: 'Ahmed Ali',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Normal',
      labName: 'Central Lab',
      results: [
        LabResultItem(
          name: 'Hemoglobin',
          value: '14.2',
          unit: 'g/dL',
          range: '12.0-16.0',
          isAbnormal: false,
          isCritical: false,
        ),
        LabResultItem(
          name: 'WBC',
          value: '7.2',
          unit: 'x10³/μL',
          range: '4.0-11.0',
          isAbnormal: false,
          isCritical: false,
        ),
        LabResultItem(
          name: 'Platelets',
          value: '280',
          unit: 'x10³/μL',
          range: '150-450',
          isAbnormal: false,
          isCritical: false,
        ),
      ],
    ),
    LabResult(
      testName: 'Lipid Profile',
      patientName: 'Fatima Mohamed',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Abnormal',
      labName: 'Cardiology Lab',
      results: [
        LabResultItem(
          name: 'Total Cholesterol',
          value: '240',
          unit: 'mg/dL',
          range: '<200',
          isAbnormal: true,
          isCritical: false,
        ),
        LabResultItem(
          name: 'LDL',
          value: '160',
          unit: 'mg/dL',
          range: '<100',
          isAbnormal: true,
          isCritical: false,
        ),
      ],
    ),
    LabResult(
      testName: 'Liver Function Test',
      patientName: 'Omar Hassan',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Critical',
      labName: 'Gastro Lab',
      results: [
        LabResultItem(
          name: 'ALT',
          value: '120',
          unit: 'U/L',
          range: '7-56',
          isAbnormal: true,
          isCritical: true,
        ),
      ],
    ),
  ];
}
