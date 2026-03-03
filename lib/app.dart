/// Main app widget with theme, router, bloc providers, and localization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/theme/app_theme.dart';

class McsApp extends StatelessWidget {
  const McsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider(create: (context) => sl<AuthBloc>()),
        // Add more BLoC providers here
        // BlocProvider(create: (context) => getIt<DoctorBloc>()),
        // BlocProvider(create: (context) => getIt<EmployeeBloc>()),
        // etc.
      ],
      child: MaterialApp.router(
        title: 'MCS - Medical Clinic System',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        // Localization setup will go here
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
