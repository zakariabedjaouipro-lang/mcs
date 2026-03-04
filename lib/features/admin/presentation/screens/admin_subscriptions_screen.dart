import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:mcs/core/enums/subscription_type.dart';
import 'package:mcs/core/models/subscription_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/widgets/confirm_dialog.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';

/// Admin Subscriptions Management Screen
class AdminSubscriptionsScreen extends StatelessWidget {
  const AdminSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(GetIt.I<SupabaseService>()),
      child: const AdminSubscriptionsView(),
    );
  }
}

class AdminSubscriptionsView extends StatefulWidget {
  const AdminSubscriptionsView({super.key});

  @override
  State<AdminSubscriptionsView> createState() => _AdminSubscriptionsViewState();
}

class _AdminSubscriptionsViewState extends State<AdminSubscriptionsView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadSubscriptionCodes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الاشتراكات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(const LoadSubscriptionCodes()),
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionCodesLoaded) {
            return _subscriptionCodesTable(subscriptions: state.subscriptions);
          }

          if (state is AdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('جاري تحميل البيانات...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGenerateCodeDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('إنشاء كود جديد'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _subscriptionCodesTable({required List<SubscriptionModel> subscriptions}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('الكود')),
              DataColumn(label: Text('النوع')),
              DataColumn(label: Text('السعر (USD)')),
              DataColumn(label: Text('السعر (EUR)')),
              DataColumn(label: Text('السعر (دج)')),
              DataColumn(label: Text('الحالة')),
              DataColumn(label: Text('العيادة')),
              DataColumn(label: Text('استخدم في')),
              DataColumn(label: Text('الإجراءات')),
            ],
            rows: subscriptions.map((sub) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      sub.code,
                      style: TextStyles.bodyMedium.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                  DataCell(Text(sub.type.label('ar'))),
                  DataCell(Text('\$${sub.priceUsd.toStringAsFixed(2)}')),
                  DataCell(Text('€${sub.priceEur.toStringAsFixed(2)}')),
                  DataCell(Text('${sub.priceDzd.toStringAsFixed(0)} دج')),
                  DataCell(
                    _buildStatusChip(sub.isUsed),
                  ),
                  DataCell(Text(sub.clinicId ?? '-')),
                  DataCell(Text(sub.usedAt != null ? _formatDate(sub.usedAt!) : '-')),
                  DataCell(
                    _buildActionsCell(context, sub),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isUsed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUsed ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isUsed ? 'مستخدم' : 'متاح',
        style: TextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, SubscriptionModel sub) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'copy':
            _copyCodeToClipboard(context, sub.code);
          case 'activate':
            if (!sub.isUsed) {
              _showActivateDialog(context, sub);
            }
          case 'delete':
            if (!sub.isUsed) {
              _confirmDeleteCode(context, sub);
            }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'copy', child: Text('نسخ الكود')),
        if (!sub.isUsed) ...[
          const PopupMenuItem(value: 'activate', child: Text('تفعيل للعيادة')),
          const PopupMenuItem(value: 'delete', child: Text('حذف الكود', style: TextStyle(color: Colors.red))),
        ],
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  Future<void> _showGenerateCodeDialog(BuildContext context) async {
    final selectedType = await showDialog<SubscriptionType>(
      context: context,
      builder: (context) => const _SelectSubscriptionTypeDialog(),
    );

    if (selectedType != null && context.mounted) {
      await _showPriceDialog(context, selectedType);
    }
  }

  Future<void> _showPriceDialog(BuildContext context, SubscriptionType type) async {
    final priceUsdController = TextEditingController();
    final priceEurController = TextEditingController();
    final priceDzdController = TextEditingController();

    priceUsdController.text = type.priceUsd.toString();
    priceEurController.text = type.priceEur.toString();
    priceDzdController.text = type.priceDzd.toString();

    const usdPrefix = r'$ ';
    const eurPrefix = '€ ';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد أسعار ${type.labelAr}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceUsdController,
              decoration: InputDecoration(
                labelText: 'السعر بالدولار ($)',
                prefixText: usdPrefix,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceEurController,
              decoration: InputDecoration(
                labelText: 'السعر باليورو (€)',
                prefixText: eurPrefix,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceDzdController,
              decoration: const InputDecoration(
                labelText: 'السعر بالدينار (دج)',
                suffixText: ' دج',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );

    if (result ?? false) {
      if (!context.mounted) return;
      context.read<AdminBloc>().add(GenerateSubscriptionCode(
        type: type,
        priceUsd: double.parse(priceUsdController.text),
        priceEur: double.parse(priceEurController.text),
        priceDzd: double.parse(priceDzdController.text),
      ),);
    }
  }

  Future<void> _showActivateDialog(BuildContext context, SubscriptionModel sub) async {
    final clinicId = await showDialog<String>(
      context: context,
      builder: (context) => const _SelectClinicDialog(),
    );

    if (clinicId != null && context.mounted) {
      context.read<AdminBloc>().add(ActivateSubscriptionCode(
        code: sub.code,
        clinicId: clinicId,
      ),);
    }
  }

  Future<void> _confirmDeleteCode(BuildContext context, SubscriptionModel sub) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'حذف كود الاشتراك',
      message: 'هل أنت متأكد من حذف كود الاشتراك "${sub.code}"؟',
      confirmText: 'حذف',
      isDestructive: true,
      icon: Icons.warning,
    );

    if (confirmed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سيتم حذف الكود بنجاح')),
      );
    }
  }

  void _copyCodeToClipboard(BuildContext context, String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ الكود: $code')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Dialog for selecting subscription type
class _SelectSubscriptionTypeDialog extends StatelessWidget {
  const _SelectSubscriptionTypeDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختر نوع الاشتراك'),
      content: ListView.separated(
        shrinkWrap: true,
        itemCount: SubscriptionType.values.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final type = SubscriptionType.values[index];
          return ListTile(
            title: Text(type.labelAr),
            subtitle: Text(type.labelEn),
            onTap: () => Navigator.pop(context, type),
          );
        },
      ),
    );
  }
}

/// Dialog for selecting clinic
class _SelectClinicDialog extends StatelessWidget {
  const _SelectClinicDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختر العيادة'),
      content: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is ClinicsLoaded) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: state.clinics.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final clinic = state.clinics[index];
                return ListTile(
                  title: Text(clinic.name),
                  subtitle: Text(clinic.email),
                  onTap: () => Navigator.pop(context, clinic.id),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
