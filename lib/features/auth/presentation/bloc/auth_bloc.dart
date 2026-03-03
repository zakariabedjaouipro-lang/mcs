import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcs/features/auth/domain/usecases/login_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/register_usecase.dart';
import 'package:mcs/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_state.dart';

/// BLoC الرئيسي للمصادقة
/// يتعامل مع جميع عمليات تسجيل الدخول والتسجيل واستعادة كلمة المرور والتحقق من OTP
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final AuthRepository authRepository;

  /// متغيرات للحفاظ على حالة النموذج
  String _loginEmail = '';
  String _loginPassword = '';
  String _registerName = '';
  String _registerEmail = '';
  String _registerPhone = '';
  String _registerPassword = '';
  String _registerConfirmPassword = '';
  String _registerRole = 'patient'; // الدور الافتراضي
  bool _isPasswordVisible = false;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOTPUseCase,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    // تسجيل معالجات الأحداث
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithSocialSubmitted>(_onLoginWithSocialSubmitted);
    on<RegisterNameChanged>(_onRegisterNameChanged);
    on<RegisterEmailChanged>(_onRegisterEmailChanged);
    on<RegisterPhoneChanged>(_onRegisterPhoneChanged);
    on<RegisterPasswordChanged>(_onRegisterPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onRegisterConfirmPasswordChanged);
    on<RegisterRoleChanged>(_onRegisterRoleChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpDigitChanged>(_onOtpDigitChanged);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ClearAuthState>(_onClearAuthState);
    on<SetLoading>(_onSetLoading);
  }

  /// ==============================
  /// معالجات أحداث تسجيل الدخول
  /// ==============================

  Future<void> _onLoginEmailChanged(
    LoginEmailChanged event,
    Emitter<AuthState> emit,
  ) async {
    _loginEmail = event.email;
  }

  Future<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<AuthState> emit,
  ) async {
    _loginPassword = event.password;
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(LoginFailure(_mapFailureToMessage(failure))),
      (user) => emit(LoginSuccess(user: user)),
    );

    _clearLoginForm();
  }

  Future<void> _onLoginWithSocialSubmitted(
    LoginWithSocialSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.loginWithSocial(
      provider: event.provider,
      token: event.token,
    );

    result.fold(
      (failure) => emit(LoginFailure(_mapFailureToMessage(failure))),
      (user) => emit(LoginSuccess(user: user)),
    );
  }

  /// ==============================
  /// معالجات أحداث التسجيل
  /// ==============================

  Future<void> _onRegisterNameChanged(
    RegisterNameChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerName = event.name;
  }

  Future<void> _onRegisterEmailChanged(
    RegisterEmailChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerEmail = event.email;
  }

  Future<void> _onRegisterPhoneChanged(
    RegisterPhoneChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerPhone = event.phone;
  }

  Future<void> _onRegisterPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerPassword = event.password;
  }

  Future<void> _onRegisterConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerConfirmPassword = event.confirmPassword;
  }

  Future<void> _onRegisterRoleChanged(
    RegisterRoleChanged event,
    Emitter<AuthState> emit,
  ) async {
    _registerRole = event.role;
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // التحقق من تطابق كلمات المرور
    if (_registerPassword != _registerConfirmPassword) {
      emit(const RegisterFailure('كلمات المرور غير متطابقة'));
      return;
    }

    emit(const AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        role: event.role,
      ),
    );

    result.fold(
      (failure) => emit(RegisterFailure(_mapFailureToMessage(failure))),
      (user) => emit(RegisterSuccess(user: user)),
    );

    _clearRegisterForm();
  }

  /// ==============================
  /// معالجات أحداث استعادة كلمة المرور
  /// ==============================

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.forgotPassword(
      contactInfo: event.contactInfo,
      method: event.method,
    );

    result.fold(
      (failure) => emit(ForgotPasswordFailure(_mapFailureToMessage(failure))),
      (_) => emit(
        ForgotPasswordSent(
          message:
              'تم إرسال رمز التحقق. برجاء فحص ${event.method == 'email' ? 'بريدك الإلكتروني' : 'رسائلك'}',
          method: event.method,
        ),
      ),
    );
  }

  /// ==============================
  /// معالجات أحداث OTP
  /// ==============================

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOTPUseCase(
      VerifyOTPParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(OtpFailure(failure.message));
        } else {
          emit(OtpFailure(_mapFailureToMessage(failure)));
        }
      },
      (_) => emit(const OtpVerified()),
    );
  }

  Future<void> _onOtpDigitChanged(
    OtpDigitChanged event,
    Emitter<AuthState> emit,
  ) async {
    // يمكن تخزين رقم OTP في حالة الـ bloc إذا لزم الأمر
    // حالياً لا نحتاج إلى تغيير الحالة، فقط نستقبل الحدث
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.forgotPassword(
      contactInfo: event.email,
      method: event.method,
    );

    result.fold(
      (failure) => emit(OtpFailure(_mapFailureToMessage(failure))),
      (_) => emit(
        OtpSent(
          email: event.email,
          method: event.method,
          message: 'تم إعادة إرسال الرمز بنجاح',
        ),
      ),
    );
  }

  /// ==============================
  /// معالجات أحداث إعادة تعيين كلمة المرور
  /// ==============================

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.resetPassword(
      email: event.email,
      otp: event.otp,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordResetFailure(_mapFailureToMessage(failure))),
      (_) => emit(const PasswordResetSuccess()),
    );
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordChangeFailure(_mapFailureToMessage(failure))),
      (_) => emit(const PasswordChangeSuccess()),
    );
  }

  /// ==============================
  /// معالجات الأحداث العامة
  /// ==============================

  Future<void> _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) async {
    _isPasswordVisible = event.isVisible;
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
          emit(AuthRedirect(role: user.role.toString().split('.').last));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(LogoutFailure(_mapFailureToMessage(failure))),
      (_) => emit(const LogoutSuccess()),
    );

    // إعادة تعيين جميع المتغيرات
    _clearAllForms();
    emit(const Unauthenticated());
  }

  Future<void> _onClearAuthState(
    ClearAuthState event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInitial());
  }

  Future<void> _onSetLoading(
    SetLoading event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
  }

  /// ==============================
  /// دوال مساعدة
  /// ==============================

  /// تحويل Failure إلى رسالة خطأ عربية
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'خطأ في الاتصال بالإنترنت';
    } else if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }

  /// مسح بيانات نموذج تسجيل الدخول
  void _clearLoginForm() {
    _loginEmail = '';
    _loginPassword = '';
  }

  /// مسح بيانات نموذج التسجيل
  void _clearRegisterForm() {
    _registerName = '';
    _registerEmail = '';
    _registerPhone = '';
    _registerPassword = '';
    _registerConfirmPassword = '';
    _registerRole = 'patient';
  }

  /// مسح جميع النماذج
  void _clearAllForms() {
    _clearLoginForm();
    _clearRegisterForm();
    _isPasswordVisible = false;
  }

  /// الحصول على بيانات النموذج الحالية للقراءة
  String get loginEmail => _loginEmail;
  String get loginPassword => _loginPassword;
  String get registerName => _registerName;
  String get registerEmail => _registerEmail;
  String get registerPhone => _registerPhone;
  String get registerPassword => _registerPassword;
  String get registerConfirmPassword => _registerConfirmPassword;
  String get registerRole => _registerRole;
  bool get isPasswordVisible => _isPasswordVisible;
}
