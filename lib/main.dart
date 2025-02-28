import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:land_house_verify/presentation/pages/landing/landing_page.dart';
import 'package:land_house_verify/core/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart'; // ✅ Import Toastification
import 'core/themes/themes_provider.dart';
import 'data/services/login_or_register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();

  runApp(
    ProviderScope(
      child: ToastificationWrapper(
        // ✅ Wrap with ToastificationWrapper
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property Registration and Verification System',
      theme: themeData,
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<String> determineStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Set isFirstTime to false only if routing to the landing page
      prefs.setBool('isFirstTime', false);
      return 'landing';
    } else {
      return 'login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: determineStartPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          switch (snapshot.data) {
            case 'landing':
              return const LandingPage();
            case 'login':
              return const LoginOrRegister();
            default:
              return const Scaffold(
                body: Center(child: Text('Unknown page')),
              );
          }
        } else {
          return const Scaffold(
            body: Center(child: Text('Error loading app')),
          );
        }
      },
    );
  }
}
