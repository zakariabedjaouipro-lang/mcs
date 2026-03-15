# 🧪 Logout Bug - Testing Instructions

**Status:** ✅ FIXED & COMPILED  
**Test Date:** March 15, 2026  
**Last Updated:** After latest code changes

---

## 📋 What Was Fixed

All logout buttons across the app now:
1. ✅ Clear the role cache immediately
2. ✅ Sign out from Supabase
3. ✅ Wait for auth state to sync (500ms)
4. ✅ Navigate to login page automatically
5. ✅ Show proper loading and error dialogs

---

## 🧪 QUICK TEST CHECKLIST

### Test 1: Dashboard Logout (AppShell)
```
1. Login with any account
2. Enter dashboard
3. Click the logout icon (🚪) in top-right
4. Expected: Loading dialog appears → redirects to login page
Result: ✅ _______
```

### Test 2: Super Admin Drawer Logout
```
1. Login as super admin
2. Look at left sidebar
3. Click logout button at bottom of sidebar
4. Expected: Proper logout → redirects to login
Result: ✅ _______
```

### Test 3: Super Admin Profile Dropdown
```
1. Login as super admin
2. Click profile avatar (top right)
3. Select "تسجيل الخروج / Logout"
4. Expected: Logout dialog → loading → login page
Result: ✅ _______
```

### Test 4: Admin Dashboard Logout  
```
1. Login as clinic admin
2. Go to admin dashboard
3. Click profile or logout
4. Confirm logout in dialog
5. Expected: Logout dialog → loading → login page
Result: ✅ _______
```

### Test 5: Re-login After Logout
```
1. Logout successfully
2. Login immediately with same account
3. Expected: Fresh session, correct role from database (not cached)
Result: ✅ _______
```

### Test 6: Network Error Handling
```
1. Simulate slow network or disconnect
2. Click logout
3. Expected: Loading dialog appears for up to 10 seconds, then shows error
4. Should still allow navigation to login after error
Result: ✅ _______
```

---

## 🔧 Test Execution

### Option A: Via Flutter Run (Recommended)
```bash
cd c:\Users\Administrateur\mcs
flutter pub get
flutter run
```

Then manually test each scenario above.

### Option B: Check Compilation First
```bash
cd c:\Users\Administrateur\mcs
flutter pub get
flutter analyze  # Should show WARNING/INFO only, no ERRORS
```

### Option C: Run on Device/Emulator
```bash
flutter run -d <device_name>
# Choose device from available options
```

---

## ✅ SUCCESS CRITERIA

**All tests pass if:**
- ✅ User sees loading indicator during logout
- ✅ After logout, app navigates to /login automatically
- ✅ No error messages about "stuck on splash"
- ✅ No infinite redirects
- ✅ Can re-login immediately after logout
- ✅ Role is correctly re-fetched from database (not from cache)
- ✅ All 4 logout buttons work (AppShell, Dashboard, Drawer, Profile)

**If any test fails:**
- Check console logs for errors
- Verify Supabase connection
- Check if profiles table has data
- Ensure role_management_service cache was cleared

---

## 🔍 Key Testing Points

### 1. Check App Logs
```
When you logout, you should see:
✓ "Signing out user with scope: SignOutScope.local"
✓ No "Undefined role" or "UserRole.unknown" messages
✓ No redirect loops
```

### 2. Check Router Logs  
```
When you logout, you should see:
✓ Router being notified of auth state change
✓ Redirect to /login allowed (since unauthenticated)
✓ No pending-approval or role-based redirect
```

### 3. Check Network
```
If network is down:
✓ Logout takes up to 10 seconds (timeout)
✓ Error message shown to user
✓ Dialog closes properly
✓ Can still try to navigate to login
```

---

## 📊 Test Matrix

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Click AppShell logout | Load → Signout → Navigate | _____ |
| Click Drawer logout | Load → Signout → Navigate | _____ |
| Click Profile dropdown logout | Load → Signout → Navigate | _____ |
| Click Admin logout | Load → Signout → Navigate | _____ |
| Login immediately after logout | Fresh session | _____ |
| Network down during logout | Error + retry option | _____ |
| Multiple rapid logouts | Handled gracefully | _____ |
| Logout on slow network | 10-second timeout | _____ |

---

## 🎯 What NOT to See

❌ **Do NOT see:**
- App stuck on splash screen
- Infinite "redirecting to" messages
- Cache role preventing logout
- Navigation not working after logout
- Error: "NavigationItem undefined"
- Error: "undefined_identifier"

❌ **These are BAD:**
```
GoRouter: INFO: redirecting to RouteMatchList#8befb(uri: /pending-approval)
[keeps repeating]
```

✅ **These are GOOD:**
```
GoRouter: INFO: redirecting to /login
Page loaded: premium_login_screen
```

---

## 📞 Troubleshooting

### Problem: Logout takes too long
**Solution:** This is expected on slow networks. The 500ms delay + Supabase processing takes time.

### Problem: Still see role after logout
**Solution:** This means cache wasn't cleared. Check that `RoleManagementService.clearCache()` was called.

### Problem: Redirects to /pending-approval after logout
**Solution:** The router guard is checking approvalStatus in metadata. This indicates the auth state wasn't fully updated. Wait 500ms.

### Problem: Can't login after logout
**Solution:** Profiles table might be missing data. Check that profiles table has a record for the user you're testing.

---

## ✨ Final Notes

- All logout buttons use the same logic pattern
- 500ms delay is reasonable for auth state sync
- Cache clearing happens before signout
- Error handling prevents app crashes
- Visual feedback keeps user informed

**Expected Logout Duration:** 500ms - 2 seconds (depending on network)

**Danger Zone:** If logout takes > 5 seconds, something is wrong (network issue likely)

---

**Ready for Testing!** 🚀
