# Role-Based Navigation Mapping for Medical Clinic System (MCS)

## Overview

This document details how pages are connected according to user roles in the Medical Clinic System. The system implements a comprehensive role-based navigation system that securely routes users to appropriate dashboards and features based on their authenticated role.

## Role Hierarchy

### 1. Super Admin (`superAdmin`)
- **Database Value**: `super_admin`
- **Home Route**: `/super-admin` or `/premium-super-admin`
- **Access Level**: Full system access
- **Dashboard**: PremiumSuperAdminDashboard
- **Navigation Items**:
  - Dashboard only

### 2. Clinic Admin (`clinicAdmin`)
- **Database Value**: `clinic_admin`
- **Home Route**: `/admin`
- **Access Level**: Clinic management
- **Dashboard**: PremiumAdminDashboardScreen
- **Navigation Items**:
  - Dashboard only

### 3. Doctor (`doctor`)
- **Database Value**: `doctor`
- **Home Route**: `/doctor`
- **Access Level**: Medical records, appointments, prescriptions
- **Dashboard**: DoctorDashboardScreen
- **Navigation Items**:
  - Dashboard
  - Appointments
  - Patients
  - Prescriptions
  - Settings

### 4. Clinic Employees
- **Nurse** (`nurse`)
  - **Database Value**: `nurse`
  - **Home Route**: `/employee`
  - **Access Level**: Patient assistance, appointments
  - **Dashboard**: EmployeeDashboardScreen

- **Receptionist** (`receptionist`)
  - **Database Value**: `receptionist`
  - **Home Route**: `/employee`
  - **Access Level**: Patient registration, appointments
  - **Dashboard**: EmployeeDashboardScreen

- **Pharmacist** (`pharmacist`)
  - **Database Value**: `pharmacist`
  - **Home Route**: `/employee`
  - **Access Level**: Prescriptions, inventory
  - **Dashboard**: EmployeeDashboardScreen

- **Lab Technician** (`labTechnician`)
  - **Database Value**: `lab_technician`
  - **Home Route**: `/employee`
  - **Access Level**: Lab results, reports
  - **Dashboard**: EmployeeDashboardScreen

- **Radiographer** (`radiographer`)
  - **Database Value**: `radiographer`
  - **Home Route**: `/employee`
  - **Home Route**: `/employee`
  - **Access Level**: Imaging reports, results
  - **Dashboard**: EmployeeDashboardScreen

### 5. Patient (`patient`)
- **Database Value**: `patient`
- **Home Route**: `/patient`
- **Access Level**: Personal records, appointments
- **Dashboard**: PatientHomeScreen
- **Navigation Items**:
  - Home
  - Appointments
  - Records
  - Lab Results
  - Settings

### 6. Relative (`relative`)
- **Database Value**: `relative`
- **Home Route**: `/patient`
- **Access Level**: Limited patient access
- **Dashboard**: PatientHomeScreen
- **Navigation Items**:
  - Home
  - Appointments
  - Records
  - Lab Results
  - Settings

### 7. Unknown (`unknown`)
- **Database Value**: `unknown`
- **Home Route**: `/login`
- **Access Level**: No access, redirect to login

## Router Configuration

### Guard Logic Flow

1. **Public Routes**: Always accessible regardless of authentication status
   - `/` (landing)
   - `/features`
   - `/pricing`
   - `/contact`
   - `/download`

2. **Splash Route**: Special handling for role resolution
   - `/splash` - Initial landing point after authentication

3. **Authenticated Route Protection**:
   - If user is not authenticated and tries to access protected routes → redirect to `/login`
   - If user is authenticated but has pending approval → redirect to `/pending-approval`
   - If user is authenticated but role is unknown → redirect to `/splash`

4. **Role-Based Dashboard Routing**:
   - On `/dashboard` route → redirect to role-specific home route
   - On `/login` route if authenticated → redirect to role-specific home route

### Route Structure

- **Patient Routes**:
  - `/patient` (home)
  - `/patient/patients`
  - `/patient/appointments`
  - `/patient/records`
  - `/patient/settings`
  - `/patient/social-accounts`
  - `/patient/book-appointment`
  - `/patient/medical-history`
  - `/patient/profile`
  - `/patient/change-password`
  - `/patient/lab-results`
  - `/patient/prescriptions`
  - `/patient/remote-sessions`

- **Doctor Routes**:
  - `/doctor` (home)
  - `/doctor/appointments`
  - `/doctor/patients`
  - `/doctor/prescriptions`
  - `/doctor/lab-results`
  - `/doctor/profile`
  - `/doctor/settings`

- **Employee Routes**:
  - `/employee` (home)
  - `/employee/appointments`
  - `/employee/patients`
  - `/employee/prescriptions`
  - `/employee/lab-results`
  - `/employee/inventory`
  - `/employee/invoices`
  - `/employee/profile`
  - `/employee/settings`

- **Admin Routes**:
  - `/admin` (home)
  - `/admin/appointments`
  - `/admin/doctors`
  - `/admin/employees`
  - `/admin/patients`
  - `/admin/settings`

- **Super Admin Routes**:
  - `/super-admin`
  - `/premium-super-admin`

## Navigation Flow

### 1. Authentication Flow
```
Public Pages → Login/Register → Authentication → Splash Screen → Role Resolution → Role-Based Dashboard
```

### 2. Splash Screen Logic
1. Check authentication status
2. If not authenticated → redirect to `/login`
3. If authenticated → fetch user role from `profiles` table
4. Check approval status
5. If rejected → sign out and redirect to `/login`
6. If pending → redirect to `/pending-approval`
7. If approved → redirect to role-specific home route

### 3. AppShell Navigation
- Each role gets appropriate navigation items based on their permissions
- Bottom navigation adapts to user role
- Drawer navigation adapts to user role
- Common actions (theme toggle, language toggle, logout) available to all users

## Security Measures

### 1. Role Validation
- Role fetched from database (`profiles` table) as source of truth
- 5-minute caching to reduce database queries
- Fallback to cached role on network errors

### 2. Route Protection
- All routes protected by authentication status
- Role-based access control prevents unauthorized navigation
- Approval status checked before granting access

### 3. Data Isolation
- Each role can only access their appropriate data
- Database Row Level Security (RLS) policies enforce data isolation
- BLoCs restrict data access based on user role

## Error Handling

### 1. Role Resolution Failures
- Timeout protection (3 seconds) during role resolution
- Retry mechanism available on error screens
- Graceful degradation to cached role values

### 2. Authentication Failures
- Clear error messages for users
- Proper logout functionality
- Navigation to appropriate error/login screens

## Implementation Notes

1. **User Role Storage**: Roles are stored in the `profiles` table in the Supabase database with the `user_role` enum type
2. **Metadata Fallback**: If database query fails, the system falls back to user metadata in Supabase auth
3. **Caching**: Role values are cached for 5 minutes to improve performance
4. **Approval Workflow**: Medical professionals require approval which is handled through the pending approval screen
5. **Responsive Design**: All screens adapt to different screen sizes and device orientations

## Testing Points

1. Verify all roles can access their appropriate dashboards
2. Verify role-based navigation items appear correctly
3. Test approval workflow for medical professionals
4. Verify proper redirects during authentication state changes
5. Test error handling for role resolution failures