/// Main app widget with theme, router, bloc providers, and localization.
///
/// This is the root MaterialApp that configures:
/// - All BLoC providers for state management
/// - Theme and dark mode
/// - Localization/internationalization
/// - GoRouter for navigation
/// - ScreenUtility for responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/screens/splash_screen.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/core/ui/responsive_config.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_state.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_state.dart';

class McsApp extends StatefulWidget {
  const McsApp({super.key});

  @override
  State<McsApp> createState() => _McsAppState();
}

class _McsAppState extends State<McsApp> {
  // Theme state
  ThemeMode _themeMode = ThemeMode.system;

  // Localization state
  Locale _locale = const Locale(AppConstants.defaultLocale); // 'ar'

  @override
  void initState() {
    super.initState();
    // BLoCs are initialized in createState and handle own events
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        // Theme BLoC - loads theme preference
        BlocProvider(
          create: (context) => sl<ThemeBloc>(),
        ),
        // Localization BLoC - loads language preference
        BlocProvider(
          create: (context) => sl<LocalizationBloc>(),
        ),
        // Add more BLoC providers here as needed
        // BlocProvider(create: (context) => sl<DoctorBloc>()),
        // BlocProvider(create: (context) => sl<PatientBloc>()),
        // etc.
      ],
      child: BlocListener<ThemeBloc, ThemeState>(
        listenWhen: (previous, current) {
          // Only rebuild when theme actually changes
          return current is ThemeChanged;
        },
        listener: (context, state) {
          if (state is ThemeChanged) {
            setState(() {
              _themeMode = state.themeMode;
            });
          }
        },
        child: BlocListener<LocalizationBloc, LocalizationState>(
          listenWhen: (previous, current) {
            // Only rebuild when language actually changes
            return current is LanguageChanged;
          },
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
            designSize: const Size(
              ResponsiveConfig.designWidth,
              ResponsiveConfig.designHeight,
            ),
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
                builder: _buildAppWithLoadingState,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Wrap the app to show loading state during initialization
  ///
  /// Listens to ThemeBloc and LocalizationBloc to know when
  /// initialization is complete
  Widget _buildAppWithLoadingState(BuildContext context, Widget? child) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) {
        // Show splash screen while theme is loading/initializing
        return current is ThemeInitial ||
            current is ThemeLoading ||
            current is ThemeChanged;
      },
      builder: (context, themeState) {
        return BlocBuilder<LocalizationBloc, LocalizationState>(
          buildWhen: (previous, current) {
            // Show splash screen while language is loading/initializing
            return current is LocalizationInitial ||
                current is LocalizationLoading ||
                current is LanguageChanged;
          },
          builder: (context, localeState) {
            // Show splash screen during initialization
            final isThemeReady = themeState is ThemeChanged ||
                (themeState is! ThemeInitial && themeState is! ThemeLoading);
            final isLocaleReady = localeState is LanguageChanged ||
                (localeState is! LocalizationInitial &&
                    localeState is! LocalizationLoading);

            if (!isThemeReady || !isLocaleReady) {
              return const SplashScreen(
                // ignore: avoid_redundant_argument_values
                message: 'جاري تحميل التطبيق...',
              );
            }

            // Once both theme and locale are ready, show the actual app
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
