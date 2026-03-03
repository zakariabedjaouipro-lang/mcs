/// Landing app entry point with theme and router configuration.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/theme/app_theme.dart';

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Landing-specific BLoC providers
        // BlocProvider(create: (context) => getIt<DownloadBloc>()),
        // BlocProvider(create: (context) => getIt<DeviceDetectionBloc>()),
        // BlocProvider(create: (context) => getIt<SettingsBloc>()),
      ],
      child: MaterialApp(
        title: 'MCS - Medical Clinic System',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const LandingPage(),
        debugShowCheckedModeBanner: false,
        // Localization setup
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

/// Landing page placeholder widget to be implemented
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Landing Page - To be implemented'),
      ),
    );
  }
}
