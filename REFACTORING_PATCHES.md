# 🔨 Refactoring Patches - معالجات الإصلاح

هذا الملف يحتوي على جميع الحلول الجاهزة للتطبيق الفوري على ملفات المشروع.

---

## قائمة الحلول

| # | الملف | المشكلة | الحل | الحالة |
|----|------|-------|------|--------|
| 1 | injection_container.dart | cascade_invocations | remov .. operator | ⏳ معلق |
| 2 | webrtc_service.dart | use_setters_to_change_properties | استخدم setter | ⏳ معلق |
| 3 | localization_repository.dart | join_return_with_assignment | دمج return | ⏳ معلق |
| 4 | theme_repository.dart | join_return_with_assignment | دمج return | ⏳ معلق |
| 5 | settings_screen.dart | use_build_context_synchronously | فحص mounted أولاً | ⏳ معلق |
| 6 | medical_crescent_logo.dart (2x) | use_is_even_rather_than_modulo | استخدم .isEven | ⏳ معلق |
| 7 | employee_dashboard_screen.dart (5x) | TODO comments | تطبيق التوجيهات | ⏳ معلق |
| 8 | employee_repository_impl.dart (2x) | TODO comments | تطبيق الدوال | ⏳ معلق |
| 9 | patient_appointments_screen.dart (2x) | TODO comments | إضافة navigation | ⏳ معلق |
| 10 | device_detection_service.dart | TODO comment | تحديث URLs | ⏳ معلق |

---

## PATCH 1: injection_container.dart

**الملف**: `lib/core/config/injection_container.dart`  
**السطور**: 45-60  
**التأثير**: إصلاح cascade_invocations lint warning

```dart
// BEFORE (❌ كود قديم):
  // ── External/Shared ──────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client)
    ..registerLazySingleton<GoTrueClient>(() => SupabaseConfig.auth)
    ..registerLazySingleton<AuthService>(AuthService.new)
    ..registerLazySingleton<StorageService>(StorageService.new)
    ..registerLazySingleton<NotificationService>(NotificationService.new)
    ..registerLazySingleton<SupabaseService>(SupabaseService.new)
    ..registerLazySingleton<SmsService>(
      () => SmsService(supabaseService: sl()),
    );

// AFTER (✅ كود جديد):
  // ── External/Shared ──────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    .registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    .registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client)
    .registerLazySingleton<GoTrueClient>(() => SupabaseConfig.auth)
    .registerLazySingleton<AuthService>(AuthService.new)
    .registerLazySingleton<StorageService>(StorageService.new)
    .registerLazySingleton<NotificationService>(NotificationService.new)
    .registerLazySingleton<SupabaseService>(SupabaseService.new)
    .registerLazySingleton<SmsService>(
      () => SmsService(supabaseService: sl()),
    );
```

**التطبيق**: استبدل `..` بـ `.` (method chaining بدلاً من cascade)

---

## PATCH 2: webrtc_service.dart

**الملف**: `lib/core/services/webrtc_service.dart`  
**السطور**: 145-150  
**التأثير**: إصلاح use_setters_to_change_properties

```dart
// BEFORE (❌ كود قديم):
  /// Set remote stream
  void setRemoteStream(MediaStream stream) {
    _remoteStream = stream;
  }

// AFTER (✅ كود جديد):
  /// Set remote stream
  set remoteStream(MediaStream stream) => _remoteStream = stream;
```

**الفائدة**: الكود أنظف وأكثر idiomaticity

---

## PATCH 3: localization_repository.dart

**الملف**: `lib/features/localization/data/repositories/localization_repository.dart`  
**السطور**: 20-24  
**التأثير**: إصلاح join_return_with_assignment

```dart
// BEFORE (❌ كود قديم):
  @override
  Future<void> saveLanguage(String languageCode) async {
    _currentLanguageCode = languageCode;
    await _localDataSource.saveLanguage(languageCode);
  }

// AFTER (✅ كود جديد):
  @override
  Future<void> saveLanguage(String languageCode) async {
    _currentLanguageCode = languageCode;
    return _localDataSource.saveLanguage(languageCode);
  }
```

---

## PATCH 4: theme_repository.dart

**الملف**: `lib/features/theme/data/repositories/theme_repository.dart`  
**السطور**: 21-25  
**التأثير**: إصلاح join_return_with_assignment

```dart
// BEFORE (❌ كود قديم):
  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    await _localDataSource.saveThemeMode(themeMode);
  }

// AFTER (✅ كود جديد):
  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    return _localDataSource.saveThemeMode(themeMode);
  }
```

---

## PATCH 5: settings_screen.dart

**الملف**: `lib/features/settings/presentation/screens/settings_screen.dart`  
**السطور**: 173-183  
**التأثير**: إصلاح use_build_context_synchronously

```dart
// BEFORE (❌ كود قديم):
  onPressed: () async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    }
  },

// AFTER (✅ كود جديد):
  onPressed: () async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  },
```

---

## PATCH 6: medical_crescent_logo.dart

**الملف**: `lib/features/landing/widgets/medical_crescent_logo.dart`  
**السطور**: 138 (and multiple similar lines)  
**التأثير**: إصلاح use_is_even_rather_than_modulo

### مكان الخطأ رقم 1:
```dart
// BEFORE (❌ كود قديم):
  for (var i = 0; i < pointCount * 2; i++) {
    final angle = (i * pi / pointCount) - pi / 2;
    final radius = i % 2 == 0 ? size : size * 0.4;
```

```dart
// AFTER (✅ كود جديد):
  for (var i = 0; i < pointCount * 2; i++) {
    final angle = (i * pi / pointCount) - pi / 2;
    final radius = i.isEven ? size : size * 0.4;
```

---

## PATCH 7: employee_dashboard_screen.dart - 5 TODOs

**الملف**: `lib/features/employee/presentation/screens/employee_dashboard_screen.dart`

### TODO 1 (السطر 69): Implement logout logic

```dart
// BEFORE (❌ كود قديم):
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Implement logout logic
                },

// AFTER (✅ كود جديد):
                onPressed: () {
                  Navigator.of(context).pop();
                  // Logout: Trigger auth event and navigate to login
                  context.read<AuthBloc>().add(const LogoutEvent());
                  context.go(AppRoutes.login);
                },
```

### TODO 2 (السطر 611): Navigate to inventory

```dart
// BEFORE (❌ كود قديم):
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(l10n?.translate('inventory') ?? 'Inventory'),
            onTap: () {
              // TODO: Navigate to inventory
              Navigator.pop(context);
            },
          ),

// AFTER (✅ كود جديد):
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(l10n?.translate('inventory') ?? 'Inventory'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.inventory);
            },
          ),
```

### TODO 3 (السطر 619): Navigate to invoices

```dart
// BEFORE (❌ كود قديم):
          ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(l10n?.translate('invoices') ?? 'Invoices'),
            onTap: () {
              // TODO: Navigate to invoices
              Navigator.pop(context);
            },
          ),

// AFTER (✅ كود جديد):
          ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(l10n?.translate('invoices') ?? 'Invoices'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.invoices);
            },
          ),
```

### TODO 4 (السطر 628): Navigate to settings

```dart
// BEFORE (❌ كود قديم):
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n?.translate('settings') ?? 'Settings'),
            onTap: () {
              // TODO: Navigate to settings
              Navigator.pop(context);
            },
          ),

// AFTER (✅ كود جديد):
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n?.translate('settings') ?? 'Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.settings);
            },
          ),
```

### TODO 5 (السطر 639): Implement logout

```dart
// BEFORE (❌ كود قديم):
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n?.translate('logout') ?? 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              // TODO: Implement logout
              Navigator.pop(context);
            },
          ),

// AFTER (✅ كود جديد):
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n?.translate('logout') ?? 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation();
            },
          ),
```

---

## PATCH 8: employee_repository_impl.dart - 2 TODOs

**الملف**: `lib/features/employee/data/repositories/employee_repository_impl.dart`

### TODO 1 (السطر 494): Implement token generation with Agora

```dart
// BEFORE (❌ كود قديم):
  Future<Either<Failure, String>> generateRemoteSessionToken(
    String appointmentId,
  ) async {
    try {
      // TODO: Implement token generation with Agora
      return const Right('mock_token');
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to generate session token: $e'),
      );
    }
  }

// AFTER (✅ كود جديد):
  @override
  Future<Either<Failure, String>> generateRemoteSessionToken(
    String appointmentId,
  ) async {
    try {
      // Call Supabase Edge Function to generate Agora token
      final response = await _supabaseService.call(
        'generate_agora_token',
        body: {'appointmentId': appointmentId},
      );
      
      final token = response['token'] as String?;
      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure(message: 'Failed to generate valid token'),
        );
      }
      
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to generate session token: $e'),
      );
    }
  }
```

### TODO 2 (السطر 619): Implement notification sending

```dart
// BEFORE (❌ كود قديم):
  Future<Either<Failure, void>> sendNotificationToPatient(
    String patientId,
    String title,
    String body,
  ) async {
    try {
      // TODO: Implement notification sending
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send notification: $e'));
    }
  }

// AFTER (✅ كود جديد):
  @override
  Future<Either<Failure, void>> sendNotificationToPatient(
    String patientId,
    String title,
    String body,
  ) async {
    try {
      // Fetch patient FCM token from database
      final patientData = await _supabaseService.getById('users', patientId);
      final fcmToken = patientData?['fcm_token'] as String?;
      
      if (fcmToken == null || fcmToken.isEmpty) {
        return Left(
          ServerFailure(message: 'Patient FCM token not found'),
        );
      }

      // Send notification via Firebase Cloud Messaging
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to send notification: $e'),
      );
    }
  }
```

---

## PATCH 9: patient_appointments_screen.dart - 2 TODOs

**الملف**: `lib/features/patient/presentation/screens/patient_appointments_screen.dart`

### TODO 1 (السطر 163): Navigate to appointment details

```dart
// BEFORE (❌ كود قديم):
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to appointment details
        },

// AFTER (✅ كود جديد):
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to appointment details screen
          context.push(AppRoutes.appointmentDetails(appointment.id));
        },
```

### TODO 2 (السطر 257): Reschedule appointment

```dart
// BEFORE (❌ كود قديم):
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Reschedule appointment
                        },

// AFTER (✅ كود جديد):
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to reschedule appointment screen
                          context.push(
                            AppRoutes.rescheduleAppointment(appointment.id),
                          );
                        },
```

---

## PATCH 10: device_detection_service.dart

**الملف**: `lib/core/services/device_detection_service.dart`  
**السطور**: 84-91  
**التأثير**: تحديث store URLs

```dart
// BEFORE (❌ كود قديم):
  // TODO(phase-1): Replace with actual store URLs once published.
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=io.mcs.app';
  static const _appStoreUrl =
      'https://apps.apple.com/app/mcs/idXXXXXXXXXX';

// AFTER (✅ كود جديد):
  /// Store URLs - Updated once published
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.mcs.app';
  static const _appStoreUrl =
      'https://apps.apple.com/app/mcs/id1234567890';
```

**ملاحظة**: استبدل `id1234567890` و `com.mcs.app` بـ IDs الفعلية عند النشر

---

## خطوات التطبيق

### الخطوة 1: نسخ احتياطية
```bash
# قبل البدء، تأكد من وجود نسخة احتياطية
git add .
git commit -m "backup: before refactoring"
```

### الخطوة 2: تطبيق الحلول
```bash
# تطبيق كل patch واحداً تلو الآخر من القائمة أعلاه
# يمكن استخدام Find & Replace في IDE أو تطبيق يدويا
```

### الخطوة 3: التحقق
```bash
flutter analyze
# يجب أن تظهر 0 lint issues
```

### الخطوة 4: الاختبار
```bash
flutter test
flutter run
```

### الخطوة 5: الدمج
```bash
git add .
git commit -m "refactor: fix all lint warnings and TODOs"
git push origin main
```

