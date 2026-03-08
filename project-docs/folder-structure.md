# هيكل المجلدات والملفات

## البنية الكلية للمشروع

```
mcs/
│
├── 📁 lib/                          # الكود الرئيسي
│   ├── app.dart                     # تطبيق المواد الأساسي
│   ├── main.dart                    # الإدخال الافتراضي
│   ├── main_web.dart                # إدخال ويب
│   ├── main_android.dart            # إدخال Android
│   ├── main_ios.dart                # إدخال iOS
│   ├── main_windows.dart            # إدخال Windows
│   ├── main_macos.dart              # إدخال macOS
│   │
│   ├── 📁 core/                     # البنية الأساسية المشتركة
│   │   ├── config/
│   │   ├── constants/
│   │   ├── enums/
│   │   ├── errors/
│   │   ├── extensions/
│   │   ├── localization/
│   │   ├── models/
│   │   ├── services/
│   │   ├── theme/
│   │   ├── usecases/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── 📁 features/                 # نماذج المميزات
│   │   ├── 📁 admin/
│   │   ├── 📁 auth/
│   │   ├── 📁 patient/
│   │   ├── 📁 doctor/
│   │   ├── 📁 employee/
│   │   ├── 📁 landing/
│   │   └── 📁 video_call/
│   │
│   └── 📁 platforms/                # كود خاص بكل منصة
│       ├── 📁 web/
│       ├── 📁 mobile/
│       └── 📁 windows/
│
├── 📁 assets/                       # الملفات الثابتة
│   ├── fonts/
│   ├── icons/
│   └── images/
│
├── 📁 android/                      # مشروع Android
│   ├── app/
│   ├── gradle/
│   └── build.gradle.kts
│
├── 📁 ios/                          # مشروع iOS
│   ├── Runner/
│   └── Podfile
│
├── 📁 web/                          # ملفات الويب
│   ├── index.html
│   ├── manifest.json
│   └── icons/
│
├── 📁 windows/                      # مشروع Windows
│   ├── runner/
│   ├── flutter/
│   └── CMakeLists.txt
│
├── 📁 macos/                        # مشروع macOS
│   ├── Runner/
│   ├── Podfile
│   └── Flutter/
│
├── 📁 test/                         # اختبارات الوحدات
│   ├── core/
│   ├── features/
│   └── integration_test/
│
├── 📁 supabase/                     # ملفات Supabase
│   ├── migrations/
│   └── config.toml
│
├── 📁 docs/                         # التوثيق
│   ├── API.md
│   ├── SETUP.md
│   └── USER_GUIDE.md
│
├── 📁 scripts/                      # سكريبتات الأتمتة
│   ├── setup.sh
│   ├── test.sh
│   └── build.sh
│
├── 📁 project-docs/                 # نظام المعرفة
│   ├── project-overview.md
│   ├── goals-and-scope.md
│   ├── system-architecture.md
│   ├── tech-stack.md
│   ├── coding-standards.md
│   ├── development-workflow.md
│   ├── folder-structure.md
│   ├── database-design.md
│   ├── api-design.md
│   ├── ai-agent-rules.md
│   ├── task-roadmap.md
│   └── future-improvements.md
│
├── .github/                         # إعدادات GitHub
│   ├── workflows/
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE/
│
├── .env.example                     # متغيرات البيئة النموذجية
├── pubspec.yaml                     # اعتماديات المشروع
├── analysis_options.yaml            # إعدادات التحليل
├── README.md                        # ملف التعريف
└── .gitignore                       # ملفات Git المتجاهلة
```

---

## تفاصيل مجلد `core/`

### 📁 lib/core/config/

```
core/config/
├── injection_container.dart         # GetIt Configuration
├── supabase_config.dart             # إعدادات Supabase
├── firebase_config.dart             # إعدادات Firebase
├── router_config.dart               # إعدادات GoRouter
└── environment_config.dart          # متغيرات البيئة
```

**الوصف**: إعدادات التطبيق الرئيسية والخدمات الخارجية

### 📁 lib/core/constants/

```
core/constants/
├── app_constants.dart               # ثوابت عامة
├── db_constants.dart                # ثوابت قاعدة البيانات
├── ui_constants.dart                # ثوابت الواجهة
├── api_constants.dart               # ثوابت الـ API
└── validation_constants.dart        # ثوابت التحقق
```

**الوصف**: جميع الثوابت المستخدمة في التطبيق

### 📁 lib/core/enums/

```
core/enums/
├── user_role_enum.dart              # أدوار المستخدمين
├── appointment_status_enum.dart     # حالات المواعيد
├── subscription_type_enum.dart      # أنواع الاشتراكات
├── payment_status_enum.dart         # حالات الدفع
└── notification_type_enum.dart      # أنواع الإشعارات
```

**الوصف**: العديات المستخدمة في التطبيق

### 📁 lib/core/errors/

```
core/errors/
├── exceptions.dart                  # الاستثناءات المخصصة
├── failures.dart                    # فئات الفشل
└── error_handler.dart               # معالج الأخطاء
```

**الوصف**: معالجة الأخطاء والاستثناءات

### 📁 lib/core/extensions/

```
core/extensions/
├── context_extension.dart           # امتدادات BuildContext
├── datetime_extension.dart          # امتدادات DateTime
├── string_extension.dart            # امتدادات String
├── num_extension.dart               # امتدادات أرقام
└── list_extension.dart              # امتدادات القوائم
```

**الوصف**: امتدادات Dart المخصصة

### 📁 lib/core/localization/

```
core/localization/
├── app_localizations.dart           # فئة التوطين الرئيسية
├── translations/
│   ├── ar.json                      # العربية
│   └── en.json                      # الإنجليزية
└── l10n.yaml                        # إعدادات التوطين
```

**الوصف**: الترجمة والتوطين

### 📁 lib/core/models/

```
core/models/
├── user_model.dart                  # نموذج المستخدم
├── patient_model.dart               # نموذج المريض
├── doctor_model.dart                # نموذج الطبيب
├── appointment_model.dart           # نموذج الموعد
├── prescription_model.dart          # نموذج الوصفة
├── invoice_model.dart               # نموذج الفاتورة
├── clinic_model.dart                # نموذج العيادة
├── subscription_model.dart          # نموذج الاشتراك
├── vital_signs_model.dart           # نموذج العلامات الحيوية
└── [more models...]
```

**الوصف**: جميع نماذج البيانات الرئيسية

### 📁 lib/core/services/

```
core/services/
├── auth_service.dart                # خدمة المصادقة
├── supabase_service.dart            # خدمة Supabase
├── storage_service.dart             # خدمة التخزين
├── notification_service.dart        # خدمة الإشعارات
├── sms_service.dart                 # خدمة SMS
└── logger_service.dart              # خدمة التسجيل
```

**الوصف**: الخدمات الأساسية المشتركة

### 📁 lib/core/theme/

```
core/theme/
├── app_theme.dart                   # الموضوع الرئيسي
├── app_colors.dart                  # الألوان
├── text_styles.dart                 # أنماط النصوص
├── spacing.dart                     # المسافات
└── dark_theme.dart                  # الموضوع الداكن
```

**الوصف**: إعدادات الموضوع والألوان

### 📁 lib/core/usecases/

```
core/usecases/
├── usecase.dart                     # فئة UseCase الأساسية
├── no_params.dart                   # حالة بدون معاملات
└── usecase_base.dart                # قاعدة UseCase
```

**الوصف**: فئات الأساس لـ Use Cases

### 📁 lib/core/utils/

```
core/utils/
├── validators/
│   ├── email_validator.dart
│   ├── phone_validator.dart
│   └── password_validator.dart
├── formatters/
│   ├── date_formatter.dart
│   ├── currency_formatter.dart
│   └── phone_formatter.dart
├── helpers/
│   ├── logger.dart
│   ├── date_helper.dart
│   └── string_helper.dart
└── constants_utils.dart
```

**الوصف**: أدوات مساعدة مختلفة

### 📁 lib/core/widgets/

```
core/widgets/
├── custom_button.dart               # زر مخصص
├── custom_text_field.dart           # حقل نص مخصص
├── custom_dialog.dart               # حوار مخصص
├── error_widget.dart                # عرض الأخطاء
├── loading_widget.dart              # عرض التحميل
├── empty_widget.dart                # عرض فارغ
└── custom_app_bar.dart              # شريط التطبيق المخصص
```

**الوصف**: الأدوات الواجهة المشتركة المخصصة

---

## تفاصيل مجلد `features/`

### هيكل Feature النموذجي

```
features/
└── auth/
    ├── 📁 data/
    │   ├── datasources/
    │   │   ├── auth_local_datasource.dart
    │   │   └── auth_remote_datasource.dart
    │   ├── models/
    │   │   ├── auth_response_model.dart
    │   │   └── user_dto.dart
    │   └── repositories/
    │       └── auth_repository_impl.dart
    │
    ├── 📁 domain/
    │   ├── entities/
    │   │   └── user_entity.dart
    │   ├── repositories/
    │   │   └── auth_repository.dart
    │   └── usecases/
    │       ├── login_usecase.dart
    │       ├── register_usecase.dart
    │       ├── logout_usecase.dart
    │       └── verify_otp_usecase.dart
    │
    ├── 📁 presentation/
    │   ├── bloc/
    │   │   ├── auth_bloc.dart
    │   │   ├── auth_event.dart
    │   │   └── auth_state.dart
    │   ├── pages/
    │   │   ├── login_page.dart
    │   │   ├── register_page.dart
    │   │   └── otp_page.dart
    │   ├── screens/
    │   │   └── auth_screen.dart
    │   └── widgets/
    │       ├── auth_form.dart
    │       └── social_login_buttons.dart
    │
    └── 📁 test/
        ├── data/
        ├── domain/
        └── presentation/
```

### Features الرئيسية

#### 1. 📁 features/auth/

```
auth/                               # المصادقة
├── data/                           # طبقة البيانات
├── domain/                         # طبقة المنطق
├── presentation/                   # طبقة العرض
└── test/                           # الاختبارات

Use Cases:
- Login
- Register
- Logout
- Verify OTP
- Reset Password
- Refresh Token
```

#### 2. 📁 features/patient/

```
patient/                            # تطبيق المريض
├── data/
├── domain/
├── presentation/
│   ├── bloc/
│   ├── screens/
│   │   ├── patient_home_screen.dart
│   │   ├── appointments_screen.dart
│   │   ├── medical_records_screen.dart
│   │   └── profile_screen.dart
│   └── widgets/
└── test/

Use Cases:
- Book Appointment
- View Appointments
- View Medical Records
- Rate Doctor
- Update Profile
```

#### 3. 📁 features/doctor/

```
doctor/                             # تطبيق الطبيب
├── data/
├── domain/
├── presentation/
│   ├── bloc/
│   ├── screens/
│   │   ├── doctor_home_screen.dart
│   │   ├── appointments_screen.dart
│   │   ├── patients_screen.dart
│   │   └── prescriptions_screen.dart
│   └── widgets/
└── test/

Use Cases:
- View Appointments
- Create Prescription
- View Patient Records
- Complete Appointment
- Manage Availability
```

#### 4. 📁 features/admin/

```
admin/                              # لوحة التحكم
├── data/
├── domain/
├── presentation/
│   ├── bloc/
│   ├── screens/
│   │   ├── admin_dashboard_screen.dart
│   │   ├── clinics_screen.dart
│   │   ├── subscriptions_screen.dart
│   │   └── reports_screen.dart
│   └── widgets/
└── test/

Use Cases:
- Manage Clinics
- Manage Subscriptions
- View Reports
- Manage Users
- View Statistics
```

#### 5. 📁 features/video_call/

```
video_call/                         # الفيديو كونفرنس
├── data/
├── domain/
├── presentation/
│   ├── bloc/
│   ├── screens/
│   │   ├── video_call_screen.dart
│   │   └── video_setup_screen.dart
│   └── widgets/
└── test/

Use Cases:
- Initiate Call
- Accept Call
- End Call
- Share Screen
- Record Call
```

---

## تفاصيل مجلد `assets/`

```
assets/
├── fonts/                           # الخطوط المخصصة
│   ├── Cairo-Bold.ttf
│   ├── Cairo-Regular.ttf
│   ├── Cairo-Light.ttf
│   └── Roboto-Bold.ttf
│
├── icons/                           # الأيقونات SVG
│   ├── doctor_icon.svg
│   ├── patient_icon.svg
│   ├── appointment_icon.svg
│   ├── prescription_icon.svg
│   └── clinic_icon.svg
│
└── images/                          # الصور
    ├── splash/
    │   └── splash_logo.png
    ├── onboarding/
    │   ├── onboarding_1.png
    │   ├── onboarding_2.png
    │   └── onboarding_3.png
    ├── illustrations/
    │   ├── empty_state.png
    │   ├── error_state.png
    │   └── loading_animation.json
    └── backgrounds/
        ├── bg_primary.png
        └── bg_secondary.png
```

---

## تفاصيل مجلد `test/`

```
test/
├── core/
│   ├── config/
│   ├── constants/
│   ├── extensions/
│   ├── services/
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_datasource_test.dart
│   │   │   ├── models/
│   │   │   │   └── auth_model_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_test.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity_test.dart
│   │   │   └── usecases/
│   │   │       └── login_usecase_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── auth_bloc_test.dart
│   │
│   └── [other features...]
│
└── integration_test/
    └── app_test.dart
```

---

## قواعس التنظيم

### 1. مبدأ الطبقات (Layered Architecture)

```
✅ يجب أن يتبع كل Feature:
   data/
   ├─ datasources (مصادر البيانات)
   ├─ models (نماذج البيانات)
   └─ repositories (تطبيق المستودعات)
   
   domain/
   ├─ entities (الكيانات)
   ├─ repositories (واجهات المستودعات)
   └─ usecases (حالات الاستخدام)
   
   presentation/
   ├─ bloc (إدارة الحالة)
   ├─ pages/screens (الصفحات)
   └─ widgets (الأدوات)
```

### 2. مبدأ الاعتماديات (Dependency Rule)

```
❌ WRONG (الاعتماديات في الاتجاه الخاطئ)
core ← features
domain ← data

✅ CORRECT (الاعتماديات في الاتجاه الصحيح)
features → core
data ← domain
presentation ← domain/data
```

### 3. حجم الملف

```
✅ المثالي: 200-400 سطر
✅ المقبول: حتى 600 سطر
❌ كبير جداً: أكثر من 1000 سطر
```

### 4. تجنب المجلدات العميقة

```
✅ GOOD
lib/core/services/auth_service.dart

❌ BAD
lib/core/services/authentication/auth/auth_service.dart
```

### 5. تنسيق الملفات

```
✅ صحيح
feature/
├── auth_screen.dart          # مفردة
├── auth_bloc.dart
├── auth_event.dart
└── auth_state.dart

❌ خاطئ
feature/
├── auth_screens.dart         # جمع
├── auths_bloc.dart
├── auth_events.dart
└── auth_states.dart
```

---

## ملفات التكوين الرئيسية

```
مcs/
├── pubspec.yaml               # اعتماديات المشروع
├── analysis_options.yaml      # إعدادات التحليل
├── android/build.gradle.kts   # إعدادات Android
├── ios/Podfile                # إعدادات iOS
├── web/index.html             # قالب الويب
├── windows/CMakeLists.txt     # إعدادات Windows
├── .env.example               # متغيرات البيئة
├── .gitignore                 # ملفات Git المتجاهلة
├── .github/workflows/         # إجراءات CI/CD
└── README.md                  # ملف التعريف
```

---

## أفضل الممارسات في التنظيم

1. **تجنب المجلدات غير الضرورية**: كل مجلد يجب أن يكون له غرض واضح
2. **الاتساق**: انتظر نفس النمط في جميع الملفات والمجلدات
3. **العزلة**: كل feature يجب أن يكون مستقلاً عن الآخر
4. **سهولة الملاحة**: يجب أن تتمكن من فهم البنية بسهولة
5. **إعادة الاستخدام**: استخدم core widgets و utilities بدلاً من إعادة إنشاء

