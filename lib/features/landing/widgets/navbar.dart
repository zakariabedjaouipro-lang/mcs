import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// شريط التنقل الرئيسي - يحتوي على الروابط والأزرار والتحكم بالإعدادات
class NavbarWidget extends StatefulWidget {
  const NavbarWidget({
    Key? key,
    this.onLogoTap,
    this.onNavigate,
    this.onLoginTap,
    this.onThemeChanged,
    this.onLanguageChanged,
    this.isDarkMode = false,
    this.currentLanguage = 'ar',
  }) : super(key: key);
  final VoidCallback? onLogoTap;
  final Function(String)? onNavigate;
  final VoidCallback? onLoginTap;
  final ValueChanged<bool>? onThemeChanged;
  final ValueChanged<String>? onLanguageChanged;
  final bool isDarkMode;
  final String currentLanguage;

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  late bool _isDarkMode;
  late String _currentLanguage;
  bool _isMenuOpen = false;

  final List<NavItem> _navItems = [
    NavItem(label: 'الرئيسية', route: 'home'),
    NavItem(label: 'المميزات', route: 'features'),
    NavItem(label: 'الأسعار', route: 'pricing'),
    NavItem(label: 'التحميل', route: 'download'),
    NavItem(label: 'الدعم', route: 'support'),
    NavItem(label: 'اتصل بنا', route: 'contact'),
  ];

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _currentLanguage = widget.currentLanguage;
  }

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
    widget.onThemeChanged?.call(value);
  }

  void _toggleLanguage() {
    final newLanguage = _currentLanguage == 'ar' ? 'en' : 'ar';
    setState(() => _currentLanguage = newLanguage);
    widget.onLanguageChanged?.call(newLanguage);
  }

  void _navigate(String route) {
    widget.onNavigate?.call(route);
    setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: isMobile ? _buildMobileNavbar() : _buildDesktopNavbar(),
        ),
      ),
    );
  }

  Widget _buildDesktopNavbar() {
    return Row(
      children: [
        // Logo
        _buildLogo(),
        const SizedBox(width: 40),

        // Navigation Items
        Expanded(
          child: Row(
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(_navItems[index]),
            ),
          ),
        ),

        // Settings & Login
        Row(
          children: [
            // Language Toggle
            _buildIconButton(
              icon: Icons.language,
              tooltip: 'تبديل اللغة',
              onPressed: _toggleLanguage,
            ),
            const SizedBox(width: 8),

            // Theme Toggle
            _buildIconButton(
              icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              tooltip: _isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
              onPressed: () => _toggleTheme(!_isDarkMode),
            ),
            const SizedBox(width: 16),

            // Login Button
            _buildLoginButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileNavbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        _buildLogo(),

        // Hamburger Menu & Settings
        Row(
          children: [
            _buildIconButton(
              icon: Icons.language,
              tooltip: 'تبديل اللغة',
              onPressed: _toggleLanguage,
            ),
            const SizedBox(width: 8),
            _buildIconButton(
              icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              tooltip: _isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
              onPressed: () => _toggleTheme(!_isDarkMode),
            ),
            const SizedBox(width: 8),
            _buildIconButton(
              icon: _isMenuOpen ? Icons.close : Icons.menu,
              tooltip: 'القائمة',
              onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onLogoTap,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'MCS',
                  style: TextStyles.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MCS',
                  style: TextStyles.subtitle2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'إدارة العيادات',
                  style: TextStyles.caption.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigate(item.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            item.label,
            style: TextStyles.subtitle2.copyWith(
              color: _isDarkMode ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: _isDarkMode ? Colors.white70 : Colors.black87,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onLoginTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.login, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'دخول',
                  style: TextStyles.subtitle2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(NavbarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _isDarkMode = widget.isDarkMode;
    }
    if (oldWidget.currentLanguage != widget.currentLanguage) {
      _currentLanguage = widget.currentLanguage;
    }
  }
}

/// عنصر التنقل
class NavItem {
  NavItem({
    required this.label,
    required this.route,
  });
  final String label;
  final String route;
}
