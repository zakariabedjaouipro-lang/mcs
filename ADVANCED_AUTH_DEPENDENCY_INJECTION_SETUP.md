# Updated Dependency Injection Setup
# تحديث إعدادات حقن التبعيات

This file shows how to register the new advanced authentication services in the dependency injection container.

## Location
`lib/core/config/injection_container.dart`

## Complete Updated Setup

```dart
import 'package:get_it/get_it.dart';
import 'package:mcs/core/config/email_templates.dart';
import 'package:mcs/core/services/email_verification_service.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/services/totp_service.dart';
import 'package:mcs/features/auth/data/repositories/advanced_auth_repository_impl.dart';
import 'package:mcs/features/auth/domain/repositories/advanced_auth_repository.dart';
import 'package:mcs/features/auth/domain/usecases/role_registration_usecases.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ──────────────────────────────────────────────────────────────────────────
  // CORE SERVICES
  // ──────────────────────────────────────────────────────────────────────────

  // Supabase service (should already be registered)
  // sl.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Email Verification Service - NEW
  sl.registerLazySingleton<EmailVerificationService>(
    () => EmailVerificationService(
      supabaseService: sl<SupabaseService>(),
    ),
  );

  // Role-Based Authentication Service
  sl.registerLazySingleton<RoleBasedAuthenticationService>(
    () => RoleBasedAuthenticationService(),
  );

  // TOTP Service - NEW (no dependencies)
  // TotpService is static, no need to register

  // ──────────────────────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────────────────────

  // Advanced Auth Repository - NEW
  sl.registerLazySingleton<AdvancedAuthRepository>(
    () => AdvancedAuthRepositoryImpl(
      roleBasedAuthService: sl<RoleBasedAuthenticationService>(),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // USE CASES - All 9 use cases
  // ──────────────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<GetAllRolesUseCase>(
    () => GetAllRolesUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<GetPublicRolesUseCase>(
    () => GetPublicRolesUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<GetRolePermissionsUseCase>(
    () => GetRolePermissionsUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<CreateRegistrationRequestUseCase>(
    () => CreateRegistrationRequestUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<Enable2FAUseCase>(
    () => Enable2FAUseCase(sl<RoleBasedAuthenticationService>()),
  );

  sl.registerLazySingleton<GetPendingRegistrationRequestsUseCase>(
    () => GetPendingRegistrationRequestsUseCase(
      sl<RoleBasedAuthenticationService>(),
    ),
  );

  sl.registerLazySingleton<ApproveRegistrationRequestUseCase>(
    () => ApproveRegistrationRequestUseCase(
      sl<RoleBasedAuthenticationService>(),
    ),
  );

  sl.registerLazySingleton<RejectRegistrationRequestUseCase>(
    () => RejectRegistrationRequestUseCase(
      sl<RoleBasedAuthenticationService>(),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // BLOC - Advanced Authentication BLoC
  // ──────────────────────────────────────────────────────────────────────────

  sl.registerFactory<AdvancedAuthBloc>(
    () => AdvancedAuthBloc(
      roleBasedAuthService: sl<RoleBasedAuthenticationService>(),
      supabaseService: sl<SupabaseService>(),
      getAllRolesUseCase: sl<GetAllRolesUseCase>(),
      getPublicRolesUseCase: sl<GetPublicRolesUseCase>(),
      getRolePermissionsUseCase: sl<GetRolePermissionsUseCase>(),
      createRegistrationRequestUseCase: sl<CreateRegistrationRequestUseCase>(),
      verifyEmailUseCase: sl<VerifyEmailUseCase>(),
      enable2FAUseCase: sl<Enable2FAUseCase>(),
      getPendingRegistrationRequestsUseCase:
          sl<GetPendingRegistrationRequestsUseCase>(),
      approveRegistrationRequestUseCase:
          sl<ApproveRegistrationRequestUseCase>(),
      rejectRegistrationRequestUseCase:
          sl<RejectRegistrationRequestUseCase>(),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Other existing registrations...
  // ──────────────────────────────────────────────────────────────────────────
}
```

## Service Usage Examples

### 1. Email Verification Service

```dart
// Inject the service
final emailService = sl<EmailVerificationService>();

// Send verification email
await emailService.sendVerificationEmail(
  email: 'user@example.com',
  userName: 'أحمد محمد',
  verificationLink: 'https://app.com/verify?token=xyz',
);

// Validate token
bool isValid = emailService.isTokenValid(token);
```

### 2. TOTP Service

```dart
// Generate secret
String secret = TotpService.generateSecret();

// Generate QR code URI
String qrUri = TotpService.generateQrCodeUri(
  secret: secret,
  userId: userId,
  issuer: 'MCS',
);

// Verify code
bool isValid = TotpService.verifyCode(
  secret: secret,
  code: '123456',
);

// Generate backup codes
List<String> codes = TotpService.generateBackupCodes();
```

### 3. Advanced Auth Repository

```dart
// Inject the repository
final authRepository = sl<AdvancedAuthRepository>();

// Get all roles
final rolesResult = await authRepository.getAllRoles();
rolesResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (roles) => print('Roles: $roles'),
);

// Create registration request
final registerResult = await authRepository.createRegistrationRequest(
  userId: userId,
  roleId: roleId,
  requestedData: {'specialization': 'Cardiology'},
);
```

### 4. Using in BLoC

```dart
// In your widget
BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
  builder: (context, state) {
    if (state is RolesLoadedSuccess) {
      return ListView(
        children: state.roles.map((role) {
          return ListTile(
            title: Text(role.displayNameAr),
            subtitle: Text(role.displayNameEn),
          );
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  },
);

// Trigger events
context.read<AdvancedAuthBloc>().add(
  const LoadAvailableRolesRequested(publicOnly: true),
);
```

## Integration Checklist

- [x] EmailVerificationService registered
- [x] TotpService available (static)
- [x] AdvancedAuthRepository registered
- [x] All 9 use cases registered
- [x] AdvancedAuthBloc registered with all dependencies
- [x] Email templates available
- [x] Demo accounts available for testing

## Dependencies Required

Add to `pubspec.yaml` if not already present:

```yaml
dependencies:
  get_it: ^7.6.4
  dartz: ^0.10.1
  flutter_bloc: ^8.1.6
  supabase_flutter: ^2.10.0
  equatable: ^2.0.5
```

## Environment Variables

Create `.env` file in project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
EMAIL_SENDER=noreply@mcs.local
```

## Next Steps

1. Update `injection_container.dart` with the above registrations
2. Ensure all imports are correct
3. Run `flutter pub get`
4. Run `flutter analyze` to check for errors
5. Test with demo accounts
6. Deploy migrations to Supabase
