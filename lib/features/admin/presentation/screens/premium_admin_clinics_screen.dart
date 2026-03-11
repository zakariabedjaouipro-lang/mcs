/// Premium Admin Clinics Management Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_button.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumAdminClinicsScreen extends StatefulWidget {
  const PremiumAdminClinicsScreen({super.key});

  @override
  State<PremiumAdminClinicsScreen> createState() =>
      _PremiumAdminClinicsScreenState();
}

class _PremiumAdminClinicsScreenState extends State<PremiumAdminClinicsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'العيادات' : 'Clinics',
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: isArabic ? 'تحديث' : 'Refresh',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(isArabic ? 'تحديث البيانات...' : 'Refreshing data...'),
              ),
            );
          },
        ),
      ],
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildClinicsContent(context, isArabic),
    );
  }

  Widget _buildClinicsContent(BuildContext context, bool isArabic) {
    final clinics = [
      {
        'name': isArabic ? 'عيادة الرعاية الصحية' : 'Health Care Clinic',
        'city': isArabic ? 'الرياض' : 'Riyadh',
        'status': 'active',
      },
      {
        'name': isArabic ? 'عيادة الطبيعة' : 'Nature Clinic',
        'city': isArabic ? 'جدة' : 'Jeddah',
        'status': 'expiring_soon',
      },
      {
        'name': isArabic ? 'عيادة المستقبل' : 'Future Clinic',
        'city': isArabic ? 'الدمام' : 'Dammam',
        'status': 'expired',
      },
      {
        'name': isArabic ? 'عيادة الأمل' : 'Hope Clinic',
        'city': isArabic ? 'المدينة' : 'Medina',
        'status': 'trial',
      },
    ];

    if (clinics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 64,
              color: PremiumColors.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? 'لا توجد عيادات مسجلة بعد'
                  : 'No clinics registered yet',
              style: PremiumTextStyles.bodyLarge.copyWith(
                color: PremiumColors.lightText,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final clinic = clinics[index];
              return _buildClinicCard(context, clinic, isArabic);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            label: isArabic ? 'إضافة عيادة' : 'Add Clinic',
            icon: Icons.add_business,
            isFullWidth: true,
            onPressed: () => _showAddClinicDialog(context, isArabic),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicCard(
      BuildContext context, Map<String, dynamic> clinic, bool isArabic) {
    Color statusColor;
    String statusText;

    switch (clinic['status']?.toString()) {
      case 'active':
        statusColor = PremiumColors.successGreen;
        statusText = isArabic ? 'نشط' : 'Active';
        break;
      case 'expired':
        statusColor = PremiumColors.errorRed;
        statusText = isArabic ? 'منتهي' : 'Expired';
        break;
      case 'expiring_soon':
        statusColor = PremiumColors.warningOrange;
        statusText = isArabic ? 'ينتهي قريباً' : 'Expiring Soon';
        break;
      case 'trial':
        statusColor = PremiumColors.primaryBlue;
        statusText = isArabic ? 'تجريبي' : 'Trial';
        break;
      default:
        statusColor = PremiumColors.mediumGrey;
        statusText = isArabic ? 'غير معروف' : 'Unknown';
    }

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    color: PremiumColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    clinic['name']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PremiumTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PremiumColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: PremiumColors.lightText,
                ),
                const SizedBox(width: 4),
                Text(
                  clinic['city']?.toString() ?? '',
                  style: PremiumTextStyles.bodySmall.copyWith(
                    color: PremiumColors.lightText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusText,
                style: PremiumTextStyles.labelSmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: isArabic ? 'التفاصيل' : 'Details',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.secondary,
                    onPressed: () =>
                        _showClinicDetails(context, clinic, isArabic),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: isArabic ? 'تعديل' : 'Edit',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.primary,
                    onPressed: () =>
                        _showEditClinicDialog(context, clinic, isArabic),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddClinicDialog(BuildContext context, bool isArabic) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isArabic ? 'إضافة عيادة جديدة' : 'Add New Clinic'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'اسم العيادة' : 'Clinic Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'رقم الهاتف' : 'Phone',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'المدينة' : 'City',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          AppButton(
            label: isArabic ? 'إضافة' : 'Add',
            size: AppButtonSize.small,
            variant: AppButtonVariant.primary,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isArabic ? 'تمت إضافة العيادة' : 'Clinic added successfully'),
        ),
      );
    }
  }

  Future<void> _showClinicDetails(
      BuildContext context, Map<String, dynamic> clinic, bool isArabic) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(clinic['name']?.toString() ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem(
              Icons.email,
              isArabic ? 'البريد الإلكتروني' : 'Email',
              clinic['email']?.toString() ?? 'N/A',
            ),
            _buildDetailItem(
              Icons.phone,
              isArabic ? 'الهاتف' : 'Phone',
              clinic['phone']?.toString() ?? 'N/A',
            ),
            _buildDetailItem(
              Icons.location_on,
              isArabic ? 'المدينة' : 'City',
              clinic['city']?.toString() ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: PremiumColors.primaryBlue),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _showEditClinicDialog(
      BuildContext context, Map<String, dynamic> clinic, bool isArabic) async {
    final nameController =
        TextEditingController(text: clinic['name']?.toString() ?? '');
    final emailController =
        TextEditingController(text: clinic['email']?.toString() ?? '');
    final phoneController =
        TextEditingController(text: clinic['phone']?.toString() ?? '');
    final cityController =
        TextEditingController(text: clinic['city']?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تعديل العيادة' : 'Edit Clinic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            const SizedBox(height: 12),
            TextField(controller: emailController),
            const SizedBox(height: 12),
            TextField(controller: phoneController),
            const SizedBox(height: 12),
            TextField(controller: cityController),
          ],
        ),
      ),
    );
  }
}
