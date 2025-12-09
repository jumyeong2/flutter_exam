import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'result_screen_intro.dart';
import 'scenario_model.dart';

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
    "equity": 0,
    "finance": 0,
    "power": 0,
    "value": 0,
  };
  List<int> answerHistory = [];

  @override
  Widget build(BuildContext context) {
    final scenario = sampleQuestions[currentIndex];
    double progress = (currentIndex + 1) / sampleQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),

      appBar: AppBar(
        title: Text(
          "라운드 ${currentIndex + 1} / ${sampleQuestions.length}",
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _showRoundTip(context),
            icon: const Icon(
              Icons.tips_and_updates_outlined,
              color: Colors.grey,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(_mainColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _progressPill(
                      Icons.flag_circle_outlined,
                      "${(progress * 100).round()}% 진단 완료",
                    ),
                    _progressPill(
                      Icons.group_outlined,
                      "시나리오 ${currentIndex + 1}",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Expanded(
            child: ListView(
              children: [
                _questionCard(scenario),
                SizedBox(height: 13),
                ...List.generate(
                  scenario.options.length,
                  (index) => _buildPastelOptionCard(
                    index,
                    scenario.options[index].text,
                  ),
                ),
                const SizedBox(height: 12),
                if (currentIndex > 0)
                  OutlinedButton.icon(
                    onPressed: _prevQuestion,
                    icon: const Icon(Icons.u_turn_left_outlined),
                    label: const Text("이전 시나리오 다시 선택"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                if (currentIndex == 0)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "선택지 터치 후 다음 라운드로 자동 진행",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _questionCard(ConflictScenario scenario) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Text(
              _getCategoryName(scenario.category),
              style: TextStyle(
                color: _getCategoryPastelColor(scenario.category),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 16),
            Text(
              scenario.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _mainColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
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
              width: 2,
            ),
            boxShadow: [
              // 부드러운 그림자
              if (!isSelected)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Row(
            children: [
              // 번호 (A, B, C)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.15)
                      : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _optionIcon(index),
                  color: isSelected ? Colors.white : const Color(0xFF90A4AE),
                ),
              ),
              const SizedBox(width: 18),
              // 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "선택 ${String.fromCharCode(65 + index)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF616161), // 진한 회색
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFCFD8DC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _optionIcon(int index) {
    const icons = [
      Icons.balance_outlined,
      Icons.handshake_outlined,
      Icons.energy_savings_leaf_outlined,
      Icons.lightbulb_outline,
    ];
    return icons[index % icons.length];
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
        MaterialPageRoute(
          builder: (context) => ResultScreenIntro(myScores: scores),
        ),
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
      case 'equity':
        return "지분 & 소유권";
      case 'finance':
        return "자금 운용";
      case 'power':
        return "권한 & 리더십";
      case 'value':
        return "가치관 & 태도";
      default:
        return "";
    }
  }

  // 🎨 [수정됨] 감성적인 파스텔 컬러 팔레트
  Color _getCategoryPastelColor(String key) {
    switch (key) {
      case 'equity':
        return const Color(0xFF9575CD); // 파스텔 퍼플 (Deep Purple 300)
      case 'finance':
        return const Color(0xFF4DB6AC); // 파스텔 틸 (Teal 300)
      case 'power':
        return const Color(0xFFFF8A65); // 파스텔 오렌지 (Deep Orange 300)
      case 'value':
        return const Color(0xFFF06292); // 파스텔 핑크 (Pink 300)
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'equity':
        return Icons.workspace_premium_outlined;
      case 'finance':
        return Icons.savings_outlined;
      case 'power':
        return Icons.gavel_outlined;
      case 'value':
        return Icons.favorite_outline;
      default:
        return Icons.blur_on;
    }
  }

  void _showRoundTip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "라운드 진행 팁",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "• 질문을 읽고 직관적으로 먼저 선택한 뒤, 필요하면 '이전 시나리오 다시 선택'으로 조정하세요.",
            ),
            const SizedBox(height: 8),
            const Text("• 합의가 어렵다면 각 선택지의 의미를 소리 내서 읽으며 서로 감정선을 확인해보세요."),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      ),
    );
  }
}
