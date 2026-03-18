/// Patient Application Entry Point
///
/// تطبيق المريض - واجهة المستخدم النهائية لإدارة الصحة والمواعيد
///
/// المميزات:
/// - تجربة سلسة وبسيطة
/// - دعم كامل للعربية والإنجليزية (RTL/LTR)
/// - المظهر الليلي والنهاري
/// - معالجة الأخطاء المحسنة
/// - نظام إشعارات متقدم
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:mcs/features/patient/presentation/bloc/patient_event.dart';
import 'package:mcs/features/patient/presentation/screens/patient_home_screen.dart';

/// تطبيق المريض الرئيسي
class PatientApp extends StatelessWidget {
  const PatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PatientBloc>()..add(InitializePatientApp()),
      child: MaterialApp(
        title: 'MCS - Patient Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        home: const PatientHomeScreen(isPremium: true),
      ),
    );
  }
}
