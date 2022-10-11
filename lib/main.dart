import 'package:flutter/material.dart';
import 'package:quiz_app/menu.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.deepOrange.shade400,
          onPrimary: Colors.white,
          secondary: Colors.green.shade400,
          onSecondary: Colors.white,
          error: Colors.red.shade400,
          onError: Colors.white,
          background: Colors.black87,
          onBackground: Colors.white,
          surface: Colors.black38,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF101010),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 112, fontWeight: FontWeight.w200, color: Colors.white),
          bodySmall: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 24),
          bodyLarge: TextStyle(fontSize: 32),
        ),
      ),
      home: const SafeArea(
        child: Scaffold(
          body: Menu(),
        ),
      ),
    );
  }
}
