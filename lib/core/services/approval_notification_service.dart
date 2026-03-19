/// Service for sending approval notifications to admins
/// خدمة إرسال إشعارات الموافقة للمسؤولين
library;

import 'dart:developer';

import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Email template for pending approval notification
const _pendingApprovalTemplate = '''
<html dir="rtl" lang="ar">
  <head>
    <meta charset="UTF-8">
    <title>طلب موافقة جديد</title>
  </head>
  <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
      <h2 style="color: #1a73e8;">طلب موافقة جديد - New Approval Request</h2>
      
      <div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
        <p><strong>اسم المستخدم / Full Name:</strong> {{fullName}}</p>
        <p><strong>البريد الإلكتروني / Email:</strong> {{email}}</p>
        <p><strong>الدور / Role:</strong> {{roleName}}</p>
        <p><strong>نوع التسجيل / Registration Type:</strong> {{registrationType}}</p>
        <p><strong>وقت الطلب / Request Date:</strong> {{requestDate}}</p>
      </div>
      
      <p style="margin-top: 20px;">
        <a href="{{approvalLink}}" 
           style="display: inline-block; padding: 12px 30px; background-color: #1a73e8; color: white; text-decoration: none; border-radius: 5px;">
          عرض الطلب / View Request
        </a>
      </p>
      
      <p style="margin-top: 20px; font-size: 12px; color: #666;">
        هذا الطلب ينتظر موافقتك لتفعيل حساب المستخدم.<br>
        This request is pending your approval to activate the user account.
      </p>
    </div>
  </body>
</html>
''';

/// Service to send approval notifications
class ApprovalNotificationService {
  ApprovalNotificationService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  /// Send notification to all super admins about pending approvals
  /// إرسال إشعار لجميع السوبر أدمن بشأن الطلبات المعلقة
  Future<void> notifyAdminsOfPendingApproval({
    required String userId,
    required String email,
    required String fullName,
    required String roleName,
    required String registrationType,
    String? approvalLink,
  }) async {
    try {
      log('Sending approval notification for user: $email',
          name: 'ApprovalNotificationService.notifyAdminsOfPendingApproval');

      // Get all super admins
      final admins = await _getSuperAdmins();
      if (admins.isEmpty) {
        log('No super admins found to notify',
            name: 'ApprovalNotificationService.notifyAdminsOfPendingApproval',
            level: 800);
        return;
      }

      // Prepare email template
      final emailBody = _pendingApprovalTemplate
          .replaceAll('{{fullName}}', fullName)
          .replaceAll('{{email}}', email)
          .replaceAll('{{roleName}}', roleName)
          .replaceAll('{{registrationType}}', registrationType)
          .replaceAll(
            '{{requestDate}}',
            DateTime.now().toIso8601String().split('T')[0],
          )
          .replaceAll(
            '{{approvalLink}}',
            approvalLink ?? 'https://mcs.example.com/admin/approvals',
          );

      // Send email to each admin
      for (final admin in admins) {
        try {
          await _sendEmail(
            to: admin['email'] as String,
            subject: 'طلب موافقة جديد | New Approval Request: $fullName',
            htmlBody: emailBody,
          );

          log('Approval notification sent to: ${admin['email']}',
              name:
                  'ApprovalNotificationService.notifyAdminsOfPendingApproval');
        } catch (e) {
          log('Failed to notify admin ${admin['email']}: $e',
              name: 'ApprovalNotificationService.notifyAdminsOfPendingApproval',
              level: 900);
          // Continue notifying other admins
        }
      }

      log('Approval notification process completed',
          name: 'ApprovalNotificationService.notifyAdminsOfPendingApproval');
    } catch (e) {
      log('Error in notifyAdminsOfPendingApproval: $e',
          name: 'ApprovalNotificationService.notifyAdminsOfPendingApproval',
          level: 1000);
      // Non-blocking - don't throw, just log
    }
  }

  /// Send approval confirmation email to user
  /// إرسال بريد تأكيد الموافقة للمستخدم
  Future<void> sendApprovalConfirmationEmail({
    required String userEmail,
    required String fullName,
    required String roleName,
    String? adminNotes,
  }) async {
    try {
      log('Sending approval confirmation to: $userEmail',
          name: 'ApprovalNotificationService.sendApprovalConfirmationEmail');

      final emailBody = '''
<html dir="rtl" lang="ar">
  <head>
    <meta charset="UTF-8">
    <title>تم الموافقة على طلبك</title>
  </head>
  <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
      <h2 style="color: #00a652;">✓ تم الموافقة على طلبك - Your Request Approved</h2>
      
      <p>مرحباً $fullName,</p>
      <p>Hello $fullName,</p>
      
      <div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
        <p><strong>الدور الموافق عليه / Approved Role:</strong> $roleName</p>
        ${adminNotes != null ? '<p><strong>ملاحظات المسؤول / Admin Notes:</strong> $adminNotes</p>' : ''}
      </div>
      
      <p>
        يمكنك الآن الدخول إلى حسابك واستخدام جميع الميزات.<br>
        You can now log in to your account and use all features.
      </p>
      
      <p style="margin-top: 20px;">
        <a href="https://mcs.example.com/login" 
           style="display: inline-block; padding: 12px 30px; background-color: #00a652; color: white; text-decoration: none; border-radius: 5px;">
          تسجيل الدخول / Login
        </a>
      </p>
    </div>
  </body>
</html>
''';

      await _sendEmail(
        to: userEmail,
        subject: 'تم الموافقة على طلبك | Your Request Has Been Approved',
        htmlBody: emailBody,
      );

      log('Approval confirmation sent to: $userEmail',
          name: 'ApprovalNotificationService.sendApprovalConfirmationEmail');
    } catch (e) {
      log('Error sending approval confirmation: $e',
          name: 'ApprovalNotificationService.sendApprovalConfirmationEmail',
          level: 900);
      // Non-blocking
    }
  }

  /// Send rejection email to user
  /// إرسال بريد رفض الطلب للمستخدم
  Future<void> sendRejectionEmail({
    required String userEmail,
    required String fullName,
    required String rejectionReason,
  }) async {
    try {
      log('Sending rejection email to: $userEmail',
          name: 'ApprovalNotificationService.sendRejectionEmail');

      final emailBody = '''
<html dir="rtl" lang="ar">
  <head>
    <meta charset="UTF-8">
    <title>تم رفض طلبك</title>
  </head>
  <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
      <h2 style="color: #d32f2f;">تم رفض طلبك - Your Request Has Been Rejected</h2>
      
      <p>مرحباً $fullName,</p>
      <p>Hello $fullName,</p>
      
      <div style="background-color: #fff3e0; padding: 15px; border-radius: 5px; margin: 20px 0; border-right: 4px solid #d32f2f;">
        <p><strong>سبب الرفض / Rejection Reason:</strong></p>
        <p>$rejectionReason</p>
      </div>
      
      <p>
        إذا كان لديك أي استفسارات، يرجى التواصل مع فريق الدعم.<br>
        If you have any questions, please contact our support team.
      </p>
    </div>
  </body>
</html>
''';

      await _sendEmail(
        to: userEmail,
        subject: 'بشأن طلبك | Regarding Your Request',
        htmlBody: emailBody,
      );

      log('Rejection email sent to: $userEmail',
          name: 'ApprovalNotificationService.sendRejectionEmail');
    } catch (e) {
      log('Error sending rejection email: $e',
          name: 'ApprovalNotificationService.sendRejectionEmail', level: 900);
      // Non-blocking
    }
  }

  /// Get all super admin emails
  Future<List<Map<String, dynamic>>> _getSuperAdmins() async {
    try {
      final response = await _client
          .from('auth.users')
          .select('id, email, raw_user_meta_data')
          .filter('raw_user_meta_data->role', 'eq', 'super_admin');

      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      log('Error fetching super admins: $e',
          name: 'ApprovalNotificationService._getSuperAdmins', level: 900);
      return [];
    }
  }

  /// Send email via Supabase Edge Function or direct SMTP
  Future<void> _sendEmail({
    required String to,
    required String subject,
    required String htmlBody,
  }) async {
    try {
      // Try to call a Supabase Edge Function for sending emails
      final response = await _client.functions.invoke(
        'send-email',
        body: {
          'to': to,
          'subject': subject,
          'html': htmlBody,
        },
      );

      log('Email sent successfully via Edge Function',
          name: 'ApprovalNotificationService._sendEmail');
    } catch (e) {
      log('Could not send via Edge Function, attempting RPC: $e',
          name: 'ApprovalNotificationService._sendEmail', level: 800);

      // Fallback: try RPC if Edge Function fails
      try {
        await _client.rpc<dynamic>(
          'send_email',
          params: {
            'recipient': to,
            'subject': subject,
            'html_body': htmlBody,
          },
        );

        log('Email sent successfully via RPC',
            name: 'ApprovalNotificationService._sendEmail');
      } catch (e) {
        throw ServerException(
          message: 'Failed to send email: $e',
        );
      }
    }
  }
}
