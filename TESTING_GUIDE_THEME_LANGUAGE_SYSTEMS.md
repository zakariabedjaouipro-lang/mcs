# 🧪 Testing Guide - Theme & Language Toggle Systems

**Date**: 2024
**Purpose**: Verification testing for Theme Toggle and Language Toggle systems
**Expected Duration**: 10-15 minutes

---

## ✅ Pre-Test Checklist

- [ ] Flutter project compiles without errors
- [ ] All dependencies installed (`flutter pub get`)
- [ ] No console errors in terminal
- [ ] Physical device or emulator connected
- [ ] Device has sufficient storage

---

## 🚀 Step 1: Run the Application

### Command

```bash
# Navigate to project directory
cd c:\Users\Administrateur\mcs

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Expected Output
```
Launching lib\main.dart on [device]...
...
✓ Built build/app/outputs/flutter-apk/app-release.apk (... MB)
✓ Installed app successfully
Application running. To quit, press 'q'.
```

### Verification
- ✅ App launches without crashes
- ✅ Landing screen displays
- ✅ No error messages in console

---

## 🎨 Step 2: Test Theme Toggle System

### Test Case 1: Initial Theme Application

**Steps**:
1. Observe the app UI colors
2. Note the theme button icon (should be moon 🌙 for light mode or sun ☀️ for dark mode)

**Expected**:
- App displays in light theme by default
- Theme button shows dark mode icon (moon 🌙)
- Colors match light theme palette

**Verification**:
- [ ] App uses light theme colors (white background, dark text)
- [ ] Theme button icon is appropriate

---

### Test Case 2: Toggle Theme Light → Dark

**Steps**:
1. Locate the theme button in the header (moon/sun icon)
2. Click the theme button
3. Observe the UI changes

**Expected**:
- UI immediately switches to dark theme
- Background becomes dark/black
- Text becomes light/white
- Button icon changes to sun ☀️
- SnackBar appears with message: "تم التبديل للوضع الداكن" (Arabic)
- All colors transition smoothly

**Verification**:
- [ ] UI changes to dark theme within 1 second
- [ ] Text is readable in dark theme
- [ ] SnackBar confirms the action
- [ ] No lag or freezing

---

### Test Case 3: Toggle Theme Dark → Light

**Steps**:
1. With app in dark theme, click the theme button again
2. Observe the UI changes back to light

**Expected**:
- UI immediately switches back to light theme
- Background becomes light/white
- Text becomes dark/black
- Button icon changes to moon 🌙
- SnackBar appears with message: "تم التبديل للوضع الفاتح" (Arabic)

**Verification**:
- [ ] UI changes back to light theme within 1 second
- [ ] All colors return to original state
- [ ] SnackBar confirms with Arabic text

---

### Test Case 4: Theme Persistence

**Steps**:
1. Set app to dark theme (theme button clicked)
2. Close the app completely
3. Wait 3 seconds
4. Reopen the app

**Expected**:
- App launches directly in dark theme
- Theme preference is remembered
- No manual theme change needed

**Verification**:
- [ ] App opens in same theme as was set before closing
- [ ] No default theme flicker
- [ ] Theme persisted correctly to SharedPreferences

**Note**: This tests persistence without manual verification of SharedPreferences

---

## 🌍 Step 3: Test Language Toggle System

### Test Case 5: Initial Language Display

**Steps**:
1. Observe the landing page text
2. Note the language button icon (globe 🌐)

**Expected**:
- All text displays in Arabic by default
- Button labels in Arabic
- Navigation links in Arabic
- Language button shows globe icon

**Verification**:
- [ ] Text is in Arabic
- [ ] All strings properly localized

---

### Test Case 6: Toggle Language Arabic → English

**Steps**:
1. Locate the language button in the header (globe 🌐 icon)
2. Click the language button
3. Observe the UI text changes

**Expected**:
- All text immediately switches to English
- "Sign In" button appears in English
- Navigation links ("Features", "Download", "About") in English
- "Login" text changes to "Sign In" in English
- SnackBar appears with message: "Switched to English"
- RTL layout switches to LTR (if applicable)

**Verification**:
- [ ] All visible text changes to English
- [ ] Text direction changes (RTL → LTR)
- [ ] SnackBar confirms the action
- [ ] No lag or freezing

---

### Test Case 7: Toggle Language English → Arabic

**Steps**:
1. With app in English, click the language button again
2. Observe text changes back to Arabic

**Expected**:
- All text immediately switches back to Arabic
- "Sign In" appears as Arabic text
- Navigation links return to Arabic
- SnackBar appears with message: "تم التبديل للعربية" (Arabic)
- RTL layout switches back

**Verification**:
- [ ] All visible text changes to Arabic
- [ ] Text direction changes back (LTR → RTL)
- [ ] SnackBar confirms with Arabic text
- [ ] No visual glitches

---

### Test Case 8: Language Persistence

**Steps**:
1. Set app to English (language button clicked)
2. Close the app completely
3. Wait 3 seconds
4. Reopen the app

**Expected**:
- App launches directly in English
- Language preference is remembered
- No manual language change needed

**Verification**:
- [ ] App opens with English text
- [ ] Text direction is LTR
- [ ] Language persisted correctly to SharedPreferences

---

## 🔄 Step 4: Combined System Testing

### Test Case 9: Theme + Language Together

**Steps**:
1. Start with app in Arabic + Light theme
2. Click theme button → Dark theme (Arabic)
3. Click language button → English (Dark theme)
4. Click theme button → Light theme (English)
5. Click language button → Arabic (Light theme)

**Expected**:
- Each action completes independently
- No conflicts between systems
- Both changes apply correctly
- App remains stable

**Verification**:
- [ ] Theme changes work while in any language
- [ ] Language changes work with any theme
- [ ] No system interference or bugs
- [ ] App handles rapid changes smoothly

---

### Test Case 10: Persistence with Both Systems

**Steps**:
1. Set app to: English + Dark theme
2. Verify both are active
3. Close and reopen app 3 times
4. Each time, verify English + Dark are maintained

**Expected**:
- Both preferences persist across restarts
- No defaults are reapplied
- First launch is always fastest

**Verification**:
- [ ] Both settings persist consistently
- [ ] No preference loss on restart
- [ ] Reliable persistence mechanism

---

## 📱 Step 5: Responsive Design Testing

### Test Case 11: Theme Toggle on Different Screen Sizes

**Steps**:
1. Rotate device between portrait and landscape
2. Click theme button in each orientation
3. Observe for layout issues

**Expected**:
- Theme button accessible in all orientations
- Theme changes apply correctly
- No UI overlap or missing elements

**Verification**:
- [ ] Theme works in portrait
- [ ] Theme works in landscape
- [ ] UI layout adapts correctly
- [ ] No visual issues

---

### Test Case 12: Language Toggle on Different Screen Sizes

**Steps**:
1. Rotate device between portrait and landscape
2. Click language button in each orientation
3. Observe text wrapping and layout

**Expected**:
- Language button accessible in all orientations
- Text wraps properly in both languages
- RTL/LTR adjusts correctly

**Verification**:
- [ ] Language works in portrait
- [ ] Language works in landscape
- [ ] Text is readable in both modes
- [ ] No text cutoff

---

## 🔨 Step 6: Error Handling Testing

### Test Case 13: App Stability Under Rapid Changes

**Steps**:
1. Rapidly click theme button 5-10 times
2. Observe for crashes or errors

**Expected**:
- App handles rapid changes smoothly
- No crashes or exceptions
- Each change completes properly

**Verification**:
- [ ] No console errors
- [ ] App doesn't freeze
- [ ] Each change queues properly

---

### Test Case 14: App Stability Under Rapid Language Changes

**Steps**:
1. Rapidly click language button 5-10 times
2. Observe for crashes or errors

**Expected**:
- App handles rapid changes smoothly
- No crashes or exceptions
- Localization updates correctly

**Verification**:
- [ ] No console errors
- [ ] No locale switching issues
- [ ] Text updates properly

---

## 📊 Testing Results Summary

### Create a checklist:

```
Theme Toggle System Tests:
├─ [ ] Initial theme application
├─ [ ] Light → Dark toggle
├─ [ ] Dark → Light toggle
├─ [ ] Theme persistence
├─ [ ] Responsive design (portrait)
├─ [ ] Responsive design (landscape)
└─ [ ] Rapid change handling

Language Toggle System Tests:
├─ [ ] Initial language display
├─ [ ] Arabic → English toggle
├─ [ ] English → Arabic toggle
├─ [ ] Language persistence
├─ [ ] Responsive design (portrait)
├─ [ ] Responsive design (landscape)
└─ [ ] Rapid change handling

Combined System Tests:
├─ [ ] Independent operation
├─ [ ] No conflicts
├─ [ ] Rapid combined changes
└─ [ ] Persistence of both settings
```

---

## ✅ Success Criteria

**All tests PASS if**:
- ✅ Theme changes instantly with visual feedback
- ✅ Language changes instantly with text updates
- ✅ Both systems work independently
- ✅ Settings persist across app restarts
- ✅ No errors in console
- ✅ UI remains responsive
- ✅ No layout issues on any screen size

---

## 🐛 Debugging Guide

If any test fails:

### Theme Not Changing
1. Check console for errors
2. Verify ThemeBloc is registered in injection_container.dart
3. Confirm theme_event.dart and theme_state.dart imports are correct
4. Check SharedPreferences key: `theme_mode`

### Language Not Changing
1. Check console for errors
2. Verify LocalizationBloc is registered in injection_container.dart
3. Confirm localization_event.dart and localization_state.dart imports
4. Check SharedPreferences key: `language_code`

### Persistence Not Working
1. Verify SharedPreferences dependency in pubspec.yaml
2. Check platform-specific configurations (Android/iOS)
3. Ensure SharedPreferences is initialized before BLoC creation
4. Check device storage permissions

### UI Layout Issues
1. Check responsive breakpoints in context_extensions.dart
2. Verify Material Design constraints
3. Test on different devices/emulators
4. Check for console layout warnings

---

## 📝 Test Log Template

```
Date: ____
Tester: ____
Device: ____ (Android/iOS/Web/Windows)
OS Version: ____

Test Case ID | Result | Notes | Time
------------ | ------ | ----- | ----
1            | ✅ PASS | All good | 23s
2            | ✅ PASS | Smooth | 15s
...

Issues Found:
- (none)

Recommendations:
- (none)

Overall Status: ✅ PASS - All systems functional
```

---

## 🎯 Post-Testing Actions

If all tests pass:
1. ✅ Document test results
2. ✅ Commit changes to git
3. ✅ Proceed to next feature implementation
4. ✅ Update project status

If any test fails:
1. ❌ Document the issue with reproduction steps
2. ❌ Check logs and debug
3. ❌ Fix the issue
4. ❌ Re-run failing tests
5. ❌ Document resolution

---

## 📞 Support

For issues or questions:
1. Check console logs for error messages
2. Review the implementation files
3. Verify all imports and registrations
4. Test on fresh app launch
5. Check platform-specific setup

---

**Expected Duration**: 15 minutes
**Difficulty**: Easy
**Required Knowledge**: None
**Status**: Ready for Testing ✅
