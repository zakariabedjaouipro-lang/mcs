/// Premium Appointments Screen with Tab Navigation
/// Displays appointments with tabs for Today, Upcoming, and History using premium design
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumAppointmentsScreen extends StatefulWidget {
  const PremiumAppointmentsScreen({super.key});

  @override
  State<PremiumAppointmentsScreen> createState() =>
      _PremiumAppointmentsScreenState();
}

class _PremiumAppointmentsScreenState extends State<PremiumAppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointmentData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointmentData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'المواعيد' : 'Appointments',
      child: Column(
        children: [
          // Tab bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PremiumColors.mediumGrey,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: PremiumColors.primaryBlue,
              labelColor: PremiumColors.primaryBlue,
              unselectedLabelColor: PremiumColors.lightText,
              indicatorWeight: 3,
              tabs: [
                Tab(text: isArabic ? 'اليوم' : 'Today'),
                Tab(text: isArabic ? 'القادمة' : 'Upcoming'),
                Tab(text: isArabic ? 'السجل' : 'History'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodayTab(),
                _buildUpcomingTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 1: Today's Appointments
  Widget _buildTodayTab() {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    if (_isLoading) {
      return _buildLoadingList();
    }

    final appointments = [
      {
        'patient': isArabic ? 'فاطمة المازروي' : 'Fatima Al-Mazrouei',
        'doctor': isArabic ? 'د. أحمد المانصوري' : 'Dr. Ahmed Al-Mansoori',
        'time': '09:00 AM',
        'type': isArabic ? 'فحص عام' : 'General Checkup',
        'status': isArabic ? 'مؤكد' : 'Confirmed',
        'icon': Icons.calendar_today,
      },
      {
        'patient': isArabic ? 'محمد القاسمي' : 'Mohammed Al-Qasimi',
        'doctor': isArabic ? 'د. ليلى الكعبي' : 'Dr. Layla Al-Kaabi',
        'time': '10:30 AM',
        'type': isArabic ? 'متابعة السكري' : 'Diabetes Follow-up',
        'status': isArabic ? 'جاري' : 'In Progress',
        'icon': Icons.calendar_today,
      },
      {
        'patient': isArabic ? 'عمر الداحري' : 'Amira Al-Dhaheri',
        'doctor': isArabic ? 'د. حسن السويدي' : 'Dr. Hassan Al-Suwaidi',
        'time': '02:00 PM',
        'type': isArabic ? 'ما بعد الجراحة' : 'Post-Operative',
        'status': isArabic ? 'مجدول' : 'Scheduled',
        'icon': Icons.calendar_today,
      },
      {
        'patient': isArabic ? 'ليلى الكعبي' : 'Layla Al-Kaabi',
        'doctor': isArabic ? 'د. راشد المانصوري' : 'Dr. Rashid Al-Mansouri',
        'time': '03:30 PM',
        'type': isArabic ? 'استشارة' : 'Consultation',
        'status': isArabic ? 'في الانتظار' : 'Waiting',
        'icon': Icons.calendar_today,
      },
    ];

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: PremiumColors.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد مواعيد اليوم' : 'No Appointments Today',
              style: PremiumTextStyles.headingSmall.copyWith(
                color: PremiumColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'ليس لديك مواعيد مجدولة اليوم'
                  : 'You have no appointments scheduled for today',
              style: PremiumTextStyles.bodyMedium.copyWith(
                color: PremiumColors.lightText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final statusColor =
            _getStatusColor(appointment['status']! as String, isArabic);

        return AppCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'موعد مع ${appointment['patient']}'
                      : 'Appointment with ${appointment['patient']}',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appointment['icon']! as IconData,
                    color: PremiumColors.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patient']! as String,
                        style: PremiumTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PremiumColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment['doctor']} • ${appointment['type']}',
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['time']! as String,
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status']! as String,
                    style: PremiumTextStyles.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Tab 2: Upcoming Appointments
  Widget _buildUpcomingTab() {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    if (_isLoading) {
      return _buildLoadingList();
    }

    final appointments = [
      {
        'patient': isArabic ? 'حسن المنصوري' : 'Hassan Al-Mansouri',
        'doctor': isArabic ? 'د. فاطمة السويدي' : 'Dr. Fatima Al-Suwaidi',
        'date': isArabic ? 'غداً، 10:00 صباحاً' : 'Tomorrow, 10:00 AM',
        'type': isArabic ? 'فحص ضغط الدم' : 'Blood Pressure Check',
        'status': isArabic ? 'مؤكد' : 'Confirmed',
        'icon': Icons.calendar_month,
      },
      {
        'patient': isArabic ? 'راشد السويدي' : 'Rashid Al-Suwaidi',
        'doctor': isArabic ? 'د. محمد الكعبي' : 'Dr. Mohammed Al-Kaabi',
        'date': isArabic ? '25 يناير، 2:30 مساءً' : 'Jan 25, 2:30 PM',
        'type': isArabic ? 'مراجعة المختبر' : 'Lab Work Review',
        'status': isArabic ? 'مجدول' : 'Scheduled',
        'icon': Icons.calendar_month,
      },
      {
        'patient': isArabic ? 'amina المازروي' : 'Amina Al-Mazrouei',
        'doctor': isArabic ? 'د. سارة المنصوري' : 'Dr. Sara Al-Mansouri',
        'date': isArabic ? '28 يناير، 11:00 صباحاً' : 'Jan 28, 11:00 AM',
        'type': isArabic ? 'فحص روتيني' : 'Regular Checkup',
        'status': isArabic ? 'مؤكد' : 'Confirmed',
        'icon': Icons.calendar_month,
      },
      {
        'patient': isArabic ? 'علي الكعبي' : 'Ali Al-Kaabi',
        'doctor': isArabic ? 'د. أحمد السويدي' : 'Dr. Ahmed Al-Suwaidi',
        'date': isArabic ? '1 فبراير، 3:00 مساءً' : 'Feb 1, 3:00 PM',
        'type': isArabic ? 'استشارة' : 'Consultation',
        'status': isArabic ? 'مجدول' : 'Scheduled',
        'icon': Icons.calendar_month,
      },
      {
        'patient': isArabic ? 'سلمى الداحري' : 'Salma Al-Dhaheri',
        'doctor': isArabic ? 'د. ليلى المنصوري' : 'Dr. Layla Al-Mansouri',
        'date': isArabic ? '5 فبراير، 9:30 صباحاً' : 'Feb 5, 9:30 AM',
        'type': isArabic ? 'زيارة متابعة' : 'Follow-up Visit',
        'status': isArabic ? 'مؤكد' : 'Confirmed',
        'icon': Icons.calendar_month,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final statusColor =
            _getStatusColor(appointment['status']! as String, isArabic);

        return AppCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'موعد مع ${appointment['patient']}'
                      : 'Appointment with ${appointment['patient']}',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: PremiumColors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appointment['icon']! as IconData,
                    color: PremiumColors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patient']! as String,
                        style: PremiumTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PremiumColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment['doctor']} • ${appointment['type']}',
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['date']! as String,
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status']! as String,
                    style: PremiumTextStyles.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Tab 3: Appointment History
  Widget _buildHistoryTab() {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    if (_isLoading) {
      return _buildLoadingList();
    }

    final appointments = [
      {
        'patient': isArabic ? 'نور القاسمي' : 'Noor Al-Qasimi',
        'doctor': isArabic ? 'د. أحمد المانصوري' : 'Dr. Ahmed Al-Mansoori',
        'date': isArabic ? '10 يناير 2024' : 'Jan 10, 2024',
        'type': isArabic ? 'فحص عام' : 'General Checkup',
        'status': isArabic ? 'مكتمل' : 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': isArabic ? 'زينب الكعبي' : 'Zainab Al-Kaabi',
        'doctor': isArabic ? 'د. فاطمة السويدي' : 'Dr. Fatima Al-Suwaidi',
        'date': isArabic ? '5 يناير 2024' : 'Jan 5, 2024',
        'type': isArabic ? 'مراجعة السكري' : 'Diabetes Review',
        'status': isArabic ? 'مكتمل' : 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': isArabic ? 'عمر المنصوري' : 'Omar Al-Mansouri',
        'doctor': isArabic ? 'د. حسن الداحري' : 'Dr. Hassan Al-Dhaheri',
        'date': isArabic ? '28 ديسمبر 2023' : 'Dec 28, 2023',
        'type': isArabic ? 'فحص ما بعد الجراحة' : 'Post-Op Checkup',
        'status': isArabic ? 'مكتمل' : 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': isArabic ? 'هند السويدي' : 'Hind Al-Suwaidi',
        'doctor': isArabic ? 'د. محمد الكعبي' : 'Dr. Mohammed Al-Kaabi',
        'date': isArabic ? '20 ديسمبر 2023' : 'Dec 20, 2023',
        'type': isArabic ? 'استشارة' : 'Consultation',
        'status': isArabic ? 'مكتمل' : 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': isArabic ? 'كريم المازروي' : 'Karim Al-Mazrouei',
        'doctor': isArabic ? 'د. سارة المنصوري' : 'Dr. Sara Al-Mansouri',
        'date': isArabic ? '15 ديسمبر 2023' : 'Dec 15, 2023',
        'type': isArabic ? 'متابعة المختبر' : 'Laboratory Follow-up',
        'status': isArabic ? 'مكتمل' : 'Completed',
        'icon': Icons.history,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final statusColor =
            _getStatusColor(appointment['status']! as String, isArabic);

        return AppCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'موعد مع ${appointment['patient']}'
                      : 'Appointment with ${appointment['patient']}',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: PremiumColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appointment['icon']! as IconData,
                    color: PremiumColors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patient']! as String,
                        style: PremiumTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PremiumColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment['doctor']} • ${appointment['type']}',
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['date']! as String,
                        style: PremiumTextStyles.bodySmall.copyWith(
                          color: PremiumColors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status']! as String,
                    style: PremiumTextStyles.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return AppCard(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: PremiumColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    PremiumColors.lightGrey,
                    PremiumColors.mediumGrey,
                    PremiumColors.lightGrey,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status, bool isArabic) {
    switch (isArabic ? _getEnglishStatus(status) : status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return PremiumColors.successGreen;
      case 'scheduled':
      case 'upcoming':
        return PremiumColors.primaryBlue;
      case 'in progress':
      case 'waiting':
        return PremiumColors.orange;
      case 'cancelled':
        return PremiumColors.errorRed;
      default:
        return PremiumColors.mediumGrey;
    }
  }

  String _getEnglishStatus(String arabicStatus) {
    final statusMap = {
      'مؤكد': 'confirmed',
      'مكتمل': 'completed',
      'مجدول': 'scheduled',
      'القادمة': 'upcoming',
      'جاري': 'in progress',
      'في الانتظار': 'waiting',
      'ملغى': 'cancelled',
    };
    return statusMap[arabicStatus] ?? 'unknown';
  }
}
