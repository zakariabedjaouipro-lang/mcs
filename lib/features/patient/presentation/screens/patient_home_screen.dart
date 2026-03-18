import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/constants/responsive_constants.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/widgets/responsive_card.dart';
import 'package:mcs/core/widgets/responsive_grid_view.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// 🏥 شاشة البيت الرئيسية للمريض
///
/// المميزات:
/// - ترحيب شخصي بالمريض
/// - إجراءات سريعة
/// - شريط تقدم إكمال البيانات
/// - آخر التقاريرالطبية
/// - دعم RTL/LTR
/// - تأثيرات حركية سلسة
class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({this.isPremium = false, super.key});

  final bool isPremium;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.adaptivePaddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Welcome Card
                      _welcomeCard(context),
                      SizedBox(height: context.adaptivePaddingVertical * 1.5),

                      /// Profile Completion Progress
                      _profileCompletionCard(context),
                      SizedBox(height: context.adaptivePaddingVertical * 1.5),

                      /// Quick Actions Section
                      _quickActionsSection(context),
                      SizedBox(height: context.adaptivePaddingVertical * 1.5),

                      /// Appointments Card
                      _sectionCard(
                        context,
                        icon: Icons.calendar_month_outlined,
                        title: context.translateSafe('appointments'),
                        subtitle: context.translateSafe(
                          'no_upcoming_appointments',
                        ),
                        color: Colors.blue,
                        onTap: () {
                          context
                              .read<PatientBloc>()
                              .add(NavigateToAppointments());
                        },
                      ),
                      SizedBox(height: context.adaptivePaddingVertical),

                      /// Prescriptions Card
                      _sectionCard(
                        context,
                        icon: Icons.medication_outlined,
                        title: context.translateSafe('prescriptions'),
                        subtitle: context.translateSafe(
                          'no_active_prescriptions',
                        ),
                        color: Colors.green,
                        onTap: () {
                          context
                              .read<PatientBloc>()
                              .add(NavigateToPrescriptions());
                        },
                      ),
                      SizedBox(height: context.adaptivePaddingVertical),

                      /// Lab Results Card
                      _sectionCard(
                        context,
                        icon: Icons.science_outlined,
                        title: context.translateSafe('lab_results'),
                        subtitle: context.translateSafe('no_lab_results'),
                        color: Colors.purple,
                        onTap: () {
                          context
                              .read<PatientBloc>()
                              .add(NavigateToLabResults());
                        },
                      ),
                      SizedBox(height: context.adaptivePaddingVertical * 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build AppBar with notifications
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(context.translateSafe('home')),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _handleNotifications(context),
              tooltip: context.translateSafe('notifications'),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _handleSettings(context),
          tooltip: context.translateSafe('settings'),
        ),
      ],
    );
  }

  /// Welcome Card with user information
  Widget _welcomeCard(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translateSafe('welcome'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.translateSafe('patient_dashboard'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile Completion Progress Card
  Widget _profileCompletionCard(BuildContext context) {
    final completionPercentage = 0.65; // Example: 65% complete

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إكمال بيانات الملف الشخصي',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${(completionPercentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionPercentage,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.green.shade500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'أكمل بيانات ملفك الشخصي للحصول على تجربة أفضل',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Actions Grid Section
  Widget _quickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe('quick_actions'),
          style: context.textThemeSafe.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.adaptivePaddingVertical),
        ResponsiveGridView(
          scrollable: false,
          childAspectRatio: 1.1,
          padding: EdgeInsets.zero,
          children: [
            _actionCard(
              context,
              icon: Icons.calendar_today_outlined,
              label: context.translateSafe('book_appointment'),
              color: Colors.blue,
              onTap: () {
                context.read<PatientBloc>().add(NavigateToBooking());
              },
            ),
            _actionCard(
              context,
              icon: Icons.video_call_outlined,
              label: context.translateSafe('remote_sessions'),
              color: Colors.purple,
              onTap: () {
                context.read<PatientBloc>().add(NavigateToRemoteSessions());
              },
            ),
            _actionCard(
              context,
              icon: Icons.medication_outlined,
              label: context.translateSafe('prescriptions'),
              color: Colors.green,
              onTap: () {
                context.read<PatientBloc>().add(NavigateToPrescriptions());
              },
            ),
            _actionCard(
              context,
              icon: Icons.science_outlined,
              label: context.translateSafe('lab_results'),
              color: Colors.orange,
              onTap: () {
                context.read<PatientBloc>().add(NavigateToLabResults());
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Action Card for quick access - with animation
  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ResponsiveCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.adaptiveCardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: ResponsiveConstants.iconLarge,
              color: color,
            ),
          ),
          SizedBox(height: context.adaptivePaddingVertical),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textThemeSafe.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Card with icon and navigation
  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ResponsiveCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        vertical: context.adaptivePaddingVertical,
        horizontal: context.adaptivePaddingHorizontal,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: context.adaptivePaddingHorizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textThemeSafe.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.adaptivePaddingVertical / 2),
                Text(
                  subtitle,
                  style: context.textThemeSafe.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  /// Build Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: context.adaptivePaddingVertical / 2),
                Text(
                  context.translateSafe('patient_name'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'patient@email.com',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(context.translateSafe('home')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(context.translateSafe('profile')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(NavigateToProfile());
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_information_outlined),
            title: Text(context.translateSafe('medical_records')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(NavigateToMedicalRecords());
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_outlined),
            title: Text(context.translateSafe('invoices')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(NavigateToInvoices());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.translateSafe('settings')),
            onTap: () {
              Navigator.pop(context);
              _handleSettings(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.translateSafe('logout')),
            onTap: () {
              Navigator.pop(context);
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  // ── Event Handlers ──────────────────────────────────────────

  /// Handles notification icon tap
  void _handleNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(context.translateSafe('no_notifications'))),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handles settings icon tap
  void _handleSettings(BuildContext context) {
    context.read<PatientBloc>().add(NavigateToSettings());
  }

  /// Handles logout action
  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.translateSafe('logout')),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.translateSafe('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<PatientBloc>().add(LogoutRequested());
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}
