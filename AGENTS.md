# AGENTS.md - Medical Clinic Management System (MCS)

## 项目概述

**MCS (Medical Clinic Management System)** 是一个综合性的多平台诊所管理解决方案，支持 Web、Android、iOS、Windows 和 macOS。该系统采用 **Clean Architecture** 架构，使用 **BLoC** 模式进行状态管理，并集成 **Supabase** 作为后端服务。

## 技术栈

| 类别 | 技术 |
|------|------|
| **前端框架** | Flutter (>=3.19.0) |
| **状态管理** | flutter_bloc (^8.1.6), bloc (^8.1.4) |
| **依赖注入** | GetIt (^7.6.4) |
| **路由** | GoRouter (^14.6.2) |
| **后端** | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| **数据库** | Supabase (含 RLS 策略) |
| **UI 库** | Material Design 3, google_fonts, flutter_svg |
| **本地化** | intl (^0.20.2), flutter_localizations |
| **本地存储** | shared_preferences, flutter_secure_storage |
| **视频通话** | flutter_webrtc, socket_io_client |
| **推送通知** | firebase_messaging, flutter_local_notifications |

## 项目结构

```
lib/
├── core/                          # 共享基础设施
│   ├── config/                    # 应用配置、Supabase、路由、依赖注入
│   ├── constants/                 # 应用、数据库、UI 常量
│   ├── enums/                     # 用户角色、订阅类型、状态枚举
│   ├── errors/                    # 异常和失败处理
│   ├── extensions/                # Dart 扩展
│   ├── localization/              # 本地化 (阿拉伯语/英语)
│   ├── models/                    # 22+ 数据模型
│   ├── services/                  # 核心服务 (Auth, Supabase, Storage, Notification, SMS)
│   ├── theme/                     # 主题 (亮色/暗色)
│   ├── usecases/                  # 基础 UseCase 类
│   ├── utils/                     # 工具类 (验证器、格式化器、日期工具)
│   └── widgets/                   # 自定义组件
│
├── features/                      # 功能模块
│   ├── admin/                     # 管理员应用
│   │   ├── data/                  # 数据层
│   │   ├── domain/                # 领域层
│   │   ├── presentation/          # 展示层 (BLoC, Screens)
│   │   └── admin_app.dart         # 管理员入口
│   │
│   ├── auth/                      # 认证模块
│   │   ├── screens/               # 登录、注册、OTP、密码重置
│   │   ├── domain/               # 仓储接口、用例
│   │   ├── data/                 # 仓储实现
│   │   └── presentation/bloc/    # Auth BLoC
│   │
│   ├── patient/                   # 患者应用
│   │   ├── data/                 # 数据层
│   │   ├── domain/               # 领域层
│   │   ├── presentation/         # 展示层 (BLoC, Screens)
│   │   └── patient_app.dart      # 患者应用入口
│   │
│   ├── doctor/                    # 医生应用
│   │   ├── data/                 # 数据层
│   │   ├── domain/               # 领域层
│   │   ├── presentation/         # 展示层 (BLoC, Screens)
│   │   └── doctor_app.dart       # 医生应用入口
│   │
│   ├── employee/                  # 员工应用
│   │
│   ├── landing/                   # 落地页网站
│   │   └── screens/              # Landing, Features, Pricing, Contact
│   │
│   └── video_call/                # 视频通话模块
│
├── platforms/                     # 平台特定代码
│   ├── web/
│   ├── mobile/
│   └── windows/
│
├── app.dart                       # 根 MaterialApp
├── main.dart                      # 默认入口
├── main_web.dart                  # Web 入口
├── main_android.dart              # Android 入口
├── main_ios.dart                  # iOS 入口
├── main_windows.dart              # Windows 入口
└── main_macos.dart                # macOS 入口
```

## 核心模型 (lib/core/models/)

| 模型 | 描述 |
|------|------|
| `user_model.dart` | 用户基础模型 |
| `patient_model.dart` | 患者模型 |
| `doctor_model.dart` | 医生模型 (33 个专科) |
| `employee_model.dart` | 员工模型 |
| `clinic_model.dart` | 诊所模型 |
| `appointment_model.dart` | 预约模型 |
| `prescription_model.dart` | 处方模型 |
| `lab_result_model.dart` | 实验室结果模型 |
| `invoice_model.dart` | 发票模型 |
| `subscription_model.dart` | 订阅模型 |
| `subscription_code_model.dart` | 订阅码模型 |
| `notification_model.dart` | 通知模型 |
| `inventory_model.dart` | 库存模型 |
| `country_model.dart` | 国家模型 |
| `region_model.dart` | 地区模型 |
| `specialty_model.dart` | 专科模型 |
| `video_session_model.dart` | 视频会话模型 |
| `vital_signs_model.dart` | 生命体征模型 |
| `autism_assessment_model.dart` | 自闭症评估模型 |
| `exchange_rate_model.dart` | 汇率模型 |

## 数据库迁移 (supabase/migrations/)

共 **27** 个 SQL 迁移文件，包括：
- 枚举类型创建
- 用户表、国家表、地区表、专科表
- 诊所表、订阅表
- 医生表、患者表、员工表
- 预约表、处方表、实验室结果表
- 视频会话表、发票表、库存表
- 订阅码表、汇率表、通知表
- 处方项目表、生命体征表
- 发票项目表、库存事务表
- 通知设置表
- RLS 策略更新

## 常用命令

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 运行 Web 版本
flutter run -d chrome

# 运行 Windows 版本
flutter run -d windows

# 运行分析
flutter analyze

# 运行测试
flutter test

# 生成代码 (如需)
dart run build_runner build

# 构建 Web 发布版本
flutter build web

# 构建 Android APK
flutter build apk

# 构建 Windows EXE
flutter build windows
```

## 开发约定

### 架构模式
- **Clean Architecture**: 严格分层 (Data → Domain → Presentation)
- **BLoC Pattern**: 使用 `flutter_bloc` 进行状态管理
- **Dependency Injection**: 使用 `GetIt` 进行依赖注入

### 代码风格
- 使用 `very_good_analysis` 进行代码检查
- 遵循 Flutter 官方风格指南
- 使用 `Equatable` 进行值相等比较

### 命名规范
- 文件名: `snake_case.dart`
- 类名: `PascalCase`
- 方法/变量: `camelCase`
- 常量: `kConstantName` 或 `CONSTANT_NAME`

### 路由定义
- 使用 `AppRoutes` 抽象类定义路由常量
- 使用 `GoRouter` 进行路由管理
- 实现基于角色的路由守卫

### 本地化
- 默认语言: 阿拉伯语 (ar)
- 支持语言: 阿拉伯语 (ar), 英语 (en)
- 完全支持 RTL/LTR

### 主题
- 亮色主题和暗色主题
- 使用 Material Design 3
- 用户偏好本地持久化

## 依赖注入配置

所有依赖在 `lib/core/config/injection_container.dart` 中注册：

```dart
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // 外部服务
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client);
  sl.registerLazySingleton<GoTrueClient>(() => SupabaseConfig.auth);
  
  // 核心服务
  sl.registerLazySingleton<AuthService>(AuthService.new);
  sl.registerLazySingleton<StorageService>(StorageService.new);
  sl.registerLazySingleton<NotificationService>(NotificationService.new);
  sl.registerLazySingleton<SupabaseService>(SupabaseService.new);
  sl.registerLazySingleton<SmsService>(() => SmsService(supabaseService: sl()));
  
  // 仓储
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authService: sl()));
  
  // 用例
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUseCase(sl()));
  
  // BLoC
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    verifyOTPUseCase: sl(),
    authRepository: sl(),
  ));
  sl.registerFactory(() => AdminBloc(sl()));
}
```

## 环境配置

创建 `.env` 文件：

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
AGORA_APP_ID=your-agora-app-id
ENVIRONMENT=development
```

## GitHub 工作流

项目包含以下 GitHub Actions 工作流 (`.github/workflows/`)：

| 工作流 | 描述 |
|--------|------|
| `issue-triage.yaml` | Issue 分类 |
| `issue-killer.yml` | 自动关闭 Issue |
| `pr-review.yml` | PR 审查自动化 |

## 注意事项

1. **Windows 开发**: 使用 PowerShell 命令，Windows 不支持 `&&` 链接符
2. **路径分隔符**: 优先使用正斜杠 `/`，但也支持反斜杠 `\`
3. **数据库**: 所有表都有 RLS (Row Level Security) 策略保护
4. **多平台**: 需要为每个平台单独配置 (如 Firebase 配置)
