import 'package:flutter/material.dart';
import 'intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '합의 시뮬레이션 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const IntroScreen(), // 앱이 켜지면 IntroScreen부터 보여줌
    );
  }
}