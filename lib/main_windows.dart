/// Windows-specific entry point for the application.
library;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize GetIt dependency injection
  setupInjectionContainer();

  // Initialize app config (load env variables, settings, etc.)
  AppConfig.initialize();

  // Windows-specific setup
  _setupWindowsOptimizations();

  runApp(const McsApp());
}

/// Setup Windows-specific optimizations and configurations.
void _setupWindowsOptimizations() {
  // Configure window title and size
  // windowManager.waitUntilReadyToShow(
  //   const Size(1200, 800),
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

  // Windows-specific features configuration:
  // - File access and file dialogs
  // - Native dialogs
  // - Context menus
  // - Keyboard shortcuts
}
