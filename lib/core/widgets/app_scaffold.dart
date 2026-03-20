/// App Scaffold - الواجهة الأساسية الموحدة
/// Main unified wrapper for all role dashboards with AppBar, Drawer, and Ayah footer
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/ayah_widget.dart';
import 'package:mcs/core/widgets/custom_back_button.dart';
import 'package:mcs/core/widgets/language_toggle_button.dart';
import 'package:mcs/core/widgets/notification_button.dart';
import 'package:mcs/core/widgets/profile_button.dart';
import 'package:mcs/core/widgets/theme_toggle_button.dart';

/// Legacy AppScaffold - For backward compatibility with existing code
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.drawer,
    this.appBar,
    this.showBackButton = true,
  });
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.landing);
                      }
                    },
                    color: PremiumColors.darkText,
                  )
                : null,
            title: Text(
              title,
              style: PremiumTextStyles.headingLarge,
            ),
            backgroundColor: PremiumColors.white,
            elevation: 0,
            foregroundColor: PremiumColors.darkText,
            actions: actions,
          ),
      drawer: drawer,
      backgroundColor: PremiumColors.almostWhite,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

/// الواجهة الأساسية الموحدة لجميع الأدوار (نسخة محسنة)
class UnifiedAppScaffold extends StatefulWidget {
  /// محتوى الصفحة الرئيسي
  final Widget body;

  /// عنوان الصفحة
  final String title;

  /// دور المستخدم الحالي
  final String userRole;

  /// بيانات المستخدم
  final AppScaffoldUserData? userData;

  /// عدد الإشعارات
  final int notificationCount;

  /// المظهر الحالي (فاتح/داكن)
  final bool isDarkMode;

  /// اللغة الحالية
  final String currentLanguage;

  /// قائمة عناصر الدرج
  final List<DrawerItem> drawerItems;

  /// رد الاتصال عند تغيير اللغة
  final void Function(String)? onLanguageChange;

  /// رد الاتصال عند تبديل المظهر
  final VoidCallback? onThemeToggle;

  /// رد الاتصال عند الضغط على الإشعارات
  final VoidCallback? onNotificationTap;

  /// رد الاتصال عند تسجيل الخروج
  final VoidCallback? onLogout;

  /// عرض الزر الخلفي
  final bool showBackButton;

  /// رد الاتصال للزر الخلفي
  final VoidCallback? onBackPressed;

  /// زر مخصص في AppBar
  final Widget? customAppBarButton;

  /// محتوى مخصص في الدرج (قبل عناصر القائمة)
  final Widget? customDrawerHeader;

  /// إظهار Ayah في تذييل الدرج
  final bool showAyahInDrawer;

  /// حجم Ayah في الدرج
  final double ayahSize;

  /// لون التركيز (يتم استنتاجه من الدور افتراضياً)
  final Color? accentColor;

  /// إظهار عنصر البحث في AppBar
  final bool showSearchBar;

  /// رد الاتصال للبحث
  final void Function(String)? onSearch;

  const UnifiedAppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.userRole,
    this.userData,
    this.notificationCount = 0,
    this.isDarkMode = false,
    this.currentLanguage = 'ar',
    required this.drawerItems,
    this.onLanguageChange,
    this.onThemeToggle,
    this.onNotificationTap,
    this.onLogout,
    this.showBackButton = false,
    this.onBackPressed,
    this.customAppBarButton,
    this.customDrawerHeader,
    this.showAyahInDrawer = true,
    this.ayahSize = 40,
    this.accentColor,
    this.showSearchBar = false,
    this.onSearch,
  });

  @override
  State<UnifiedAppScaffold> createState() => _UnifiedAppScaffoldState();
}

class _UnifiedAppScaffoldState extends State<UnifiedAppScaffold> {
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final roleColor = CustomIcons.getRoleColor(widget.userRole);
    final accentColor = widget.accentColor ?? roleColor;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context, isArabic, accentColor),
      drawer: _buildDrawer(context, isArabic, accentColor),
      backgroundColor: PremiumColors.almostWhite,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.body,
      ),
    );
  }

  /// بناء AppBar مع جميع الأزرار
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isArabic,
    Color accentColor,
  ) {
    return AppBar(
      elevation: 2,
      backgroundColor: accentColor.withValues(alpha: 0.1),
      leading: widget.showBackButton
          ? CustomBackButton(onPressed: widget.onBackPressed)
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.userRole,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (widget.showSearchBar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildSearchField(context, isArabic),
          ),
        // Notification Button
        NotificationButton(
          badgeCount: widget.notificationCount,
          onTap: widget.onNotificationTap ?? () {},
          color: accentColor,
        ),
        // Theme Toggle Button
        ThemeToggleButton(
          isDarkMode: widget.isDarkMode,
          onToggle: widget.onThemeToggle ?? () {},
          color: accentColor,
        ),
        // Language Toggle Button
        LanguageToggleButton(
          currentLanguage: widget.currentLanguage,
          onToggle: () {
            final newLang = widget.currentLanguage == 'ar' ? 'en' : 'ar';
            widget.onLanguageChange?.call(newLang);
          },
          color: accentColor,
        ),
        // Profile Button
        if (widget.userData != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ProfileButton(
              userName: widget.userData?.name ?? 'User',
              userRole: widget.userRole,
              avatarUrl: widget.userData?.avatarUrl,
              accentColor: accentColor,
              onLogoutTap: widget.onLogout,
            ),
          ),
        // Custom Button
        if (widget.customAppBarButton != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.customAppBarButton!,
          ),
      ],
    );
  }

  /// بناء الدرج مع قائمة الملاحة
  Widget _buildDrawer(
    BuildContext context,
    bool isArabic,
    Color accentColor,
  ) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: 0.2),
                  accentColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: widget.customDrawerHeader ??
                _buildDefaultDrawerHeader(isArabic, accentColor),
          ),
          // Divider
          Divider(height: 1, color: Colors.grey.shade300),
          // Menu Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: widget.drawerItems.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = widget.drawerItems[index];
                return _buildDrawerItem(item, context, isArabic);
              },
            ),
          ),
          // Divider
          Divider(height: 1, color: Colors.grey.shade300),
          // Ayah Footer
          if (widget.showAyahInDrawer)
            Padding(
              padding: const EdgeInsets.all(16),
              child: AyahWidget(
                size: widget.ayahSize,
                animated: true,
                showText: false,
              ),
            ),
        ],
      ),
    );
  }

  /// بناء رأس الدرج الافتراضي
  Widget _buildDefaultDrawerHeader(bool isArabic, Color accentColor) {
    return Column(
      spacing: 12,
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.userData != null) ...[
          CircleAvatar(
            radius: 30,
            backgroundImage: widget.userData?.avatarUrl != null
                ? NetworkImage(widget.userData!.avatarUrl!)
                : null,
            backgroundColor: widget.userData?.avatarUrl == null
                ? accentColor.withValues(alpha: 0.2)
                : null,
            child: widget.userData?.avatarUrl == null
                ? Text(
                    widget.userData?.name.isNotEmpty ?? false
                        ? widget.userData!.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          Text(
            widget.userData?.name ?? 'User',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.userData?.email ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.userRole,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ] else
          Text(
            isArabic ? 'مرحبا بك' : 'Welcome',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  /// بناء عنصر الدرج
  Widget _buildDrawerItem(
    DrawerItem item,
    BuildContext context,
    bool isArabic,
  ) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.label),
      trailing: item.badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: PremiumColors.errorRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        item.onTap?.call();
      },
    );
  }

  /// بناء حقل البحث
  Widget _buildSearchField(BuildContext context, bool isArabic) {
    return SizedBox(
      width: 150,
      height: 40,
      child: TextField(
        onChanged: widget.onSearch,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: isArabic ? 'بحث...' : 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          isDense: true,
          prefixIcon: isArabic ? null : const Icon(Icons.search),
          suffixIcon: isArabic ? const Icon(Icons.search) : null,
        ),
      ),
    );
  }
}

/// بيانات المستخدم
class AppScaffoldUserData {
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;

  AppScaffoldUserData({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
  });
}

/// عنصر الدرج
class DrawerItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final String? badge;
  final bool showDivider;

  DrawerItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.badge,
    this.showDivider = false,
  });
}

/// مساعد لإنشاء عناصر الدرج الشائعة
class DrawerItemBuilder {
  static DrawerItem dashboard(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.dashboard,
        onTap: onTap,
      );

  static DrawerItem appointments(
    String label,
    VoidCallback onTap, {
    String? badge,
  }) =>
      DrawerItem(
        label: label,
        icon: Icons.calendar_today,
        onTap: onTap,
        badge: badge,
      );

  static DrawerItem patients(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.people,
        onTap: onTap,
      );

  static DrawerItem prescriptions(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.local_pharmacy,
        onTap: onTap,
      );

  static DrawerItem reports(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.description,
        onTap: onTap,
      );

  static DrawerItem analytics(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.analytics,
        onTap: onTap,
      );

  static DrawerItem settings(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.settings,
        onTap: onTap,
      );

  static DrawerItem help(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.help_outline,
        onTap: onTap,
      );

  static DrawerItem logout(
    String label,
    VoidCallback onTap,
  ) =>
      DrawerItem(
        label: label,
        icon: Icons.logout,
        onTap: onTap,
      );
}
