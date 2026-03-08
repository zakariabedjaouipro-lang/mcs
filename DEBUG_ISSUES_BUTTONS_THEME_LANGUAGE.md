# 🔴 تقرير المشاكل الحالية - الأزرار والثيم واللغة

**التاريخ:** March 8, 2026  
**المشاكل:** الأزرار المعطلة، الثيم، اللغة، التبويبات  

---

## 🔴 المشاكل المكتشفة

### **1. الأزرار معطلة (Disabled Buttons)**

**الملف:** [lib/features/auth/screens/login_screen.dart](lib/features/auth/screens/login_screen.dart#L83)

**المشكلة:**
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    final isLoading = state is AuthLoading;  // ❌ المشكلة هنا
    
    // الزر معطل عندما isLoading = true
    onPressed: isLoading ? null : () => _handleLogin(context),
  },
)
```

**السبب المحتمل:**
- الحالة `AuthLoading` قد تكون عالقة (stuck)
- أو أن UseCase لا يرسل حالة نجاح/فشل
- أو أن هناك مشكلة في تهيئة BLoC

**الحل المقترح:**
```dart
// يجب إضافة timeout وتحديد الحالة بشكل صريح
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    final isLoading = state is AuthLoading;
    final isError = state is LoginFailure;
    
    return Column(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : () => _handleLogin(context),
          child: isLoading 
            ? const CircularProgressIndicator()
            : const Text('تسجيل الدخول'),
        ),
        if (isError)
          Text(
            (state as LoginFailure).message,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  },
)
```

---

### **2. الثيم معطل (Theme Not Applied)**

**الملف:** [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)

**المشكلة:**
```dart
// ❌ الثيم لا يُعاد حساب عند تغيير الوضع
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  // ❌ لا يوجد themeMode أو لا يُحفظ
)
```

**السبب:**
- لا توجد آلية لتغيير الثيم بشكل ديناميكي
- `ThemeMode` دائماً الافتراضي (system)
- لا توجد BLoC لإدارة تغيير الثيم

**الحل:**
```dart
// إنشاء ThemeBloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter emit) async {
    final newMode = state.themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
    
    // حفظ في التخزين
    await _saveThemeMode(newMode);
    
    emit(ThemeState(themeMode: newMode));
  }
}

// ثم في MaterialApp
BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: state.themeMode,  // ✅ ديناميكي
      routerConfig: AppRouter.router,
    );
  },
)
```

---

### **3. زر تحويل اللغة معطل (Language Toggle)**

**الملف:** ❓ لم أجد زر اللغة!

**المشكلة:**
```dart
// ❌ لا يوجد زر لتحويل اللغة
// ❌ لا توجد آلية لتغيير اللغة بشكل ديناميكي
```

**السبب:**
- لم يتم تنفيذ زر تحويل اللغة
- لا توجد BLoC للـ Localization
- اللغة الحالية محددة بقيمة ثابتة

**الحل:**
```dart
// إنشاء LocalizationBloc
class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState(locale: Locale('ar'))) {
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onChangeLocale(ChangeLocale event, Emitter emit) async {
    await _saveLocale(event.locale);
    emit(LocalizationState(locale: event.locale));
  }
}

// في الواجهة
ListTile(
  title: const Text('اللغة'),
  trailing: DropdownButton<String>(
    value: context.locale.languageCode,
    items: const [
      DropdownMenuItem(value: 'ar', child: Text('العربية')),
      DropdownMenuItem(value: 'en', child: Text('English')),
    ],
    onChanged: (locale) {
      if (locale != null) {
        context.read<LocalizationBloc>().add(ChangeLocale(Locale(locale)));
      }
    },
  ),
)
```

---

### **4. التبويبات لا تفتح (Tabs Not Opening)**

**الملف:** ❓ لم أجد شاشة بها تبويبات!

**المشكلة:**
```dart
// ❌ لا توجد تبويبات working
// أو التبويبات معطلة لأن الصفحات لا تُفتح
```

**السبب المحتمل:**
- مشكلة في `TabController`
- مشكلة في تهيئة `PageView`
- الصفحات لا تُبني بشكل صحيح

**الحل:**
```dart
class TabbedScreen extends StatefulWidget {
  const TabbedScreen({super.key});

  @override
  State<TabbedScreen> createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
          onTap: (index) {
            // ✅ تأكد أن التبويب يتغير
            setState(() {});
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Content 1')),
          Center(child: Text('Content 2')),
          Center(child: Text('Content 3')),
        ],
      ),
    );
  }
}
```

---

## 🔧 الإصلاحات المطلوبة

| المشكلة | الأولوية | الحل |
|--------|----------|------|
| الأزرار معطلة | 🔴 عالية | تحقق من AuthBloc وإضافة آلية timeout |
| الثيم معطل | 🟠 متوسطة | إنشاء ThemeBloc وإضافة toggle |
| اللغة | 🟠 متوسطة | إنشاء LocalizationBloc وزر تحويل |
| التبويبات | 🟠 متوسطة | إصلاح TabController وPageView |

---

## ✅ الخطوات المقترحة

### الخطوة 1: إصلاح الأزرار
1. تحقق من استجابة AuthBloc
2. أضف timeout للعمليات
3. تأكد من أن جميع الحالات تُصدر بشكل صحيح

### الخطوة 2: إضافة ThemeBloc
```powershell
# أنشئ ملفات BLoC جديدة
flutter create --template=bloc lib/features/theme/presentation/bloc/theme_bloc
```

### الخطوة 3: إضافة LocalizationBloc
```powershell
# أنشئ ملفات BLoC جديدة
flutter create --template=bloc lib/features/localization/presentation/bloc/localization_bloc
```

### الخطوة 4: تحديث Material App
```dart
// استخدم multi-BLoC providers
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc(...)),
    BlocProvider(create: (_) => ThemeBloc()),
    BlocProvider(create: (_) => LocalizationBloc()),
  ],
  child: BlocBuilder2<ThemeBloc, LocalizationBloc>(
    // بناء الـ MaterialApp بناءً على الثيم واللغة
  ),
)
```

---

## 📋 ملاحظات مهمة

- ⚠️ **لا تنسى حفظ الإعدادات** في shared_preferences أو flutter_secure_storage
- ⚠️ **اختبر جميع الحالات** - نجاح، فشل، loading، timeout
- ⚠️ **تأكد من التنظيف (cleanup)** من BLoC عند الخروج

---

**الحالة:** 🔴 **بحاجة لإصلاح عاجل**
