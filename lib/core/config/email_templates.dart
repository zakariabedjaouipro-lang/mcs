/// Email Templates Configuration
/// قوالب البريد الإلكتروني
library;

class EmailTemplates {
  // ── Verification Email ───────────────────────────────────

  /// Email template for email verification
  static Map<String, String> verificationEmail({
    required String userName,
    required String verificationLink,
  }) {
    return {
      'subject': 'تحقق من بريدك الإلكتروني - Verify Your Email',
      'html': '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f9f9f9; padding: 20px; margin: 20px 0; }
    .button { background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>مرحبا بك في النظام</h1>
    </div>
    
    <div class="content">
      <p>السلام عليكم ورحمة الله وبركاته $userName</p>
      
      <p>لقد قمت بإنشاء حساب جديد معنا. يُرجى التحقق من بريدك الإلكتروني بالنقر على الزر أدناه:</p>
      
      <p style="text-align: center;">
        <a href="$verificationLink" class="button">تحقق من بريدك الإلكتروني</a>
      </p>
      
      <p>أو نسخ واستخدم هذا الرابط:</p>
      <p style="word-break: break-all; font-size: 12px;">$verificationLink</p>
      
      <p>هذا الرابط سينتهي بعد 24 ساعة.</p>
    </div>
    
    <div class="footer">
      <p>© 2026 Medical Clinic Management System. جميع الحقوق محفوظة.</p>
    </div>
  </div>
</body>
</html>
      '''
    };
  }

  // ── Approval Notification Email ──────────────────────────

  /// Email template for registration approval
  static Map<String, String> approvalNotificationEmail({
    required String userName,
    required String roleName,
  }) {
    return {
      'subject': 'تمت الموافقة على حسابك - Account Approved',
      'html': '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #2196F3; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f9f9f9; padding: 20px; margin: 20px 0; }
    .success { background-color: #4CAF50; color: white; padding: 15px; border-radius: 5px; text-align: center; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>تم الموافقة على طلبك!</h1>
    </div>
    
    <div class="content">
      <p>السلام عليكم ورحمة الله وبركاته $userName</p>
      
      <div class="success">
        <h2>✓ تمت الموافقة</h2>
      </div>
      
      <p>يسرنا إعلامك بأنه تمت الموافقة على طلب التسجيل الخاص بك كـ <strong>$roleName</strong></p>
      
      <p>يمكنك الآن تسجيل الدخول إلى النظام باستخدام بيانات اعتمادك.</p>
      
      <p>إذا واجهت أي مشاكل، يُرجى التواصل مع فريق الدعم.</p>
    </div>
    
    <div class="footer">
      <p>© 2026 Medical Clinic Management System. جميع الحقوق محفوظة.</p>
    </div>
  </div>
</body>
</html>
      '''
    };
  }

  // ── Rejection Notification Email ─────────────────────────

  /// Email template for registration rejection
  static Map<String, String> rejectionNotificationEmail({
    required String userName,
    required String roleName,
    required String rejectionReason,
  }) {
    return {
      'subject': 'تفاصيل تقديمك - Application Details',
      'html': '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #f44336; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f9f9f9; padding: 20px; margin: 20px 0; }
    .reason { background-color: #fff3cd; padding: 15px; border-right: 4px solid #ff9800; margin: 15px 0; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>معلومات طلبك</h1>
    </div>
    
    <div class="content">
      <p>السلام عليكم ورحمة الله وبركاته $userName</p>
      
      <p>شكراً لتقديمك لطلب التسجيل كـ <strong>$roleName</strong></p>
      
      <div class="reason">
        <p><strong>السبب:</strong></p>
        <p>$rejectionReason</p>
      </div>
      
      <p>يمكنك إعادة محاولة التقديم والتأكد من توفر جميع المتطلبات المطلوبة.</p>
      
      <p>للمزيد من المعلومات، يُرجى التواصل مع فريق الدعم.</p>
    </div>
    
    <div class="footer">
      <p>© 2026 Medical Clinic Management System. جميع الحقوق محفوظة.</p>
    </div>
  </div>
</body>
</html>
      '''
    };
  }

  // ── Two-Factor Authentication Confirmation ───────────────

  /// Email template for 2FA setup confirmation
  static Map<String, String> twoFactorConfirmationEmail({
    required String userName,
  }) {
    return {
      'subject': 'تم تفعيل المصادقة الثنائية - 2FA Enabled',
      'html': '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #9C27B0; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f9f9f9; padding: 20px; margin: 20px 0; }
    .reminder { background-color: #e3f2fd; padding: 15px; border-right: 4px solid #2196F3; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>تم تفعيل المصادقة الثنائية</h1>
    </div>
    
    <div class="content">
      <p>السلام عليكم ورحمة الله وبركاته $userName</p>
      
      <p>تم تفعيل المصادقة الثنائية في حسابك بنجاح!</p>
      
      <div class="reminder">
        <h3>نقاط مهمة:</h3>
        <ul>
          <li>احفظ رموز الاحتياطية في مكان آمن</li>
          <li>سيُطلب منك إدخال رمز التحقق عند تسجيل الدخول</li>
          <li>في حالة فقدان الجهاز، استخدم الرموز الاحتياطية</li>
          <li>لا تشارك رموزك مع أحد</li>
        </ul>
      </div>
      
      <p>حسابك أصبح أكثر أماناً الآن.</p>
    </div>
    
    <div class="footer">
      <p>© 2026 Medical Clinic Management System. جميع الحقوق محفوظة.</p>
    </div>
  </div>
</body>
</html>
      '''
    };
  }

  // ── Password Reset Email ────────────────────────────────

  /// Email template for password reset
  static Map<String, String> passwordResetEmail({
    required String userName,
    required String resetLink,
  }) {
    return {
      'subject': 'إعادة تعيين كلمة المرور - Reset Password',
      'html': '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #FF9800; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f9f9f9; padding: 20px; margin: 20px 0; }
    .button { background-color: #FF9800; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>إعادة تعيين كلمة المرور</h1>
    </div>
    
    <div class="content">
      <p>السلام عليكم ورحمة الله وبركاته $userName</p>
      
      <p>تلقينا طلباً لإعادة تعيين كلمة المرور الخاصة بك.</p>
      
      <p style="text-align: center;">
        <a href="$resetLink" class="button">إعادة تعيين كلمة المرور</a>
      </p>
      
      <p>إذا لم تطلب هذا، تجاهل هذا البريد.</p>
      <p>هذا الرابط سينتهي بعد ساعة واحدة.</p>
    </div>
    
    <div class="footer">
      <p>© 2026 Medical Clinic Management System. جميع الحقوق محفوظة.</p>
    </div>
  </div>
</body>
</html>
      '''
    };
  }
}
