import 'package:flutter/material.dart';
import 'package:arbtilant/Pages/splash_screen.dart';
import 'package:arbtilant/Services/hive_service.dart';
import 'package:arbtilant/Services/disease_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 App starting...');

  // Initialize Hive (local storage)
  try {
    print('📦 Initializing Hive...');
    await HiveService().init();
    print('✅ Hive initialized');
  } catch (e) {
    print('❌ Hive initialization failed: $e');
  }

  // Initialize diseases
  try {
    print('🦠 Initializing diseases...');
    await DiseaseService().initializeDiseases();
    print('✅ Diseases initialized');
  } catch (e) {
    print('❌ Disease initialization failed: $e');
  }

  // TODO: Enable Supabase after proper configuration
  // - Uncomment imports at top
  // - Uncomment Supabase initialization below
  // - Uncomment sync buttons in history_page.dart
  /*
  try {
    await SupabaseService().init();
    final isConnected = await SupabaseService().isConnected();
    print('Supabase connected: $isConnected');
  } catch (e) {
    print('Supabase initialization failed: $e');
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
