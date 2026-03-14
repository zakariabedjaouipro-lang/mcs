# Professional Responsive Design System - دليل التصميم المتجاوب الاحترافي

## Overview | نظرة عامة

This guide explains how to use the **professional responsive design system** that integrates:
- ✅ `flutter_screenutil` - Pixel-based responsive sizing
- ✅ `responsive_framework` - Layout-based responsive design  
- ✅ Custom design system - Domain-specific components

Together, these provide **production-grade** responsiveness across:
- 📱 **Phones** (< 600px)
- 📱 **Tablets** (600-900px)
- 🖥️ **Desktops** (≥ 900px)
- 🖼️ **4K Displays** (≥ 1400px)

---

## Quick Start | البدء السريع

### 1. Import the Library

```dart
import 'package:mcs/core/ui/index.dart';
```

This gives you access to:
- All spacing constants (`AppSpacing`, `AppRadius`, `AppPadding`)
- Responsive config (`ResponsiveConfig`, `ResponsiveExtensionPro`)
- All UI components (buttons, cards, text, grids)

### 2. Use Responsive Container

```dart
ResponsiveContainer(
  child: Column(
    children: [
      // Content automatically scales
    ],
  ),
)
```

### 3. Check Device Type

```dart
@override
Widget build(BuildContext context) {
  if (context.isMobile) {
    return MobileLayout();
  } else if (context.isTablet) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

---

## Part 1: flutter_screenutil Integration

### What is flutter_screenutil?

`flutter_screenutil` adapts pixel sizes based on design mockup dimensions:
- Design on 360px width mockup
- Auto-scales to any device width
- Maintains aspect ratio perfectly

### Basic Usage

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Convert design pixels to device pixels
double width = 100.w;      // 100 device-independent width
double height = 100.h;     // 100 device-independent height
double fontSize = 16.sp;   // 16 device-independent font size
double radius = 8.r;       // 8 device-independent radius
```

### Using with AppSpacing

```dart
// Old way - hard-coded
Padding(padding: EdgeInsets.all(16))

// New way - responsive with screenutil
Padding(
  padding: EdgeInsets.all(AppSpacing.lg),  // Uses screenutil internally
)
```

### Font Scaling with screenutil

```dart
Text(
  'Responsive Text',
  style: TextStyle(
    fontSize: 16.sp,  // Auto-scales on any device
    fontWeight: FontWeight.bold,
  ),
)
```

### Padding & Margins with screenutil

```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: 16.w,  // Responsive width
    vertical: 12.h,    // Responsive height
  ),
  child: Text('Content'),
)
```

---

## Part 2: responsive_framework Integration

### What is responsive_framework?

`responsive_framework` provides device classification:
- **MOBILE**: < 600px
- **TABLET**: 600-900px
- **DESKTOP**: ≥ 900px
- **4K**: ≥ 1400px

### Device Detection

```dart
import 'package:mcs/core/ui/responsive_config.dart';

@override
Widget build(BuildContext context) {
  // Option 1: Check device type
  if (context.isMobile) {
    return SingleColumn();
  } else if (context.isTablet) {
    return TwoColumns();
  } else if (context.isDesktop) {
    return ThreeColumns();
  } else if (context.is4K) {
    return FourColumns();
  }
}
```

### Get Current Device Name

```dart
String device = context.deviceName;  // Returns 'mobile', 'tablet', 'desktop', etc.
```

### Scaling Factors

```dart
// Get responsive scaling for current device
double fontScale = context.fontScale;        // 1.0, 1.1, 1.2
double spacingScale = context.spacingScale;  // 1.0, 1.15, 1.3
double dimensionScale = context.dimensionScale; // 1.0, 1.2, 1.4
```

---

## Part 3: ResponsiveConfig - Advanced Features

### Responsive Font Sizes

```dart
import 'package:mcs/core/ui/responsive_config.dart';

Text(
  'Responsive Headline',
  style: TextStyle(
    fontSize: ResponsiveConfig.headlineFontSize(context),
  ),
)
```

**Values**:
- Mobile: 24px
- Tablet: 32px
- Desktop: 40px

### Responsive Title Sizes

```dart
Text(
  'Section Title',
  style: TextStyle(
    fontSize: ResponsiveConfig.titleFontSize(context),
  ),
)
```

**Values**:
- Mobile: 18px
- Tablet: 22px
- Desktop: 26px

### Responsive Body Text

```dart
Text(
  'Body paragraph text',
  style: TextStyle(
    fontSize: ResponsiveConfig.bodyFontSize(context),
  ),
)
```

**Values**:
- Mobile: 14px
- Tablet: 16px
- Desktop: 18px

### Responsive Spacing

```dart
SizedBox(
  height: ResponsiveConfig.responsiveMargin(context),
)
```

**Values**:
- Mobile: 8px
- Tablet: 12px
- Desktop: 16px

### Responsive Padding

```dart
Padding(
  padding: EdgeInsets.all(
    ResponsiveConfig.responsivePadding(context),
  ),
  child: YourWidget(),
)
```

**Values**:
- Mobile: 12px
- Tablet: 16px
- Desktop: 20px

### Responsive Button Height

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(
      vertical: ResponsiveConfig.buttonHeight(context) / 2,
    ),
  ),
  child: Text('Button'),
)
```

**Values**:
- Mobile: 44px
- Tablet: 48px
- Desktop: 52px

### Responsive Icon Sizing

```dart
Icon(
  Icons.home,
  size: ResponsiveConfig.iconSize(context),
)
```

**Values**:
- Mobile: 20px
- Tablet: 24px
- Desktop: 28px

### Responsive Card Border Radius

```dart
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      ResponsiveConfig.cardBorderRadius(context),
    ),
  ),
  child: YourContent(),
)
```

**Values**:
- Mobile: 8px
- Tablet: 12px
- Desktop: 16px

---

## Part 4: Using Pre-built Components

### Responsive Text Components

```dart
import 'package:mcs/core/ui/responsive_text.dart';

// Heading levels
Heading1('Main Title')          // 24-32px
Heading2('Subtitle')            // 18-24px
Heading3('Section Title')       // 16-20px

// Body text
BodyLarge('Large body text')     // 16-18px
BodyMedium('Regular text')       // 14-16px
BodySmall('Small text')          // 12-14px

// Caption
Caption('Helper text')           // 10-12px
```

### Responsive Buttons

```dart
import 'package:mcs/core/ui/responsive_button.dart';

// Elevated button
ResponsiveElevatedButton(
  onPressed: () {},
  label: 'Save',
  icon: Icons.save,
)

// Outlined button
ResponsiveOutlinedButton(
  onPressed: () {},
  label: 'Cancel',
  fullWidth: true,
)

// Text button
ResponsiveTextButton(
  onPressed: () {},
  label: 'Learn More',
)

// FAB
ResponsiveFAB(
  onPressed: () {},
  icon: Icons.add,
  label: 'Add',
)
```

### Responsive Cards

```dart
import 'package:mcs/core/ui/responsive_card.dart';

// Basic card
ResponsiveCard(
  onTap: () {},
  child: Text('Card content'),
)

// Stat card
ResponsiveStatCard(
  value: '42',
  label: 'Total Patients',
  icon: Icons.people,
  change: '+12%',
)

// List card
ResponsiveListCard(
  title: 'Profile',
  icon: Icons.person,
  subtitle: 'Manage account',
)

// Image card
ResponsiveImageCard(
  image: AssetImage('doctor.jpg'),
  title: 'Dr. Hassan',
  subtitle: 'Cardiologist',
)
```

### Responsive Grids

```dart
import 'package:mcs/core/ui/responsive_grid.dart';

// Dynamic columns based on screen
ResponsiveGridBuilder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  smallColumns: 1,    // Mobile
  mediumColumns: 2,   // Tablet
  largeColumns: 3,    // Desktop
)

// Responsive two-column layout
ResponsiveTwoColumnLayout(
  left: LeftPanel(),
  right: RightPanel(),
)

// Responsive sidebar layout
ResponsiveSidebarLayout(
  sidebar: Sidebar(),
  content: MainContent(),
)
```

---

## Part 5: Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:mcs/core/ui/index.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctors = getDoctors();
    
    return Scaffold(
      appBar: AppBar(
        title: Heading1('Our Doctors'),
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              ResponsiveSectionCard(
                title: 'Featured Doctors',
                trailing: ResponsiveTextButton(
                  onPressed: () => viewAll(),
                  label: 'View All',
                ),
                child: BodyMedium(
                  'Browse our experienced medical professionals',
                ),
              ),
              SizedBox(height: ResponsiveConfig.responsiveMargin(context)),

              // Doctors grid - adapts columns based on screen
              ResponsiveGridBuilder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return ResponsiveCard(
                    onTap: () => viewDoctor(doctor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image
                        CircleAvatar(
                          radius: ResponsiveConfig.iconSize(context) * 2,
                          backgroundImage: AssetImage(doctor.image),
                        ),
                        SizedBox(
                          height:
                              ResponsiveConfig.responsiveMargin(context),
                        ),

                        // Doctor info
                        Heading3(doctor.name),
                        SizedBox(
                          height: ResponsiveConfig.responsiveMargin(context) /
                              2,
                        ),
                        BodySmall(
                          doctor.specialty,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height:
                              ResponsiveConfig.responsiveMargin(context),
                        ),

                        // CTA button
                        ResponsiveElevatedButton(
                          onPressed: () => bookAppointment(doctor),
                          label: 'Book Now',
                          fullWidth: true,
                        ),
                      ],
                    ),
                  );
                },
                smallColumns: 1,   // Mobile: 1 column
                mediumColumns: 2,  // Tablet: 2 columns
                largeColumns: 3,   // Desktop: 3 columns
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Part 6: Best Practices | أفضل الممارسات

### ✅ DO

```dart
// ✅ Use AppSpacing constants
Padding(
  padding: EdgeInsets.all(AppSpacing.lg),
  child: YourWidget(),
)

// ✅ Use responsive config values
Text(
  'Title',
  style: TextStyle(
    fontSize: ResponsiveConfig.titleFontSize(context),
  ),
)

// ✅ Use responsive components
ResponsiveElevatedButton(
  onPressed: () {},
  label: 'Save',
)

// ✅ Check device type
if (context.isTablet) {
  return TwoColumnLayout();
}

// ✅ Use screenutil for custom values
Container(
  width: 200.w,  // Responsive width
  height: 100.h, // Responsive height
)
```

### ❌ DON'T

```dart
// ❌ Hard-code pixel values
Padding(padding: EdgeInsets.all(16))

// ❌ Fixed box sizes
SizedBox(width: 300, height: 100)

// ❌ Ignore device type
return SingleLayout()  // Works only on one device

// ❌ Mix responsive and non-responsive
Row(
  children: [
    SizedBox(width: 100),  // Fixed width
    Expanded(...)          // Responsive width
  ]
)
```

---

## Part 7: Migration Guide - From Custom to Professional

If you have existing screens using the old custom responsive system:

### Before (Custom only)

```dart
import 'package:mcs/core/ui/responsive_container.dart';

@override
Widget build(BuildContext context) {
  final isSmall = context.isSmallScreen;
  return SizedBox(
    width: isSmall ? 300 : 400,
    height: isSmall ? 44 : 48,
  );
}
```

### After (Professional system)

```dart
import 'package:mcs/core/ui/index.dart';

@override
Widget build(BuildContext context) {
  return ResponsiveElevatedButton(
    onPressed: () {},
    label: 'Action',
    // Height auto-scales: 44px (mobile) → 48px (tablet) → 52px (desktop)
  );
}
```

---

## Part 8: Device Breakpoints Reference

| Device Type | Width Range | Scale Factor | Use Case |
|-------------|-------------|--------------|----------|
| **Mobile** | < 600px | 1.0 | Phones (iPhone, Android) |
| **Tablet** | 600-900px | 1.2 | iPad, 7-10" tablets |
| **Desktop** | 900-1400px | 1.3 | Laptops, monitors |
| **4K** | ≥ 1400px | 1.5 | 4K displays, large monitors |

---

## Part 9: Troubleshooting

### Issue: Text looks too small/large

**Solution**: Use `ResponsiveConfig` functions instead of hardcoded values:

```dart
// ❌ Problem
Text('Title', style: TextStyle(fontSize: 24))

// ✅ Solution
Text(
  'Title',
  style: TextStyle(
    fontSize: ResponsiveConfig.titleFontSize(context),
  ),
)
```

### Issue: Buttons different sizes on different screens

**Solution**: Use `ResponsiveElevatedButton` instead of custom styling:

```dart
// ✅ Auto-scales button height
ResponsiveElevatedButton(
  onPressed: () {},
  label: 'Button',
  // Height: 44px (mobile) → 48px (tablet) → 52px (desktop)
)
```

### Issue: Grid showing wrong number of columns

**Solution**: Ensure `ResponsiveGridBuilder` has correct column counts:

```dart
ResponsiveGridBuilder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  smallColumns: 1,   // ← Mobile
  mediumColumns: 2,  // ← Tablet  
  largeColumns: 3,   // ← Desktop
)
```

---

## Summary Table

| Feature | flutter_screenutil | responsive_framework | Our System |
|---------|-------------------|----------------------|-----------|
| Pixel Scaling | ✅ Yes | ❌ No | ✅ Via screenutil |
| Device Type | ❌ No | ✅ Yes | ✅ Via responsive_framework |
| Components | ❌ No | ❌ No | ✅ Yes |
| Easy to Use | ✅ Yes | ✅ Yes | ✅ Yes |
| Production Ready | ✅ Yes | ✅ Yes | ✅ Yes |

**Together = Professional Grade Responsive Design** 🚀

