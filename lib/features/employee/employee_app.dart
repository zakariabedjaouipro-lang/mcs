/// Employee Application Entry Point
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/employee/presentation/bloc/employee_bloc.dart';

/// Employee application
class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCS - Employee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (context) => sl<EmployeeBloc>(),
        child: const EmployeeHomeScreen(),
      ),
    );
  }
}

/// Employee home screen placeholder
class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
      ),
      body: const Center(
        child: Text('Employee App - Coming Soon'),
      ),
    );
  }
}
