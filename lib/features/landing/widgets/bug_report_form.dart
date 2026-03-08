import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/validators.dart';

/// نموذج الإبلاغ عن مشكلة - يتضمن وصف المشكلة والصور واختياري
class BugReportFormWidget extends StatefulWidget {
  const BugReportFormWidget({
    super.key,
    this.primaryColor,
    this.onSubmitSuccess,
  });
  final Color? primaryColor;
  final VoidCallback? onSubmitSuccess;

  @override
  State<BugReportFormWidget> createState() => _BugReportFormWidgetState();
}

class _BugReportFormWidgetState extends State<BugReportFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String _selectedSeverity = 'متوسط';
  String _selectedCategory = 'عام';
  final List<String> _attachmentPaths = [];
  bool _includeDeviceInfo = true;

  final List<String> _severityLevels = ['منخفض', 'متوسط', 'مرتفع', 'حرج'];
  final List<String> _categories = [
    'عام',
    'واجهة المستخدم',
    'الأداء',
    'الأمان',
    'البيانات',
    'التكامل',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addAttachment() {
    // In a real app, use image_picker or file_picker
    // For now, just simulate adding an attachment
    setState(() {
      _attachmentPaths.add('attachment_${_attachmentPaths.length + 1}.png');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة المرفق بنجاح'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachmentPaths.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 3));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('شكراً لك! تم استقبال بلاغك بنجاح.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _emailController.clear();
        _attachmentPaths.clear();
        _selectedSeverity = 'متوسط';
        _selectedCategory = 'عام';

        widget.onSubmitSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ. يرجى المحاولة لاحقاً.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? AppColors.primary;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'الإبلاغ عن مشكلة',
            style: TextStyles.heading2.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'ساعدنا في تحسين التطبيق بإخبارنا عن أي مشكلة تواجهها',
            style: TextStyles.body2.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 24),

          // Title Field
          TextFormField(
            controller: _titleController,
            decoration: _buildInputDecoration(
              label: 'عنوان المشكلة',
              hint: 'اكتب عنواناً موجزاً للمشكلة',
              icon: Icons.bug_report,
              primaryColor: primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال عنوان المشكلة';
              }
              if (value.length < 5) {
                return 'العنوان يجب أن يكون 5 أحرف على الأقل';
              }
              return null;
            },
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),

          // Category and Severity Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التصنيف',
                      style: TextStyles.subtitle2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      items: _categories
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ),
                          )
                          .toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(
                                () => _selectedCategory = value ?? 'عام',
                              );
                            },
                      decoration: _buildInputDecoration(
                        label: '',
                        hint: 'اختر التصنيف',
                        icon: Icons.category,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مستوى الخطورة',
                      style: TextStyles.subtitle2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSeverity,
                      items: _severityLevels
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ),
                          )
                          .toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(
                                () => _selectedSeverity = value ?? 'متوسط',
                              );
                            },
                      decoration: _buildInputDecoration(
                        label: '',
                        hint: 'اختر المستوى',
                        icon: Icons.priority_high,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description Field
          TextFormField(
            controller: _descriptionController,
            decoration: _buildInputDecoration(
              label: 'وصف المشكلة',
              hint: 'اشرح المشكلة بالتفصيل...',
              icon: Icons.description,
              primaryColor: primaryColor,
              maxLines: 5,
            ),
            maxLines: 5,
            minLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال وصف المشكلة';
              }
              if (value.length < 20) {
                return 'الوصف يجب أن يكون 20 حرفاً على الأقل';
              }
              return null;
            },
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: _emailController,
            decoration: _buildInputDecoration(
              label: 'بريدك الإلكتروني',
              hint: 'حتى نتمكن من التواصل معك',
              icon: Icons.email,
              primaryColor: primaryColor,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!Validators.isValidEmail(value)) {
                  return 'البريد الإلكتروني غير صحيح';
                }
              }
              return null;
            },
            enabled: !_isLoading,
          ),
          const SizedBox(height: 24),

          // Attachments Section
          Text(
            'المرفقات (اختياري)',
            style: TextStyles.subtitle2.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _addAttachment,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('إضافة صورة أو ملف'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_attachmentPaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                _attachmentPaths.length,
                (index) => Chip(
                  label: Text(_attachmentPaths[index]),
                  onDeleted: () => _removeAttachment(index),
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  deleteIconColor: primaryColor,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Device Info Checkbox
          CheckboxListTile(
            value: _includeDeviceInfo,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() => _includeDeviceInfo = value ?? false);
                  },
            title: Text(
              'تضمين معلومات الجهاز لمساعدتنا بشكل أفضل',
              style: TextStyles.body2,
            ),
            subtitle: Text(
              'سيتم إرسال معلومات النظام والجهاز مع البلاغ',
              style: TextStyles.caption.copyWith(color: AppColors.grey),
            ),
            activeColor: primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'إرسال البلاغ',
                      style: TextStyles.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required Color primaryColor,
    int maxLines = 1,
  }) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyles.body2,
      hintStyle: TextStyles.body2.copyWith(color: AppColors.grey),
      errorStyle: TextStyles.caption.copyWith(color: Colors.red),
    );
  }
}

