/// Records/Documents Screen
/// Displays medical records and documents in a grid layout
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/components/empty_error_state.dart';
import 'package:mcs/core/components/skeleton_loaders.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Records & Documents',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
      ),
      body: _hasError
          ? Center(
              child: ErrorStateWidget(
                title: 'Failed to Load Records',
                message: 'Unable to fetch medical records',
                onRetry: _loadRecords,
              ),
            )
          : _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: List.generate(
                      6,
                      (index) => _buildSkeletonCard(),
                    ),
                  ),
                )
              : _buildRecordsGrid(),
    );
  }

  Widget _buildRecordsGrid() {
    final records = [
      {
        'title': 'Blood Tests',
        'icon': Icons.assignment,
        'color': MedicalColors.primary,
        'count': '5',
      },
      {
        'title': 'X-Rays',
        'icon': Icons.image,
        'color': MedicalColors.secondary,
        'count': '3',
      },
      {
        'title': 'Ultrasounds',
        'icon': Icons.waves,
        'color': MedicalColors.accent,
        'count': '2',
      },
      {
        'title': 'ECG Reports',
        'icon': Icons.favorite,
        'color': const Color(0xFFFF5252),
        'count': '1',
      },
      {
        'title': 'Prescriptions',
        'icon': Icons.medication,
        'color': const Color(0xFF4CAF50),
        'count': '12',
      },
      {
        'title': 'Vaccination',
        'icon': Icons.medical_services,
        'color': const Color(0xFFFF9800),
        'count': '8',
      },
      {
        'title': 'Pathology',
        'icon': Icons.microscope,
        'color': const Color(0xFF9C27B0),
        'count': '3',
      },
      {
        'title': 'Surgery Notes',
        'icon': Icons.accessibility_new,
        'color': const Color(0xFF2196F3),
        'count': '1',
      },
    ];

    return records.isEmpty
        ? Center(
            child: EmptyStateWidget(
              icon: Icons.folder_open,
              title: 'No Records Found',
              message: 'Medical records will appear here',
              onRefresh: _loadRecords,
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _buildRecordCard(
                context,
                title: record['title']! as String,
                icon: record['icon']! as IconData,
                color: record['color']! as Color,
                count: record['count']! as String,
              );
            },
          );
  }

  Widget _buildRecordCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String count,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $title ($count records)')),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count records',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// Simple Shimmer effect widget
class Shimmer extends StatefulWidget {
  const Shimmer.fromColors({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: Tween<double>(begin: 0.5, end: 1)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          )
          .value,
      child: widget.child,
    );
  }
}
