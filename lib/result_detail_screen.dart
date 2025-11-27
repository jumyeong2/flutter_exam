import 'package:flutter/material.dart';

class ResultDetailScreen extends StatelessWidget {
  // 이전 화면에서 넘겨받은 데이터
  final Map<String, double> myScores;
  final Map<String, double> partnerScores;

  const ResultDetailScreen({
    super.key,
    required this.myScores,
    required this.partnerScores,
  });

  @override
  Widget build(BuildContext context) {
    // [핵심 로직] 빌드 시점에 분석 결과 생성
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
            const Text(
              "두 분의\n창업 파트너십 진단 결과",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 10),
            const Text("인식의 괴리율(Risk Divergence)을 기반으로 분석했습니다.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            // 분석 결과 카드 리스트 출력
            ...diagnosisResult.map((res) => _buildRiskCard(res)),

            const SizedBox(height: 40),
            // 처음으로 돌아가는 버튼
            OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black87),
              ),
              child: const Text("처음으로 돌아가기", style: TextStyle(color: Colors.black87)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- [분석 로직 및 UI 함수들] ---

  // 1. 점수 분석 함수 (결과 리스트 반환)
  List<Map<String, dynamic>> _analyzeScores() {
    List<Map<String, dynamic>> results = [];

    // 공통 계산 내부 함수
    void calculateAndAdd(String category, double maxScore) {
      double myScore = myScores[category]!;
      double partnerScore = partnerScores[category]!;
      double gap = (myScore - partnerScore).abs();
      double riskPercent = (gap / maxScore) * 100;

      String title = "";
      String desc = "";
      Color color = Colors.green;

      String catName = category == 'money' ? "자원(돈)" : category == 'power' ? "권한(리더십)" : "가치(태도)";

      if (riskPercent >= 50) {
        // 고위험 (빨강)
        color = Colors.redAccent.shade700;
        title = "🚨 $catName 심각한 충돌";
        desc = (category == 'money') ? "재무 관점이 완전히 다릅니다. 지분/비용 문제로 회사 존립이 위험합니다."
             : (category == 'power') ? "리더십이 정면 충돌합니다. 결정적인 순간에 팀이 마비될 수 있습니다."
             : "일하는 방식이 너무 다릅니다. 서로를 이해하지 못하고 비난하게 됩니다.";
      } else if (riskPercent >= 20) {
        // 주의 (주황)
        color = Colors.orange;
        title = "⚠️ $catName 차이 주의";
        desc = "관점의 차이가 있습니다. 구체적인 규칙(Rule)을 정해두지 않으면 갈등의 씨앗이 됩니다.";
      } else {
        // 안전 (초록)
        color = Colors.green;
        title = "✅ $catName 안정적";
        desc = "이 영역에서는 두 분의 생각이 잘 맞습니다. 큰 문제가 없을 것입니다.";
      }

      results.add({
        "title": title,
        "desc": desc,
        "riskPercent": riskPercent,
        "color": color,
      });
    }

    // 3개 카테고리 분석 실행
    calculateAndAdd('money', 50);
    calculateAndAdd('power', 30);
    calculateAndAdd('value', 20);

    return results;
  }

  // 2. [핵심 시각화] 끊어진 사슬 카드 위젯 (이전과 동일하지만 Stateless에 맞게 수정)
  Widget _buildRiskCard(Map<String, dynamic> data) {
    double risk = data['riskPercent'];
    Color baseColor = data['color'];

    IconData centerIcon;
    Color iconColor;
    double iconSize;
    Widget connectorWidget;

    if (risk >= 50) {
      centerIcon = Icons.link_off_rounded; // 끊어진 사슬
      iconColor = baseColor;
      iconSize = 40.0;
      connectorWidget = Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 5), decoration: BoxDecoration(gradient: LinearGradient(colors: [iconColor.withOpacity(0.5), Colors.transparent, Colors.transparent, iconColor.withOpacity(0.5)], stops: const [0.0, 0.45, 0.55, 1.0])));
    } else if (risk >= 20) {
      centerIcon = Icons.warning_amber_rounded;
      iconColor = baseColor;
      iconSize = 28.0;
      connectorWidget = Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0), child: Divider(thickness: 2, color: iconColor.withOpacity(0.5), indent: 2, endIndent: 2));
    } else {
      centerIcon = Icons.check_circle_outline_rounded;
      iconColor = baseColor;
      iconSize = 28.0;
      connectorWidget = Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 5), color: iconColor.withOpacity(0.5));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: risk >= 50 ? iconColor.withOpacity(0.5) : Colors.grey.shade200, width: risk >= 50 ? 2 : 1),
        boxShadow: [BoxShadow(color: baseColor.withOpacity(risk >= 50 ? 0.25 : 0.1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(20), boxShadow: risk >= 50 ? [BoxShadow(color: baseColor.withOpacity(0.6), blurRadius: 8)] : []),
                child: Text(risk <= 20 ? "안전 (${risk.toInt()}%)" : "괴리율 ${risk.toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Column(children: [Icon(Icons.person, size: 40, color: baseColor.withOpacity(0.7)), Text("나", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: baseColor))]),
              Expanded(child: Stack(alignment: Alignment.center, children: [connectorWidget, Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: risk >= 50 ? [BoxShadow(color: iconColor.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)] : []), child: Icon(centerIcon, size: iconSize, color: iconColor))])),
              Column(children: [Icon(Icons.person_outline, size: 40, color: Colors.grey), const Text("상대", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))]),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: baseColor.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Text(data['desc'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}