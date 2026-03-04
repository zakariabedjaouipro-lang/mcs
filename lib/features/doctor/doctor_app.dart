/// Doctor Application Entry Point
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: const Center(
        child: Text('Doctor App - Coming Soon'),
      ),
    );
  }
}