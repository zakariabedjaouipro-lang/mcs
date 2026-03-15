# 🚨 RECOVERY ACTION PLAN - MCS Project

**Date:** 2026-03-15  
**Objective:** Restore project to last stable state where authentication and navigation work correctly  
**Status:** Diagnostic Phase Complete → Ready for Implementation

---

## PHASE 1: DIAGNOSIS RESULTS ✅

### Code Review Findings:

| Component | Status | Details |
|-----------|--------|---------|
| **Router Guard** | ✅ CORRECT | Properly synchronous, falls back to /splash |
| **RoleManagementService** | ✅ CORRECT | Queries `users` table for role |
| **Splash Screen** | ⚠️ NEEDS VERIFICATION | Should call getCurrentUserRole() |
| **Database Schema** | ✅ CORRECT | `users` table exists with `role` column |
| **Demo Accounts** | ⚠️ NEEDS VERIFICATION | Should exist in users table |
| **Chat System** | ❌ NOT IMPLEMENTED | Never completed (WebRTC only) |

---

## ROOT CAUSE: Multiple Confusing Database Implementations

The project currently has:

1. ✅ **Primary System (CORRECT):**
   - `users` table in Supabase (has `role` column)
   - RoleManagementService queries from `users` table
   - Works correctly IF user records exist

2. ❌ **Lingering Confusion:**
   - Migration file creates/references `public.users` (may not exist)
   - Code previously tried to query `profiles` table (doesn't exist)
   - Multiple conflicting implementations left in place

### Why Login Fails:
```
User logs in → auth.users created → trigger should create users table record
BUT: If trigger wasn't deployed OR if user was created before trigger
→ No record in users table → RoleManagementService returns null
→ RoleManagementService.getCurrentUserRole() returns UserRole.unknown
→ Splash screen shows error or returns to login
```

---

## RECOVERY STEPS

### STEP 1: Verify Database Has Real Data

**Check if demo accounts exist in the `users` table:**

```sql
-- Execute in Supabase SQL Editor
SELECT 
  id, 
  email, 
  role,
  created_at
FROM users 
WHERE email LIKE '%demo%' OR email LIKE 'admin%'
ORDER BY created_at DESC;
```

**Expected Result:**
```
id                                    | email                | role           | created_at
──────────────────────────────────────┼──────────────────────┼────────────────┼──────────────
123e4567-e89b-12d3-a456-426614174000 | superadmin@demo.com  | super_admin    | 2026-03-14...
223e4567-e89b-12d3-a456-426614174001 | admin@demo.com       | clinic_admin   | 2026-03-14...
323e4567-e89b-12d3-a456-426614174002 | doctor@demo.com      | doctor         | 2026-03-14...
423e4567-e89b-12d3-a456-426614174003 | patient@demo.com     | patient        | 2026-03-14...
```

**If you get NO rows:** Users weren't created in users table - see STEP 2

---

### STEP 2: Create Demo Accounts (If Missing)

**Option A: Using Dart Script**

```dart
// dart run create_demo_accounts.dart
// Should create users in both auth.users and users table
```

**Option B: Manual (Via Supabase Dashboard)**

1. Go to Supabase → Authentication → Add user
   - Email: admin@demo.com
   - Password: Demo@123456

2. Go to SQL Editor → Run this INSERT:
```sql
INSERT INTO users (id, email, full_name, role, is_active, is_verified, created_at, updated_at)
VALUES (
  'USER_UUID_FROM_AUTH',  -- Get UUID from auth.users
  'admin@demo.com',
  'Admin User',
  'clinic_admin'::user_role,
  true,
  true,
  NOW(),
  NOW()
);
```

---

### STEP 3: Verify Splash Screen Implementation

**File:** `lib/features/splash/screens/splash_screen.dart`

**Critical method should exist:**
```dart
Future<void> _initialize() async {
  try {
    // Step 1: Get current auth user
    final authUser = SupabaseConfig.currentUser;
    
    if (authUser == null) {
      // Not logged in
      if (mounted) context.go(AppRoutes.login);
      return;
    }
    
    // Step 2: Fetch role (with database lookup as fallback)
    final role = await RoleManagementService.getCurrentUserRole(
      forceRefresh: true,
    );
    
    if (role == UserRole.unknown) {
      // Show error UI with retry
      _showRoleError();
      return;
    }
    
    // Step 3: Navigate to role's home path
    if (mounted) context.go(role.homeRoute);
    
  } catch (e) {
    _showError('Initialization failed: $e');
  }
}
```

**Verify it exists and is properly implemented:** ⬜

---

### STEP 4: Clean Up Database Confusion

**Remove conflicting migrations/tables:**

```sql
-- Check if public.users or profiles table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'profiles', 'public_users');

-- If profiles exists: DROP IT
DROP TABLE IF EXISTS profiles CASCADE;

-- If public.users exists and is different from users: Drop it
DROP TABLE IF EXISTS public.users CASCADE;
```

**Keep only:** The primary `users` table in `public` schema

---

### STEP 5: Test Authentication Flow

#### Test Case 1: Email/Password Login ✅
```
1. Start app → Splash Screen shown
2. No cached session → Redirected to /login
3. Enter: admin@demo.com / Demo@123456
4. Click Login
5. Expected: 
   - AuthService logs in with Supabase
   - AuthBloc emits LoginSuccess
   - BlocListener calls context.go(AppRoutes.dashboard)
   - Router guard checks metadata (not found)
   - Router returns /splash
   - Splash._initialize() calls RoleManagementService.getCurrentUserRole()
   - RoleManagementService queries users table
   - Gets role: 'clinic_admin'
   - Navigates to /admin (clinic_admin dashboard)
```

#### Test Case 2: Google Sign-In ✅
```
1. On login screen, click Google Sign-In button
2. LoginWithSocialSubmitted(provider: 'google') event triggered
3. AuthBloc handles it with AuthService.signInWithGoogle()
4. Expected: Same flow as above
```

---

## SPECIFIC CODE VERIFICATION CHECKLIST

- [ ] **Router:**
  - [ ] `_getRoleBasedHomePath()` is SYNCHRONOUS
  - [ ] Returns `/splash` when role not in metadata
  - [ ] No database queries in guard method

- [ ] **RoleManagementService:**
  - [ ] `_getRoleFromDatabase()` queries `users` table (NOT `profiles`)
  - [ ] `getCurrentUserRole()` has caching with 5-minute TTL
  - [ ] Returns `UserRole.unknown` only if role is genuinely not found

- [ ] **Splash Screen:**
  - [ ] `_initialize()` method exists
  - [ ] Calls `RoleManagementService.getCurrentUserRole()`
  - [ ] Handles timeout (3 seconds as in original implementation)
  - [ ] Shows error with retry if role not found
  - [ ] Navigates to `role.homeRoute` on success

- [ ] **Dependency Injection:**
  - [ ] All services properly registered in `injection_container.dart`
  - [ ] AuthService injected into AuthBloc
  - [ ] RoleManagementService properly initialized

---

## IMMEDIATE FIXES NEEDED

### Fix A: Remove Problematic Migration (If Exists)

**File:** `supabase/migrations/20260315_add_user_signup_trigger.sql`

**Issue:** Creates/uses `public.users` when code uses `users`

**Action:**
- [ ] Delete this file from repo
- [ ] Verify trigger `on_auth_user_created` exists and works correctly:

```sql
-- In Supabase, check if THIS trigger exists:
SELECT trigger_name, event_object_table
FROM information_schema.triggers
WHERE event_object_table = 'users'
AND trigger_name = 'on_auth_user_created';
```

If it doesn't exist, create it:
```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (
    id,
    email,
    role,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    NEW.email,
    'patient'::user_role,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();
```

### Fix B: Ensure RoleManagementService Is Correct

**File:** `lib/core/services/role_management_service.dart`

**Verify:**
```dart
static Future<String?> _getRoleFromDatabase(String userId) async {
  try {
    final response = await _client
        .from('users')  // ← MUST BE 'users', NOT 'profiles'
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

Status: ✅ Already correct (verified from code review)

---

## CHAT SYSTEM STATUS

**Finding:** Chat system is NOT IMPLEMENTED in current codebase

**What exists:**
- WebRTC infrastructure for video calls
- Socket.IO client integration  
- Notification system foundation
- But NO ChatBloc, ChatService, ChatScreen, or real-time messaging

**Options:**
1. **Skip for now:** Not part of core authentication/navigation recovery
2. **Implement later:** Create separate task/issue for chat feature
3. **Document current state:** Note that infrastructure exists but feature incomplete

---

## FINAL VALIDATION TESTS

### Test 1: Happy Path Login
```
superadmin@demo.com / Demo@123456
→ Should navigate to → /super-admin dashboard
```

### Test 2: Role-Based Routing
```
admin@demo.com → /admin (clinic_admin dashboard)
doctor@demo.com → /doctor (doctor dashboard)
patient@demo.com → /patient (patient dashboard)
```

### Test 3: Error Handling
```
1. Delete user from users table
2. User still in auth.users
3. Try to login
→ Should show error "User role not found. Retry?"
```

### Test 4: Cache Validation
```
1. Login successfully → role cached
2. Go to Settings, change application role
3. Return to home → should still show cached role (within 5 minutes)
4. Force refresh in settings → new role loaded
```

### Test 5: Redirect Loop Prevention
```
1. Clear cache
2. Login
3. Monitor for infinite splash/login redirects
4. Should not happen - each screen should load role once from DB
```

---

## ROLLBACK PLAN (If Recovery Fails)

If after these fixes the system still doesn't work:

```bash
# Revert to last known good commit
git log --oneline | head -20  # Find last working commit
git checkout <COMMIT_SHA>     # Go back

# Or mark specific files to revert:
git restore lib/core/config/router.dart
git restore lib/core/services/role_management_service.dart
```

---

## IMPLEMENTATION TIMELINE

```
Phase Duration  | Activity
───────────────┼───────────────────────────────────────
5 min          | STEP 1: Verify database has demo data
10 min         | STEP 2: Create demo accounts if missing  
10 min         | STEP 3: Check splash screen code
5 min          | STEP 4: Clean database (remove wrong tables)
15 min         | STEP 5: Test authentication flow
30 min         | Fix any issues found during testing
20 min         | Validation & verification tests
───────────────┼───────────────────────────────────────
95 min TOTAL   | (≈1.5 hours expected)
```

---

## SUCCESS CRITERIA

✅ **Recovery is successful when:**

1. User logs in with email/password → navigates to dashboard (not stuck on login/splash)
2. User logs in with Google → same result
3. Different roles see different dashboards
4. No infinite redirect loops
5. No "UserRole.unknown" errors in production
6. Demo accounts work: superadmin, admin, doctor, patient
7. Chat system documented (not required to work yet)

---

**Next Step:** Begin STEP 1 - Database Verification
