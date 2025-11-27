import 'package:flutter/material.dart';

class ResultDetailScreen extends StatelessWidget {
  final Map<String, double> myScores;
  final Map<String, double> partnerScores;

  const ResultDetailScreen({
    super.key,
    required this.myScores,
    required this.partnerScores,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 점수 분석 실행
    final diagnosisResult = _analyzeScores();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("정밀 분석 결과 Report"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [헤더]
            const Text(
              "두 분의\n창업 파트너십 진단 결과",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "인식의 괴리율(Risk Divergence)을 기반으로 분석했습니다.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // [핵심 시각화] 분석 결과 카드 리스트 출력
            ...diagnosisResult.map((res) => _buildRiskCard(res)),

            const SizedBox(height: 40),

            // [마무리] 룰북 연결 대신 간단한 메시지
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "위험(Risk)이 감지된 영역에 대해서는\n반드시 창업 전 깊은 대화를 나누시길 권장합니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 처음으로 돌아가기 버튼
            OutlinedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black87),
              ),
              child: const Text(
                "처음으로 돌아가기",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- [분석 로직] ---
  List<Map<String, dynamic>> _analyzeScores() {
    List<Map<String, dynamic>> results = [];

    void calculateAndAdd(String category, double maxScore) {
      double myScore = myScores[category] ?? 0;
      double partnerScore = partnerScores[category] ?? 0;
      double gap = (myScore - partnerScore).abs();
      double riskPercent = (gap / maxScore) * 100;

      String title = "";
      String desc = "";
      Color color = Colors.green;
      String catName = "";

      if (category == 'equity')
        catName = "지분(소유권)";
      else if (category == 'finance')
        catName = "자금(운용)";
      else if (category == 'power')
        catName = "권한(리더십)";
      else
        catName = "가치(태도)";

      if (riskPercent >= 50) {
        color = Colors.redAccent.shade700;
        title = "🚨 $catName 심각한 충돌";
        if (category == 'equity')
          desc = "소유권에 대한 생각이 정반대입니다. 나중에 회사 쪼개질 수 있습니다.";
        else if (category == 'finance')
          desc = "돈 쓰는 기준이 너무 다릅니다. 매번 비용 처리로 싸울 것입니다.";
        else if (category == 'power')
          desc = "서로 리더가 되려고 하거나, 책임을 미룰 수 있습니다.";
        else
          desc = "일하는 방식(워라밸)이 맞지 않아 서로를 비난하게 됩니다.";
      } else if (riskPercent >= 20) {
        color = Colors.orange;
        title = "⚠️ $catName 차이 주의";
        desc = "관점의 차이가 존재합니다. 구체적인 규칙으로 예방 가능합니다.";
      } else {
        color = Colors.green;
        title = "✅ $catName 안정적";
        desc = "이 영역에서는 두 분의 가치관이 일치합니다.";
      }

      results.add({
        "title": title,
        "desc": desc,
        "riskPercent": riskPercent,
        "color": color,
      });
    }

    // 4개 영역 분석 실행
    calculateAndAdd('equity', 30);
    calculateAndAdd('finance', 20);
    calculateAndAdd('power', 30);
    calculateAndAdd('value', 20);

    return results;
  }

  // --- [시각화 위젯] 끊어진 사슬 카드 ---
  Widget _buildRiskCard(Map<String, dynamic> data) {
    double risk = data['riskPercent'];
    Color baseColor = data['color'];

    IconData centerIcon;
    Color iconColor;
    double iconSize;
    Widget connectorWidget;

    if (risk >= 50) {
      centerIcon = Icons.link_off_rounded;
      iconColor = baseColor;
      iconSize = 40.0;
      connectorWidget = Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              iconColor.withOpacity(0.5),
              Colors.transparent,
              Colors.transparent,
              iconColor.withOpacity(0.5),
            ],
            stops: const [0.0, 0.45, 0.55, 1.0],
          ),
        ),
      );
    } else if (risk >= 20) {
      centerIcon = Icons.warning_amber_rounded;
      iconColor = baseColor;
      iconSize = 28.0;
      connectorWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Divider(
          thickness: 2,
          color: iconColor.withOpacity(0.5),
          indent: 2,
          endIndent: 2,
        ),
      );
    } else {
      centerIcon = Icons.check_circle_outline_rounded;
      iconColor = baseColor;
      iconSize = 28.0;
      connectorWidget = Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: iconColor.withOpacity(0.5),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: risk >= 50 ? iconColor.withOpacity(0.5) : Colors.grey.shade200,
          width: risk >= 50 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(risk >= 50 ? 0.25 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: baseColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: risk >= 50
                      ? [
                          BoxShadow(
                            color: baseColor.withOpacity(0.6),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  risk <= 20 ? "안전 (${risk.toInt()}%)" : "괴리율 ${risk.toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 40,
                    color: baseColor.withOpacity(0.7),
                  ),
                  Text(
                    "나",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: baseColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    connectorWidget,
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: risk >= 50
                            ? [
                                BoxShadow(
                                  color: iconColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(centerIcon, size: iconSize, color: iconColor),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.person_outline, size: 40, color: Colors.grey),
                  const Text(
                    "상대",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              data['desc'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
