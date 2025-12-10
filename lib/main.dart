import 'package:flutter/material.dart';
import 'intro_screen.dart';
import 'responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B7CFA),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '합의 시뮬레이션 Demo',
      theme: ThemeData(
        colorScheme: baseScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          foregroundColor: baseScheme.primary,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: baseScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1B1D29),
          displayColor: const Color(0xFF1B1D29),
        ),
        cardTheme: const CardThemeData().copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: baseScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: baseScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            elevation: 0,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: ResponsiveLayout(
        mobileBody: const IntroScreen(),
        desktopBody: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const IntroScreen(),
          ),
        ),
      ), // 앱이 켜지면 IntroScreen부터 보여줌
    );
  }
}
