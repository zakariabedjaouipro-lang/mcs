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
import 'package:mcs/core/services/supabase_service.dart';
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
  sl
    ..registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client)
    ..registerLazySingleton<GoTrueClient>(() => SupabaseConfig.auth)
    ..registerLazySingleton<AuthService>(() => AuthService())
    ..registerLazySingleton<StorageService>(() => StorageService())
    ..registerLazySingleton<NotificationService>(() => NotificationService())
    ..registerLazySingleton<SupabaseService>(() => SupabaseService())
    ..registerLazySingleton<SmsService>(
      () => SmsService(supabaseService: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authService: sl()),
    )
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => VerifyOTPUseCase(sl()))
    ..registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        verifyOTPUseCase: sl(),
        authRepository: sl(),
      ),
    );
}

/// Alias for [configureDependencies] for backward compatibility.
Future<void> setupInjectionContainer() => configureDependencies();

/// Resets all registered dependencies.
///
/// Useful for testing or when reinitializing the app.
Future<void> resetDependencies() async {
  await sl.reset();
}
