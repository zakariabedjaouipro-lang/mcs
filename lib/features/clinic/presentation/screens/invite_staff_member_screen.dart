/// Invite Staff Member Screen - شاشة استدعاء موظف جديد
/// تتيح لـ Clinic Admin إضافة موظفين جدد للعيادة
library;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/utils/role_management_utils.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';

class InviteStaffMemberScreen extends StatefulWidget {
  /// معرّف العيادة الحالي
  final String clinicId;

  /// معرّف Clinic Admin (المستخدم الحالي)
  final String adminId;

  const InviteStaffMemberScreen({
    super.key,
    required this.clinicId,
    required this.adminId,
  });

  @override
  State<InviteStaffMemberScreen> createState() =>
      _InviteStaffMemberScreenState();
}

class _InviteStaffMemberScreenState extends State<InviteStaffMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedRole = 'doctor'; // الدور الافتراضي
  bool _isLoading = false;

  /// الأدوار المتاحة للموظفين
  late final List<RoleOption> _availableRoles =
      RoleManagementUtils.clinicStaffRoles;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// إرسال دعوة للموظف الجديد
  Future<void> _handleInviteStaffMember() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final client = Supabase.instance.client;

      // ✅ 1. حفظ الدعوة في جدول staff_invitations
      await client.from('staff_invitations').insert({
        'clinic_id': widget.clinicId,
        'invited_by': widget.adminId,
        'email': _emailController.text.trim(),
        'full_name': _nameController.text.trim(),
        'role': _selectedRole,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      // ✅ 2. إرسال بريد إلكتروني للموظف (مستقبلاً)
      await client.functions.invoke(
        'send-staff-invitation',
        body: {
          'email': _emailController.text.trim(),
          'fullName': _nameController.text.trim(),
          'role': _selectedRole,
          'clinicId': widget.clinicId,
          'inviteUrl': _buildInviteUrl(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إرسال الدعوة إلى ${_emailController.text}',
            ),
            backgroundColor: PremiumColors.successGreen,
          ),
        );

        _formKey.currentState!.reset();
        _emailController.clear();
        _nameController.clear();
        setState(() => _selectedRole = 'doctor');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: PremiumColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// بناء URL الدعوة
  String _buildInviteUrl() {
    return 'https://mcs-app.example.com/invite?'
        'clinic_id=${widget.clinicId}&'
        'email=${Uri.encodeComponent(_emailController.text.trim())}&'
        'role=$_selectedRole';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استدعاء موظف جديد'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── العنوان والوصف ────────────────────────
              const Text(
                'إضافة موظف جديد للعيادة', // ✅ تم إضافة const
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'سيتم إرسال دعوة بريدية للموظف الجديد ليقوم بقبول الدعوة والتسجيل في النظام',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),

              // ── اسم الموظف ────────────────────────────
              CustomTextField(
                controller: _nameController,
                label: 'اسم الموظف',
                hint: 'أدخل الاسم الكامل',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يجب إدخال اسم الموظف';
                  }
                  if (value!.length < 3) {
                    return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── البريد الإلكتروني ────────────────────
              CustomTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                hint: 'staff@example.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يجب إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                    return 'البريد غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── اختيار الدور ───────────────────────────
              Text(
                'اختر الدور',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                _availableRoles.length,
                (index) {
                  final role = _availableRoles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Icon(role.icon, color: Colors.teal),
                        title: Text(role.label),
                        subtitle: Text(
                          role.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // ✅ تم استبدال Radio بـ GestureDetector
                        trailing:
                            _buildRadioIndicator(role.value == _selectedRole),
                        onTap: () {
                          setState(() => _selectedRole = role.value);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // ── معلومات إضافية ──────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'الموظف الجديد سيتلقى رسالة بريد إلكترونية '
                        'تحتوي على رابط دعوة فريد. '
                        'سيتمكن من التسجيل مباشرة عبر هذا الرابط.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue.shade700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── أزرار الإجراء ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'إرسال الدعوة',
                      onPressed: _isLoading ? null : _handleInviteStaffMember,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: 'إلغاء',
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
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

  // ✅ دالة مساعدة لبناء مؤشر Radio مخصص
  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.teal : Colors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal,
                ),
              ),
            )
          : null,
    );
  }
}
