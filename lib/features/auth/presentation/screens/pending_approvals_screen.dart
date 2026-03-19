import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

/// صفحة إدارة طلبات الموافقة الجديدة
/// New Approval Requests Management Screen
class PendingApprovalsScreen extends StatefulWidget {
  const PendingApprovalsScreen({super.key});

  @override
  State<PendingApprovalsScreen> createState() => _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState extends State<PendingApprovalsScreen> {
  late AdvancedAuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AdvancedAuthBloc>();
    // تحميل الطلبات المعلقة عند فتح الصفحة
    _authBloc.add(const LoadPendingRegistrationRequestsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'طلبات الموافقة المعلقة' : 'Pending Approvals',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
      ),
      body: RefreshableList(
        onRefresh: () async {
          _authBloc.add(const LoadPendingRegistrationRequestsRequested());
        },
        child: BlocConsumer<AdvancedAuthBloc, AdvancedAuthState>(
          listener: (context, state) {
            if (state is RegistrationRequestApprovedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic ? 'تمت الموافقة بنجاح' : 'Approval successful',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // إعادة تحميل الطلبات
              _authBloc.add(
                const LoadPendingRegistrationRequestsRequested(),
              );
            } else if (state is RegistrationRequestRejectedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic ? 'تم الرفض بنجاح' : 'Rejected successfully',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              // إعادة تحميل الطلبات
              _authBloc.add(
                const LoadPendingRegistrationRequestsRequested(),
              );
            } else if (state is RegistrationRequestApprovalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdvancedAuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
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
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text(
                        isArabic
                            ? 'لا توجد طلبات معلقة'
                            : 'No pending requests',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        isArabic
                            ? 'جميع الطلبات تمت معالجتها'
                            : 'All requests have been processed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.requests.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return PendingApprovalCard(
                    request: request,
                    onApprove: () =>
                        _showApprovalDialog(context, request, isArabic),
                    onReject: () =>
                        _showRejectionDialog(context, request, isArabic),
                    isArabic: isArabic,
                  );
                },
              );
            }

            if (state is AdvancedAuthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _authBloc.add(
                          const LoadPendingRegistrationRequestsRequested(),
                        );
                      },
                      child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showApprovalDialog(
    BuildContext context,
    RegistrationRequest request,
    bool isArabic,
  ) {
    final notesController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isArabic ? 'الموافقة على الطلب' : 'Approve Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText:
                      isArabic ? 'ملاحظات (اختياري)' : 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _authBloc.add(
                  RegistrationRequestApprovalSubmitted(
                    requestId: request.id,
                    approverUserId: 'current_user_id', // TODO: Get from auth
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(isArabic ? 'الموافقة' : 'Approve'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectionDialog(
    BuildContext context,
    RegistrationRequest request,
    bool isArabic,
  ) {
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isArabic ? 'رفض الطلب' : 'Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'سبب الرفض' : 'Rejection Reason',
                  border: OutlineInputBorder(),
                  hintText: isArabic
                      ? 'اشرح سبب رفض الطلب'
                      : 'Explain why you are rejecting this request',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isArabic ? 'مطلوب' : 'Required';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'يرجى إدخال سبب الرفض'
                            : 'Please provide a rejection reason',
                      ),
                    ),
                  );
                  return;
                }

                _authBloc.add(
                  RegistrationRequestRejectionSubmitted(
                    requestId: request.id,
                    approverUserId: 'current_user_id', // TODO: Get from auth
                    rejectionReason: reasonController.text,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(isArabic ? 'رفض' : 'Reject'),
            ),
          ],
        );
      },
    );
  }
}

/// بطاقة طلب موافقة واحدة
/// Single pending approval card
class PendingApprovalCard extends StatelessWidget {
  const PendingApprovalCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.isArabic,
    super.key,
  });

  final RegistrationRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            right: BorderSide(
              color: Colors.blue,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (request.requestedData?['full_name'] as String?) ??
                              'Unknown',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          (request.requestedData?['email'] as String?) ??
                              'No email',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic ? 'معلق' : 'Pending',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),

              // معلومات التفاصيل
              _buildInfoRow(
                label: isArabic ? 'الدور' : 'Role',
                value: (request.requestedData?['role'] as String?) ?? 'Unknown',
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                label: isArabic ? 'التاريخ' : 'Date',
                value: DateFormat('yyyy-MM-dd HH:mm').format(
                  request.createdAt!,
                ),
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                label: isArabic ? 'رقم الهاتف' : 'Phone',
                value: (request.requestedData?['phone'] as String?) ?? 'N/A',
              ),

              SizedBox(height: 16),

              // أزرار الموافقة والرفض
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(Icons.check),
                      label: Text(isArabic ? 'موافقة' : 'Approve'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                      icon: Icon(Icons.close),
                      label: Text(isArabic ? 'رفض' : 'Reject'),
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

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Wrapper for refreshable list
class RefreshableList extends StatelessWidget {
  const RefreshableList({
    required this.child,
    required this.onRefresh,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}
