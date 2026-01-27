import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/firebase_options.dart';
import 'intro_screen.dart';
import 'responsive_layout.dart';
import 'result_screen2.dart';
import 'result_detail_screen.dart';
import 'share_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  bool isDev = false;

  // Developer Mode Logic
  try {
    final prefs = await SharedPreferences.getInstance();

    // 1. 체크: URL 파라미터로 개발자 모드 활성화 (?dev=true)
    if (kIsWeb && Uri.base.toString().contains('dev=true')) {
      await prefs.setBool('is_dev', true);
      isDev = true;
    }

    // 2. 체크: 이전에 설정된 값이 있는지 확인
    isDev = isDev || (prefs.getBool('is_dev') ?? false);

    if (isDev) {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      debugPrint('🚫 Analytics Disabled (Developer Mode Active)');
    }
  } catch (e) {
    debugPrint('Error initializing dev mode: $e');
  }

  runApp(MyApp(isDev: isDev));
}

class MyApp extends StatelessWidget {
  final bool isDev;

  const MyApp({super.key, this.isDev = false});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3B82F6);
    const secondary = Color(0xFF60A5FA);
    const tertiary = Color(0xFF93C5FD);
    const surface = Color(0xFFFFFFFF);
    const background = Color(0xFFF5F8FF);

    final baseScheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          surface: surface,
          background: background,
          surfaceTint: primary,
        );

    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      title: 'CoSync_Test',
      theme: ThemeData(
        colorScheme: baseScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          foregroundColor: const Color(0xFF111827),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'NanumSquareNeo',
          ),
        ),
        fontFamily: 'NanumSquareNeo',
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1B1D29),
          displayColor: const Color(0xFF1B1D29),
          fontFamily: 'NanumSquareNeo',
        ),
        cardTheme: const CardThemeData().copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: surface,
          shadowColor: const Color(0xFF3B82F6).withOpacity(0.08),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FBFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: baseScheme.primary, width: 1.2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF7B88A1)),
          hintStyle: const TextStyle(color: Color(0xFF9AA6BF)),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: baseScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 2,
            shadowColor: const Color(0xFF1D4ED8).withOpacity(0.25),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'NanumSquareNeo',
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: baseScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumSquareNeo',
            ),
            elevation: 2,
            shadowColor: const Color(0xFF1D4ED8).withOpacity(0.25),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: baseScheme.primary,
            side: BorderSide(
              color: baseScheme.primary.withOpacity(0.35),
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'NanumSquareNeo',
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: baseScheme.primary.withOpacity(0.12),
          side: const BorderSide(color: Color(0xFFE6ECF7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: const TextStyle(color: Color(0xFF1B1D29)),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            ResponsiveLayout(
              mobileBody: child!,
              desktopBody: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: child,
                ),
              ),
            ),
            if (isDev)
              Positioned(
                bottom: 20,
                left: 20,
                child: IgnorePointer(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "DEV MODE (Analytics OFF)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      home: _getInitialRoute(),
    );
  }

  // URL 파라미터를 확인하여 초기 라우트 결정
  static Widget _getInitialRoute() {
    if (kIsWeb) {
      try {
        final uri = Uri.base;
        final dataParam = uri.queryParameters['data'];

        if (dataParam != null) {
          final decodedData = ShareUtils.decodeFromUrl(uri.toString());

          if (decodedData != null) {
            final type = decodedData['type'] as String?;

            if (type == 'profile') {
              // 내 성향 결과 페이지
              final scores = decodedData['scores'] as Map<String, dynamic>?;
              if (scores != null) {
                final myScores = scores.map(
                  (key, value) => MapEntry(key, (value as num).toDouble()),
                );
                return ResultScreen2(myScores: myScores);
              }
            } else if (type == 'team') {
              // 팀 궁합 결과 페이지
              final myScoresData =
                  decodedData['myScores'] as Map<String, dynamic>?;
              final partnersListData =
                  decodedData['partnersList'] as List<dynamic>?;

              if (myScoresData != null && partnersListData != null) {
                final myScores = myScoresData.map(
                  (key, value) => MapEntry(key, (value as num).toDouble()),
                );
                final partnersList = partnersListData
                    .map((item) => item as Map<String, dynamic>)
                    .toList();

                return ResultDetailScreen(
                  myScores: myScores,
                  partnersList: partnersList,
                );
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error parsing URL parameters: $e');
      }
    }

    // 기본 홈 화면
    return const IntroScreen();
  }
}
