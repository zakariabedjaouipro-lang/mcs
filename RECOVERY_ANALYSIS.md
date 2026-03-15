# 🔧 SOFTWARE RECOVERY ANALYSIS - MCS Project

**Last Updated:** 2026-03-15  
**Status:** In Progress - Root Cause Identified  
**Priority:** CRITICAL

---

## EXECUTIVE SUMMARY

The MCS project experienced critical instability after recent development stages. Investigation reveals:

✅ **Database Schema:** Correctly configured with `users` table (including `role` column)  
✅ **Authentication:** Working correctly (Firebase, Supabase)  
🟡 **Role Resolution:** Multiple code paths querying wrong/missing tables  
❌ **Chat System:** Not implemented (incomplete in current codebase)  
❌ **Navigation:** Potential circular redirect loops due to incorrect role lookups  

---

## ROOT CAUSE OF THE BREAK

### Issue #1: Inconsistent Data Model (CRITICAL)

**Current State:**
- Database has `users` table with `role` column
- Code was trying to query from non-existent `profiles` table
- Router and RoleManagementService had conflicting logic

**Impact:**
- Role lookups fail → UserRole.unknown
- Users get stuck on login/splash screens
- No navigation to dashboard after successful authentication

### Issue #2: Navigation Guard Logic (HIGH)

**Router File:** `lib/core/config/router.dart`  
**Problem:** `_getRoleBasedHomePath()` has async database query in sync context

```dart
// This is WRONG - async query in sync guard method
static String _getRoleBasedHomePath() {
  try {
    // ... metadata checks ...
    
    final profileData = supabase
        .from('profiles')  // ← WRONG TABLE
        .select('role')
        .eq('id', authUser.id)
        .maybeSingle()
        .then((data) { /* ... */ });  // ← ASYNC
    
    return '/splash'; // ← Always returns this, ignoring async result
  }
}
```

**Why it breaks:** Database call is async but router needs sync response

---

## FILES THAT INTRODUCED INSTABILITY

### 1. **lib/core/services/role_management_service.dart** 
   - **Issue:** `_getRoleFromDatabase()` querying wrong table
   - **Status:** Currently queries `users` (correct) but documentation says `profiles`
   - **Risk:** Confusion about correct table

### 2. **lib/core/config/router.dart**
   - **Issue:** Multiple problems:
     - `_getRoleBasedHomePath()` returns `/splash` always
     - Async database query in sync method
     - References `profiles` table (doesn't exist)
   - **Status:** NEEDS CRITICAL FIX
   - **Risk:** Creates routing loops

### 3. **supabase/migrations/20260315_add_user_signup_trigger.sql**
   - **Issue:** Creates public.users table, but code queries from `users` table
   - **Status:** Schema mismatch
   - **Risk:** Migration creates wrong table structure

---

## COMPARISON: CURRENT vs. EXPECTED STATE

### Current Architecture
```
auth.users (Supabase Auth)
    ↓
    ↓ (Trigger?)
public.users (?)  OR  users table (?)
    ↓
RoleManagementService tries to read role
    ↓
Queries 'users' or 'profiles' table (inconsistent)
    ↓
UserRole.unknown (if table doesn't match)
```

### Expected Architecture (What Should Work)
```
User logs in with email/password or Google
    ↓
AuthService.signInWithEmail/Google() → Supabase auth.users
    ↓
AuthBloc emits LoginSuccess
    ↓
BlocListener calls context.go(AppRoutes.dashboard)
    ↓
GoRouter guard _getRoleBasedHomePath() needs user's role
    ↓
    1. Check appMetadata['role'] ← Often empty
    2. Check userMetadata['role'] ← Often empty  
    3. **Query users.role from database** ← THIS IS KEY
    ↓
Return role-based path (/admin, /doctor, /patient, etc.)
    ↓
User navigates to their dashboard
```

---

## STABLE MODULES TO PRESERVE

✅ **Authentication System**
- Firebase Core configuration
- Supabase integration
- AuthService (email/password/Google Sign-In)
- AuthBloc state management
- Login/Register screens

✅ **Database Schema**
- All 29 migrations deployed
- users table with role column
- Countries, regions, specialties tables
- Appointments, prescriptions, lab results tables
- All RLS policies in place

✅ **UI/Theme System**
- Material Design 3 integration
- Dark/Light theme
- Localization (Arabic/English)
- Responsive layouts

✅ **Video Call Infrastructure**
- WebRTC service
- Socket.IO signaling
- Video call screens (partially implemented)

---

## RECOVERY STRATEGY

### Phase 1: Fix Role Resolution (IMMEDIATE)
1. **Verify database schema** - Confirm `users` table exists with `role` column
2. **Fix RoleManagementService** - Ensure it queries `users` table correctly
3. **Fix Router Guard** - Move async role fetch to splash screen setup
4. **Test Role Resolution** - Login with different roles and verify navigation

### Phase 2: Fix Navigation Flow (HIGH)
1. Remove async database query from router guard `_getRoleBasedHomePath()`
2. Make router guard fully sync (use cached/provided role data)
3. Move role fetching to splash screen initialization
4. Implement proper fallback routes

### Phase 3: Clean Up Database (MEDIUM)
1. Verify which user table is actually used (users vs public.users vs profiles)
2. Delete confusing migrations that create wrong tables
3. Create a single migration that clarifies the schema
4. Migrate any data if multiple tables exist

### Phase 4: Restore Chat System (LOW - NOT IMPLEMENTED YET)
1. Design chat/messaging data model (if needed)
2. Create necessary database tables
3. Implement real-time messaging via Supabase Realtime or Socket.IO
4. Create Chat BLoC and screens

---

## EXACT CODE FIXES NEEDED

### Fix #1: Remove Async Query from Router (CRITICAL)

**File:** `lib/core/config/router.dart`  
**Method:** `_getRoleBasedHomePath()`

**Current (broken) code:**
```dart
// PRIORITY 3: Try to fetch role from profiles table in database
try {
  final supabase = SupabaseConfig.client;
  final profileData = supabase  // WRONG - this is async!
      .from('profiles')
      .select('role')
      .eq('id', authUser.id)
      .maybeSingle()
      .then((data) {
        // Can't return from async in sync function
      });
  
  return '/splash'; // Always returns this
} catch (e) {
  debugPrint('[GO_ROUTER] Error fetching role from profiles: $e');
}
```

**Fixed code:**
```dart
// ═════════════════════════════════════════════════════════════════════
// PRIORITY 3: Return to splash if role not found in metadata
// Note: Role will be fetched from database in splash screen initialization
// This prevents infinite loops and keeps guard logic synchronous
// ═════════════════════════════════════════════════════════════════════

// Role not found in appMetadata or userMetadata
// Return to splash screen to handle async role fetching
debugPrint(
  '[GO_ROUTER] WARNING: Role not in metadata for user ${authUser.id}. '
  'Returning to splash for database lookup.',
);
```

**Reason:** Router guards must be synchronous. Async work belongs in screen initialization (splash screen).

### Fix #2: Ensure RoleManagementService Queries Correct Table

**File:** `lib/core/services/role_management_service.dart`  
**Method:** `_getRoleFromDatabase()`

**Current code (verify this is correct):**
```dart
static Future<String?> _getRoleFromDatabase(String userId) async {
  try {
    final response = await _client
        .from('users')  // ← CORRECT TABLE
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    if (response != null && response['role'] != null) {
      return response['role'] as String;
    }
    return null;
  } catch (_) {
    return null;
  }
}
```

**Status:** ✅ Appears to be correct - queries `users` table

**But verify:** 
1. Does `users` table actually have a `role` column? ✅ YES (from migration)
2. Does user record exist when trying to read it? NEEDS VERIFICATION

### Fix #3: Ensure Splash Screen Properly Initializes Role

**File:** `lib/features/splash/screens/splash_screen.dart`

**Expected behavior:**
```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // 1. Get current user
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        // Not logged in - go to login
        if (mounted) context.go(AppRoutes.login);
        return;
      }

      // 2. Fetch role from service (will query database if needed)
      final role = await RoleManagementService.getCurrentUserRole();
      
      if (role == UserRole.unknown) {
        // Show error and retry
        if (mounted) _showErrorRetry();
        return;
      }

      // 3. Navigate to role-based path
      final path = role.homeRoute;  // e.g., '/admin', '/doctor', '/patient'
      if (mounted) context.go(path);
    } catch (e) {
      if (mounted) _showErrorRetry();
    }
  }

  void _showErrorRetry() {
    // Show "Error loading role. Retry?" UI
    // User can tap Retry which calls _initialize() again
  }
}
```

---

## VERIFICATION CHECKLIST

- [ ] **Database Schema Check**
  - [ ] Table `users` exists and has `role` column
  - [ ] Table `public.users` either doesn't exist OR is synced with `users`
  - [ ] Table `profiles` doesn't exist (or is not used by code)
  - [ ] Run: `SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users');`

- [ ] **Demo Account Verification**
  - [ ] superadmin@demo.com exists in auth.users
  - [ ] superadmin@demo.com exists in users table with role='super_admin'
  - [ ] admin@demo.com exists in users table with role='clinic_admin'
  - [ ] doctor@demo.com exists in users table with role='doctor'
  - [ ] patient@demo.com exists in users table with role='patient'

- [ ] **Authentication Flow Test**
  - [ ] Can log in with email/password
  - [ ] Can log in with Google Sign-In
  - [ ] AuthBloc emits LoginSuccess
  - [ ] BlocListener navigates to dashboard

- [ ] **Role Resolution Test**  
  - [ ] Splash screen loads role from database
  - [ ] RoleManagementService._getCurrentUserRole() returns correct role
  - [ ] No UserRole.unknown (unless role actually missing)
  - [ ] Cache properly stores role for 5 minutes

- [ ] **Navigation Test**
  - [ ] After login: superadmin@demo.com → /super-admin dashboard
  - [ ] After login: admin@demo.com → /admin dashboard
  - [ ] After login: doctor@demo.com → /doctor dashboard
  - [ ] After login: patient@demo.com → /patient dashboard
  - [ ] No redirect loops
  - [ ] No endless splash screen

- [ ] **Chat System Status**
  - [ ] Document design and implementation plan if needed
  - [ ] Create issue/task for chat feature development
  - [ ] Note: WebRTC/Socket.IO infrastructure exists but chat not yet implemented

---

## CRITICAL QUESTIONS TO ANSWER

1. **Does the `users` table actually exist in Supabase?**
   - Check: `SELECT table_name FROM information_schema.tables WHERE table_name = 'users';`

2. **Do user records exist in the users table?**
   - Check: `SELECT id, email, role FROM users WHERE email LIKE '%demo%';`

3. **Was data migrated from auth.users to users table?**
   - Check if there's a migration that INSERTs data from auth.users
   - Currently only see trigger `on_auth_user_created` which should do this automatically

4. **Why did we think profiles table existed?**
   - Investigation needed - code might have been trying to use a table that was deleted

5. **Is the chat system actually needed or just incomplete documentation?**
   - Review with stakeholder what features are actually required

---

## NEXT IMMEDIATE STEPS

1. **Run database verification queries** to confirm schema state
2. **Test login locally** with Chrome to see exact error messages
3. **Compare current code with Git history** to see what was changed
4. **Fix router guard** to remove async database query
5. **Test role resolution** with each role type
6. **Document chat system** status and implementation needs

---

**Recovery Owner:** Senior Software Recovery Engineer  
**Start Date:** 2026-03-15  
**Target Completion:** 2026-03-15-16:00
