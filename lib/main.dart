/// Main entry point for the application.
library;

import 'package:flutter/material.dart';

import 'package:mcs/app.dart';
import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app config (load env variables, settings, etc.)
  // IMPORTANT: Replace these placeholder values with your actual Supabase credentials
  // You can get these from your Supabase project settings: https://supabase.com/dashboard
  AppConfig.initialize(
    supabaseUrl: 'https://your-project-id.supabase.co',
    supabaseAnonKey: 'your-anon-key-here',
    environment: AppEnvironment.development,
  );

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize GetIt dependency injection
  await configureDependencies();

  runApp(const McsApp());
}
