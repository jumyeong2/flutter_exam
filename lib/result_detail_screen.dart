import 'package:flutter/material.dart';

class ResultDetailScreen extends StatelessWidget {
  final Map<String, double> myScores;
  final List<Map<String, dynamic>> partnersList;

  const ResultDetailScreen({
    super.key,
    required this.myScores,
    required this.partnersList,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 전체 멤버 리스트 생성
    List<Map<String, dynamic>> allMembers = [
      {"name": "나", "scores": myScores, "isMe": true},
      ...partnersList.map((p) => {...p, "isMe": false}),
    ];

    // 참여 인원 수 확인
    int totalMembers = allMembers.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("팀 성향 분포도"),
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
              "우리 팀은\n한 방향을 보고 있을까요?",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "총 $totalMembers명의 생각 위치를 시각화했습니다.\n서로의 생각 차이(Gap)를 확인해보세요.",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 4대 영역별 분포도 카드
            _buildDistributionCard("👑 지분(소유권)", "equity", 30, allMembers),
            _buildDistributionCard("💰 자금(운용)", "finance", 20, allMembers),
            _buildDistributionCard("⚖️ 권한(리더십)", "power", 30, allMembers),
            _buildDistributionCard("❤️ 가치(태도)", "value", 20, allMembers),

            const SizedBox(height: 20),

            // 인원수에 따른 범례(Legend) 텍스트 변경
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendIcon(
                  Colors.blueAccent,
                  totalMembers == 2 ? "나" : "나 포함 그룹",
                ),
                const SizedBox(width: 20),
                _buildLegendIcon(
                  Colors.grey[700]!,
                  totalMembers == 2 ? "파트너" : "파트너 그룹",
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 하단 안내 메시지
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "합의된 내용도, 이견이 있는 내용도\n모두 '주주간 계약서'로 명문화해야 안전합니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "초기 창업팀의 구두 약속은 상황에 따라 변하기 쉽습니다.\n지금의 합의를 법적 효력이 있는 문서로 남기세요.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendIcon(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.location_on, color: color, size: 18),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDistributionCard(
    String title,
    String category,
    double maxScore,
    List<Map<String, dynamic>> members,
  ) {
    // 1. 데이터 그룹핑
    Map<double, List<Map<String, dynamic>>> groupedMembers = {};
    List<double> allScores = [];

    for (var member in members) {
      var sMap = member['scores'];
      double score = (sMap is Map<String, double>)
          ? sMap[category]!
          : (sMap[category] as num).toDouble();
      allScores.add(score);

      if (!groupedMembers.containsKey(score)) groupedMembers[score] = [];
      groupedMembers[score]!.add(member);
    }

    allScores.sort();
    double spread = allScores.isNotEmpty ? allScores.last - allScores.first : 0;
    double riskPercent = (spread / maxScore) * 100;

    // 2. 텍스트 분석 생성
    Map<String, dynamic> analysis = _generateAnalysisText(
      category,
      riskPercent,
      allScores,
      groupedMembers,
      maxScore,
      members,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: riskPercent >= 50 ? Colors.red.shade100 : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: analysis['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  analysis['status'],
                  style: TextStyle(
                    color: analysis['color'],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // 이름표가 쌓일 공간 확보를 위해 상단 여백 (오버플로우 방지)
          const SizedBox(height: 50),

          // [시각화] 라인(Line) 위로 그룹 배치
          SizedBox(
            height: 100, // [수정됨] 60 -> 100으로 변경하여 공간 확보 (에러 해결)
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 6,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade100,
                          Colors.purple.shade100,
                          Colors.red.shade100,
                        ],
                      ),
                    ),
                  ),
                ),

                ...groupedMembers.entries.map((entry) {
                  double score = entry.key;
                  List<Map<String, dynamic>> membersAtScore = entry.value;
                  double alignPercent = (score / maxScore).clamp(0.0, 1.0);

                  bool containsMe = membersAtScore.any(
                    (m) => m['isMe'] == true,
                  );
                  Color pinColor = containsMe
                      ? Colors.blueAccent
                      : Colors.grey[700]!;

                  return Align(
                    alignment: Alignment((alignPercent * 2) - 1, 1.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...membersAtScore.map(
                          (member) => Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: _nameTag(member['name'], member['isMe']),
                          ),
                        ),
                        Icon(Icons.location_on, color: pinColor, size: 30),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Strict (엄격)",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                "Generous (관대)",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: analysis['color'].withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: analysis['color'].withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(analysis['icon'], size: 18, color: analysis['color']),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        analysis['headline'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: analysis['color'],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  analysis['desc'],
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameTag(String name, bool isMe) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMe ? Colors.blueAccent : Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        name,
        style: TextStyle(
          color: isMe ? Colors.white : Colors.grey[50],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 📝 2인 vs 3인 이상 분기 처리된 분석 로직
  Map<String, dynamic> _generateAnalysisText(
    String category,
    double riskPercent,
    List<double> scores,
    Map<double, List<Map<String, dynamic>>> groupedMembers,
    double maxScore,
    List<Map<String, dynamic>> allMembers,
  ) {
    // 기본값 (안전)
    String status = "✅ 안정적";
    String headline = "초기 주주 간 신뢰도가 높습니다.";
    String desc =
        "현재 주요 안건에 대해 같은 방향을 바라보고 있습니다. 이 합의가 변질되지 않도록 구체적인 실행 계획을 계약서에 담으세요.";
    Color color = Colors.green;
    IconData icon = Icons.check_circle;

    if (scores.isEmpty)
      return {
        "status": status,
        "headline": headline,
        "desc": desc,
        "color": color,
        "icon": icon,
      };

    double minVal = scores.first;
    double maxVal = scores.last;
    int totalCount = allMembers.length;

    // --- 🚨 고위험 구간 ---
    if (riskPercent >= 50) {
      status = "🚨 관점의 양극화";
      color = Colors.redAccent;
      icon = Icons.warning_amber_rounded;

      // [CASE A] 2명일 때
      if (totalCount == 2) {
        String partnerName = allMembers.firstWhere(
          (m) => m['isMe'] == false,
        )['name'];
        headline = "두 분의 관점이 정반대입니다.";
        desc =
            "본인(나)과 '$partnerName' 님의 생각 차이가 매우 큽니다. 서로 양보 없이 진행될 경우 사사건건 충돌할 수 있습니다. 중간 지점을 찾는 타협안이 필수적입니다.";
      }
      // [CASE B] 3명 이상일 때
      else {
        List<double> partnerScores = [];
        double myScore = 0;
        for (var m in allMembers) {
          var sMap = m['scores'];
          double s = (sMap is Map<String, double>)
              ? sMap[category]!
              : (sMap[category] as num).toDouble();
          if (m['isMe'])
            myScore = s;
          else
            partnerScores.add(s);
        }
        partnerScores.sort();
        double partnerSpread = partnerScores.isNotEmpty
            ? partnerScores.last - partnerScores.first
            : 0;
        double partnerSpreadPercent = (partnerSpread / maxScore) * 100;

        if (partnerSpreadPercent >= 30) {
          headline = "구성원 각자의 기준이 모두 다릅니다.";
          desc =
              "특정 주류 의견 없이 모두의 생각이 제각각입니다(파편화). 다수결로 정하기보다, 서로 양보하여 '중간 지점(Middle Ground)'을 찾는 새로운 합의안이 필요합니다.";
        } else {
          double avgPartnerScore =
              partnerScores.reduce((a, b) => a + b) / partnerScores.length;
          double distFromMe = (myScore - avgPartnerScore).abs();

          if (distFromMe > partnerSpread) {
            headline = "본인(나)과 팀의 의견 차이가 큽니다.";
            desc =
                "다른 파트너들은 대체로 비슷한 의견을 가지고 있으나, 본인만 관점이 다릅니다. 설득 과정 없이 진행될 경우 소외감을 느끼거나 리더십에 타격을 입을 수 있습니다.";
          } else {
            headline = "팀 내에 극단적인 의견 차이가 있습니다.";
            desc =
                "대다수는 동의하지만 특정 멤버 한 명이 강하게 반대하는 형국입니다. 무시하고 진행하면 해당 멤버의 이탈이나 반발을 초래할 수 있습니다.";
          }
        }
      }
    }
    // --- ⚠️ 주의 구간 ---
    else if (riskPercent >= 20) {
      status = "⚠️ 조율 필요";
      color = Colors.orange;
      icon = Icons.info_outline;

      if (totalCount == 2) {
        headline = "서로 다른 우선순위를 가집니다.";
        desc =
            "치명적이진 않지만, '$category' 이슈에서 서로의 기준이 다릅니다. 구두 약속보다는 문서로 명문화하여 오해를 줄이는 것이 좋습니다.";
      } else {
        headline = "팀 내에 미세한 관점 차이가 존재합니다.";
        desc = "완벽하게 일치하진 않지만, 대화로 충분히 풀 수 있는 수준입니다. 정기적인 회의를 통해 격차를 줄여나가세요.";
      }
    }

    return {
      "status": status,
      "headline": headline,
      "desc": desc,
      "color": color,
      "icon": icon,
    };
  }
}
