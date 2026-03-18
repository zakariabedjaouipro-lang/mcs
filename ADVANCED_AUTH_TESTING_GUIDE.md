# Advanced Authentication Testing Guide
# دليل اختبار المصادقة المتقدمة

## Overview
Complete testing guide for the advanced role-based authentication system.

---

## Test Environment Setup

### Prerequisites
- ✓ Database migration deployed
- ✓ All models and services created
- ✓ BLoC configured and registered
- ✓ Routes configured in GoRouter
- ✓ Demo accounts initialized

### Test Database
- Test against Supabase development project
- Use demo roles and test accounts
- Clear test data between test runs

---

## Test Scenarios

### 1. Public Role Registration (Patient)

**Objective**: Test registration flow for roles without approval

**Steps**:
1. Launch app
2. Navigate to `/advanced-auth/registration`
3. Select "Patient" role
4. Fill form:
   - Email: `patient.test@mcs.local`
   - Password: `Test@Password123`
   - Full Name: `Test Patient`
   - Phone: `+20100000001`
5. Submit registration
6. Verify system shows email verification screen
7. Enter verification token
8. Complete email verification
9. Verify account is activated

**Expected Results**:
- ✓ User account created
- ✓ Email verification prompt shown
- ✓ After email verification, user can login immediately
- ✓ No approval required

**Duration**: ~5 minutes

---

### 2. Approval-Required Role Registration (Doctor)

**Objective**: Test registration flow for roles requiring admin approval

**Steps**:
1. Launch app
2. Navigate to `/advanced-auth/registration`
3. Select "Doctor" role
4. Fill form:
   - Email: `doctor.test@mcs.local`
   - Password: `Test@Password123`
   - Full Name: `Test Doctor`
   - Phone: `+20100000002`
   - Specialty: `General Medicine`
5. Submit registration
6. Verify system shows "Awaiting Admin Approval" message
7. **Switch to admin account**
8. Navigate to `/advanced-auth/approval-dashboard`
9. Find pending request
10. Click "Approve"
11. **Switch back to doctor account**
12. Verify email notification of approval
13. Test login with doctor account

**Expected Results**:
- ✓ Registration request created with status "pending"
- ✓ User sees awaiting approval message
- ✓ Admin can view pending requests
- ✓ Admin can approve/reject with reason
- ✓ User receives approval email notification
- ✓ User can login only after approval

**Duration**: ~10 minutes

---

### 3. Email Verification Flow

**Objective**: Test email verification functionality

**Test Cases**:

#### 3.1 Valid Token
- Provide correct verification token
- Expected: Email marked as verified
- ✓ PASS

#### 3.2 Expired Token
- Provide token older than 24 hours
- Expected: Token rejected, option to resend
- ✓ PASS

#### 3.3 Invalid Token
- Provide random token
- Expected: Invalid token error message
- ✓ PASS

#### 3.4 Resend Email
- Click "Resend Verification Email"
- Check email for new token
- Use new token
- Expected: Verification successful
- ✓ PASS

**Duration**: ~5 minutes

---

### 4. Two-Factor Authentication (2FA) Setup

**Objective**: Test 2FA setup and verification

**Steps** (for admin or users with required 2FA):
1. Navigate to account settings
2. Select "Setup 2FA"
3. System displays:
   - QR code
   - Secret key
   - Backup codes
4. Scan QR code with authenticator app (or use secret)
5. Enter 6-digit code from app
6. System verifies code
7. Display backup codes
8. Confirm setup
9. Re-login - 2FA code required

**Expected Results**:
- ✓ QR code generated correctly
- ✓ Secret key displayed for manual entry
- ✓ Code verification successful
- ✓ Backup codes generated (10 codes)
- ✓ Login requires 2FA code

**Test Cases**:
- Valid 2FA code: ✓ Login successful
- Invalid 2FA code: ✓ Error message
- Expired code: ✓ Error message
- Missing 2FA: ✓ Login blocked
- Backup code: ✓ Can use instead

**Duration**: ~10 minutes

---

### 5. Admin Approval Dashboard

**Objective**: Test admin approval workflow

**Steps**:
1. Login as admin (`admin@mcs.local`)
2. Navigate to `/advanced-auth/approval-dashboard`
3. Verify pending requests displayed
4. Check request details
5. Approve a request:
   - Click "Approve"
   - Confirm action
6. Reject a request:
   - Click "Reject"
   - Enter rejection reason
   - Confirm action
7. Verify request history

**Expected Results**:
- ✓ Pending requests visible
- ✓ Request details accurate
- ✓ Approve action works
- ✓ Reject action works with reason
- ✓ Status updated in database
- ✓ User notifications sent

**Duration**: ~5 minutes

---

### 6. Permission Checking

**Objective**: Test role-based permission system

**Test Cases**:

#### 6.1 Patient Permissions
- Patient role permissions checked
- Expected: Limited to personal operations
- ✓ PASS

#### 6.2 Doctor Permissions
- Doctor role permissions checked
- Expected: Can view patient records, create prescriptions
- ✓ PASS

#### 6.3 Admin Permissions
- Admin role permissions checked
- Expected: Full access to management functions
- ✓ PASS

#### 6.4 Permission Denied
- Try unauthorized operation
- Expected: Operation blocked with error message
- ✓ PASS

**Duration**: ~5 minutes

---

### 7. Account Locking After Failed Logins

**Objective**: Test security feature for failed login attempts

**Steps**:
1. Use test account `test.user@mcs.local`
2. Attempt login with wrong password 5 times
3. Verify account gets locked
4. View locked account message
5. Wait 15 minutes (or reset in DB)
6. Attempt login with correct password
7. Verify login successful

**Expected Results**:
- ✓ Account locks after 5 failed attempts
- ✓ Locked message displayed
- ✓ Auto-unlock after 15 minutes
- ✓ Can login after unlock

**Duration**: ~15+ minutes (due to lock duration)

---

## Performance Tests

### 1. Role Loading Performance
- Load all roles
- Expected: <500ms
- ✓ PASS

### 2. Permission Resolution
- Check user permissions
- Expected: <200ms
- ✓ PASS

### 3. Registration Request Approval
- Approve 10 requests in order
- Expected: <2s per request
- ✓ PASS

**Duration**: ~5 minutes

---

## Localization Tests

### 1. Arabic UI
- Set locale to Arabic
- Verify all screens display RTL
- Check Arabic text display
- ✓ PASS

### 2. English UI
- Set locale to English
- Verify all screens display LTR
- Check English text display
- ✓ PASS

### 3. Error Messages
- Trigger various errors
- Verify bilingual error messages
- ✓ PASS

**Duration**: ~5 minutes

---

## Error Handling Tests

### 1. Network Errors
- Disconnect network
- Attempt registration
- Expected: Error message displayed
- ✓ PASS

### 2. Server Errors
- Simulate API errors
- Expected: Graceful error handling
- ✓ PASS

### 3. Validation Errors
- Submit invalid form data
- Expected: Field-level errors
- ✓ PASS

**Duration**: ~5 minutes

---

## Test Checklist

- [ ] Patient registration (no approval)
- [ ] Doctor registration (with approval)
- [ ] Email verification (valid/invalid/expired)
- [ ] 2FA setup and verification
- [ ] Admin approval workflow
- [ ] Permission checking
- [ ] Account locking
- [ ] Role loading performance
- [ ] Localization (Arabic/English)
- [ ] Error handling
- [ ] All BLoC state transitions
- [ ] All UI screens navigate correctly
- [ ] Database RLS policies enforced

---

## Bug Reporting Template

```
Title: [Brief Description]

Environment:
- OS: [Windows/Mac/iOS/Android]
- Flutter Version: 3.19.0+
- Device: [Phone/Tablet/Web]

Steps to Reproduce:
1. 
2. 
3. 

Expected Result:

Actual Result:

Screenshots/Logs:
```

---

## Test Data Cleanup

After testing, clean up:

```sql
-- Clear test users
DELETE FROM profiles WHERE email LIKE '%.test@%' OR email LIKE '%.demo@%';

-- Clear test registration requests
DELETE FROM registration_requests 
WHERE user_id IN (SELECT id FROM auth.users WHERE email LIKE '%.test@%');

-- Reset sequences if needed
ALTER SEQUENCE roles_id_seq RESTART WITH 1;
```

---

## Sign-off

- [ ] All tests passed
- [ ] No critical bugs found
- [ ] Performance acceptable
- [ ] Localization working
- [ ] Ready for production

**Date**: ___________
**Tester**: ___________
**Sign-off**: ___________
