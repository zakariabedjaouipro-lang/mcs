/// Web-specific entry point with responsive and PWA configurations.
library;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove URL hash for web (#/)
  setPathUrlStrategy();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize GetIt dependency injection
  setupInjectionContainer();

  // Initialize app config (load env variables, settings, etc.)
  AppConfig.initialize();

  runApp(const McsApp());
}
