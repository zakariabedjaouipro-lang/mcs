# 📱 RESPONSIVE IMPLEMENTATION GUIDE

## Quick Reference for Screen Refactoring

This guide provides patterns and examples for refactoring all screens to be fully responsive.

---

## ✅ PATTERN 1: Basic Responsive Screen

Use this pattern for all simple screens with scrollable content.

```dart
import 'package:mcs/core/extensions/context_extensions.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Adaptive padding based on screen width
          padding: EdgeInsets.all(context.adaptivePaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content goes here
            ],
          ),
        ),
      ),
    );
  }
}
```

**Key Points**:
- Always use `SafeArea` for system insets
- Use `context.adaptivePaddingHorizontal` instead of hardcoded 20
- Use `context.adaptivePaddingVertical` for vertical spacing
- Wrap long content in `SingleChildScrollView`

---

## ✅ PATTERN 2: Responsive Grid

Use this pattern for displaying items in a grid.

```dart
import 'package:mcs/core/widgets/responsive_grid_view.dart';

// Simple grid
ResponsiveGridView(
  children: [
    _buildItem(1),
    _buildItem(2),
    _buildItem(3),
    _buildItem(4),
  ],
)

// Grid with builder (for large lists)
ResponsiveGridViewBuilder(
  itemCount: items.length,
  itemBuilder: (context, index) => _buildItem(items[index]),
)

// Grid with section header
ResponsiveGridSection(
  title: 'My Section',
  children: [
    _buildItem(1),
    _buildItem(2),
  ],
)
```

**Features**:
- Automatically 2 columns on mobile, 3 on tablet, 4 on desktop
- Adaptive spacing based on screen size
- Proper padding handling
- Use `.builder` for lazy loading (performance)

---

## ✅ PATTERN 3: Responsive Card

Use this pattern for card-based layouts.

```dart
import 'package:mcs/core/widgets/responsive_card.dart';

ResponsiveCard(
  onTap: () => navigate(),
  // Padding is automatically adaptive
  child: Column(
    children: [
      Text('Content'),
    ],
  ),
)

// With custom padding
ResponsiveCard(
  padding: EdgeInsets.only(
    left: context.adaptivePaddingHorizontal,
    right: context.adaptivePaddingHorizontal,
    top: context.adaptivePaddingVertical,
  ),
  child: Text('Custom padding'),
)
```

**Features**:
- Padding adapts to screen width
- Supports tap callbacks
- Customizable elevation and radius
- Dark mode aware

---

## ✅ PATTERN 4: Responsive Button

Use this pattern for all buttons.

```dart
import 'package:mcs/core/widgets/responsive_button.dart';

// Primary button (full width)
ResponsiveButton(
  label: 'Log In',
  onPressed: () => login(),
)

// Secondary button
ResponsiveButton(
  label: 'Cancel',
  onPressed: () => navigate(),
  style: ResponsiveButtonStyle.secondary,
)

// Outline button
ResponsiveButton(
  label: 'More Info',
  onPressed: () => showInfo(),
  style: ResponsiveButtonStyle.outline,
)

// With icon
ResponsiveButton(
  label: 'Send',
  leadingIcon: Icons.send,
  onPressed: () => send(),
)

// Loading state
ResponsiveButton(
  label: 'Processing...',
  isLoading: true,
  onPressed: null,
)

// Small button
ResponsiveButton(
  label: 'Skip',
  size: ResponsiveButtonSize.small,
  onPressed: () => skip(),
)
```

**Standard Heights**:
- Small: 40px
- Medium (default): 48px
- Large: 56px

---

## ✅ PATTERN 5: Responsive Text Field

Use this pattern for form inputs.

```dart
import 'package:mcs/core/widgets/responsive_text_field.dart';

ResponsiveTextField(
  label: 'Email',
  hintText: 'user@example.com',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email,
)

// With error
ResponsiveTextField(
  label: 'Password',
  errorText: 'Password too short',
  obscureText: true,
  prefixIcon: Icons.lock,
)

// Multiline
ResponsiveTextField(
  label: 'Message',
  maxLines: 5,
  minLines: 3,
)

// Loading state
ResponsiveTextField(
  label: 'Username',
  isLoading: true,
  enabled: false,
)
```

**Standard Heights**:
- Single line: 48px
- Large: 56px
- Multiline: Dynamic (56px * lines)

---

## ✅ PATTERN 6: Responsive Layout

Use this pattern to show different layouts on different screen sizes.

```dart
import 'package:mcs/core/widgets/responsive_layout.dart';

ResponsiveLayout(
  // Mobile layout (< 600px)
  mobile: _buildMobileLayout(),
  
  // Tablet layout (600-1024px) - defaults to mobile if not provided
  tablet: _buildTabletLayout(),
  
  // Desktop layout (>= 1024px) - defaults to tablet then mobile
  desktop: _buildDesktopLayout(),
)

// Or check breakpoint manually
if (context.isSmall) {
  return _buildMobileLayout();
} else if (context.isMedium) {
  return _buildTabletLayout();
} else {
  return _buildDesktopLayout();
}
```

---

## ✅ PATTERN 7: Responsive Navigation

Use this for mobile/desktop adaptive navigation.

```dart
Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      if (context.isMobile) {
        // Mobile: AppBar + Drawer
        return _buildMobileLayout();
      } else {
        // Desktop: Sidebar + Content
        return Row(
          children: [
            _buildSidebar(),
            Expanded(child: _buildContent()),
          ],
        );
      }
    },
  ),
  bottomNavigationBar: context.isMobile ? _buildBottomNav() : null,
  drawer: context.isMobile ? _buildDrawer() : null,
)
```

---

## ✅ PATTERN 8: Flexible Text in Rows

Always use `Flexible` when text might overflow in a `Row`.

```dart
// ❌ WRONG - Will overflow
Row(
  children: [
    Icon(Icons.star),
    Text('Very long text that might overflow'),
  ],
)

// ✅ CORRECT
Row(
  children: [
    Icon(Icons.star),
    SizedBox(width: 8),
    Flexible(
      child: Text(
        'Very long text that wraps gracefully',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

---

## ✅ PATTERN 9: Spacer with Responsive Sizing

Use `context.adaptive*` properties for spacing consistency.

```dart
// ❌ WRONG - Fixed spacing
Column(
  children: [
    Widget1(),
    SizedBox(height: 20),  // Same on all devices
    Widget2(),
    SizedBox(height: 20),
    Widget3(),
  ],
)

// ✅ CORRECT - Adaptive spacing
Column(
  children: [
    Widget1(),
    SizedBox(height: context.adaptivePaddingVertical),
    Widget2(),
    SizedBox(height: context.adaptivePaddingVertical),
    Widget3(),
  ],
)

// ✅ OR Use padding directly
Column(
  children: [
    Padding(
      padding: context.adaptiveVPadding,
      child: Widget1(),
    ),
    Padding(
      padding: context.adaptiveVPadding,
      child: Widget2(),
    ),
  ],
)
```

---

## 🔧 REFACTORING CHECKLIST

When refactoring a screen, ensure:

- [ ] Remove hardcoded `EdgeInsets` and use `context.adaptive*`
- [ ] Remove hardcoded `SizedBox` heights/widths
- [ ] Replace `GridView.count` with `ResponsiveGridView`
- [ ] Use `ResponsiveButton` for all buttons
- [ ] Use `ResponsiveCard` for card layouts
- [ ] Use `ResponsiveTextField` for inputs
- [ ] Add `SafeArea` around body content
- [ ] Use `SingleChildScrollView` for scrollable content
- [ ] Add `Flexible` to text in `Row` widgets
- [ ] Set proper `maxLines` on text that might overflow
- [ ] Use `context.isSmall/isMedium/isLarge` for layout conditions
- [ ] Test on mobile (< 600), tablet (600-1024), desktop (>= 1024)

---

## 📏 RESPONSIVE SIZING REFERENCE

### Breakpoints
```dart
Mobile:   width < 600
Tablet:   600 ≤ width < 1024
Desktop:  width ≥ 1024
```

### Adaptive Values
```dart
Padding (horizontal):
  Mobile:   12px
  Tablet:   16px
  Desktop:  20px

Padding (vertical):
  Mobile:   12px
  Tablet:   16px
  Desktop:  20px

Card Padding:
  Mobile:   12px
  Tablet:   16px
  Desktop:  20px

Grid Columns:
  Mobile:   2
  Tablet:   3
  Desktop:  4

Grid Spacing:
  Mobile:   12px
  Tablet:   16px
  Desktop:  20px
```

### Fixed Standards
```dart
Button Height:      48px
Button Height (S):  40px
Button Height (L):  56px

Input Height:       48px
Input Height (L):   56px

Icon Size:          24px
Icon Size (S):      20px
Icon Size (L):      32px

Min Touch Target:   48x48px

Icon (Large):       32px
Avatar (Medium):    48px
Avatar (Large):     72px
```

---

## 🧪 TESTING RESPONSIVE LAYOUTS

### Device Sizes to Test
- Mobile: 360x800 (small), 414x896 (large)
- Tablet: 600x1024 (portrait), 1024x600 (landscape)
- Desktop: 1280x720, 1920x1080

### Test Commands
```bash
# Run on specific device
flutter run -d chrome --web-renderer html

# Run on tablet simulator
flutter run -d "iPad Air (5th generation)"

# Run on different screen sizes
flutter run --device-id=<device-id>
```

### Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| Text overflows in Row | Wrap with `Flexible` + `overflow: TextOverflow.ellipsis` |
| Layout too cramped on mobile | Use `context.adaptivePaddingHorizontal` instead of 20 |
| Cards too wide | Use `ResponsiveCard` instead of `Card` |
| Button not full width | Don't specify width, use default |
| Navigation bar hidden | Use `SafeArea` |
| Keyboard overlaps content | Use `SingleChildScrollView` with proper padding |
| Grid items oversized | Use `ResponsiveGridView` instead of `GridView.count` |
| Spacing inconsistent | Use spacing constants from `ResponsiveConstants` |

---

## 🚀 QUICK MIGRATION EXAMPLES

### Before & After: Simple Screen

**BEFORE** (Not Responsive):
```dart
Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(20),
      child: Text('Title',
        style: TextStyle(fontSize: 20)),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        children: [...],
      ),
    ),
  ],
)
```

**AFTER** (Fully Responsive):
```dart
SingleChildScrollView(
  padding: EdgeInsets.all(context.adaptivePaddingHorizontal),
  child: Column(
    children: [
      Text(
        'Title',
        style: context.textThemeSafe.headlineSmall,
      ),
      SizedBox(height: context.adaptivePaddingVertical),
      ResponsiveGridView(
        scrollable: false,
        children: [...],
      ),
    ],
  ),
)
```

**Changes**:
- Hardcoded `20` → `context.adaptivePaddingHorizontal`
- Hardcoded `GridView.count(2)` → `ResponsiveGridView` (auto columns)
- Added `SingleChildScrollView` for safety
- Added `SafeArea` wrapping

---

## 📞 SUPPORT & QUESTIONS

For questions or issues with responsive design:
1. Check the `ResponsiveConstants` class
2. Review `context_extensions.dart` for available helpers
3. Look at refactored `patient_home_screen.dart` for examples
4. Test on multiple screen sizes before committing
