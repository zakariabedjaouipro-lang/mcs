/// Doctor Application Entry Point
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/doctor/presentation/bloc/doctor_bloc.dart';

/// Doctor application
class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCS - Doctor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: BlocProvider(
        create: (context) => sl<DoctorBloc>(),
        child: const DoctorHomeScreen(),
      ),
    );
  }
}

/// Doctor home screen placeholder
class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.doctor ?? 'Doctor Dashboard'),
      ),
      body: Center(
        child: Text(localizations?.getStarted ?? 'Doctor App - Coming Soon'),
      ),
    );
  }
}
