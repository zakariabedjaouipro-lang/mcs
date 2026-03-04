import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// شهادات المستخدمين - عرض آراء المستخدمين مع تقييمات وصور
class TestimonialsWidget extends StatefulWidget {
  const TestimonialsWidget({
    super.key, // ✅ تم الإصلاح: استخدام super parameter
    this.primaryColor,
    this.testimonials,
  });

  final Color? primaryColor;
  final List<Testimonial>? testimonials;

  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

/// فئة تمثل شهادة مستخدم
class Testimonial {
  // 'patient', 'doctor', 'staff'

  Testimonial({
    required this.name,
    required this.title,
    required this.comment,
    required this.rating,
    required this.type,
    this.imageUrl,
  });
  final String name;
  final String title;
  final String comment;
  final int rating;
  final String? imageUrl;
  final String type;
}

class _TestimonialsWidgetState extends State<TestimonialsWidget>
    with TickerProviderStateMixin {
  late List<Testimonial> _testimonials;
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _testimonials = widget.testimonials ?? _getDefaultTestimonials();
    _pageController = PageController(viewportFraction: 0.9);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    // Auto-scroll every 5 seconds
    Future.delayed(const Duration(seconds: 5), _autoScroll);
  }

  List<Testimonial> _getDefaultTestimonials() {
    return [
      Testimonial(
        name: 'د. محمد أحمد',
        title: 'طبيب أسنان',
        comment:
            'نظام MCS غيّر طريقة إدارتي للعيادة بشكل جذري. الآن يمكنني التركيز على علاج المرضى وليس الأوراق!',
        rating: 5,
        type: 'doctor',
      ),
      Testimonial(
        name: 'فاطمة الحمادي',
        title: 'مريضة',
        comment:
            'تطبيق رائع جداً! حجزت موعدي أونلاين وقوبلت بخدمة احترافية. سأوصي به لكل أصدقائي.',
        rating: 5,
        type: 'patient',
      ),
      Testimonial(
        name: 'علي محمود',
        title: 'موظف إداري',
        comment:
            'سهولة الاستخدام والتقارير التفصيلية جعلت عملي أكثر كفاءة. نظام حقاً يستحق الثناء.',
        rating: 5,
        type: 'staff',
      ),
      Testimonial(
        name: 'د. سارة القحطاني',
        title: 'طبيبة عامة',
        comment:
            'إمكانيات الاستشارة عن بعد رائعة جداً. استطعت خدمة عدد أكبر من المرضى بكفاءة أعلى.',
        rating: 4,
        type: 'doctor',
      ),
      Testimonial(
        name: 'خديجة علي',
        title: 'مريضة',
        comment:
            'تطبيق احترافي وآمن جداً. أشعر براحة تامة عند تخزين بيانات صحتي فيه.',
        rating: 5,
        type: 'patient',
      ),
      Testimonial(
        name: 'أحمد الشمري',
        title: 'مدير عيادة',
        comment:
            'أفضل استثمار قمت به للعيادة. حسّن من جودة الخدمة وقلل التكاليف الإدارية.',
        rating: 5,
        type: 'staff',
      ),
    ];
  }

  void _autoScroll() {
    if (mounted) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
      Future.delayed(const Duration(seconds: 5), _autoScroll);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? AppColors.primary;
    final size = MediaQuery.of(context).size.width;

    // ✅ تم الإصلاح: استخدام int محسوب بشكل صحيح
    final itemCount = _testimonials.length;

    // ✅ تم الإصلاح: حساب ارتفاع البطاقة بناءً على حجم الشاشة
    final cardHeight = size < 768 ? 380.0 : 320.0;

    return Column(
      children: [
        // Header
        Text(
          'شهادات المستخدمين',
          style: TextStyles.heading2.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'استمع إلى ما يقوله مستخدمونا',
          style: TextStyles.body1.copyWith(
            color: AppColors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        // Testimonials Carousel
        ScaleTransition(
          scale: _slideAnimation,
          child: SizedBox(
            height: cardHeight, // ✅ تم الإصلاح: استخدام double
            child: PageView.builder(
              controller: _pageController,
              itemCount: itemCount, // ✅ تم الإصلاح: استخدام int
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _animationController
                  ..reset()
                  ..forward();
              },
              itemBuilder: (context, index) {
                final testimonial = _testimonials[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    var value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                    }
                    return Transform.scale(
                      scale: value,
                      child: _buildTestimonialCard(
                        testimonial,
                        primaryColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Indicators
        _buildIndicators(
            primaryColor,
            itemCount,
          ), // ✅ تم الإصلاح: تمرير itemCount
      ],
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote Icon
              Icon(
                Icons.format_quote,
                color: primaryColor.withValues(alpha: 0.3),
                size: 40,
              ),
              const SizedBox(height: 12),

              // Comment
              Expanded(
                child: Text(
                  testimonial.comment,
                  style: TextStyles.body1.copyWith(
                    height: 1.6,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Rating
              Row(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      index < testimonial.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Author Info
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        testimonial.name[0],
                        style: TextStyles.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Name & Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testimonial.name,
                          style: TextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor(testimonial.type)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getTypeLabel(testimonial.type),
                                style: TextStyles.caption.copyWith(
                                  color: _getTypeColor(testimonial.type),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              testimonial.title,
                              style: TextStyles.caption.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators(Color primaryColor, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: _currentIndex == index ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == index
                    ? primaryColor
                    : primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'doctor':
        return const Color(0xFF3B82F6); // Blue
      case 'patient':
        return const Color(0xFF10B981); // Green
      case 'staff':
        return const Color(0xFFF59E0B); // Amber
      default:
        return AppColors.primary;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'doctor':
        return 'طبيب';
      case 'patient':
        return 'مريض';
      case 'staff':
        return 'موظف';
      default:
        return 'مستخدم';
    }
  }
}
