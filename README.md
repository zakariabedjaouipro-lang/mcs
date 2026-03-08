# MCS - Medical Clinic Management System

نظام إدارة العيادات المتكامل | Integrated Clinic Management System

## 📊 Development Status

**Current Phase:** Phase 3 - Admin Application ✅ COMPLETE

| Phase | Name | Status | Files |
|-------|------|--------|-------|
| **Phase 0** | Infrastructure | ✅ 100% | 60+ |
| **Phase 1** | Landing Website | ✅ 100% | 19 |
| **Phase 2** | Authentication | ✅ 100% | 19 |
| **Phase 3** | Admin Application | ✅ 100% | 15+ |
| **Phase 4** | Patient App | ⏳ Planning | - |
| **Phase 5** | Doctor App | ⏳ Planning | - |
| **Phase 6** | Employee App | ⏳ Planning | - |

**Total Progress:** 115+ files | 25,000+ lines of code

### Recent Accomplishments
- ✅ Admin Dashboard with 5 screens
- ✅ Subscription codes management
- ✅ Clinics management with status tracking
- ✅ Multi-currency support (USD, EUR, DZD)
- ✅ Exchange rates management
- ✅ Connected to Supabase
- ✅ Fixed multiple enum and type errors

---

## 🎯 Target Applications

| App | Target Users |
|-----|-------------|
| **Patient App** | Patients, Guardians, Autism Therapists |
| **Doctor App** | Doctors (33 specialties) |
| **Employee App** | Receptionists, Nurses, Technicians, Admins |
| **Admin App** | Super Admin, Clinic Managers |
| **Landing Website** | Public visitors |

---

## ✨ Key Features (Implemented & Planned)

### ✅ Implemented
- **Multi-platform support** (Web, Android, iOS, Windows, macOS)
- **Complete authentication** (Email/Password, Social, OTP, Password Reset)
- **BLoC state management** (32 events, 21 states)
- **Material 3 Design** (Light/Dark themes)
- **RTL/LTR support** (Arabic/English)
- **Clean Architecture** (Domain/Data/Presentation layers)
- **Responsive layouts** (Mobile, Tablet, Web)
- **Landing website** with Contact, Pricing, Features sections

### ⏳ Upcoming
- **Phase 4:** Patient Application (appointments, prescriptions, video calls)
- **Phase 5:** Doctor Application (patient management, consultations)
- **Phase 6:** Employee Application (reception, nursing, pharmacy)
- Profile management & user data editing
- Video consultation with Agora integration
- Prescription delivery tracking
- Patient health records
- Audit logging

---

## 🏗️ Architecture

- **Clean Architecture** with separation of concerns (Data, Domain, Presentation)
- **BLoC Pattern** for state management
- **GetIt** for dependency injection
- **GoRouter** for navigation with deep linking support

## Tech Stack

- **Frontend:** Flutter (Web, Android, iOS, Windows, macOS)
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Edge Functions, Realtime)
- **Video Calls:** Agora RTC Engine
- **Notifications:** Firebase Cloud Messaging

## Prerequisites

- Flutter SDK >= 3.16.0
- Dart SDK >= 3.2.0
- Supabase account and project
- Firebase project (for push notifications)
- Agora account (for video calls)
- Git

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd mcs
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Environment setup

Create a `.env` file at the project root:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
AGORA_APP_ID=your-agora-app-id
ENVIRONMENT=development
```

### 4. Run the app

```bash
# With environment variables
flutter run --dart-define-from-file=.env

# Or use VS Code launch configuration (F5)
# See .vscode/launch.json
```

## Project Structure

```
lib/
├── core/                          # Shared infrastructure (60+ files)
│   ├── config/                    # App config, Supabase, Router, DI, Env
│   ├── constants/                 # App, DB, UI constants
│   ├── enums/                     # User roles, Subscription types, Status
│   ├── errors/                    # Exceptions and Failures
│   ├── models/                    # 15+ data models (User, Clinic, Doctor, Patient, etc.)
│   ├── services/                  # Auth, Supabase, Storage, Notification, SMS, Device Detection
│   ├── theme/                     # Light/Dark themes, Colors, Text styles
│   ├── usecases/                  # Base UseCase class
│   ├── utils/                     # Validators, Formatters, DateUtils, Extensions, Platform utils
│   └── widgets/                   # Custom Button, TextField, Loading, Error, OTP, Responsive
│
├── features/                      # Feature modules
│   ├── landing/                   # Landing website (19 files)
│   │   ├── screens/              # Landing, Features, Pricing, Contact, Support, Download
│   │   └── widgets/              # Navigation, Footer, Testimonials, Cards, Forms
│   │
│   ├── auth/                      # Authentication (19 files)
│   │   ├── screens/              # Login, Register, ForgotPassword, OTP, ChangePassword
│   │   ├── domain/
│   │   │   ├── repositories/    # AuthRepository interface
│   │   │   └── usecases/        # Login, Register, VerifyOTP use cases
│   │   ├── data/
│   │   │   └── repositories/    # AuthRepository implementation
│   │   └── presentation/
│   │       └── bloc/            # Auth BLoC with 32 events, 21 states
│   │
│   └── admin/                     # Admin Application (15+ files)
│       ├── admin_app.dart        # Admin entry point
│       ├── presentation/
│       │   ├── bloc/            # Admin BLoC with 10 events, 8 states
│       │   ├── screens/         # Dashboard, Stats, Subscriptions, Clinics, Currencies
│       │   └── widgets/         # Admin-specific widgets
│       ├── domain/
│       │   ├── repositories/    # Admin repository interfaces
│       │   └── usecases/        # Admin use cases
│       └── data/
│           └── repositories/    # Admin repository implementations
│
├── platforms/                     # Platform-specific code
│   ├── web/                      # Web utilities
│   ├── mobile/                   # Mobile utilities
│   └── windows/                  # Windows utilities
│
├── app.dart                       # Root MaterialApp with BLoC providers
├── main.dart                      # Default entry point
├── main_web.dart                  # Web-specific entry point
├── main_android.dart              # Android-specific entry point
├── main_ios.dart                  # iOS-specific entry point
├── main_windows.dart              # Windows-specific entry point
└── main_macos.dart                # macOS-specific entry point
```

## 📊 Code Statistics

| Category | Count |
|----------|-------|
| Total Files | 115+ |
| Total Lines | 25,000+ |
| Models | 17 |
| Services | 8 |
| Screens | 16 |
| BLoC Events | 42 |
| BLoC States | 29 |
| Use Cases | 3+ |
| Widgets | 12+ |
| SQL Migrations | 16 |

## Database

The database is hosted on Supabase (PostgreSQL) with Row Level Security (RLS) policies. Migration scripts are located in `supabase/migrations/`.

## Localization

- Arabic (ar) — default
- English (en)

Full RTL/LTR support.

## Themes

- Light theme
- Dark theme

User preference is persisted locally.

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## License

Proprietary — All rights reserved.
