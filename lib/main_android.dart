/// Android-specific entry point for the application.
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

  // Android-specific optimizations
  _setupAndroidOptimizations();

  runApp(const McsApp());
}

/// Setup Android-specific optimizations and configurations.
void _setupAndroidOptimizations() {
  // Configure system UI mode
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set preferred device orientations (portrait mode for medical app)
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // Set status bar and navigation bar colors
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );
}
