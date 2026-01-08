import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'simulation_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _startTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimulationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalPadding = kIsWeb ? 24.0 : 20.0;
            
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(height: kIsWeb ? 32 : 24),
                
                    // 1. 상단: 로고
                    const Text(
                                    "CoSync",
                                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                                      color: Color(0xFF212121),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                    
                    const SizedBox(height: kIsWeb ? 32 : 28),
                
                    // 2. 메인 헤드라인
                Text(
                      "대부분의 팀은 문제가 터진 뒤에야\n기준을 맞춥니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontSize: kIsWeb ? 24 : 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF212121),
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                ),
                
                    const SizedBox(height: kIsWeb ? 32 : 28),
                
                    // 4. 핵심 비교 카드 영역
                    _buildComparisonCardsRow(),
                    
                    const SizedBox(height: 12),
                    
                    // 5. 결과물 안내 카드
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(kIsWeb ? 24 : 20),
                        decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                          color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                                  ),
                                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                          const Text(
                            "3분 후, 남는 것",
                            textAlign: TextAlign.left,
                                  style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "이 테스트는 팀이 합의해야 할 기준을 미리 드러내기 위한 첫 단계입니다.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9E9E9E),
                              height: 1.4,
                            ),
                            ),
                          const SizedBox(height: 16),
                          _ValueItem(
                            "4가지 핵심 카테고리로 정리된 나의 창업가 의사결정 유형",
                            highlight: "4가지 핵심 카테고리",
                          ),
                          const SizedBox(height: 12),
                          _ValueItem(
                            "같은 질문에서 드러난 파트너와의 기준 차이",
                            highlight: "파트너와의 기준 차이",
                          ),
                          const SizedBox(height: 12),
                          _ValueItem(
                            "다음 논의를 어디서 시작해야 하는지에 대한 가이드",
                            highlight: "다음 논의를 어디서 시작해야 하는지",
                        ),
                        ],
                          ),
                      ),

                    const SizedBox(height: kIsWeb ? 32 : 28),
                
                    // 보조 문장
                const Text(
                      "결과는 '평가'가 아니라 '정리'입니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    height: 1.4,
                  ),
                ),
                
                    const SizedBox(height: 12),
                
                    // 플로팅 버튼
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: FloatingActionButton.extended(
                    onPressed: () => _startTest(context),
                        backgroundColor: const Color(0xFF64B5F6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                        label: const Text(
                          "간단한 팀 시뮬레이션 해보기",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                
                    const SizedBox(height: kIsWeb ? 24 : 20),
                              ],
                            ),
                          ),
        );
      },
        ),
      ),
    );
  }

  Widget _buildComparisonCardsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(
          child: _buildLeftCard(),
        ),
        const SizedBox(width: 12),
              Expanded(
          child: _buildRightCard(),
        ),
      ],
    );
  }

  Widget _buildLeftCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6), // 따뜻한 연한 주황/베이지
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
          color: const Color(0xFFFFB74D).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
          const Text(
            "기준을 미루었을 때",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF8A65),
            ),
          ),
          const SizedBox(height: 12),
          _ProblemItem(Icons.schedule, "중요 의사결정 지연"),
          const SizedBox(height: 6),
          _ProblemItem(Icons.trending_down, "소통 비용 증가 및 속도 저하"),
          const SizedBox(height: 6),
          _ProblemItem(Icons.warning_outlined, "해소되지 않는 잠재 갈등"),
        ],
      ),
    );
  }

  Widget _buildRightCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // 연한 파란/쿨톤
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
          color: const Color(0xFF64B5F6).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
            "미리 확인했을 때",
                  style: TextStyle(
              fontSize: 13,
                  fontWeight: FontWeight.bold,
              color: Color(0xFF64B5F6),
              ),
            ),
          const SizedBox(height: 12),
          _SolutionItem(Icons.search, "핵심 기준 선제 확인"),
          const SizedBox(height: 6),
          _SolutionItem(Icons.checklist, "필수 합의 지점 파악"),
          const SizedBox(height: 6),
          _SolutionItem(Icons.shield_outlined, "리스크 사전 방지"),
        ],
      ),
    );
  }
}

// 문제 상황 아이템 위젯
class _ProblemItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProblemItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFFFF8A65),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF616161),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// 해결 상황 아이템 위젯
class _SolutionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SolutionItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF64B5F6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
          text,
          style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
              height: 1.4,
            fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// 결과물 안내 아이템 위젯
class _ValueItem extends StatelessWidget {
  final String text;
  final String highlight;

  const _ValueItem(this.text, {required this.highlight});

  @override
  Widget build(BuildContext context) {
    final int highlightIndex = text.indexOf(highlight);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 18,
          color: Color(0xFF64B5F6),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: highlightIndex >= 0
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: text.substring(0, highlightIndex),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF424242),
                          height: 1.4,
                        ),
                      ),
                      TextSpan(
                        text: highlight,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF424242),
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: text.substring(highlightIndex + highlight.length),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF424242),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                )
              : Text(
            text,
                  textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 13,
            color: Color(0xFF424242),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
