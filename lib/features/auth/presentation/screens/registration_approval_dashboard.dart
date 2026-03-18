/// Registration Approval Management Screen (Admin Dashboard)
/// شاشة إدارة توافقات التسجيل (لوحة التحكم الإدارية)
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class RegistrationApprovalDashboard extends StatefulWidget {
  const RegistrationApprovalDashboard({super.key});

  @override
  State<RegistrationApprovalDashboard> createState() =>
      _RegistrationApprovalDashboardState();
}

class _RegistrationApprovalDashboardState
    extends State<RegistrationApprovalDashboard> {
  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    // Load pending requests
    context.read<AdvancedAuthBloc>().add(
          const LoadPendingRegistrationRequestsRequested(),
        );
  }

  void _approveRequest(String requestId) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _isArabic ? 'تأكيد الموافقة' : 'Confirm Approval',
        ),
        content: Text(
          _isArabic
              ? 'هل تريد الموافقة على هذا الطلب؟'
              : 'Are you sure you want to approve this request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdvancedAuthBloc>().add(
                    RegistrationRequestApprovalSubmitted(
                      requestId: requestId,
                      approverUserId: 'current_user_id', // Use actual user ID
                    ),
                  );
            },
            child: Text(_isArabic ? 'موافق' : 'Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(String requestId) {
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _isArabic ? 'رفض الطلب' : 'Reject Request',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isArabic ? 'أدخل سبب الرفض' : 'Enter rejection reason',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: _isArabic ? 'السبب' : 'Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                Navigator.pop(context);
                context.read<AdvancedAuthBloc>().add(
                      RegistrationRequestRejectionSubmitted(
                        requestId: requestId,
                        approverUserId: 'current_user_id', // Use actual user ID
                        rejectionReason: reasonController.text,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(_isArabic ? 'رفض' : 'Reject'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isArabic ? 'طلبات التسجيل المعلقة' : 'Pending Registrations',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
        builder: (context, state) {
          if (state is AdvancedAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PendingRegistrationRequestsLoaded) {
            if (state.requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isArabic ? 'لا توجد طلبات معلقة' : 'No pending requests',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdvancedAuthBloc>().add(
                      const LoadPendingRegistrationRequestsRequested(),
                    );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return _buildRequestCard(context, request);
                },
              ),
            );
          }

          if (state is RegistrationRequestApprovalFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdvancedAuthBloc>().add(
                            const LoadPendingRegistrationRequestsRequested(),
                          );
                    },
                    child: Text(_isArabic ? 'إعادة محاولة' : 'Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    RegistrationRequest request,
  ) {
    final statusColor = _getStatusColor(request.status);
    final statusText = _getStatusText(context, request.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userId,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Role: ${request.roleId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
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
            const SizedBox(height: 12),

            // Request Info
            if (request.requestedData != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (request.requestedData as Map<String, dynamic>)
                      .entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${e.key}: ${e.value}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Timestamps
            Row(
              children: [
                Text(
                  _isArabic ? 'مقدم في: ' : 'Submitted: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Expanded(
                  child: Text(
                    _formatDate(request.createdAt!),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),

            if (request.rejectionReason != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_isArabic ? 'سبب الرفض: ' : 'Rejection Reason: '}${request.rejectionReason}',
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Action Buttons
            if (request.status.toString().split('.').last == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(
                        _isArabic ? 'موافق' : 'Approve',
                      ),
                      onPressed: () => _approveRequest(request.id),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: Text(
                        _isArabic ? 'رفض' : 'Reject',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _rejectRequest(request.id),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RegistrationRequestStatus status) {
    switch (status.toString().split('.').last) {
      case 'pending':
        return Colors.blue;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'under_review':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(
      BuildContext context, RegistrationRequestStatus status) {
    final statusStr = status.toString().split('.').last;
    if (_isArabic) {
      switch (statusStr) {
        case 'pending':
          return 'معلق';
        case 'approved':
          return 'موافق عليه';
        case 'rejected':
          return 'مرفوض';
        case 'under_review':
          return 'قيد المراجعة';
        default:
          return 'غير معروف';
      }
    } else {
      switch (statusStr) {
        case 'pending':
          return 'Pending';
        case 'approved':
          return 'Approved';
        case 'rejected':
          return 'Rejected';
        case 'under_review':
          return 'Under Review';
        default:
          return 'Unknown';
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
