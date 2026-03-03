import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/widgets/responsive_layout.dart';
import 'package:mcs/features/landing/widgets/faq_section.dart';

/// صفحة الدعم الفني - تحتوي على أسئلة شائعة وروابط سريعة ودروس فيديو
class SupportScreenLanding extends StatefulWidget {
  const SupportScreenLanding({Key? key}) : super(key: key);

  @override
  State<SupportScreenLanding> createState() => _SupportScreenLandingState();
}

class _SupportScreenLandingState extends State<SupportScreenLanding> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(),
          SizedBox(height: 60),
          _buildTabsSection(),
          SizedBox(height: 40),
          _buildContentSection(),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'الدعم الفني',
            style: TextStyles.heading1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'احصل على المساعدة والدعم من فريقنا المتخصص',
            style: TextStyles.body1.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('الأسئلة الشائعة', 0),
            SizedBox(width: 12),
            _buildTabButton('دروس فيديو', 1),
            SizedBox(width: 12),
            _buildTabButton('روابط سريعة', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return Material(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyles.subtitle1.copyWith(
              color: isSelected ? AppColors.primary : AppColors.greyDark,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    switch (_selectedTab) {
      case 0:
        return FaqSectionWidget();
      case 1:
        return _buildVideoTutorialsSection();
      case 2:
        return _buildQuickLinksSection();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildVideoTutorialsSection() {
    final videos = [
      {
        'title': 'كيفية استخدام تطبيق المريض',
        'duration': '15:30',
        'category': 'أساسيات',
        'icon': Icons.person,
      },
      {
        'title': 'شرح نظام الحجز والمواعيد',
        'duration': '12:45',
        'category': 'حجز المواعيد',
        'icon': Icons.calendar_today,
      },
      {
        'title': 'كيفية إرسال الوصفات الطبية',
        'duration': '8:20',
        'category': 'الوصفات',
        'icon': Icons.description,
      },
      {
        'title': 'الاستشارة الطبية عن بعد',
        'duration': '18:10',
        'category': 'التطبيب عن بعد',
        'icon': Icons.video_call,
      },
      {
        'title': 'إدارة الملف الصحي',
        'duration': '10:15',
        'category': 'الملفات الصحية',
        'icon': Icons.folder,
      },
      {
        'title': 'الدفع والفواتير',
        'duration': '9:50',
        'category': 'الدفع',
        'icon': Icons.payment,
      },
    ];

    return ResponsiveLayout(
      mobile: _buildVideoGrid(videos, 1),
      tablet: _buildVideoGrid(videos, 2),
      desktop: _buildVideoGrid(videos, 3),
    );
  }

  Widget _buildVideoGrid(List<Map<String, dynamic>> videos, int columns) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return _buildVideoCard(video);
        },
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 50,
                color: AppColors.primary,
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      video['category'] as String,
                      style: TextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(height: 8),
                  Text(
                    video['title'] as String,
                    style: TextStyles.subtitle2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.play_arrow,
                          size: 16, color: AppColors.primary),
                      Text(
                        video['duration'] as String,
                        style:
                            TextStyles.caption.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinksSection() {
    final links = [
      {
        'title': 'التوثيق الكامل',
        'description': 'اطّلع على جميع الميزات والشروحات',
        'icon': Icons.description_outlined,
        'color': Color(0xFF6366F1),
      },
      {
        'title': 'مركز المساعدة',
        'description': 'إجابات سريعة على الأسئلة الشائعة',
        'icon': Icons.help_outline,
        'color': Color(0xFF3B82F6),
      },
      {
        'title': 'المدونة',
        'description': 'نصائح وأفكار حول استخدام التطبيق',
        'icon': Icons.article_outlined,
        'color': Color(0xFF8B5CF6),
      },
      {
        'title': 'المجتمع',
        'description': 'تواصل مع المستخدمين الآخرين',
        'icon': Icons.groups_outlined,
        'color': Color(0xFFEC4899),
      },
      {
        'title': 'تطبيق الجوال',
        'description': 'حمّل التطبيق على هاتفك',
        'icon': Icons.phone_android,
        'color': Color(0xFF10B981),
      },
      {
        'title': 'الإصدارات الجديدة',
        'description': 'اطّلع على أحدث التحديثات',
        'icon': Icons.update,
        'color': Color(0xFFF59E0B),
      },
    ];

    return ResponsiveLayout(
      mobile: _buildLinksGrid(links, 1),
      tablet: _buildLinksGrid(links, 2),
      desktop: _buildLinksGrid(links, 3),
    );
  }

  Widget _buildLinksGrid(List<Map<String, dynamic>> links, int columns) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.1,
        ),
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return _buildLinkCard(link);
        },
      ),
    );
  }

  Widget _buildLinkCard(Map<String, dynamic> link) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border(
                top: BorderSide(
                  color: link['color'] as Color,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  link['icon'] as IconData,
                  color: link['color'] as Color,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  link['description'] as String,
                  style: TextStyles.subtitle1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: link['color'] as Color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  link['description'] as String,
                  style: TextStyles.caption.copyWith(
                    color: AppColors.greyDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
