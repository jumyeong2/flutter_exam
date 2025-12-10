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
        title: const Text('결과 인트로'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🤔',
              style: TextStyle(
                fontSize: 80, // 이모티콘 크게
              ),
            ),
            const SizedBox(height: 40),

            // 내 성향 확인하기 버튼
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen2(myScores: myScores),
                    ),
                  );
                },
                child: const Text('내 성향 확인하기'),
              ),
            ),
            const SizedBox(height: 16),

            // 팀 궁합 확인하기 버튼
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(myScores: myScores),
                    ),
                  );
                },
                child: const Text('팀 궁합 확인하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
