
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

  // [핵심] 카테고리별 점수 저장소
  Map<String, double> scores = {
    "money": 0,
    "power": 0,
    "value": 0,
  };

  @override
  Widget build(BuildContext context) {
    final scenario = sampleQuestions[currentIndex];

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
              child: Column(
                children: [
                  // 카테고리 뱃지 표시
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getCategoryName(scenario.category),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    scenario.questionText,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
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

  // 다음 질문으로 넘어가면서 점수 저장
  void _nextQuestion() {
    final currentQuestion = sampleQuestions[currentIndex];
    final category = currentQuestion.category;
    final addedScore = currentQuestion.options[selectedOptionIndex!].score;

    // 카테고리에 점수 누적
    scores[category] = (scores[category] ?? 0) + addedScore;

    if (currentIndex < sampleQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOptionIndex = null;
      });
    } else {
      // 결과 화면으로 이동 (점수 Map 전달)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(myScores: scores),
        ),
      );
    }
  }

  // 카테고리 영문 -> 한글 변환
  String _getCategoryName(String key) {
    switch (key) {
      case 'money': return "💰 자원/돈";
      case 'power': return "⚖️ 권한/리더십";
      case 'value': return "❤️ 가치관";
      default: return "기타";
    }
  }
}