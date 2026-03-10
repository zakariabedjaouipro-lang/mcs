# 📱 RESPONSIVE DESIGN QUICK REFERENCE CARD

## At a Glance

### Import These in Every Screen
```dart
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/widgets/responsive_*.dart';
import 'package:mcs/core/constants/responsive_constants.dart';
```

### Use These Instead of Hardcoded Values

| Use This | Instead Of | Example |
|----------|-----------|---------|
| `context.adaptivePaddingHorizontal` | `20` | `padding: EdgeInsets.symmetric(horizontal: context.adaptivePaddingHorizontal)` |
| `context.adaptiveCardPadding` | `16` | `ResponsiveCard(child: ...)` |
| `context.adaptivePaddingVertical` | `20` | `SizedBox(height: context.adaptivePaddingVertical)` |
| `context.adaptiveGridSpacing` | `16` | Grid item spacing |
| `context.gridColumnsCount` | Fixed `2` | Automatic 2/3/4 columns |
| `context.isSmall` | Check width < 600 | `if (context.isSmall) {...}` |
| `context.isMedium` | Check width 600-1024 | `if (context.isMedium) {...}` |
| `context.isLarge` | Check width >= 1024 | `if (context.isLarge) {...}` |

---

## Screen Layout Template

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      // 👇 Always wrap body in SafeArea
      body: SafeArea(
        // 👇 Wrap in SingleChildScrollView for safety
        child: SingleChildScrollView(
          // 👇 Use adaptive padding
          padding: EdgeInsets.all(context.adaptivePaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your widgets here
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Common Patterns (Copy & Paste)

### 1. Responsive Grid
```dart
ResponsiveGridView(
  children: [
    _buildItem(0),
    _buildItem(1),
    _buildItem(2),
  ],
)
```

### 2. Responsive Card
```dart
ResponsiveCard(
  onTap: () => navigate(),
  child: Text('Content'),
)
```

### 3. Responsive Button
```dart
ResponsiveButton(
  label: 'Click',
  onPressed: () {},
)
```

### 4. Responsive Text Field
```dart
ResponsiveTextField(
  label: 'Email',
  hintText: 'user@example.com',
)
```

### 5. Spacing
```dart
SizedBox(height: context.adaptivePaddingVertical),
```

### 6. Conditional Layout
```dart
if (context.isSmall) {
  _buildMobileLayout()
} else {
  _buildDesktopLayout()
}
```

### 7. Text in Row (Always Use Flexible!)
```dart
Row(
  children: [
    Icon(Icons.star),
    SizedBox(width: 8),
    Flexible(
      child: Text('Long text', overflow: TextOverflow.ellipsis),
    ),
  ],
)
```

### 8. Safe Padding (With Insets)
```dart
padding: context.safePaddingAll,
```

### 9. Grid with Headers
```dart
ResponsiveGridSection(
  title: 'Section Title',
  children: [...],
)
```

### 10. Lazy-Loading Grid
```dart
ResponsiveGridViewBuilder(
  itemCount: 100,
  itemBuilder: (context, index) => _buildItem(index),
)
```

---

## Sizing Standards

### Always Use These Constants
```dart
ResponsiveConstants.buttonHeight = 48  // All buttons
ResponsiveConstants.buttonHeightSmall = 40
ResponsiveConstants.buttonHeightLarge = 56
ResponsiveConstants.inputHeight = 48
ResponsiveConstants.iconSize = 24
ResponsiveConstants.minTouchSize = 48  // 48x48 minimum
```

### Adaptive Values by Device
```
Mobile (< 600px):
  Padding:  12px
  Grid:     2 columns
  Spacing:  12px

Tablet (600-1024px):
  Padding:  16px
  Grid:     3 columns
  Spacing:  16px

Desktop (>= 1024px):
  Padding:  20px
  Grid:     4 columns
  Spacing:  20px
```

---

## Checklist Before Commit

- [ ] No hardcoded numbers like `20`, `16`, `12`
- [ ] Uses `context.adaptive*` or `ResponsiveConstants.*`
- [ ] Grid uses `ResponsiveGridView` not `GridView.count`
- [ ] Buttons use `ResponsiveButton` not `ElevatedButton`
- [ ] Cards use `ResponsiveCard` not `Card`
- [ ] Text in Row wrapped with `Flexible`
- [ ] Uses `SafeArea` around body
- [ ] Uses `SingleChildScrollView` for scrollable content
- [ ] Padding uses `EdgeInsets.symmetric()` or helper
- [ ] No fixed heights/widths except for icons/avatars
- [ ] Tested on mobile, tablet, desktop

---

## Fix Common Issues

| Problem | Solution |
|---------|----------|
| Text overflow | Wrap with `Flexible` + `overflow: TextOverflow.ellipsis` |
| UI too cramped | Replace `20` with `context.adaptivePaddingHorizontal` |
| Grid wrong columns | Replace `GridView.count(2)` with `ResponsiveGridView` |
| Button wrong size | Replace `ElevatedButton` with `ResponsiveButton` |
| Card wrong padding | Replace `Card` with `ResponsiveCard` |
| Supabase URI error | Run: `flutter run --dart-define-from-file=.env` |
| Layout looks wrong | Add `SafeArea` + `SingleChildScrollView` |
| Column too tall | Wrap in `SingleChildScrollView` |

---

## File Locations

| Component | File |
|-----------|------|
| Responsive Button | `lib/core/widgets/responsive_button.dart` |
| Responsive Card | `lib/core/widgets/responsive_card.dart` |
| Responsive Grid | `lib/core/widgets/responsive_grid_view.dart` |
| Responsive TextField | `lib/core/widgets/responsive_text_field.dart` |
| Responsive Layout | `lib/core/widgets/responsive_layout.dart` |
| Constants | `lib/core/constants/responsive_constants.dart` |
| Helpers | `lib/core/extensions/context_extensions.dart` |
| Example | `lib/features/patient/presentation/screens/patient_home_screen.dart` |

---

## Helper Properties Quick List

```dart
// Spacing
context.adaptivePaddingHorizontal  // 12/16/20
context.adaptivePaddingVertical    // 12/16/20
context.adaptiveCardPadding        // 12/16/20
context.adaptiveGridSpacing        // 12/16/20
context.adaptiveHPadding           // EdgeInsets (h only)
context.adaptiveVPadding           // EdgeInsets (v only)
context.adaptiveAllPadding         // EdgeInsets (all)
context.safePaddingAll             // With system insets
context.safePaddingTop             // With system insets (top only)

// Sizing
context.gridColumnsCount           // 2/3/4
context.fontScaleFactor            // 1.0/1.1/1.2
context.constrainedWidth           // Max 1200px

// Detection
context.isSmall                    // < 600
context.isMedium                   // 600-1024
context.isLarge                    // >= 1024
context.screenWidth                // Actual width
context.screenHeight               // Actual height
context.screenSize                 // Size object
```

---

## Before & After Examples

### Example 1: Padding
```dart
// ❌ WRONG
padding: const EdgeInsets.all(20)

// ✅ CORRECT
padding: EdgeInsets.all(context.adaptivePaddingHorizontal)
```

### Example 2: Grid
```dart
// ❌ WRONG
GridView.count(crossAxisCount: 2, children: [...])

// ✅ CORRECT
ResponsiveGridView(children: [...])
```

### Example 3: Card
```dart
// ❌ WRONG
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Content'),
  ),
)

// ✅ CORRECT
ResponsiveCard(child: Text('Content'))
```

### Example 4: spacing
```dart
// ❌ WRONG
SizedBox(height: 20)

// ✅ CORRECT
SizedBox(height: context.adaptivePaddingVertical)
```

### Example 5: Button
```dart
// ❌ WRONG
ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
  ),
  onPressed: () {},
  child: const Text('Click'),
)

// ✅ CORRECT
ResponsiveButton(
  label: 'Click',
  onPressed: () {},
)
```

---

## Device Testing Sizes

| Device | Width | Height | Test |
|--------|-------|--------|------|
| iPhone 12 | 390px | 844px | Small mobile |
| iPhone 14 Pro | 430px | 932px | Large mobile |
| Pixel 6 | 412px | 915px | Android phone |
| iPad Air | 820px | 1180px | Tablet portrait |
| iPad (landscape) | 1180px | 820px | Tablet landscape |
| Desktop | 1920px | 1080px | Desktop |

---

## Key Takeaways

1. **Never hardcode**: 20, 16, 12, 2, etc.
2. **Always check**: Use responsive helpers
3. **Patterns matter**: Follow the 9 patterns
4. **Test everywhere**: Mobile, tablet, desktop
5. **Consistency is key**: Use same components
6. **Future-proof**: Changes in one place
7. **Professional**: Looks good on all devices

---

## Quick Links

- Full Patterns: `RESPONSIVE_IMPLEMENTATION_PATTERNS.md`
- Detailed Analysis: `RESPONSIVE_DESIGN_REFACTOR_ANALYSIS.md`
- Delivery Summary: `RESPONSIVE_REFACTOR_DELIVERY.md`
- Example Screen: `lib/features/patient/presentation/screens/patient_home_screen.dart`

---

## Remember

✅ **Mobile First** - Design for 320px, scale up  
✅ **Touch Friendly** - 48×48 minimum  
✅ **Consistent** - Use components, not manual layouts  
✅ **Testable** - Works on all screen sizes  
✅ **Maintainable** - Changes in one place affect everywhere  

**Happy Refactoring! 🚀**
