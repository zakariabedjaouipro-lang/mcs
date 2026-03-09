# ⚠️ تقرير المخاطر والتبعات التفصيلي

---

## جدول ملخص المخاطر

| # | المخاطر | الاحتمالية | الأثير | الخطورة | الحل المقترح |
|----|--------|----------|-------|--------|------------|
| 1 | Agora Token Generation Failure | 60% | عالي جداً | 🔴 حرج | Fallback + Retry |
| 2 | Session State Inconsistency | 40% | عالي | 🔴 حرج | atomic operations |
| 3 | FCM Token Missing | 50% | عالي | 🔴 حرج | Check before send |
| 4 | Undefined Routes | 30% | متوسط | 🟡 متوسط | Route validation |
| 5 | BuildContext Crashes | 20% | متوسط | 🟡 متوسط | mounted checks |
| 6 | Performance Degradation | 40% | متوسط | 🟡 متوسط | Caching + Lazy Load |

---

## المخاطر التفصيلية

### 🔴 مخاطر حرجة (Critical)

#### 1. Agora Token Generation Failure

**الوصف**: إذا فشل Edge Function أو الاتصال بـ Agora، لن تتمكن من البدء في مكالمات الفيديو.

**الأعراض المحتملة**:
- ❌ مكالمة فيديو لا تبدأ
- ❌ رسالة خطأ غير واضحة للمستخدم
- ❌ التطبيق قد يتعطل عند التحميل

**السيناريوهات**:
```
السيناريو 1: Edge Function معطل
┌─────────────────────────────┐
│ generateRemoteSessionToken  │
│ → call('generate_agora...') │ ❌ FAILS
│ → No response               │
└─────────────────────────────┘

السيناريو 2: Network Timeout
┌─────────────────────────────┐
│ Call made successfully      │
│ → Waiting for response...   │ ⏳ 30s
│ → Timeout error             │ ❌ FAILS
└─────────────────────────────┘

السيناريو 3: Invalid Token Response
┌─────────────────────────────┐
│ Call successful             │
│ → response['token'] = null  │ ❌ FAILS
└─────────────────────────────┘
```

**التبعات**:
- الميزة الأساسية (video calls) معطلة
- المستخدمون يشعرون بالإحباط
- Support tickets زائدة

**الحل المقترح**:
```dart
// 1. من أفضل الممارسات - Retry logic مع exponential backoff
Future<Either<Failure, String>> generateRemoteSessionToken(String apt) async {
  const maxRetries = 3;
  var retryCount = 0;
  
  while (retryCount < maxRetries) {
    try {
      final response = await _supabaseService.call(
        'generate_agora_token',
        body: {'appointmentId': apt},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Token generation timeout'),
      );
      
      final token = response['token'] as String?;
      if (token != null && token.isNotEmpty) return Right(token);
      
    } on TimeoutException {
      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * retryCount));
        continue;
      }
    } on ServerException {
      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * retryCount));
        continue;
      }
    }
  }
  
  // Fallback: Log error and notify user
  _logger.error('Token generation failed after $maxRetries retries');
  return Left(
    ServerFailure(
      message: 'Unable to generate video call token. Please try again.',
    ),
  );
}

// 2. في الـ UI - Show meaningful error
context.read<VideoCallBloc>().add(GenerateTokenEvent(...));

// في الـ BLoC state:
if (state is TokenGenerationFailed) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          context.read<VideoCallBloc>().add(GenerateTokenEvent(...));
        },
      ),
    ),
  );
}
```

**خطوات الوقاية**:
- ✅ اختبر Edge Function في بيئة staging
- ✅ أضف monitoring و alerting
- ✅ وثّق API contract بوضوح
- ✅ أضف unit tests للعطل

**المراقبة المقترحة**:
```dart
// إضافة logging dashboard
_crashlytics.recordError(
  error,
  stackTrace,
  reason: 'Agora token generation failed',
  information: [
    DiagnosticsProperty('appointmentId', appointmentId),
    DiagnosticsProperty('timestamp', DateTime.now()),
    DiagnosticsProperty('environment', Environment.current),
  ],
);
```

---

#### 2. Session State Inconsistency During Logout

**الوصف**: عند تسجيل الخروج، قد تبقى بيانات مخزنة مؤقتاً أو جلسات نشطة.

**السيناريوهات**:
```
السيناريو 1: Token لا يُحذف
┌──────────────────────────────┐
│ 1. Logout triggered          │
│ 2. AuthBloc.add(LogoutEvent) │
│ 3. Clear local database ✅   │
│ 4. Clear SharedPrefs ✅      │
│ 5. Clear token ❌ FAILS      │
│ 6. User still authenticated  │
└──────────────────────────────┘

السيناريو 2: Cache race condition
┌──────────────────────────────┐
│ 1. Logout.add()              │
│ 2. API call made ✅          │
│ 3. But cached data still used │
│ 4. Shows past user data ❌   │
└──────────────────────────────┘
```

**التبعات**:
- ❌ وصول غير مصرح به من جديد
- ❌ تسرب بيانات المستخدم السابق
- 🔴 **مشكلة أمان حرجة**

**الحل المقترح**:
```dart
// في AuthBloc أو AuthService:
Future<void> logout() async {
  try {
    // 1. نحتفظ بـ backup من الحالة الحالية
    _previousAuthState = authState;
    
    // 2. تطبيق atomic logout
    await Future.wait([
      // Clear Supabase session
      _supabaseClient.auth.signOut(),
      
      // Clear local storage
      _localDataSource.clearAll(),
      
      // Clear cache
      _cacheService.clearAll(),
      
      // Clear secure storage (tokens)
      _secureStorage.deleteAll(),
      
      // Invalidate all BLoCs
      _invalidateAllBlocsCache(),
    ]);
    
    // 3. التحقق من أن الخروج تم بنجاح
    if (_supabaseClient.auth.currentUser != null) {
      throw LogoutException('Failed to clear Supabase session');
    }
    
    // 4. إعادة تعيين الحالة
    _authState = AuthState.unauthenticated;
    
  } catch (e) {
    // Rollback في حالة الفشل
    _authState = _previousAuthState;
    rethrow;
  }
}

// في الـ UI:
context.read<AuthBloc>().add(const LogoutEvent());

// بعد اكتمال العملية:
if (state is LoggedOut) {
  // 1. تنظيف كامل الـ route stack
  context.go(AppRoutes.login);
  
  // 2. تأكيد عدم وجود بيانات متبقية
  assert(_authService.currentUser == null);
  
  // 3. إعادة تعيين جميع البيانات في الذاكرة
  await _supabaseService.reset();
}
```

**معايير التحقق**:
```dart
// Test case: Verify complete logout
test('Logout clears all sessions and data', () async {
  // Before logout
  expect(authService.currentUser, isNotNull);
  expect(secureStorage.hasToken(), isTrue);
  
  // Perform logout
  await authService.logout();
  
  // After logout - All must be true
  expect(authService.currentUser, isNull);
  expect(secureStorage.hasToken(), isFalse);
  expect(localStorage.isEmpty(), isTrue);
  expect(cacheService.isEmpty(), isTrue);
});
```

---

#### 3. FCM Token Missing or Invalid

**الوصف**: بيانات FCM قد لا توجد في قاعدة البيانات، أو قد تكون منتهية الصلاحية.

**السيناريوهات**:
```
السيناريو 1: Token لم يسجل
┌──────────────────────────────┐
│ 1. New user signs up         │
│ 2. FCM refreshed ✅          │
│ 3. But didn't save to DB ❌  │
│ 4. Notifications fail        │
└──────────────────────────────┘

السيناريو 2: Token Expired
┌──────────────────────────────┐
│ 1. Old token in database     │
│ 2. Firebase refreshed it ✅  │
│ 3. Local token != DB token ❌│
│ 4. Notifications fail        │
└──────────────────────────────┘
```

**التبعات**:
- المستخدمون لا يتلقون إشعارات
- عدم القدرة على تذكيرات المواعيد
- تجربة مستخدم سيئة

**الحل المقترح**:
```dart
Future<Either<Failure, void>> sendNotificationToPatient(
  String patientId,
  String title,
  String body,
) async {
  try {
    // 1. جلب الـ patient data
    final patient = await _supabaseService.getById('users', patientId);
    
    if (patient == null) {
      return Left(ServerFailure(message: 'Patient not found'));
    }
    
    // 2. الحصول على الـ token
    var fcmToken = patient['fcm_token'] as String?;
    
    // 3. إذا كان التوكن فارغاً أو منتهي الصلاحية، حاول التحديث
    if (fcmToken == null || fcmToken.isEmpty) {
      // محاولة الحصول على token جديد من Firebase
      final newToken = await _firebaseMessaging.getToken();
      if (newToken != null) {
        // تحديث database بالـ token الجديد
        await _supabaseService.update(
          'users',
          {'fcm_token': newToken},
          PostgrestFilterBuilder().eq('id', patientId),
        );
        fcmToken = newToken;
      }
    }
    
    // 4. التحقق النهائي
    if (fcmToken == null || fcmToken.isEmpty) {
      _logger.warning('FCM token still missing for patient: $patientId');
      return Left(
        ServerFailure(
          message: 'Patient has notifications disabled or token missing',
        ),
      );
    }
    
    // 5. إرسال الإشعار
    try {
      await _notificationService.sendRemoteNotification(
        token: fcmToken,
        title: title,
        body: body,
        data: {
          'type': 'appointment_notification',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } on FirebaseException catch (e) {
      // قد يكون التوكن غير صالح
      if (e.code == 'messaging/invalid-registration-token') {
        // احذف التوكن القديم وأخبر المستخدم
        await _supabaseService.update(
          'users',
          {'fcm_token': null},
          PostgrestFilterBuilder().eq('id', patientId),
        );
        
        return Left(
          ServerFailure(
            message: 'Notification token expired. Please reinstall app.',
          ),
        );
      }
      rethrow;
    }
    
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } catch (e) {
    return Left(ServerFailure(message: 'Failed to send notification: $e'));
  }
}
```

**إجراءات الوقاية**:
```dart
// في initialization:
void _initializeNotifications() {
  // حفظ token عند تحديثه
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    _saveTokenToDatabase(newToken);
    _logger.info('FCM token refreshed: ${newToken.substring(0, 20)}...');
  });
  
  // اختبر الاتصال أثناء التطبيق
  _verifyNotificationSetup();
}

Future<void> _saveTokenToDatabase(String token) async {
  try {
    final response = await _supabaseClient
        .from('users')
        .update({'fcm_token': token})
        .eq('id', _authService.currentUser!.id);
    
    _logger.info('FCM token saved to database');
  } catch (e) {
    _logger.error('Failed to save FCM token: $e');
    // Send to error tracking
    _crashlytics.recordError(e, StackTrace.current);
  }
}
```

---

### 🟡 مخاطر متوسطة (Medium)

#### 4. Undefined Routes

**المشكلة**: إذا لم يتم تعريف routes بشكل صحيح في GoRouter.

```dart
// ❌ BEFORE - Route غير معرّفة
context.go(AppRoutes.inventory);  // قد لا توجد!

// ✅ AFTER - تأكد من التعريف
// في config/app_routes.dart:
class AppRoutes {
  static const String inventory = '/employee/inventory';
  static const String invoices = '/employee/invoices';
  static const String settings = '/settings';
  
  static String appointmentDetails(String id) => '/appointments/$id';
  static String rescheduleAppointment(String id) => '/appointments/$id/reschedule';
}

// في config/router_config.dart:
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/employee/inventory',
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: '/employee/invoices',
      builder: (context, state) => const InvoicesScreen(),
    ),
    GoRoute(
      path: '/appointments/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AppointmentDetailsScreen(appointmentId: id);
      },
    ),
    GoRoute(
      path: '/appointments/:id/reschedule',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RescheduleAppointmentScreen(appointmentId: id);
      },
    ),
  ],
);
```

**الحل**:
- ✅ تحقق من جميع routes المستخدمة
- ✅ استخدم constants لـ routes
- ✅ اختبر navigation قبل الإطلاق

---

#### 5. BuildContext Usage After Async Gap

**المشكلة**: استخدام `context` بعد عملية async قد تسبب crashes.

```dart
// ❌ BEFORE - خطر
onPressed: () async {
  await Future.delayed(const Duration(seconds: 1));
  if (mounted) {
    // ⚠️ قد يكون widget قد تم فصله
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
},

// ✅ AFTER - آمن
onPressed: () async {
  await Future.delayed(const Duration(seconds: 1));
  if (!mounted) return;
  // الآن context آمن للاستخدام
  ScaffoldMessenger.of(context).showSnackBar(...);
},
```

---

#### 6. Performance Degradation

**المشكلة**: رسم custom widget (medical_crescent_logo) قد يكون بطيئاً.

```dart
// ✅ الحل: Use RepaintBoundary للـ cache
class MedicalCrescentLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: MedicalCrescentPainter(),
        size: const Size(200, 200),
      ),
    );
  }
}
```

---

### 🟢 مخاطر منخفضة (Low)

#### Store URLs Configuration

```dart
// ✅ تحديثات مقترحة:
static const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.mcs.app';
static const _appStoreUrl =
    'https://apps.apple.com/app/mcs/id1234567890';
static const _windowsDownloadUrl =
    'https://mcs.app/download/windows';
static const _macDownloadUrl =
    'https://mcs.app/download/macos';

// Test URLs قبل الإطلاق
test_urls() {
  expect(
    Uri.tryParse(_playStoreUrl),
    isNotNull,
  );
}
```

---

## مصفوفة قرار المخاطر

```
┌─────────────────────────────────────────────────────────┐
│           الاحتمالية (Probability)                      │
│   منخفضة   │   متوسطة    │     عالية                   │
├─────────────────────────────────────────────────────────┤
│  🟢 قبول  │  🟡 مراقبة  │  🔴 يجب التقليل             │
│  المخاطر  │             │                              │
├─────────────────────────────────────────────────────────┤
│ Store URLs │ BuildContext │ Agora Token                  │
│            │ Performance  │ Session Consistency          │
│            │              │ FCM Token                    │
└─────────────────────────────────────────────────────────┘
```

---

## خطة تخفيف المخاطر

| المخاطر | التأثير | الحد الأدنى | المقترح |
|--------|--------|----------|--------|
| Agora Token | عالي جداً | Retry Logic | Fallback Token |
| Session Consistency | عالي | Unit Tests | State validation |
| FCM Token | عالي | Null checks | Auto-refresh |
| Routes | متوسط | Lint test | Route validation |
| BuildContext | متوسط | mounted checks | Context wrapper |
| Performance | متوسط | Profiling | Caching + Optimization |

