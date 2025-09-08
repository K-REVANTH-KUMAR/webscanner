import 'package:flutter/material.dart';
import 'package:vulscanner/home_page.dart';
import 'package:vulscanner/result.dart' hide HomePage;
import 'package:vulscanner/scan_progress_page.dart';
// import 'pages/home_page.dart';
// import 'pages/scan_progress_page.dart';
// import 'pages/results_dashboard.dart';
// import 'pages/reports_page.dart';
// import 'pages/chatbot_page.dart';
// import 'pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Web Vulnerability Scanner',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.purpleAccent,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/progress': (context) => ScanProgressPage(),
        '/results': (context) => ResultsPage(),
        // '/reports': (context) => ReportsPage(),
        // '/chatbot': (context) => ChatbotPage(),
        // '/settings': (context) => SettingsPage(),
      },
    );
  }
}
