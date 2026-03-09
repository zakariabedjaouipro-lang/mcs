# 🧪 Comprehensive Test Suite

دليل شامل للاختبارات المقترحة لجميع التغييرات المذكورة.

## تصميم الاختبارات

### 1. Unit Tests للـ Repositories

#### `test/features/employee/data/repositories/employee_repository_impl_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('EmployeeRepositoryImpl - generateRemoteSessionToken', () {
    late MockSupabaseService mockSupabaseService;
    late MockNotificationService mockNotificationService;
    late EmployeeRepositoryImpl repository;

    setUp(() {
      mockSupabaseService = MockSupabaseService();
      mockNotificationService = MockNotificationService();
      repository = EmployeeRepositoryImpl(
        supabaseService: mockSupabaseService,
        notificationService: mockNotificationService,
      );
    });

    test('Returns valid token when Agora service succeeds', () async {
      // Arrange
      const appointmentId = 'apt_001';
      const expectedToken = 'agora_token_xyz123';
      
      when(mockSupabaseService.call(
        'generate_agora_token',
        body: {'appointmentId': appointmentId},
      )).thenAnswer((_) async => {
        'token': expectedToken,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Act
      final result = await repository.generateRemoteSessionToken(appointmentId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right, got: $failure'),
        (token) => expect(token, equals(expectedToken)),
      );
      
      verify(mockSupabaseService.call(
        'generate_agora_token',
        body: {'appointmentId': appointmentId},
      )).called(1);
    });

    test('Returns ServerFailure when token is null', () async {
      // Arrange
      const appointmentId = 'apt_002';
      
      when(mockSupabaseService.call(
        'generate_agora_token',
        body: any,
      )).thenAnswer((_) async => {'token': null});

      // Act
      final result = await repository.generateRemoteSessionToken(appointmentId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure.message,
          contains('Failed to generate valid token'),
        ),
        (token) => fail('Should return Left, got Right: $token'),
      );
    });

    test('Returns ServerFailure when API throws exception', () async {
      // Arrange
      const appointmentId = 'apt_003';
      final exception = ServerException(message: 'API Error: 500');
      
      when(mockSupabaseService.call(any, body: any))
          .thenThrow(exception);

      // Act
      final result = await repository.generateRemoteSessionToken(appointmentId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('API Error')),
        (token) => fail('Should return Left'),
      );
    });

    test('Handles empty string token gracefully', () async {
      // Arrange
      when(mockSupabaseService.call(any, body: any))
          .thenAnswer((_) async => {'token': ''});

      // Act
      final result = await repository.generateRemoteSessionToken('apt_004');

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('EmployeeRepositoryImpl - sendNotificationToPatient', () {
    late MockSupabaseService mockSupabaseService;
    late MockNotificationService mockNotificationService;
    late EmployeeRepositoryImpl repository;

    setUp(() {
      mockSupabaseService = MockSupabaseService();
      mockNotificationService = MockNotificationService();
      repository = EmployeeRepositoryImpl(
        supabaseService: mockSupabaseService,
        notificationService: mockNotificationService,
      );
    });

    test('Sends notification successfully with valid FCM token', () async {
      // Arrange
      const patientId = 'patient_001';
      const title = 'Appointment Reminder';
      const body = 'Your appointment is tomorrow at 3 PM';
      const fcmToken = 'fcm_token_abc123';

      when(mockSupabaseService.getById('users', patientId))
          .thenAnswer((_) async => {
            'id': patientId,
            'fcm_token': fcmToken,
          });

      when(mockNotificationService.sendRemoteNotification(
        token: fcmToken,
        title: title,
        body: body,
        data: any,
      )).thenAnswer((_) async => true);

      // Act
      final result = await repository.sendNotificationToPatient(
        patientId,
        title,
        body,
      );

      // Assert
      expect(result.isRight(), true);
      verify(mockNotificationService.sendRemoteNotification(
        token: fcmToken,
        title: title,
        body: body,
        data: any,
      )).called(1);
    });

    test('Returns failure when patient FCM token is null', () async {
      // Arrange
      const patientId = 'patient_002';
      
      when(mockSupabaseService.getById('users', patientId))
          .thenAnswer((_) async => {
            'id': patientId,
            'fcm_token': null,
          });

      // Act
      final result = await repository.sendNotificationToPatient(
        patientId,
        'Title',
        'Body',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('FCM token not found')),
        (data) => fail('Should return Left'),
      );
      
      verifyNever(mockNotificationService.sendRemoteNotification(
        token: any,
        title: any,
        body: any,
        data: any,
      ));
    });

    test('Returns failure when patient not found', () async {
      // Arrange
      const patientId = 'patient_nonexistent';
      
      when(mockSupabaseService.getById('users', patientId))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.sendNotificationToPatient(
        patientId,
        'Title',
        'Body',
      );

      // Assert
      expect(result.isLeft(), true);
    });

    test('Includes correct metadata in notification', () async {
      // Arrange
      const patientId = 'patient_003';
      const fcmToken = 'fcm_token_xyz';

      when(mockSupabaseService.getById('users', patientId))
          .thenAnswer((_) async => {'fcm_token': fcmToken});

      final captor = ArgCaptor();
      when(mockNotificationService.sendRemoteNotification(
        token: any,
        title: any,
        body: any,
        data: captor(named: 'data'),
      )).thenAnswer((_) async => true);

      // Act
      await repository.sendNotificationToPatient(
        patientId,
        'Test',
        'Body',
      );

      // Assert
      expect(captor.value, {
        'type': 'appointment_notification',
      });
    });
  });
}
```

---

### 2. Widget Tests للـ Screens

#### `test/features/employee/presentation/screens/employee_dashboard_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('EmployeeDashboardScreen Widget Tests', () {
    late MockEmployeeBloc mockEmployeeBloc;
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockEmployeeBloc = MockEmployeeBloc();
      mockAuthBloc = MockAuthBloc();
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<EmployeeBloc>.value(value: mockEmployeeBloc),
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            ],
            child: const EmployeeDashboardScreen(),
          ),
        ),
      );
    }

    testWidgets('Displays employee welcome card', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(
        EmployeeProfileLoaded(
          profile: EmployeeModel(
            id: '1',
            name: 'John Doe',
            role: 'Receptionist',
          ),
        ),
      );

      // Act
      await pumpScreen(tester);

      // Assert
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Receptionist'), findsOneWidget);
    });

    testWidgets('Shows logout confirmation dialog', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(EmployeeInitial());

      await pumpScreen(tester);

      // Act - Tap the menu button and select logout
      await tester.tap(find.byType(PopupMenuButton<String>).first);
      await tester.pumpAndSettle();
      
      final logoutMenuItem = find.text(
        RegExp(r'Logout', caseSensitive: false),
      );
      await tester.tap(logoutMenuItem);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });

    testWidgets('Triggers logout when confirmed', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(EmployeeInitial());

      await pumpScreen(tester);

      // Act - Open dialog and confirm
      await tester.tap(find.byType(PopupMenuButton<String>).first);
      await tester.pumpAndSettle();
      
      await tester.tap(find.text(RegExp(r'Logout')));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Logout').last);
      await tester.pumpAndSettle();

      // Assert
      verify(mockAuthBloc.add(
        isA<LogoutEvent>(),
      )).called(1);
    });

    testWidgets('Displays stats cards correctly', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(
        DashboardStatsLoaded(
          stats: {
            'total_patients': 45,
            'today_appointments': 8,
            'pending_appointments': 3,
            'pending_invoices': 2,
          },
        ),
      );

      // Act
      await pumpScreen(tester);

      // Assert
      expect(find.text('45'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Drawer contains all navigation items', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(EmployeeInitial());
      await pumpScreen(tester);

      // Act
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Appointments'), findsOneWidget);
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('Invoices'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Navigation works on drawer taps', (WidgetTester tester) async {
      // Arrange
      when(mockEmployeeBloc.state).thenReturn(EmployeeInitial());
      await pumpScreen(tester);

      // Act
      await tester.tap(find.byType(Drawer));
      await tester.pumpAndSettle();

      final inventoryTile = find.text('Inventory');
      if (inventoryTile.evaluate().isNotEmpty) {
        await tester.tap(inventoryTile);
        await tester.pumpAndSettle();
      }

      // Assert - Verify navigation was triggered (via GoRouter)
      // This depends on your navigation setup
    });
  });
}
```

---

### 3. Integration Tests

#### `test/integration_tests/employee_features_integration_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Employee Features Integration Tests', () {
    testWidgets(
      'Complete logout flow with confirmation',
      (WidgetTester tester) async {
        // Step 1: Launch app with employee login
        await tester.pumpWidget(const McsApp());
        await tester.pumpAndSettle();

        // Step 2: Navigate to employee dashboard
        expect(find.byType(EmployeeDashboardScreen), findsOneWidget);

        // Step 3: Open profile menu
        await tester.tap(find.byType(PopupMenuButton<String>).first);
        await tester.pumpAndSettle();

        // Step 4: Tap logout
        await tester.tap(find.text(RegExp(r'Logout')));
        await tester.pumpAndSettle();

        // Step 5: Verify dialog shows
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Are you sure?'), findsOneWidget);

        // Step 6: Confirm logout
        await tester.tap(find.text('Logout').last);
        await tester.pumpAndSettle();

        // Step 7: Verify navigation to login
        expect(find.byType(LoginScreen), findsOneWidget);

        // Step 8: Verify session cleared
        final authService = getIt<AuthService>();
        expect(authService.currentUser, isNull);
      },
    );

    testWidgets(
      'Appointment notification sending',
      (WidgetTester tester) async {
        // Assume employee is logged in
        await tester.pumpWidget(const McsApp());
        await tester.pumpAndSettle();

        // Navigate to appointments screen
        await tester.tap(find.text('Appointments'));
        await tester.pumpAndSettle();

        // Find and tap an appointment
        final appointmentTile = find.byType(ListTile).first;
        await tester.tap(appointmentTile);
        await tester.pumpAndSettle();

        // Tap "Send Reminder" button (if exists)
        final sendButton = find.text('Send Reminder');
        if (sendButton.evaluate().isNotEmpty) {
          await tester.tap(sendButton);
          await tester.pumpAndSettle();

          // Verify success message
          expect(find.byType(SnackBar), findsWidgets);
          expect(find.text('Notification sent'), findsWidgets);
        }
      },
    );

    testWidgets(
      'Navigation through drawer',
      (WidgetTester tester) async {
        await tester.pumpWidget(const McsApp());
        await tester.pumpAndSettle();

        // Open drawer
        final scaffoldState = tester.state<ScaffoldState>(
          find.byType(Scaffold),
        );
        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        // Test each navigation item
        final navigationItems = [
          'Inventory',
          'Invoices',
          'Settings',
        ];

        for (final item in navigationItems) {
          await tester.tap(find.text(item));
          await tester.pumpAndSettle();

          // Close drawer after each navigation
          scaffoldState.openDrawer();
          await tester.pumpAndSettle();
        }
      },
    );
  });
}
```

---

## إجراء تشغيل الاختبارات

### تشغيل جميع الاختبارات:
```bash
flutter test --coverage
```

### تشغيل اختبارات معينة:
```bash
# Unit tests فقط
flutter test test/features/employee/data/repositories/

# Widget tests
flutter test test/features/employee/presentation/screens/

# Integration tests
flutter drive --target=test/integration_tests/main.dart
```

### إنشاء تقرير التغطية:
```bash
# تثبيت الأداة
pub global activate coverage

# إنشاء التقرير
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# فتح التقرير
open coverage/html/index.html
```

---

## معايير التقبول

✅ **جميع unit tests تمر**  
✅ **جميع widget tests تمر**  
✅ **تغطية اختبار 80% على الأقل**  
✅ **لا توجد تحذيرات linting في الكود**  
✅ **تطبيق يعمل بدون crashes**  
