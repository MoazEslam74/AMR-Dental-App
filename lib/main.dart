import 'package:eda_pharma/firebase_options.dart';
import 'package:eda_pharma/screens/AI_infection_search_beta.dart';
import 'package:eda_pharma/screens/about_us.dart';
import 'package:eda_pharma/screens/antibiotic_search_screen.dart';
import 'package:eda_pharma/screens/home_screen.dart';
import 'package:eda_pharma/screens/infection_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antibiotics App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 164, 58),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          headlineLarge: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/antibiotic': (context) => AntibioticSearchScreen(),
        '/infection': (context) => InfectionSearchScreen(),
        '/about': (context) => AboutUsScreen(),
        '/beta_chat': (context) => BetaChatScreen(sessionId: 'your_session_id'),
      },
    );
  }
}