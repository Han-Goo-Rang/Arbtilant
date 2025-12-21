import 'package:flutter/material.dart';
import 'package:arbtilant/Pages/splash_screen.dart';
import 'package:arbtilant/Services/hive_service.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/core/design_system/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (local storage)
  try {
    await HiveService().init();
  } catch (e) {
    debugPrint('❌ Hive initialization failed: $e');
  }

  // Initialize diseases
  try {
    await DiseaseService().initializeDiseases();
  } catch (e) {
    debugPrint('❌ Disease initialization failed: $e');
  }

  // TODO: Enable Supabase after proper configuration
  // - Uncomment imports at top
  // - Uncomment Supabase initialization below
  // - Uncomment sync buttons in history_page.dart
  /*
  try {
    await SupabaseService().init();
    final isConnected = await SupabaseService().isConnected();
    debugPrint('Supabase connected: $isConnected');
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }
  SyncService().startPeriodicSync(interval: const Duration(minutes: 5));
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arbtilant',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
