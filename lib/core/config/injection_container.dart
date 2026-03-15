/// Dependency Injection setup using GetIt.
///
/// All services, repositories, and BLoCs are registered here.
/// Call [configureDependencies] once at app startup.
library;

import 'package:get_it/get_it.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/services/demo_account_service.dart';
import 'package:mcs/core/services/notification_service.dart';
import 'package:mcs/core/services/sms_service.dart';
import 'package:mcs/core/services/storage_service.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/usecases/approval_usecase.dart';
import 'package:mcs/core/usecases/demo_accounts_usecase.dart';
import 'package:mcs/features/admin/data/datasources/approval_remote_data_source.dart';
import 'package:mcs/features/admin/data/repositories/approval_repository_impl.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/bloc/approval_bloc.dart';
import 'package:mcs/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcs/features/auth/domain/usecases/login_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/register_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mcs/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:mcs/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:mcs/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:mcs/features/localization/data/datasources/localization_local_data_source.dart';
import 'package:mcs/features/localization/data/repositories/localization_repository.dart'
    as localization_repo;
import 'package:mcs/features/localization/domain/repositories/localization_repository.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/theme/data/datasources/theme_local_data_source.dart';
import 'package:mcs/features/theme/data/repositories/theme_repository.dart'
    as theme_repo;
import 'package:mcs/features/theme/domain/repositories/theme_repository.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all dependencies.
///
/// Must be called once in `main()` after Supabase is initialized.
Future<void> configureDependencies() async {
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
    )
    ..registerLazySingleton<DemoAccountService>(DemoAccountService.new)
    ..registerLazySingleton(
      () => CreateDemoAccountsUseCase(sl<DemoAccountService>()),
    )
    ..registerLazySingleton(
      () => CheckDemoAccountExistsUseCase(sl<DemoAccountService>()),
    )
    // ── Auth Feature ─────────────────────────────────────────
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
        authService: sl(),
      ),
    )
    // ── Theme Feature ────────────────────────────────────────
    ..registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSource(sl<SharedPreferences>()),
    )
    ..registerLazySingleton<ThemeRepository>(
      () => theme_repo.ThemeRepositoryImpl(sl()),
    )
    ..registerFactory(
      () => ThemeBloc(themeRepository: sl()),
    )
    // ── Localization Feature ─────────────────────────────────
    ..registerLazySingleton<LocalizationLocalDataSource>(
      () => LocalizationLocalDataSource(sl<SharedPreferences>()),
    )
    ..registerLazySingleton<LocalizationRepository>(
      () => localization_repo.LocalizationRepositoryImpl(sl()),
    )
    ..registerFactory(
      () => LocalizationBloc(localizationRepository: sl()),
    )
    // ── Doctor Feature ──────────────────────────────────────
    ..registerLazySingleton<DoctorRepository>(
      () => DoctorRepositoryImpl(sl<SupabaseService>()),
    )
    ..registerFactory(
      () => DoctorBloc(sl<DoctorRepository>()),
    )
    // ── Other BLoCs ──────────────────────────────────────────
    // ✅ Admin BLoC - محدد بشكل واضح
    ..registerFactory(() => AdminBloc(sl<SupabaseService>()))
    // ── Approval Feature ────────────────────────────────────
    ..registerLazySingleton<ApprovalRemoteDataSource>(
      () => ApprovalRemoteDataSourceImpl(
        supabaseService: sl(),
        supabaseClient: sl(),
      ),
    )
    ..registerLazySingleton<ApprovalRepository>(
      () => ApprovalRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(
      () => GetPendingApprovalsUseCase(sl()),
    )
    ..registerLazySingleton(
      () => ApproveUserUseCase(sl()),
    )
    ..registerLazySingleton(
      () => RejectUserUseCase(sl()),
    )
    ..registerFactory(
      () => ApprovalBloc(
        getPendingApprovalsUseCase: sl(),
        approveUserUseCase: sl(),
        rejectUserUseCase: sl(),
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
