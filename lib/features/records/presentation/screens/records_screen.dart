/// Premium Records/Documents Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_button.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'السجلات الطبية' : 'Records & Documents',
      child: _hasError
          ? _buildErrorState(isArabic)
          : _isLoading
              ? _buildLoadingGrid()
              : _buildPremiumRecordsGrid(isArabic),
    );
  }

  Widget _buildErrorState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: PremiumColors.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? 'تعذر جلب السجلات الطبية'
                : 'Unable to fetch medical records',
            style: PremiumTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: isArabic ? 'إعادة المحاولة' : 'Retry',
            variant: AppButtonVariant.secondary,
            onPressed: _loadRecords,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return GridView.count(
      crossAxisCount: isMobile ? 1 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(4, (index) => _buildSkeletonCard()),
    );
  }

  Widget _buildPremiumRecordsGrid(bool isArabic) {
    final records = [
      {
        'title': isArabic ? 'تحاليل الدم' : 'Blood Tests',
        'icon': Icons.assignment,
        'color': PremiumColors.primaryBlue,
        'count': '5',
      },
      {
        'title': isArabic ? 'الأشعة' : 'X-Rays',
        'icon': Icons.image,
        'color': PremiumColors.accentCyan,
        'count': '3',
      },
      {
        'title': isArabic ? 'الوصفات' : 'Prescriptions',
        'icon': Icons.medical_services,
        'color': PremiumColors.successGreen,
        'count': '8',
      },
      {
        'title': isArabic ? 'تقارير أخرى' : 'Other Reports',
        'icon': Icons.folder,
        'color': PremiumColors.warningOrange,
        'count': '2',
      },
    ];

    final isMobile = MediaQuery.of(context).size.width < 600;

    return GridView.count(
      crossAxisCount: isMobile ? 1 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: records.map((record) {
        final color = record['color']! as Color;
        final icon = record['icon']! as IconData;
        final title = record['title']! as String;
        final count = record['count']! as String;

        return AppCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic ? 'جاري فتح $title' : 'Opening $title',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: PremiumTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic ? 'عدد الملفات: $count' : 'Files: $count',
                  style: PremiumTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: isArabic ? 'عرض' : 'View',
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkeletonCard() {
    return AppCard(
      child: Container(
        height: 200,
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
  }
}
