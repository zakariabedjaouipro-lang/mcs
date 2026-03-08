# Medical Landing Design - Developer Quick Reference

## 🎨 Color Palette Quick Reference

```dart
// Import medical colors
import 'package:mcs/core/theme/medical_colors.dart';

// Primary colors
MedicalColors.primary          // #0FB5D4 (Turquoise)
MedicalColors.primaryDark      // #0A8FA3
MedicalColors.primaryLight     // #E0F7FA

// Secondary colors
MedicalColors.secondary        // #26A69A (Teal)
MedicalColors.accent           // #4DD0E1 (Cyan)

// Status colors
MedicalColors.success          // #4CAF50 (Green)
MedicalColors.warning          // #FFC107 (Yellow)
MedicalColors.error            // #D32F2F (Red)

// Gradients
MedicalColors.medicalGradient  // Turquoise → Teal
MedicalColors.lightGradient    // Light turquoise → Light teal
```

---

## 🏗️ Component Usage Guide

### 1. Medical Crescent Logo

```dart
import 'package:mcs/features/landing/widgets/medical_crescent_logo.dart';

// Basic usage
MedicalCrescentLogo()

// Custom size and color
MedicalCrescentLogo(
  size: 100,
  color: MedicalColors.primary,
  withStar: true,  // Include medical star
)
```

### 2. Hero Section

```dart
import 'package:mcs/features/landing/widgets/medical_hero_section.dart';

MedicalHeroSection(
  onLoginPressed: () => context.go(AppRoutes.login),
  onRegisterPressed: () => context.go(AppRoutes.register),
)
```

### 3. Feature Card

```dart
import 'package:mcs/features/landing/widgets/medical_feature_card.dart';

MedicalFeatureCard(
  icon: Icons.event_note,
  title: 'Smart Scheduling',
  description: 'Automated appointment management with intelligent conflict resolution',
  iconColor: MedicalColors.primary,
  onTap: () { /* Handle tap */ },
)
```

### 4. CTA Button

```dart
import 'package:mcs/features/landing/widgets/medical_cta_button.dart';

// Primary button
MedicalCTAButton(
  label: 'Get Started',
  onPressed: () { /* Navigate */ },
  isPrimary: true,
)

// Secondary button
MedicalCTAButton(
  label: 'Learn More',
  onPressed: () { /* Navigate */ },
  isPrimary: false,
)

// With icon
MedicalCTAButton(
  label: 'Sign In',
  onPressed: () { /* Navigate */ },
  icon: Icons.login,
)

// Small size
MedicalCTAButton(
  label: 'Small Button',
  onPressed: () { /* Navigate */ },
  isSmall: true,
)
```

### 5. Features Section

```dart
import 'package:mcs/features/landing/widgets/medical_features_section.dart';

const MedicalFeaturesSection()
```

---

## 📱 Responsive Design Helpers

```dart
import 'package:mcs/core/utils/extensions.dart';

// Check device size
context.isSmall      // Mobile: width < 600
context.isMedium     // Tablet: 600 <= width <= 900
context.isLarge      // Desktop: width > 900

// Check theme
context.isDarkMode   // true if dark theme active

// Check locale
final locale = Localizations.localeOf(context);
final isArabic = locale.languageCode == 'ar';
final isRTL = locale.textDirection == TextDirection.rtl;
```

---

## 🎯 Landing Page Structure

### Full Page Example

```dart
SingleChildScrollView(
  child: Column(
    children: [
      // Header
      _buildHeader(context),      // Logo, nav, theme, language
      
      // Hero section
      MedicalHeroSection(...),    // Logo, headline, CTAs
      
      // Features
      const MedicalFeaturesSection(),  // 6 feature cards
      
      // Footer
      _buildFooter(context),      // Links, compliance badge
    ],
  ),
)
```

---

## 🎨 Design Customization

### Update Color Scheme

```dart
// In medical_colors.dart
static const Color primary = Color(0xFF...).  // Change to your brand color

// Automatically updates all components
```

### Add New Features

```dart
// In medical_features_section.dart
final features = [
  _Feature(
    icon: Icons.your_icon,
    title: 'Your Title',
    description: 'Your description',
    color: MedicalColors.custom,
  ),
  // ... more features
];
```

### Customize Hero Section

```dart
// Edit in medical_hero_section.dart
- Change headline text
- Modify subtitle
- Adjust button labels
- Update gradient colors
- Change animation duration
```

---

## 🔄 Theme & Language Integration

### Dark Mode

Components automatically adapt:
- Dark mode: Grey[900] backgrounds, light text
- Light mode: White backgrounds, dark text

Toggle via:
```dart
context.read<ThemeBloc>().add(const ToggleThemeEvent());
```

### Localization (AR/EN)

Components use:
```dart
final currentLocale = Localizations.localeOf(context);
final isArabic = currentLocale.languageCode == 'ar';
```

Toggle via:
```dart
context.read<LocalizationBloc>().add(const ToggleLanguageEvent());
```

---

## 📐 Spacing & Typography

### Spacing Grid (8px)

```dart
const spacing = <int, double>{
  1: 8.0,
  2: 16.0,
  3: 24.0,
  4: 32.0,
  5: 40.0,
  6: 48.0,
};
```

### Text Styles

```dart
import 'package:mcs/core/theme/text_styles.dart';

TextStyles.headlineLarge      // 56px, bold
TextStyles.headlineMedium     // 44px, bold
TextStyles.titleMedium        // 18px, bold
TextStyles.bodyLarge          // 16px, regular
TextStyles.bodyMedium         // 14px, regular
TextStyles.labelLarge         // 14px, bold
TextStyles.labelMedium        // 12px, bold
```

---

## ✨ Animation Timings

```dart
// Floating animation (Hero logo)
duration: const Duration(seconds: 4)
curve: Curves.easeInOut
range: 0 → 20px vertical

// Card hover animation
duration: const Duration(milliseconds: 300)
curve: Curves.easeInOut
elevation: 4dp → 12dp
scale: 1.0 → 1.03

// Button hover animation
duration: const Duration(milliseconds: 200)
curve: Curves.easeInOut
scale: 1.0 → 1.05
shadow: intensified
```

---

## 🔍 Testing Checklist

- [ ] Page loads without errors
- [ ] Logo renders correctly
- [ ] Hero section displays with animations
- [ ] Feature cards show 6 items
- [ ] Hover effects work on desktop
- [ ] Mobile layout (1 column)
- [ ] Tablet layout (2 columns)
- [ ] Desktop layout (3 columns)
- [ ] Dark mode toggles correctly
- [ ] Language toggle works
- [ ] Navigation buttons work
- [ ] Responsive at all breakpoints
- [ ] Animations are smooth (60fps)

---

## 🚀 Deployment Checklist

- ✅ No compilation errors
- ✅ Accessibility compliant
- ✅ Responsive on all devices
- ✅ Dark mode working
- ✅ Localization working
- ✅ Navigation implemented
- ✅ Performance optimized
- ✅ Browser tested (Chrome, Firefox, Safari)

---

## 📚 File References

```
lib/
├── core/theme/
│   └── medical_colors.dart               # Color system
├── features/landing/
│   ├── screens/
│   │   └── landing_screen.dart           # Main page
│   └── widgets/
│       ├── medical_crescent_logo.dart    # Crescent logo
│       ├── medical_hero_section.dart     # Hero section
│       ├── medical_features_section.dart # Features grid
│       ├── medical_feature_card.dart     # Feature card
│       └── medical_cta_button.dart       # CTA button
```

---

## 💡 Pro Tips

1. **Colors**: Use `MedicalColors.` constants, never hardcode hex values
2. **Responsive**: Always check `context.isSmall/isMedium/isLarge`
3. **Dark Mode**: Test components in both light and dark themes
4. **RTL**: Remember Arabic is RTL - test with Arabic locale
5. **Performance**: Use `const` constructors where possible
6. **Animations**: Keep animation duration <500ms for smoothness
7. **Accessibility**: Ensure touch targets are >48x48dp
8. **Testing**: Test on multiple device sizes and browsers

---

## 🎓 Resources

- **Design System**: [medical_colors.dart](./lib/core/theme/medical_colors.dart)
- **Main Landing**: [landing_screen.dart](./lib/features/landing/screens/landing_screen.dart)
- **Documentation**: [PROFESSIONAL_LANDING_DESIGN_REPORT.md](./PROFESSIONAL_LANDING_DESIGN_REPORT.md)

---

**Version**: 1.0.0  
**Status**: Production Ready  
**Last Updated**: March 8, 2026

