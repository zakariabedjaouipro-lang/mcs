# Design System - Usage Guide

## Overview | نظرة عامة

This guide explains how to use the responsive UI component library created for the Medical Clinic System (MCS). All components automatically adapt to different screen sizes.

هذا الدليل يشرح كيفية استخدام مكتبة مكونات الواجهة المتجاوبة المنشأة لنظام إدارة العيادة الطبية (MCS). جميع المكونات تتكيف تلقائياً مع أحجام الشاشات المختلفة.

---

## 1. Spacing System | نظام التباعد

### AppSpacing Constants

```dart
import 'package:mcs/core/ui/spacing.dart';

// Font sizes and spacing scale (in pixels)
AppSpacing.xs      // 4px
AppSpacing.sm      // 8px
AppSpacing.md      // 12px
AppSpacing.lg      // 16px
AppSpacing.xl      // 20px
AppSpacing.xxl     // 24px
AppSpacing.xxxl    // 32px
AppSpacing.huge    // 40px
AppSpacing.massive // 48px
```

### AppRadius Constants

```dart
AppRadius.sm   // 4px
AppRadius.md   // 8px
AppRadius.lg   // 12px
AppRadius.xl   // 16px
AppRadius.full // Circular (9999px)
```

### AppPadding Constants

```dart
AppPadding.screen      // 16px (screen padding)
AppPadding.card        // 16px (card padding)
AppPadding.buttonH     // 24px (button horizontal)
AppPadding.buttonV     // 12px (button vertical)
AppPadding.listItem    // 16px (list item padding)
```

### Usage Example

```dart
Padding(
  padding: EdgeInsets.all(AppSpacing.lg),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),
)
```

---

## 2. Responsive Container Extensions | مدة التفاعل

Use `BuildContext` extensions for responsive properties:

```dart
import 'package:mcs/core/ui/responsive_container.dart';

@override
Widget build(BuildContext context) {
  // Screen detection
  if (context.isSmallScreen) {
    // Mobile layout (< 600px)
  } else if (context.isMediumScreen) {
    // Tablet layout (600-900px)
  } else {
    // Desktop layout (≥ 900px)
  }

  // Use responsive properties
  final padding = context.responsivePadding; // Auto-scales
  final scale = context.textScale;           // 1.0, 1.1, or 1.15
  
  return SizedBox(
    width: context.screenWidth,
    height: context.screenHeight,
  );
}
```

### Available Properties

- `screenSize` - Size (width, height)
- `screenWidth` - double
- `screenHeight` - double
- `isPortrait` - bool
- `isLandscape` - bool
- `isSmallScreen` - bool (< 600px)
- `isMediumScreen` - bool (600-900px)
- `isLargeScreen` - bool (≥ 900px)
- `responsivePadding` - EdgeInsets (auto-scales)
- `textScale` - double (1.0, 1.1, or 1.15)

### ResponsiveContainer Widget

```dart
ResponsiveContainer(
  child: Column(
    children: [...],
  ),
)
```

### ResponsivePadding Widget

```dart
ResponsivePadding(
  textScale: context.textScale,
  child: YourWidget(),
)
```

### ResponsiveGap Widget

```dart
// Vertical gap
ResponsiveGap(
  direction: Axis.vertical,
  size: AppSpacing.lg,
)

// Horizontal gap
ResponsiveGap(
  direction: Axis.horizontal,
  size: AppSpacing.md,
)
```

---

## 3. Responsive Text | النصوص المتجاوبة

All text widgets automatically scale based on screen size.

### Text Components

```dart
import 'package:mcs/core/ui/responsive_text.dart';

// Display heading (32-40px)
DisplayText(
  'Large Title',
  color: Colors.black,
  fontWeight: FontWeight.bold,
)

// Heading 1 (24-32px)
Heading1('Main Heading')

// Heading 2 (18-24px)
Heading2('Sub Heading')

// Heading 3 (16-20px)
Heading3('Section Title')

// Body Large (16-18px)
BodyLarge('Body text paragraph')

// Body Medium (14-16px)
BodyMedium('Regular body text')

// Body Small (12-14px)
BodySmall('Small body text')

// Caption (10-12px)
Caption('Caption or hint text')
```

### Full Example

```dart
Column(
  children: [
    Heading1('Welcome'),
    SizedBox(height: AppSpacing.md),
    BodyMedium(
      'This is responsive text that scales automatically.',
      textAlign: TextAlign.center,
      color: Colors.grey,
    ),
    SizedBox(height: AppSpacing.lg),
    Caption('Last updated: Today'),
  ],
)
```

---

## 4. Responsive Buttons | الأزرار المتجاوبة

Buttons automatically adjust padding and sizing based on screen.

### Button Types

```dart
import 'package:mcs/core/ui/responsive_button.dart';

// Elevated button (primary action)
ResponsiveElevatedButton(
  onPressed: () => handleLogin(),
  label: 'Login',
  icon: Icons.login,
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
)

// Outlined button (secondary action)
ResponsiveOutlinedButton(
  onPressed: () => handleRegister(),
  label: 'Register',
  borderColor: Colors.blue,
  textColor: Colors.blue,
)

// Text button (tertiary action)
ResponsiveTextButton(
  onPressed: () => handleForgot(),
  label: 'Forgot Password?',
  textColor: Colors.blue,
)

// Floating Action Button
ResponsiveFAB(
  onPressed: () => handleAdd(),
  icon: Icons.add,
  label: 'Add New', // Optional
  backgroundColor: Colors.blue,
)

// Icon button
ResponsiveIconButton(
  onPressed: () => handleMenu(),
  icon: Icons.menu,
  tooltip: 'Open menu',
)

// Generic button with type selection
ResponsiveButton(
  onPressed: () => handleAction(),
  label: 'Action',
  type: ButtonType.elevated,
  fullWidth: true,
)
```

### Button Props

```dart
ResponsiveElevatedButton(
  onPressed: () {},           // Required
  label: 'Button',            // Required
  icon: Icons.check,          // Optional icon
  isLoading: false,           // Shows loading indicator
  isEnabled: true,            // Enables/disables button
  fullWidth: false,           // Stretch to full width
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
)
```

### Full Example

```dart
Column(
  children: [
    ResponsiveElevatedButton(
      onPressed: () => handleLogin(),
      label: 'Login',
      icon: Icons.login,
      fullWidth: true,
    ),
    SizedBox(height: AppSpacing.md),
    ResponsiveOutlinedButton(
      onPressed: () => handleRegister(),
      label: 'Create Account',
      fullWidth: true,
    ),
  ],
)
```

---

## 5. Responsive Cards | البطاقات المتجاوبة

Cards with adaptive padding and styling.

```dart
import 'package:mcs/core/ui/responsive_card.dart';

// Basic responsive card
ResponsiveCard(
  onTap: () => handleTap(),
  backgroundColor: Colors.white,
  child: Column(
    children: [
      Text('Card Content'),
    ],
  ),
)

// Stat card for displaying metrics
ResponsiveStatCard(
  value: '42',
  label: 'Total Patients',
  icon: Icons.people,
  change: '+12%',
  changeIsPositive: true,
)

// List card with icon
ResponsiveListCard(
  title: 'Profile Settings',
  icon: Icons.person,
  subtitle: 'Manage your account',
  trailing: Icon(Icons.arrow_forward),
  onTap: () => handleTap(),
)

// Section card with header
ResponsiveSectionCard(
  title: 'Recent Appointments',
  trailing: TextButton(label: 'View All'),
  divider: true,
  child: Column(
    children: [
      // Content here
    ],
  ),
)

// Image card with overlay
ResponsiveImageCard(
  image: AssetImage('assets/doctor.jpg'),
  title: 'Dr. Ahmed Hassan',
  subtitle: 'Cardiologist',
  onTap: () => handleProfile(),
)
```

### Card Props

```dart
ResponsiveCard(
  child: YourWidget(),           // Required
  onTap: () {},                  // Optional tap handler
  padding: EdgeInsets.all(16),  // Optional custom padding
  margin: EdgeInsets.all(8),    // Optional custom margin
  backgroundColor: Colors.white,
  elevation: 1.0,
  borderRadius: BorderRadius.circular(12),
)
```

---

## 6. Responsive Grids & Layouts | الشبكات والتخطيطات

Various grid and layout options for responsive designs.

### Grid Components

```dart
import 'package:mcs/core/ui/responsive_grid.dart';

// Simple grid with list of children
ResponsiveGrid(
  children: [
    GridItem1(),
    GridItem2(),
    GridItem3(),
  ],
  smallColumns: 1,   // 1 column on mobile
  mediumColumns: 2,  // 2 columns on tablet
  largeColumns: 3,   // 3 columns on desktop
)

// Grid builder with item count
ResponsiveGridBuilder(
  itemCount: doctors.length,
  itemBuilder: (context, index) {
    return DoctorCard(doctor: doctors[index]);
  },
  smallColumns: 1,
  mediumColumns: 2,
  largeColumns: 3,
)

// Wrapped grid for dynamic sizing
ResponsiveWrapGrid(
  children: [
    // Children auto-size based on screen
  ],
)

// Masonry layout (staggered grid)
ResponsiveMasonryGrid(
  children: items,
  smallColumns: 1,
  mediumColumns: 2,
  largeColumns: 3,
)
```

### Layout Components

```dart
// Two-column layout (stacks on mobile)
ResponsiveTwoColumnLayout(
  left: LeftPanel(),
  right: RightPanel(),
)

// Three-column layout (adapts based on screen)
ResponsiveThreeColumnLayout(
  left: LeftPanel(),
  center: CenterPanel(),
  right: RightPanel(),
)

// Sidebar layout
ResponsiveSidebarLayout(
  sidebar: NavigationSidebar(),
  content: MainContent(),
  sidebarWidth: 280,
)

// Flow layout (row on desktop, column on mobile)
ResponsiveFlowLayout(
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)

// List view with responsive spacing
ResponsiveListView(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]);
  },
  spacing: AppSpacing.md,
)
```

---

## 7. Complete Screen Example | مثال الشاشة الكاملة

Here's a complete example showing how to use all components together:

```dart
import 'package:flutter/material.dart';
import 'package:mcs/core/ui/index.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctors = [
      // Doctor data
    ];

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
                title: 'Available Doctors',
                trailing: ResponsiveTextButton(
                  onPressed: () => viewAll(),
                  label: 'View All',
                ),
                child: BodyMedium(
                  'Browse our experienced medical professionals',
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Doctors grid
              ResponsiveGridBuilder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return ResponsiveCard(
                    onTap: () => navigateToProfile(doctor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor image
                        CircleAvatar(
                          radius: context.isSmallScreen ? 40 : 48,
                          backgroundImage: AssetImage(doctor.profilePic),
                        ),
                        SizedBox(height: AppSpacing.md),
                        // Doctor info
                        Heading3(doctor.name),
                        SizedBox(height: AppSpacing.xs),
                        BodySmall(doctor.specialty, color: Colors.grey),
                        SizedBox(height: AppSpacing.md),
                        // Join button
                        ResponsiveElevatedButton(
                          onPressed: () => bookAppointment(doctor),
                          label: 'Book Now',
                          fullWidth: true,
                        ),
                      ],
                    ),
                  );
                },
                smallColumns: 1,
                mediumColumns: 2,
                largeColumns: 3,
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Import Pattern | نمط الاستيراد

### Import all components at once

```dart
import 'package:mcs/core/ui/index.dart';

// Now you can use:
// - AppSpacing, AppRadius, AppPadding
// - ResponsiveExtension, ResponsiveContainer, ResponsivePadding, ResponsiveGap
// - DisplayText, Heading1, BodyLarge, Caption, etc.
// - ResponsiveElevatedButton, ResponsiveOutlinedButton, etc.
// - ResponsiveCard, ResponsiveStatCard, ResponsiveListCard, etc.
// - ResponsiveGrid, ResponsiveGridBuilder, etc.
```

### Import specific components

```dart
import 'package:mcs/core/ui/responsive_button.dart';
import 'package:mcs/core/ui/spacing.dart';
```

---

## 9. Best Practices | أفضل الممارسات

### ✅ DO

- Use `AppSpacing` constants for all padding and margins
- Use responsive text components instead of plain `Text` widgets
- Use responsive buttons for better UX on all screen sizes
- Use responsive grids for collections of items
- Test your layouts on multiple screen sizes

### ❌ DON'T

- Hard-code pixel values for padding/margin
- Use fixed button heights or widths
- Hard-code number of grid columns
- Ignore screen size variations
- Mix responsive and non-responsive components

---

## 10. Screen Size Breakpoints | نقاط تقسيم الشاشة

The design system uses these breakpoints:

| Screen Type | Width Range | Columns | Use Case |
|------------|-------------|---------|----------|
| Small (Mobile) | < 600px | 1 | Phones |
| Medium (Tablet) | 600-899px | 2 | Tablets |
| Large (Desktop) | ≥ 900px | 3 | Desktops |

When the screen width is:
- **< 600px**: Shows mobile optimized layout (single column, compact buttons)
- **600-899px**: Shows tablet optimized layout (2 columns, medium buttons)
- **≥ 900px**: Shows desktop optimized layout (3 columns, large buttons)

---

## 11. Next Steps | الخطوات التالية

This design system is Phase 1 of the UI improvement project:

1. ✅ **Phase 1 - Design System (COMPLETE)**
   - Spacing system
   - Responsive utilities
   - Text components
   - Button components
   - Card components
   - Grid components

2. 🔄 **Phase 2 - Test POC (NEXT)**
   - Select 3 screens to refactor as proof of concept
   - Apply new components to these screens
   - Validate responsive behavior

3. 📋 **Phase 3 - Rollout**
   - Apply pattern to remaining screens
   - Can be done incrementally by team members

---

## Questions?

For detailed implementation examples, see:
- `lib/core/ui/responsive_container.dart` - Extension properties
- `lib/core/ui/responsive_text.dart` - Text scaling logic
- `lib/core/ui/responsive_button.dart` - Button implementations
- `lib/core/ui/responsive_card.dart` - Card variations
- `lib/core/ui/responsive_grid.dart` - Grid and layout patterns

