import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'result_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int currentIndex = 0; // 현재 문제 번호
  int? selectedOptionIndex; // 현재 선택한 답
  double totalScore = 0; // 누적 점수 (성향 분석용)

  @override
  Widget build(BuildContext context) {
    final scenario = sampleQuestions[currentIndex]; // 현재 문제 데이터 가져오기

    return Scaffold(
      appBar: AppBar(
        title: Text("진단 진행 중 (${currentIndex + 1}/${sampleQuestions.length})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 질문 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                scenario.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            
            // 선택지 리스트
            ...List.generate(scenario.options.length, (index) {
              final option = scenario.options[index];
              final isSelected = selectedOptionIndex == index;

              return GestureDetector(
                onTap: () => setState(() => selectedOptionIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
            
            const Spacer(),
            
            // 다음 버튼
            ElevatedButton(
              onPressed: selectedOptionIndex == null ? null : _nextQuestion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                currentIndex == sampleQuestions.length - 1 ? "결과 보기" : "다음 질문",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() {
    // 점수 누적
    totalScore += sampleQuestions[currentIndex].options[selectedOptionIndex!].score;

    if (currentIndex < sampleQuestions.length - 1) {
      // 다음 문제로
      setState(() {
        currentIndex++;
        selectedOptionIndex = null; // 선택 초기화
      });
    } else {
      // 결과 화면으로 이동 (점수 전달)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(finalScore: totalScore),
        ),
      );
    }
  }
}