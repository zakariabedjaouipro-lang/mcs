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
  // Supabase credentials - Production
  // Project: rxwtdbvhxqxvckkllgep
  AppConfig.initialize(
    supabaseUrl: 'https://rxwtdbvhxqxvckkllgep.supabase.com',
    supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4d3RkYnZoeHF4dmNra2xsZ2VwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTA1NTMsImV4cCI6MjA4ODE4NjU1M30.RZfSJBgb9DUq6Fqq_HhgG1dCgtAN-_hBmzHRuaUDP38',
  );

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize GetIt dependency injection
  await configureDependencies();

  runApp(const McsApp());
}
