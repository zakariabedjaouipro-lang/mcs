/// Admin Application Entry Point
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';
import 'package:mcs/features/admin/presentation/screens/admin_dashboard_screen.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AdminBloc(sl<SupabaseService>()),
        ),
      ],
      child: MaterialApp(
        title: 'MCS Admin - Medical Clinic System',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: const AdminDashboardScreen(),
      ),
    );
  }
}

