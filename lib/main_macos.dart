/// macOS-specific entry point for the application.
library;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mcs/app.dart';
import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/env.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize GetIt dependency injection
  setupInjectionContainer();

  // Initialize app config (load env variables, settings, etc.)
  AppConfig.initialize(
    supabaseUrl: Env.supabaseUrl,
    supabaseAnonKey: Env.supabaseAnonKey,
    environment: AppEnvironment.values.firstWhere(
      (e) => e.name == Env.environment,
      orElse: () => AppEnvironment.development,
    ),
  );

  // macOS-specific setup
  _setupMacOSOptimizations();

  runApp(const McsApp());
}

/// Setup macOS-specific optimizations and configurations.
void _setupMacOSOptimizations() {
  // Configure window size and properties
  // windowManager.waitUntilReadyToShow(
  //   const Size(1400, 900),
  //   () async {
  //     await windowManager.show();
  //     await windowManager.focus();
  //   },
  // );

  // Set preferred device orientations (both portrait and landscape for desktop)
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  // macOS-specific features configuration:
  // - Native menu bar integration
  // - Dock integration
  // - Spotlight integration
  // - File access and file dialogs
  // - Keyboard shortcuts
  // - Trackpad gestures
}
