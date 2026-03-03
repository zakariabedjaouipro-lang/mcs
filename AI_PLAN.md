# MCS - AI Development Plan Tracker

## Phase 0: Infrastructure (البنية التحتية)

### Group 0-1: Project Setup (إعداد المشروع الأساسي)
- ✅ `pubspec.yaml` — Dependencies
- ✅ `README.md` — Project documentation
- ✅ `.gitignore` — Git ignore rules
- ✅ `analysis_options.yaml` — Lint rules (very_good_analysis)

### Group 0-2: Core Config
- ✅ `lib/core/config/app_config.dart`
- ✅ `lib/core/config/supabase_config.dart`
- ✅ `lib/core/config/router.dart`
- ✅ `lib/core/config/injection_container.dart`
- ✅ `lib/core/config/env.dart`

### Group 0-3: Constants & Enums
- ✅ `lib/core/constants/app_constants.dart`
- ✅ `lib/core/constants/db_constants.dart`
- ✅ `lib/core/constants/ui_constants.dart`
- ✅ `lib/core/enums/user_role.dart`
- ✅ `lib/core/enums/subscription_type.dart`

### Group 0-4: More Enums & Errors
- ✅ `lib/core/enums/appointment_status.dart`
- ✅ `lib/core/enums/invoice_status.dart`
- ✅ `lib/core/errors/failures.dart`
- ✅ `lib/core/errors/exceptions.dart`

### Group 0-5: Localization
- ⬜ `lib/core/localization/app_localizations.dart`
- ⬜ `lib/core/localization/l10n/app_ar.arb`
- ⬜ `lib/core/localization/l10n/app_en.arb`

### Group 0-6: Theme
- ✅ `lib/core/theme/app_theme.dart`
- ✅ `lib/core/theme/light_theme.dart`
- ✅ `lib/core/theme/dark_theme.dart`
- ✅ `lib/core/theme/app_colors.dart`
- ✅ `lib/core/theme/text_styles.dart`

### Group 0-7: Services (Part 1)
- ✅ `lib/core/services/supabase_service.dart`
- ✅ `lib/core/services/auth_service.dart`
- ✅ `lib/core/services/notification_service.dart`
- ✅ `lib/core/services/sms_service.dart`

### Group 0-8: Services (Part 2)
- ⬜ `lib/core/services/video_call_service.dart`
- ✅ `lib/core/services/storage_service.dart`
- ⬜ `lib/core/services/currency_service.dart`
- ✅ `lib/core/services/device_detection_service.dart`

### Group 0-9: Utils
- ✅ `lib/core/utils/validators.dart`
- ✅ `lib/core/utils/formatters.dart`
- ✅ `lib/core/utils/date_utils.dart`
- ✅ `lib/core/utils/platform_utils.dart`
- ✅ `lib/core/utils/extensions.dart`

### Group 0-10: Core Widgets (Part 1)
- ✅ `lib/core/widgets/custom_button.dart`
- ✅ `lib/core/widgets/custom_text_field.dart`
- ✅ `lib/core/widgets/loading_widget.dart`
- ✅ `lib/core/widgets/error_widget.dart`
- ✅ `lib/core/widgets/empty_state_widget.dart`

### Group 0-11: Core Widgets (Part 2)
- ✅ `lib/core/widgets/otp_input_widget.dart`
- ✅ `lib/core/widgets/responsive_layout.dart`
- ⬜ `lib/core/widgets/app_drawer.dart`
- ⬜ `lib/core/widgets/language_switcher.dart`
- ⬜ `lib/core/widgets/theme_switcher.dart`

### Group 0-12: Core Widgets (Part 3) & Models Start
- ⬜ `lib/core/widgets/currency_selector.dart`
- ⬜ `lib/core/widgets/confirm_dialog.dart`

### Group 0-13: Models (Part 1)
- ✅ `lib/core/models/user_model.dart`
- ✅ `lib/core/models/clinic_model.dart`
- ✅ `lib/core/models/doctor_model.dart`
- ✅ `lib/core/models/patient_model.dart`
- ✅ `lib/core/models/employee_model.dart`

### Group 0-14: Models (Part 2)
- ✅ `lib/core/models/appointment_model.dart`
- ✅ `lib/core/models/subscription_model.dart`
- ✅ `lib/core/models/subscription_code_model.dart`
- ✅ `lib/core/models/prescription_model.dart`
- ✅ `lib/core/models/invoice_model.dart`

### Group 0-15: Models (Part 3)
- ✅ `lib/core/models/inventory_model.dart`
- ✅ `lib/core/models/vital_signs_model.dart`
- ✅ `lib/core/models/lab_result_model.dart`
- ✅ `lib/core/models/notification_model.dart`
- ✅ `lib/core/models/video_session_model.dart`

### Group 0-16: Models (Part 4)
- ✅ `lib/core/models/specialty_model.dart`
- ✅ `lib/core/models/country_model.dart`
- ✅ `lib/core/models/region_model.dart`
- ✅ `lib/core/models/exchange_rate_model.dart`
- ✅ `lib/core/models/report_model.dart`

### Group 0-17: Models (Part 5) & Entry Points
- ✅ `lib/core/models/autism_assessment_model.dart`
- ✅ `lib/core/models/bug_report_model.dart`
- ✅ `lib/app.dart`
- ✅ `lib/main.dart`
- ✅ `lib/main_web.dart`

### Group 0-18: More Entry Points & Platform Utils
- ✅ `lib/main_android.dart`
- ✅ `lib/main_ios.dart`
- ✅ `lib/main_windows.dart`
- ✅ `lib/main_macos.dart`
- ✅ `lib/platforms/web/web_utils.dart`

### Group 0-19: Platform Utils & SQL Migrations Start
- ✅ `lib/platforms/windows/windows_utils.dart`
- ✅ `lib/platforms/mobile/mobile_utils.dart`
- ✅ `supabase/migrations/001_create_enums.sql`
- ✅ `supabase/migrations/002_create_users_table.sql`

---

## Phase 1: Landing Website (الموقع التعريفي)

### Group 1-1: Landing Website Setup (إعدادات الموقع التعريفي)
- ✅ `lib/features/landing/landing_app.dart` — Landing app entry point
- ✅ `lib/features/landing/screens/landing_screen.dart` — Main landing page with hero section
- ✅ `lib/features/landing/screens/download_screen.dart` — Download page with system requirements
- ✅ `lib/features/landing/widgets/device_detector.dart` — Device detection and recommendations
- ✅ `lib/features/landing/widgets/platform_buttons.dart` — Platform-specific download buttons

### Group 1-2: Features & Pricing (الميزات والأسعار)
- ✅ `lib/features/landing/screens/features_screen.dart` — Features showcase (4 sections)
- ✅ `lib/features/landing/screens/pricing_screen.dart` — Pricing plans with billing periods
- ✅ `lib/features/landing/widgets/feature_card.dart` — Single feature card with hover effects
- ✅ `lib/features/landing/widgets/pricing_card.dart` — Single pricing plan card
- ✅ `lib/features/landing/widgets/currency_selector.dart` — Multi-currency support (USD, EUR, DZD)

### Group 1-3: Contact & Support (الاتصال والدعم)
- ✅ `lib/features/landing/screens/contact_screen.dart` — Contact page with form and info
- ✅ `lib/features/landing/screens/support_screen.dart` — Support page with FAQ, videos, links
- ✅ `lib/features/landing/widgets/contact_form.dart` — Contact form with validation
- ✅ `lib/features/landing/widgets/faq_section.dart` — Reusable FAQ section with search
- ✅ `lib/features/landing/widgets/social_links.dart` — Social media links widget
- ✅ `lib/features/landing/widgets/bug_report_form.dart` — Bug report form with device info

### Group 1-4: Landing Components (المكونات النهائية)
- ✅ `lib/features/landing/widgets/navbar.dart` — Navigation bar with links, theme/language toggle, mobile menu
- ✅ `lib/features/landing/widgets/footer.dart` — Footer with links, contact info, social media
- ✅ `lib/features/landing/widgets/testimonials.dart` — User testimonials carousel with ratings

## Phase 2: Authentication (المصادقة)

### Group 2-1: Authentication Basics (أساسيات المصادقة)
- ✅ `lib/features/auth/screens/login_screen.dart` — Login with email/password and social auth
- ✅ `lib/features/auth/screens/register_screen.dart` — Register with role selection (patient/doctor/staff)
- ✅ `lib/features/auth/screens/forgot_password_screen.dart` — Password recovery via email or phone
- ✅ `lib/features/auth/screens/otp_verification_screen.dart` — 6-digit OTP verification with countdown
- ✅ `lib/features/auth/screens/change_password_screen.dart` — Password change with strength indicators

### Group 2-2: Auth BLoC & State Management (إدارة الحالة والمنطق التجاري)
- ✅ `lib/features/auth/domain/repositories/auth_repository.dart` — Abstract repository interface with 11 methods
  * login, register, verifyOTP, forgotPassword, resetPassword, changePassword, logout, getCurrentUser, isUserLoggedIn, updateProfile, loginWithSocial
  * Returns Either<Failure, T> for all operations
- ✅ `lib/features/auth/data/repositories/auth_repository_impl.dart` — Repository implementation with AuthService
  * Integrates with AuthService for API calls
  * Error handling with exception-to-failure conversion
  * Token management with StorageService
  * User data transformation between auth models and UserModel
- ✅ `lib/features/auth/domain/usecases/login_usecase.dart` — Login use case with email/password params
  * Implements UseCase<UserModel, LoginParams> interface
  * Calls authRepository.login() with parameters
- ✅ `lib/features/auth/domain/usecases/register_usecase.dart` — Register use case with 5 params (name, email, phone, password, role)
  * Implements UseCase<UserModel, RegisterParams> interface
  * Calls authRepository.register() with parameters
- ✅ `lib/features/auth/domain/usecases/verify_otp_usecase.dart` — OTP verification use case
  * Implements UseCase<bool, VerifyOTPParams> interface
  * Calls authRepository.verifyOTP() with email and OTP code

### Group 2-3: Auth BLoC & State Management (إدارة الحالة مع BLoC)
- ✅ `lib/features/auth/presentation/bloc/auth_event.dart` — 21 authentication events
  * Login: LoginEmailChanged, LoginPasswordChanged, LoginSubmitted, LoginWithSocialSubmitted
  * Register: RegisterNameChanged, RegisterEmailChanged, RegisterPhoneChanged, RegisterPasswordChanged, RegisterConfirmPasswordChanged, RegisterRoleChanged, RegisterSubmitted
  * Password: ForgotPasswordSubmitted, ResetPasswordSubmitted, ChangePasswordSubmitted
  * OTP: OtpDigitChanged, OtpSubmitted, ResendOtpRequested
  * General: TogglePasswordVisibility, AuthCheckRequested, LogoutRequested, ClearAuthState, SetLoading
- ✅ `lib/features/auth/presentation/bloc/auth_state.dart` — 21 authentication states
  * Basic: AuthInitial, AuthLoading, Authenticated, Unauthenticated
  * Login: LoginSuccess(UserModel), LoginFailure(message)
  * Register: RegisterSuccess(UserModel), RegisterFailure(message)
  * Password: ForgotPasswordSent(email, method), ForgotPasswordFailure, PasswordResetSuccess, PasswordResetFailure, PasswordChangeSuccess, PasswordChangeFailure
  * OTP: OtpSent(email, method), OtpVerified, OtpFailure(attempts), OtpExpired
  * Navigation: AuthRedirect(role), ProfileCompletionRequired(user)
  * Logout: LogoutSuccess, LogoutFailure(message)
- ✅ `lib/features/auth/presentation/bloc/auth_bloc.dart` — Main BLoC with 19 event handlers (700+ lines)
  * Integrates LoginUseCase, RegisterUseCase, VerifyOTPUseCase
  * Handles login/register, OTP verification, password reset/change
  * User authentication checking and logout
  * Error handling with failure-to-message mapping (Arabic messages)
  * Form state management (email, password, name, phone, role, visibility)
  * Dynamic routing based on user role
- ✅ `lib/features/auth/presentation/bloc/index.dart` — BLoC exports
  * Re-exports auth_bloc, auth_event, auth_state for cleaner imports

### Group 2-4: BLoC Integration with Auth Screens (تكامل BLoC مع شاشات المصادقة)
- ✅ `lib/features/auth/screens/login_screen.dart` — Login screen with BLoC integration (280+ lines)
  * Added BlocListener for LoginSuccess navigation and LoginFailure error handling
  * Added BlocBuilder for UI state reflection (isLoading)
  * Form field onChanged events trigger LoginEmailChanged, LoginPasswordChanged
  * Login button triggers LoginSubmitted event
  * Social auth buttons integrated with BLoC
  * Navigation to /home on LoginSuccess with user role as argument
  * SnackBar error handling for LoginFailure with Arabic messages
  * Zero compilation errors ✓
- ✅ `lib/features/auth/screens/register_screen.dart` — Register screen with BLoC integration (380+ lines)
  * Wrapped entire screen with BlocListener<AuthBloc> for success/failure handling
  * All 7 form fields connected to RegisterEvents (Name, Email, Phone, Password, ConfirmPassword, Role)
  * Role selection triggers RegisterRoleChanged event
  * Register button triggers RegisterSubmitted event
  * Navigation to /otp-verification on RegisterSuccess with email as argument
  * Password mismatch validation maintained
  * Error display via SnackBar with Arabic messages
  * Zero compilation errors ✓
- ✅ `lib/features/auth/screens/forgot_password_screen.dart` — Forgot password screen with BLoC integration (340+ lines)
  * Added BlocListener for ForgotPasswordSent navigation and ForgotPasswordFailure handling
  * Added BlocBuilder for UI state reflection and button enable/disable logic
  * Contact method toggle (email/phone) with method state management
  * Text field onChanged triggers email/phone validation
  * Send verification button triggers ForgotPasswordSubmitted event
  * Navigation to /otp-verification on ForgotPasswordSent with contact info as argument
  * SnackBar feedback for success and error states
  * Zero compilation errors ✓
- ✅ `lib/features/auth/screens/otp_verification_screen.dart` — OTP verification screen with BLoC integration (380+ lines)
  * Removed manual timer animation, integrated with BLoC OtpTimerUpdated state
  * 6 OTP input fields connected to OtpDigitChanged events with position tracking
  * Automatic focus management on field completion/deletion
  * Verify button triggers OtpSubmitted event
  * Resend button triggers ResendOtpRequested event
  * BlocListener handles OtpVerified (navigation), OtpVerificationFailure (error), OtpResent (feedback)
  * Shake animation triggered on invalid OTP
  * Countdown timer updates from BLoC state (OtpTimerUpdated)
  * Navigation to /reset-password on OtpVerified
  * Zero compilation errors ✓
- ✅ `lib/features/auth/screens/change_password_screen.dart` — Change password screen with BLoC integration (410+ lines)
  * Removed manual async password change logic, integrated with BLoC
  * Password strength indicators updated via _updatePasswordStrength() method
  * Form validation maintained (min 8 chars, uppercase, lowercase, number, special char)
  * Current password field conditional (hidden if forced change)
  * Change password button triggers ResetPasswordSubmitted event with new password and optional current password
  * BlocListener handles PasswordResetSuccess and PasswordResetFailure states
  * Navigation to /home on PasswordResetSuccess if forced change, else pop()
  * Password visibility toggles for all 3 fields
  * Error handling with Arabic messages
  * Zero compilation errors ✓

## Phase 3+: Remaining Phases  
- ⬜ (To be planned)

---

## SQL Migrations
- ✅ `supabase/migrations/001_create_enums.sql`
- ✅ `supabase/migrations/002_create_users_table.sql`
- ⬜ `supabase/migrations/003_create_clinics_table.sql`
- ⬜ ... (remaining migrations)

---
**Legend:** ✅ = Complete | ⬜ = Pending
