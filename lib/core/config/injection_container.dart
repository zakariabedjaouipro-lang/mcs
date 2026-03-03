/// Dependency Injection setup using GetIt.
///
/// All services, repositories, and BLoCs are registered here.
/// Call [configureDependencies] once at app startup.
library;

import 'package:get_it/get_it.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/services/notification_service.dart';
import 'package:mcs/core/services/sms_service.dart';
import 'package:mcs/core/services/storage_service.dart';
import 'package:mcs/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcs/features/auth/domain/usecases/login_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/register_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all dependencies.
///
/// Must be called once in `main()` after Supabase is initialized.
Future<void> configureDependencies() async {
  // ── External ─────────────────────────────────────────────
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client);
  sl.registerLazySingleton<GoTrueClient>(() => SupabaseConfig.auth);

  // ── Services ─────────────────────────────────────────────
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<SmsService>(() => SmsService());

  // ── Repositories ─────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: sl()),
  );

  // ── Use Cases ────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUseCase(sl()));

  // ── BLoCs / Cubits ───────────────────────────────────────
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        verifyOTPUseCase: sl(),
        authRepository: sl(),
      ));
}

/// Resets all registered dependencies.
///
/// Useful for testing or when reinitializing the app.
Future<void> resetDependencies() async {
  await sl.reset();
}
