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
  final Color _mainColor = const Color(0xFF3B82F6);

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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        title: Text(
          "라운드 ${currentIndex + 1} / ${sampleQuestions.length}",
          style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _showRoundTip(context),
            icon: Icon(
              Icons.tips_and_updates_outlined,
              color: const Color(0xFF111827),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE8EEF9),
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: ListView(
            children: [
              _questionCard(scenario, currentIndex),
              const SizedBox(height: 56),
              ...List.generate(
                scenario.options.length,
                (index) =>
                    _buildPastelOptionCard(index, scenario.options[index].text),
              ),
              const SizedBox(height: 36),
              if (currentIndex > 0)
                TextButton.icon(
                  onPressed: _prevQuestion,
                  icon: const Icon(Icons.u_turn_left_outlined),
                  label: const Text("이전 시나리오 다시 선택"),
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.primary,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
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
    );
  }

  Widget _questionCard(ConflictScenario scenario, int questionIndex) {
    final categoryColor = _getCategoryPastelColor(scenario.category);

    return Column(
      children: [
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(scenario.category),
              color: categoryColor,
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              _getCategoryName(scenario.category),
              style: TextStyle(
                color: categoryColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Q${questionIndex + 1}. ${scenario.questionText}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            height: 1.5,
            color: Color(0xFF1B1D29),
          ),
        ),
      ],
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
            color: const Color(0xFF3B82F6).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: isAnimating ? null : () => _handleAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
          decoration: BoxDecoration(
            // 선택되면 파스텔 블루, 아니면 아주 연한 회색 배경
            color: isSelected ? _mainColor : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? _mainColor.withOpacity(0.4) : const Color(0xFFE7ECF6),
              width: 2.2,
            ),
            boxShadow: [
              // 부드러운 그림자
              BoxShadow(
                color: isSelected
                    ? _mainColor.withOpacity(0.25)
                    : const Color(0xFF3B82F6).withOpacity(0.08),
                blurRadius: isSelected ? 18 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // 번호 (A, B, C)
              Icon(
                _optionIcon(index),
                size: 28,
                color: isSelected ? Colors.white : const Color(0xFF7BA2E8),
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
                        fontSize: 13,
                        color: isSelected ? Colors.white70 : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF2E3440), // 진한 회색
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFC7D2E5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _optionIcon(int index) {
    return Icons.check_circle_outline;
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
        return const Color(0xFFEC4899); // pink
      case 'finance':
        return const Color(0xFFF59E0B); // yellow
      case 'power':
        return const Color(0xFF10B981); // green
      case 'value':
        return const Color(0xFF8B5CF6); // purple
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
