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
  int? tappedIndex; 
  bool isAnimating = false; 

  // [수정됨] 메인 테마: 부드러운 파스텔 블루 (Cornflower Blue)
  final Color _mainColor = const Color(0xFF64B5F6); 

  Map<String, double> scores = {
    "equity": 0, "finance": 0, "power": 0, "value": 0,
  };
  List<int> answerHistory = [];

  @override
  Widget build(BuildContext context) {
    final scenario = sampleQuestions[currentIndex];
    double progress = (currentIndex + 1) / sampleQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white, // 배경은 깨끗한 화이트
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Round ${currentIndex + 1}",
          style: TextStyle(color: _mainColor, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0), // 진행바 살짝 두껍게 (동글동글하게)
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // 양옆 여백 줌
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFF5F5F5), // 아주 연한 회색
                valueColor: AlwaysStoppedAnimation<Color>(_mainColor),
                minHeight: 6,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              // [질문 영역]
              // 카테고리 뱃지
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    // 파스텔톤 배경
                    color: _getCategoryPastelColor(scenario.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getCategoryName(scenario.category),
                    style: TextStyle(
                      // 글자는 조금 더 진한 파스텔톤
                      color: _getCategoryPastelColor(scenario.category),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // 질문 텍스트
              Text(
                scenario.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF424242), // 완전 검정 대신 진한 회색 (눈 편안)
                  height: 1.4, 
                ),
              ),

              const Spacer(flex: 1),

              // [선택지 리스트]
              ...List.generate(scenario.options.length, (index) {
                return _buildPastelOptionCard(index, scenario.options[index].text);
              }),

              const Spacer(flex: 1),

              // [이전 버튼]
              if (currentIndex > 0)
                TextButton.icon(
                  onPressed: _prevQuestion,
                  icon: const Icon(Icons.refresh_rounded, size: 25),
                  label: const Text("다시 선택하기"),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 121, 122, 122), // 은은한 블루그레이
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                )
              else
                const SizedBox(height: 48),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 [핵심] 파스텔톤 카드 위젯
  Widget _buildPastelOptionCard(int index, String text) {
    bool isSelected = tappedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: GestureDetector(
        onTap: isAnimating ? null : () => _handleAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
          decoration: BoxDecoration(
            // 선택되면 파스텔 블루, 아니면 아주 연한 회색 배경
            color: isSelected ? _mainColor : Colors.white,
            borderRadius: BorderRadius.circular(24), // 더 둥글게 (부드러운 느낌)
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFEEEEEE), 
              width: 2
            ),
            boxShadow: [
              // 부드러운 그림자
              if (!isSelected)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
            ],
          ),
          child: Row(
            children: [
              // 번호 (A, B, C)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28, height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.3) : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF90A4AE), 
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // 텍스트
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : const Color(0xFF616161), // 진한 회색
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAnswer(int index) async {
    setState(() {
      isAnimating = true;
      tappedIndex = index;
    });

    final currentQuestion = sampleQuestions[currentIndex];
    final category = currentQuestion.category;
    final addedScore = currentQuestion.options[index].score;

    scores[category] = (scores[category] ?? 0) + addedScore;
    answerHistory.add(index);

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (currentIndex < sampleQuestions.length - 1) {
      setState(() {
        currentIndex++;
        isAnimating = false;
        tappedIndex = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(myScores: scores)),
      );
    }
  }

  void _prevQuestion() {
    if (currentIndex == 0 || answerHistory.isEmpty) return;
    
    final prevIndex = currentIndex - 1;
    final prevQuestion = sampleQuestions[prevIndex];
    final prevAnswerIndex = answerHistory.removeLast();
    final category = prevQuestion.category;
    final subtractScore = prevQuestion.options[prevAnswerIndex].score;

    setState(() {
      scores[category] = (scores[category] ?? 0) - subtractScore;
      currentIndex--;
      tappedIndex = null;
    });
  }

  String _getCategoryName(String key) {
    switch (key) {
      case 'equity': return "지분 & 소유권";
      case 'finance': return "자금 운용";
      case 'power': return "권한 & 리더십";
      case 'value': return "가치관 & 태도";
      default: return "";
    }
  }

  // 🎨 [수정됨] 감성적인 파스텔 컬러 팔레트
  Color _getCategoryPastelColor(String key) {
    switch (key) {
      case 'equity': return const Color(0xFF9575CD); // 파스텔 퍼플 (Deep Purple 300)
      case 'finance': return const Color(0xFF4DB6AC); // 파스텔 틸 (Teal 300)
      case 'power': return const Color(0xFFFF8A65); // 파스텔 오렌지 (Deep Orange 300)
      case 'value': return const Color(0xFFF06292); // 파스텔 핑크 (Pink 300)
      default: return Colors.grey;
    }
  }
}