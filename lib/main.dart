import 'package:flutter/material.dart';
import 'package:land_house_verify/pages/landing/landing_page.dart';
import 'package:land_house_verify/service_locator.dart';
import 'package:land_house_verify/services/login_or_register.dart';
import 'package:land_house_verify/themes/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider for ThemeProvider to manage theme-related state
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:
          'Property Registration and Verification System', // Title of the application

      theme: Provider.of<ThemeProvider>(context).themeData,

      home: InitialScreen(),
       // Initial screen for user authentication
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

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
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          switch (snapshot.data) {
            case 'landing':
              return LandingPage();
            default:
              return LoginOrRegister();
          }
        } else {
          return Center(child: Text('Error loading app'));
        }
      },
    );
  }
}
