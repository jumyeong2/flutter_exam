import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final double finalScore; // 나의 점수 (이전 화면에서 받아옴)

  const ResultScreen({super.key, required this.finalScore});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 상대방 점수 입력을 위한 컨트롤러
  final TextEditingController _partnerScoreController = TextEditingController();
  
  // 분석 결과 데이터를 담을 변수 (null이면 아직 분석 안 함)
  Map<String, dynamic>? matchResult;

  @override
  void dispose() {
    _partnerScoreController.dispose();
    super.dispose();
  }

  // [핵심 로직] 점수 비교 및 처방전 생성 함수
  void _analyzeCompatibility() {
    // 1. 입력값 유효성 검사
    if (_partnerScoreController.text.isEmpty) return;
    double? partnerScore = double.tryParse(_partnerScoreController.text);
    if (partnerScore == null || partnerScore < 0 || partnerScore > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("0 ~ 100 사이의 올바른 점수를 입력해주세요.")),
      );
      return;
    }

    // 2. 나의 점수와 상대 점수
    double myScore = widget.finalScore;
    
    // 3. 로직 수행
    double gap = (myScore - partnerScore).abs(); // 점수 차이
    int matchRate = (100 - (gap * 2.5)).round().clamp(0, 100); // 일치도 공식 (가중치 조절 가능)

    String title;
    String description;
    Color color;
    IconData icon;

    if (gap > 60) {
      // 차이가 60점 이상 (위험)
      title = "🔴 위험: 가치관 충돌 주의";
      description = "두 분은 '물과 기름'입니다.\n한 분은 성과를, 한 분은 관계를 너무 중시합니다.\n반드시 창업 전 '역할 분담 계약서'를 쓰세요.";
      color = Colors.redAccent;
      icon = Icons.warning_amber_rounded;
    } else if (gap > 30) {
      // 차이가 30~60점 (보통)
      title = "🟢 양호: 상호 보완적 관계";
      description = "서로 다른 관점이 시너지를 낼 수 있습니다.\n건설적인 토론이 가능한 최적의 조합입니다.\n서로의 영역을 존중해주세요.";
      color = Colors.green;
      icon = Icons.handshake;
    } else {
      // 차이가 30점 미만 (너무 비슷함)
      title = "🟡 주의: 너무 비슷한 생각";
      description = "호흡은 척척 맞겠지만, 사각지대가 생길 수 있습니다.\n두 분과 다른 성향의 멘토나 직원을 채용하세요.";
      color = Colors.orange;
      icon = Icons.copy_all;
    }

    // 4. 결과 업데이트 (화면 갱신)
    setState(() {
      matchResult = {
        "matchRate": matchRate,
        "title": title,
        "description": description,
        "color": color,
        "icon": icon,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // 내 점수에 따른 간단한 성향 텍스트
    String myType = widget.finalScore < 40 
        ? "냉철한 사업가형 (Shark)" 
        : widget.finalScore < 70 
            ? "합리적 조율자형 (Owl)" 
            : "헌신적 관계형 (Dolphin)";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("진단 결과"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [SECTION 1] 나의 결과
            const Text("나의 창업 성향", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "${widget.finalScore.toInt()}점",
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  Text(
                    myType,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // [SECTION 2] 상대방 점수 입력 (MVP 방식)
            const Text("공동창업자와 비교하기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "상대방에게도 이 테스트를 시키고,\n나온 점수를 아래에 입력해보세요.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _partnerScoreController,
              keyboardType: TextInputType.number, // 숫자 키패드
              decoration: InputDecoration(
                labelText: "상대방 점수 입력 (0~100)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_add_alt_1),
              ),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _analyzeCompatibility,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black87,
              ),
              child: const Text("궁합 분석하기", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            const SizedBox(height: 40),

            // [SECTION 3] 분석 결과 (버튼 누르면 나타남)
            if (matchResult != null) ...[
              const Divider(thickness: 2),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(matchResult!['icon'], size: 60, color: matchResult!['color']),
                    const SizedBox(height: 10),
                    Text(
                      "일치도 ${matchResult!['matchRate']}%",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: matchResult!['color']),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: matchResult!['color']),
                        borderRadius: BorderRadius.circular(16),
                        color: (matchResult!['color'] as Color).withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          Text(
                            matchResult!['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: matchResult!['color']),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            matchResult!['description'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              OutlinedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("처음으로 돌아가기"),
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}