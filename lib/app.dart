/// Main app widget with theme, router, bloc providers, and localization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_state.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_state.dart';

class McsApp extends StatefulWidget {
  const McsApp({super.key});

  @override
  State<McsApp> createState() => _McsAppState();
}

class _McsAppState extends State<McsApp> {
  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _themeMode = ThemeMode.system;
    _locale = const Locale(AppConstants.defaultLocale); // 'ar'

    // Load initial theme and locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeBloc>().add(const LoadThemeEvent());
      context.read<LocalizationBloc>().add(const LoadLanguageEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider(create: (context) => sl<AuthBloc>()),
        // Theme BLoC
        BlocProvider(create: (context) => sl<ThemeBloc>()),
        // Localization BLoC
        BlocProvider(create: (context) => sl<LocalizationBloc>()),
        // Add more BLoC providers here
        // BlocProvider(create: (context) => sl<DoctorBloc>()),
        // BlocProvider(create: (context) => sl<EmployeeBloc>()),
        // etc.
      ],
      child: BlocListener<ThemeBloc, ThemeState>(
        listener: (context, state) {
          if (state is ThemeChanged) {
            setState(() {
              _themeMode = state.themeMode;
            });
          }
        },
        child: BlocListener<LocalizationBloc, LocalizationState>(
          listener: (context, state) {
            if (state is LanguageChanged) {
              setState(() {
                _locale = Locale(state.languageCode);
              });
            }
          },
          child: ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'MCS - Medical Clinic System',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: _themeMode,
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
                // Localization setup
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale(AppConstants.arabicCode),
                  Locale(AppConstants.englishCode),
                ],
                locale: _locale,
              );
            },
          ),
        ),
      ),
    );
  }
}
