import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'result_screen2.dart';

class ResultScreenIntro extends StatelessWidget {
  final Map<String, double> myScores;

  const ResultScreenIntro({super.key, required this.myScores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '결과 인트로',
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111827)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/thinking.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),

            // 내 성향 확인하기 버튼
            SizedBox(
              width: 280,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen2(myScores: myScores),
                    ),
                  );
                },
                child: const Text(
                  '내 성향 확인하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 팀 궁합 확인하기 버튼
            SizedBox(
              width: 280,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(myScores: myScores),
                    ),
                  );
                },
                child: const Text(
                  '팀 궁합 확인하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
