import 'dart:math' as math;
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
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
                    Text(
                      "CoSync",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: scheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: kIsWeb ? 32 : 28),
                
                    // 2. 메인 헤드라인
                Text(
                  "창업 파트너와 내 생각, 얼마나 다를까?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: kIsWeb ? 24 : 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                ),
                
                    const SizedBox(height: 4),

                    // 3. 핵심 비교 문구
                    Text(
                      "공동창업팀을 위한 테스트",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: kIsWeb ? 36 : 32),
                    
                    // 4. 결과물 안내 카드
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(kIsWeb ? 24 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                          color: const Color(0xFFE6ECF7),
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
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "이 테스트는 팀이 합의해야 할 기준을 미리 드러내기 위한 첫 단계입니다.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 도표(그림)로 먼저 보여주고, 문장은 아래에 설명으로 둠
                          const _OutcomeDiagram(),
                          const SizedBox(height: 14),
                          const _OutcomeLegendExpander(),
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
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                
                    const SizedBox(height: 12),
                
                    // 플로팅 버튼
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: FloatingActionButton.extended(
                    onPressed: () => _startTest(context),
                        backgroundColor: scheme.primary,
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
          color: Color(0xFF3B82F6),
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
                          color: Color(0xFF1F2937),
                          height: 1.4,
                        ),
                      ),
                      TextSpan(
                        text: highlight,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1F2937),
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: text.substring(highlightIndex + highlight.length),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1F2937),
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
            color: Color(0xFF1F2937),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _OutcomeDiagram extends StatelessWidget {
  const _OutcomeDiagram();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 260,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final center = Offset(size.width / 2, size.height * 0.68);
          final top = Offset(size.width / 2, size.height * 0.10);
          final lineLength = (center - top).distance;
          final dy = size.height * 0.12;
          final dx = math.sqrt((lineLength * lineLength) - (dy * dy));
          final left = Offset(center.dx - dx, center.dy + dy);
          final right = Offset(center.dx + dx, center.dy + dy);

          const denseSize = 44.0;
          const centerSize = 58.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _OutcomeDiagramPainter(
                    color: scheme.primary,
                    center: center,
                    top: top,
                    left: left,
                    right: right,
                  ),
                ),
              ),
              Positioned(
                left: center.dx - (centerSize / 2),
                top: center.dy - (centerSize / 2),
                child: _DiagramNode(
                  background: scheme.primary,
                  foreground: Colors.white,
                  icon: Icons.group_rounded,
                  label: "팀 기준",
                  dense: false,
                ),
              ),
              Positioned(
                left: top.dx - (denseSize / 2),
                top: top.dy - (denseSize / 2),
                child: _DiagramNode(
                  background: Colors.white,
                  foreground: scheme.primary,
                  icon: Icons.category_outlined,
                  label: "유형",
                  dense: true,
                  borderColor: scheme.primary.withOpacity(0.18),
                ),
              ),
              Positioned(
                left: left.dx - (denseSize / 2),
                top: left.dy - (denseSize / 2),
                child: _DiagramNode(
                  background: Colors.white,
                  foreground: scheme.primary,
                  icon: Icons.compare_arrows_rounded,
                  label: "차이",
                  dense: true,
                  borderColor: scheme.primary.withOpacity(0.18),
                ),
              ),
              Positioned(
                left: right.dx - (denseSize / 2),
                top: right.dy - (denseSize / 2),
                child: _DiagramNode(
                  background: Colors.white,
                  foreground: scheme.primary,
                  icon: Icons.forum_outlined,
                  label: "가이드",
                  dense: true,
                  borderColor: scheme.primary.withOpacity(0.18),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final Color background;
  final Color foreground;
  final IconData icon;
  final String label;
  final bool dense;
  final Color? borderColor;

  const _DiagramNode({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.label,
    required this.dense,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final double size = dense ? 44 : 58;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: borderColor == null ? null : Border.all(color: borderColor!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: foreground, size: dense ? 20 : 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _OutcomeDiagramPainter extends CustomPainter {
  final Color color;
  final Offset center;
  final Offset top;
  final Offset left;
  final Offset right;

  const _OutcomeDiagramPainter({
    required this.color,
    required this.center,
    required this.top,
    required this.left,
    required this.right,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.22)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, top, paint);
    canvas.drawLine(center, left, paint);
    canvas.drawLine(center, right, paint);

    final dotPaint = Paint()..color = color.withOpacity(0.18);
    canvas.drawCircle(center, 3, dotPaint);
    canvas.drawCircle(top, 3, dotPaint);
    canvas.drawCircle(left, 3, dotPaint);
    canvas.drawCircle(right, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _OutcomeDiagramPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.center != center ||
        oldDelegate.top != top ||
        oldDelegate.left != left ||
        oldDelegate.right != right;
  }
}

class _OutcomeLegend extends StatelessWidget {
  const _OutcomeLegend();

  @override
  Widget build(BuildContext context) {
    // 텍스트는 "기존 문장" 그대로 유지
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _ValueItem(
          "4가지 핵심 카테고리로 정리된 나의 창업가 의사결정 유형",
          highlight: "4가지 핵심 카테고리",
        ),
        SizedBox(height: 12),
        _ValueItem(
          "같은 질문에서 드러난 파트너와의 기준 차이",
          highlight: "파트너와의 기준 차이",
        ),
        SizedBox(height: 12),
        _ValueItem(
          "다음 논의를 어디서 시작해야 하는지에 대한 가이드",
          highlight: "다음 논의를 어디서 시작해야 하는지",
        ),
      ],
    );
  }
}

class _OutcomeLegendExpander extends StatefulWidget {
  const _OutcomeLegendExpander();

  @override
  State<_OutcomeLegendExpander> createState() => _OutcomeLegendExpanderState();
}

class _OutcomeLegendExpanderState extends State<_OutcomeLegendExpander> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          style: TextButton.styleFrom(
            foregroundColor: scheme.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_expanded ? "접기" : "더 보기"),
              const SizedBox(width: 6),
              Icon(
                _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                size: 18,
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: _OutcomeLegend(),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
