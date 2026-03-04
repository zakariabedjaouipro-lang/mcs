import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// قسم الأسئلة الشائعة - قابل لإعادة الاستخدام مع البحث والتصنيف
class FaqSectionWidget extends StatefulWidget {
  const FaqSectionWidget({
    super.key,
    this.primaryColor,
    this.categories,
  });
  final Color? primaryColor;
  final List<FaqCategory>? categories;

  @override
  State<FaqSectionWidget> createState() => _FaqSectionWidgetState();
}

/// فئة الأسئلة الشائعة
class FaqCategory {
  FaqCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
  final String title;
  final String icon;
  final List<FaqItem> items;
}

/// عنصر سؤال وجواب
class FaqItem {
  FaqItem({
    required this.question,
    required this.answer,
  });
  final String question;
  final String answer;
}

class _FaqSectionWidgetState extends State<FaqSectionWidget> {
  late List<FaqCategory> _categories;
  late List<FaqCategory> _filteredCategories;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories ?? _getDefaultCategories();
    _filteredCategories = List.from(_categories);
  }

  List<FaqCategory> _getDefaultCategories() {
    return [
      FaqCategory(
        title: 'الحساب والتسجيل',
        icon: '👤',
        items: [
          FaqItem(
            question: 'كيف أنشئ حساباً جديداً؟',
            answer:
                'يمكنك إنشاء حساب جديد بالنقر على "إنشاء حساب" وملء بيانات الهاتف وكلمة المرور والبريد الإلكتروني. سيتم إرسال رمز تحقق لتأكيد هويتك.',
          ),
          FaqItem(
            question: 'هل يمكنني تغيير بريدي الإلكتروني؟',
            answer:
                'نعم، يمكنك تغيير بريدك الإلكتروني من إعدادات الحساب. سيتم إرسال رابط تأكيد إلى البريد الجديد.',
          ),
          FaqItem(
            question: 'كيف أستعيد كلمة مرور منسية؟',
            answer:
                'انقر على "نسيت كلمة المرور" في صفحة تسجيل الدخول وأدخل بريدك الإلكتروني. ستتلقى رابط لإعادة تعيين كلمة المرور.',
          ),
          FaqItem(
            question: 'هل يمكن حذف حسابي؟',
            answer:
                'نعم، يمكنك حذف حسابك من إعدادات الحساب. لاحظ أن جميع بيانات الحساب ستُحذف نهائياً.',
          ),
        ],
      ),
      FaqCategory(
        title: 'الحجز والمواعيد',
        icon: '📅',
        items: [
          FaqItem(
            question: 'كيف أحجز موعداً مع الطبيب؟',
            answer:
                'اذهب لقسم "المواعيد" واختر التخصص والطبيب والتاريخ والوقت المناسب. ثم قام بتأكيد الحجز والدفع.',
          ),
          FaqItem(
            question: 'هل يمكن إلغاء أو تعديل الموعد؟',
            answer:
                'نعم، يمكنك إلغاء أو تعديل الموعد قبل 24 ساعة من الموعد المحدد من صفحة "مواعيدي".',
          ),
          FaqItem(
            question: 'ما رسوم الإلغاء؟',
            answer:
                'إذا قمت بالإلغاء قبل 24 ساعة فلا رسم إلغاء. إذا أُلغي بعد ذلك سيتم خصم رسم إلغاء بنسبة 50%.',
          ),
          FaqItem(
            question: 'هل هناك موعد احتياطي؟',
            answer:
                'نعم، إذا لم تتمكن من الحضور يمكنك اختيار موعد بديل من نفس صفحة الحجز.',
          ),
        ],
      ),
      FaqCategory(
        title: 'الدفع والفواتير',
        icon: '💳',
        items: [
          FaqItem(
            question: 'ما طرق الدفع المتاحة؟',
            answer:
                'نقبل بطاقات الائتمان والحوالات البنكية والمحافظ الرقمية وovez العملات الرقمية.',
          ),
          FaqItem(
            question: 'هل يوجد رسوم معالجة الدفع؟',
            answer: 'لا توجد رسوم إضافية. السعر المعروض هو السعر النهائي.',
          ),
          FaqItem(
            question: 'كيف أطلب فاتورة؟',
            answer:
                'يمكنك تحميل الفاتورة مباشرة من صفحة "الفواتير" وطباعتها أو إرسالها عبر البريد.',
          ),
          FaqItem(
            question: 'هل الدفع آمن؟',
            answer:
                'نعم، جميع عمليات الدفع محمية برموز تشفير SSL ومعايير أمان دولية.',
          ),
        ],
      ),
      FaqCategory(
        title: 'الاستشارات الطبية',
        icon: '🏥',
        items: [
          FaqItem(
            question: 'كيف أرسل استفسار طبي؟',
            answer:
                'اذهب لقسم "الاستشارات" واختر التخصص ثم اكتب استفسارك. سيرد عليك طبيب متخصص خلال 24 ساعة.',
          ),
          FaqItem(
            question: 'هل يمكنني طلب استشارة فيديو؟',
            answer:
                'نعم، يمكنك حجز استشارة فيديو مباشرة مع الطبيب. ستتلقى رابط الفيديو قبل الموعد بـ 15 دقيقة.',
          ),
          FaqItem(
            question: 'كم مدة الاستشارة؟',
            answer: 'تختلف مدة الاستشارة حسب التخصص، عادة بين 15-30 دقيقة.',
          ),
          FaqItem(
            question: 'هل معلوماتي الطبية آمنة؟',
            answer:
                'نعم، جميع المعلومات الطبية مشفرة وتحت حماية قوانين الخصوصية الدولية.',
          ),
        ],
      ),
      FaqCategory(
        title: 'الملف الصحي',
        icon: '📋',
        items: [
          FaqItem(
            question: 'ما المعلومات المطلوبة في الملف الصحي؟',
            answer:
                'معلومات شخصية، التاريخ الطبي، الأدوية الحالية، الحساسيات، والحالات المزمنة.',
          ),
          FaqItem(
            question: 'هل يمكن تحميل الأشعات والتحاليل؟',
            answer:
                'نعم، يمكنك تحميل جميع الفحوصات والأشعات والتحاليل في قسم "الملفات الطبية".',
          ),
          FaqItem(
            question: 'هل الأطباء يرون ملفي الصحي؟',
            answer:
                'نعم، الأطباء المختصون يمكنهم رؤية ملفك الصحي لتقديم استشارة أفضل.',
          ),
          FaqItem(
            question: 'هل يمكن تصدير ملفي الصحي؟',
            answer:
                'نعم، يمكنك تصدير ملفك الصحي بصيغة PDF من إعدادات الملف الصحي.',
          ),
        ],
      ),
    ];
  }

  void _filterFaq(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();

      if (query.isEmpty) {
        _filteredCategories = List.from(_categories);
      } else {
        _filteredCategories = _categories
            .map(
              (category) => FaqCategory(
                title: category.title,
                icon: category.icon,
                items: category.items
                    .where(
                      (item) =>
                          item.question.toLowerCase().contains(lowerQuery) ||
                          item.answer.toLowerCase().contains(lowerQuery),
                    )
                    .toList(),
              ),
            )
            .where((category) => category.items.isNotEmpty)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن أسئلتك...',
              prefixIcon: Icon(Icons.search, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _filterFaq,
          ),
          const SizedBox(height: 32),

          // Categories and FAQ Items
          if (_filteredCategories.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.search_off,
                        size: 48, color: AppColors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'لم نجد نتائج',
                      style: TextStyles.subtitle1.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: List.generate(
                _filteredCategories.length,
                (categoryIndex) => _buildCategorySection(
                  _filteredCategories[categoryIndex],
                  primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(FaqCategory category, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Row(
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Text(
                category.title,
                style: TextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // FAQ Items
          Column(
            children: List.generate(
              category.items.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFaqItem(category.items[index], primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(FaqItem item, Color primaryColor) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: TextStyles.subtitle1.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      collapsedBackgroundColor: primaryColor.withValues(alpha: 0.05),
      backgroundColor: primaryColor.withValues(alpha: 0.05),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      iconColor: primaryColor,
      collapsedIconColor: primaryColor,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            item.answer,
            style: TextStyles.body2.copyWith(
              color: AppColors.greyDark,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
