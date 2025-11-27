import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double finalScore;

  const ResultScreen({super.key, required this.finalScore});

  @override
  Widget build(BuildContext context) {
    // 점수에 따른 간단한 로직 (실제로는 더 복잡한 알고리즘 적용 가능)
    String resultText;
    Color resultColor;

    if (finalScore < 10) {
      resultText = "매우 엄격한 성과 중심형";
      resultColor = Colors.redAccent;
    } else if (finalScore < 20) {
      resultText = "균형 잡힌 합리적 조율형";
      resultColor = Colors.orange;
    } else {
      resultText = "관계 중심의 평화주의형";
      resultColor = Colors.green;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("진단 완료", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Icon(Icons.analytics_outlined, size: 80, color: resultColor),
            const SizedBox(height: 20),
            Text(
              "당신의 성향은...",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              resultText,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: resultColor),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 처음으로 돌아가기
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("처음으로 돌아가기"),
            )
          ],
        ),
      ),
    );
  }
}