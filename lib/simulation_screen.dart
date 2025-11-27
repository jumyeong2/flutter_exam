import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'result_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int currentIndex = 0;
  
  // 중복 터치 방지용 플래그 (화면 넘어가는 중에 또 누르는 것 방지)
  bool isAnimating = false;

  // 점수 저장소
  Map<String, double> scores = {
    "equity": 0,
    "finance": 0,
    "power": 0,
    "value": 0,
  };

  // [추가] '이전' 버튼을 위해 내가 어떤 답을 골랐었는지 기록하는 스택
  // (index: 문제 번호, value: 선택한 옵션 인덱스)
  List<int> answerHistory = [];

  @override
  Widget build(BuildContext context) {
    final scenario = sampleQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("진단 진행 중 (${currentIndex + 1}/${sampleQuestions.length})"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 첫 번째 문제에서는 앱 종료 확인, 그 외에는 이전 문제로
            if (currentIndex == 0) {
              Navigator.pop(context);
            } else {
              _prevQuestion();
            }
          },
        ),
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(scenario.category),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getCategoryName(scenario.category),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
            
            // 선택지 리스트 (버튼 형태)
            ...List.generate(scenario.options.length, (index) {
              final option = scenario.options[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: isAnimating ? null : () => _handleAnswer(index), // 애니메이션 중엔 터치 막음
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    padding: const EdgeInsets.all(20),
                    side: const BorderSide(color: Colors.blueAccent, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // 눌렸을 때 효과 (Splash)
                    overlayColor: Colors.blueAccent.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      // 번호 표시 (A, B, C)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        child: Text(
                          String.fromCharCode(65 + index), // 0->A, 1->B ...
                          style: const TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // 선택지 텍스트
                      Expanded(
                        child: Text(
                          option.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const Spacer(),
            
            // [하단] 이전 버튼 (첫 문제는 안 보임)
            if (currentIndex > 0)
              TextButton.icon(
                onPressed: _prevQuestion,
                icon: const Icon(Icons.undo, color: Colors.grey),
                label: const Text("이전 질문으로 돌아가기", style: TextStyle(color: Colors.grey)),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 답을 선택했을 때 처리 (자동 넘김 로직)
  void _handleAnswer(int index) async {
    setState(() {
      isAnimating = true; // 중복 터치 방지
    });

    final currentQuestion = sampleQuestions[currentIndex];
    final category = currentQuestion.category;
    final addedScore = currentQuestion.options[index].score;

    // 1. 점수 누적
    scores[category] = (scores[category] ?? 0) + addedScore;
    
    // 2. 히스토리에 기록 (나중에 '이전' 눌렀을 때 취소하기 위해)
    answerHistory.add(index);

    // 3. 0.2초 딜레이 (사용자가 "내가 뭘 눌렀구나" 인식할 시간 줌)
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (currentIndex < sampleQuestions.length - 1) {
      // 다음 문제로 이동
      setState(() {
        currentIndex++;
        isAnimating = false; // 터치 잠금 해제
      });
    } else {
      // 결과 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(myScores: scores)),
      );
    }
  }

  // 이전 버튼 눌렀을 때 (점수 취소 로직)
  void _prevQuestion() {
    if (currentIndex == 0 || answerHistory.isEmpty) return;

    // 1. 방금 전 문제 정보 가져오기
    final prevIndex = currentIndex - 1;
    final prevQuestion = sampleQuestions[prevIndex];
    final prevAnswerIndex = answerHistory.removeLast(); // 기록에서 삭제하며 가져오기

    // 2. 점수 취소 (Undo)
    final category = prevQuestion.category;
    final subtractScore = prevQuestion.options[prevAnswerIndex].score;
    scores[category] = (scores[category] ?? 0) - subtractScore;

    // 3. 화면 되돌리기
    setState(() {
      currentIndex--;
    });
  }

  String _getCategoryName(String key) {
    switch (key) {
      case 'equity': return "👑 지분/소유권";
      case 'finance': return "💰 자금/운용";
      case 'power': return "⚖️ 권한/리더십";
      case 'value': return "❤️ 가치관/태도";
      default: return "기타";
    }
  }

  Color _getCategoryColor(String key) {
    switch (key) {
      case 'equity': return Colors.purple;
      case 'finance': return Colors.green;
      case 'power': return Colors.orange;
      case 'value': return Colors.pinkAccent;
      default: return Colors.blue;
    }
  }
}