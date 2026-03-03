# MCS - Medical Clinic Management System

نظام إدارة العيادات المتكامل | Integrated Clinic Management System

## Overview

MCS is a comprehensive, multi-platform clinic management system built with **Flutter** and **Supabase**. It consists of 4 separate applications and a landing website:

| App | Target Users |
|-----|-------------|
| **Patient App** | Patients, Guardians, Autism Therapists |
| **Doctor App** | Doctors (33 specialties) |
| **Employee App** | Receptionists, Nurses, Technicians, Admins |
| **Admin App** | Super Admin, Clinic Managers |
| **Landing Website** | Public visitors |

## Architecture

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

Create a `.env` file at the project root (see `.env.example`):

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Run the app

```bash
# Default
flutter run

# Web
flutter run -d chrome -t lib/main_web.dart

# Android
flutter run -t lib/main_android.dart

# Windows
flutter run -d windows -t lib/main_windows.dart
```

## Project Structure

```
lib/
├── core/           # Shared code (config, constants, enums, errors, models, services, theme, utils, widgets)
├── features/       # Feature modules
│   ├── landing/    # Landing website
│   ├── auth/       # Authentication
│   ├── patient/    # Patient app
│   ├── doctor/     # Doctor app
│   ├── employee/   # Employee app
│   └── admin/      # Admin app
├── platforms/      # Platform-specific utilities
├── app.dart        # Root MaterialApp
├── main.dart       # Default entry point
├── main_web.dart   # Web entry point
├── main_android.dart
├── main_ios.dart
├── main_windows.dart
└── main_macos.dart
```

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
