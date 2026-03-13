import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/models/user_approval_model.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/features/admin/presentation/bloc/approval_bloc.dart';

/// Screen for managing user approvals
/// شاشة لإدارة موافقات المستخدمين
class ApprovalsManagementScreen extends StatefulWidget {
  const ApprovalsManagementScreen({super.key});

  @override
  State<ApprovalsManagementScreen> createState() =>
      _ApprovalsManagementScreenState();
}

class _ApprovalsManagementScreenState extends State<ApprovalsManagementScreen> {
  late ApprovalBloc _approvalBloc;
  ApprovalStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _approvalBloc = context.read<ApprovalBloc>();
    _approvalBloc.add(const FetchPendingApprovalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'إدارة الموافقات' : 'Manage Approvals',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _selectedStatus?.label ?? (isArabic ? 'جميع الحالات' : 'All'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ApprovalBloc, ApprovalState>(
        bloc: _approvalBloc,
        builder: (context, state) {
          if (state is ApprovalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApprovalsLoaded) {
            if (state.approvals.isEmpty) {
              return Center(
                child: Text(
                  isArabic ? 'لا توجد طلبات موافقة' : 'No approval requests',
                ),
              );
            }

            return Column(
              children: [
                _buildFilterBar(context, isArabic),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.approvals.length,
                    itemBuilder: (context, index) => _buildApprovalCard(
                      context,
                      state.approvals[index],
                      isArabic,
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ApprovalError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _approvalBloc.add(const FetchPendingApprovalsEvent());
                    },
                    child: Text(
                      isArabic ? 'إعادة محاولة' : 'Retry',
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  /// Build filter bar
  Widget _buildFilterBar(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ApprovalStatus.values.map((status) {
                  final isSelected = _selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(isArabic ? status.label : status.labelEn),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected ? status : null;
                        });
                        if (selected) {
                          _approvalBloc
                              .add(FetchApprovalsByStatusEvent(status));
                        } else {
                          _approvalBloc.add(const FetchPendingApprovalsEvent());
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build approval card
  Widget _buildApprovalCard(
    BuildContext context,
    UserApprovalModel approval,
    bool isArabic,
  ) {
    final noteController = TextEditingController();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(approval.fullName),
        subtitle: Text(approval.email),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  label: isArabic ? 'البريد الإلكتروني:' : 'Email:',
                  value: approval.email,
                ),
                _buildInfoRow(
                  label: isArabic ? 'الدور:' : 'Role:',
                  value: approval.role,
                ),
                _buildInfoRow(
                  label: isArabic ? 'طريقة التسجيل:' : 'Registration Type:',
                  value: approval.registrationType,
                ),
                _buildInfoRow(
                  label: isArabic ? 'تاريخ الطلب:' : 'Requested at:',
                  value: approval.createdAt.toString().split('.')[0],
                ),
                _buildInfoRow(
                  label: isArabic ? 'الحالة:' : 'Status:',
                  value: isArabic
                      ? approval.status.label
                      : approval.status.labelEn,
                  valueColor: _getStatusColor(approval.status),
                ),
                const SizedBox(height: 16),
                if (approval.status == ApprovalStatus.pending) ...[
                  _buildApprovalNoteField(context, noteController, isArabic),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleApprove(
                              context, approval, noteController.text, isArabic),
                          icon: const Icon(Icons.check),
                          label: Text(isArabic ? 'الموافقة' : 'Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PremiumColors.successGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _handleReject(context, approval, isArabic),
                          icon: const Icon(Icons.close),
                          label: Text(isArabic ? 'الرفض' : 'Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    approval.status == ApprovalStatus.approved
                        ? (isArabic ? 'تم الموافقة:' : 'Approved at:')
                        : (isArabic ? 'تم الرفض:' : 'Rejected at:'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (approval.approvedAt != null)
                    Text(approval.approvedAt.toString().split('.')[0])
                  else if (approval.rejectedAt != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(approval.rejectedAt.toString().split('.')[0]),
                        const SizedBox(height: 8),
                        if (approval.rejectionReason != null) ...[
                          Text(
                            isArabic ? 'سبب الرفض:' : 'Rejection reason:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(approval.rejectionReason!),
                        ],
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build approval note field
  Widget _buildApprovalNoteField(
    BuildContext context,
    TextEditingController controller,
    bool isArabic,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isArabic ? 'ملاحظات الموافقة' : 'Approval Notes',
        hintText:
            isArabic ? 'أضف ملاحظات اختيارية...' : 'Add optional notes...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      maxLines: 2,
    );
  }

  /// Handle user approval
  Future<void> _handleApprove(
    BuildContext context,
    UserApprovalModel approval,
    String approvalNotes,
    bool isArabic,
  ) async {
    _approvalBloc.add(
      ApproveUserEvent(
        userId: approval.userId,
        approvalNotes: approvalNotes.isNotEmpty ? approvalNotes : null,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'تمت الموافقة على ${approval.fullName}'
              : 'Approved ${approval.fullName}',
        ),
        backgroundColor: PremiumColors.successGreen,
      ),
    );
  }

  /// Handle user rejection
  Future<void> _handleReject(
    BuildContext context,
    UserApprovalModel approval,
    bool isArabic,
  ) async {
    final reason = await _showRejectionDialog(context, isArabic);
    if (reason != null && reason.isNotEmpty) {
      _approvalBloc.add(
        RejectUserEvent(
          userId: approval.userId,
          rejectionReason: reason,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'تم رفض ${approval.fullName}'
                : 'Rejected ${approval.fullName}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show rejection dialog
  Future<String?> _showRejectionDialog(
    BuildContext context,
    bool isArabic,
  ) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'سبب الرفض' : 'Rejection Reason'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText:
                isArabic ? 'اكتب سبب الرفض...' : 'Enter rejection reason...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(isArabic ? 'رفض' : 'Reject'),
          ),
        ],
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return Colors.orange;
      case ApprovalStatus.approved:
        return PremiumColors.successGreen;
      case ApprovalStatus.rejected:
        return Colors.red;
      case ApprovalStatus.suspended:
        return Colors.grey;
    }
  }
}
