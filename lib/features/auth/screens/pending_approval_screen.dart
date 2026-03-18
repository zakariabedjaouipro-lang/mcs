import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Screen shown to users awaiting approval
/// شاشة معروضة للمستخدمين في انتظار الموافقة
class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Supabase.instance.client.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userMetadata = _currentUser?.userMetadata;
    final userRole = userMetadata?['role'] as String? ?? 'user';
    final userName = userMetadata?['fullName'] as String? ?? 'المستخدم';

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Illustration / Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      size: 60,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Title
                  Text(
                    isArabic
                        ? 'حسابك قيد المراجعة'
                        : 'Your Account is Under Review',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  /// Subtitle
                  Text(
                    isArabic
                        ? 'مرحبا $userName، شكراً لتسجيلك.'
                        : 'Hello $userName, thank you for signing up.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  /// Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isArabic
                              ? 'نحن نراجع طلب تسجيلك حالياً'
                              : 'We are currently reviewing your registration request',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isArabic
                              ? 'سيتم الموافقة على حسابك في غضون 24 إلى 48 ساعة'
                              : 'Your account will be approved within 24 to 48 hours',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Approval Details Card
                  Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'تفاصيل الطلب' : 'Request Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            label: isArabic ? 'الدور:' : 'Role:',
                            value: userRole,
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            context,
                            label: isArabic ? 'البريد الإلكتروني:' : 'Email:',
                            value: _currentUser?.email ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            context,
                            label: isArabic ? 'الحالة:' : 'Status:',
                            value: isArabic ? 'قيد المراجعة' : 'Under Review',
                            valueColor: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Steps
                  _buildStepsSection(context, isArabic),
                  const SizedBox(height: 32),

                  /// Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic ? 'تم تسجيل الخروج' : 'Logged out',
                              ),
                            ),
                          );
                          // Navigator will automatically redirect to login
                          // due to auth state change
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(
                        isArabic ? 'تسجيل الخروج' : 'Logout',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Support Contact
                  TextButton.icon(
                    onPressed: _showSupportDialog,
                    icon: const Icon(Icons.help_outline),
                    label: Text(
                      isArabic ? 'الاتصال بالدعم' : 'Contact Support',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build detail row
  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  /// Build steps section
  Widget _buildStepsSection(BuildContext context, bool isArabic) {
    final steps = [
      {
        'title': isArabic ? 'تم الاستقبال' : 'Request Received',
        'description': isArabic
            ? 'تم استقبال طلب التسجيل'
            : 'Your registration request has been received',
      },
      {
        'title': isArabic ? 'قيد المراجعة' : 'Under Review',
        'description': isArabic
            ? 'يتم التحقق من بيانات التسجيل'
            : 'Your details are being verified',
      },
      {
        'title': isArabic ? 'الموافقة' : 'Approval',
        'description': isArabic
            ? 'ستتلقى رسالة بنتيجة الموافقة'
            : 'You will receive an approval notification',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'خطوات الموافقة' : 'Approval Steps',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            final isCompleted = index == 0;
            final isActive = index <= 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? PremiumColors.successGreen
                              : (isActive ? Colors.amber : Colors.grey[300]),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          width: 2,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step['description'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Show support dialog
  void _showSupportDialog() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'الاتصال بالدعم' : 'Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'البريد الإلكتروني:' : 'Email:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('support@mcs.app'),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'رقم الهاتف:' : 'Phone:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('+1 (555) 123-4567'),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? 'ساعات العمل: من الأحد إلى الخميس 9 صباحاً - 5 مساءً'
                  : 'Business Hours: Sunday-Thursday 9AM-5PM',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }
}
