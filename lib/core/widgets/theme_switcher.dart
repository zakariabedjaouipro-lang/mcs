/// Theme switcher widget for changing app theme.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/localization/app_localizations.dart';

/// Theme mode enum.
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Theme switcher button widget.
class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeMode = Theme.of(context).brightness == Brightness.dark
        ? AppThemeMode.dark
        : AppThemeMode.light;

    IconData iconData;
    switch (themeMode) {
      case AppThemeMode.light:
        iconData = Icons.light_mode_outlined;
      case AppThemeMode.dark:
        iconData = Icons.dark_mode_outlined;
      case AppThemeMode.system:
        iconData = Icons.brightness_auto_outlined;
    }

    return IconButton(
      icon: Icon(iconData),
      tooltip: localizations.lightTheme,
      onPressed: () => _showThemeDialog(context, localizations),
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations localizations) {
    final currentBrightness = Theme.of(context).brightness;
    final currentMode = currentBrightness == Brightness.dark
        ? AppThemeMode.dark
        : AppThemeMode.light;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.lightTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              AppThemeMode.light,
              Icons.light_mode_outlined,
              localizations.lightTheme,
              currentMode,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              AppThemeMode.dark,
              Icons.dark_mode_outlined,
              localizations.darkTheme,
              currentMode,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              AppThemeMode.system,
              Icons.brightness_auto_outlined,
              'System',
              currentMode,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeMode mode,
    IconData icon,
    String label,
    AppThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        if (context.canPop()) {
          context.pop();
        }
        _changeTheme(context, mode);
      },
      selected: isSelected,
    );
  }

  void _changeTheme(BuildContext context, AppThemeMode mode) {
    // This would typically be handled by a BLoC or state management
    // For now, we'll show a dialog indicating the change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mode == AppThemeMode.dark
              ? 'تم تفعيل الوضع الداكن'
              : 'تم تفعيل الوضع الفاتح',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Simple theme switcher for use in settings pages.
class ThemeSwitcherSimple extends StatelessWidget {
  const ThemeSwitcherSimple({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: ListTile(
        leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
        title: Text(localizations.lightTheme),
        subtitle: Text(
          isDark ? localizations.darkTheme : localizations.lightTheme,
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) {
            _changeTheme(context, value, localizations);
          },
        ),
      ),
    );
  }

  void _changeTheme(
    BuildContext context,
    bool isDark,
    AppLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDark ? 'تم تفعيل الوضع الداكن' : 'تم تفعيل الوضع الفاتح',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Theme selector dropdown for forms.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    this.selectedTheme,
    this.onChanged,
    this.label,
    this.hint,
  });
  final AppThemeMode? selectedTheme;
  final ValueChanged<AppThemeMode?>? onChanged;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DropdownButtonFormField<AppThemeMode>(
      initialValue: selectedTheme,
      decoration: InputDecoration(
        labelText: label ?? localizations.lightTheme,
        hintText: hint ?? localizations.lightTheme,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.palette),
      ),
      items: const [
        DropdownMenuItem(
          value: AppThemeMode.light,
          child: Row(
            children: [
              Icon(Icons.light_mode_outlined),
              SizedBox(width: 12),
              Text('Light'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: AppThemeMode.dark,
          child: Row(
            children: [
              Icon(Icons.dark_mode_outlined),
              SizedBox(width: 12),
              Text('Dark'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: AppThemeMode.system,
          child: Row(
            children: [
              Icon(Icons.brightness_auto_outlined),
              SizedBox(width: 12),
              Text('System'),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return localizations.requiredField;
        }
        return null;
      },
    );
  }
}

/// Toggle theme button with animation.
class AnimatedThemeSwitcher extends StatefulWidget {
  const AnimatedThemeSwitcher({super.key});

  @override
  State<AnimatedThemeSwitcher> createState() => _AnimatedThemeSwitcherState();
}

class _AnimatedThemeSwitcherState extends State<AnimatedThemeSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Update state when theme changes
    if (_isDark != isDark) {
      _isDark = isDark;
      if (isDark) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    final localizations = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 3.14159,
          child: IconButton(
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
            ),
            tooltip: localizations.lightTheme,
            onPressed: () => _showThemeDialog(context, localizations),
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations localizations) {
    final currentBrightness = Theme.of(context).brightness;
    final currentMode = currentBrightness == Brightness.dark
        ? AppThemeMode.dark
        : AppThemeMode.light;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.lightTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              AppThemeMode.light,
              Icons.light_mode_outlined,
              localizations.lightTheme,
              currentMode,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              AppThemeMode.dark,
              Icons.dark_mode_outlined,
              localizations.darkTheme,
              currentMode,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              AppThemeMode.system,
              Icons.brightness_auto_outlined,
              'System',
              currentMode,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeMode mode,
    IconData icon,
    String label,
    AppThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        _changeTheme(context, mode);
      },
      selected: isSelected,
    );
  }

  void _changeTheme(BuildContext context, AppThemeMode mode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mode == AppThemeMode.dark
              ? 'تم تفعيل الوضع الداكن'
              : 'تم تفعيل الوضع الفاتح',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
