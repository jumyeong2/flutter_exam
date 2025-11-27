import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, double> myScores;

  const ResultScreen({super.key, required this.myScores});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 입력 컨트롤러
  final _moneyCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  
  // [추가] 화면 스크롤을 제어하기 위한 컨트롤러
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> diagnosisResult = [];

  @override
  void dispose() {
    _moneyCtrl.dispose();
    _powerCtrl.dispose();
    _valueCtrl.dispose();
    _scrollController.dispose(); // [추가] 메모리 해제
    super.dispose();
  }

  void _analyzeDetail() {
    // [추가] 버튼 누르면 키보드부터 내리기 (중요!)
    FocusScope.of(context).unfocus();

    double pMoney = double.tryParse(_moneyCtrl.text) ?? 0;
    double pPower = double.tryParse(_powerCtrl.text) ?? 0;
    double pValue = double.tryParse(_valueCtrl.text) ?? 0;

    double mMoney = widget.myScores['money']!;
    double mPower = widget.myScores['power']!;
    double mValue = widget.myScores['value']!;

    List<Map<String, dynamic>> results = [];

    // 갈등 진단 로직
    if ((mMoney - pMoney).abs() >= 20) {
      results.add({
        "title": "💰 자원(돈) 리스크",
        "desc": "지분과 급여 문제로 싸울 확률이 높습니다. 재무적 합의가 시급합니다.",
        "color": Colors.redAccent,
      });
    }

    if ((mPower - pPower).abs() >= 15) {
      results.add({
        "title": "⚖️ 권한(리더십) 충돌",
        "desc": "의사결정 방식이 정반대입니다. CEO의 권한 범위를 명확히 하세요.",
        "color": Colors.orange,
      });
    }

    if ((mValue - pValue).abs() >= 10) {
      results.add({
        "title": "❤️ 가치관(태도) 차이",
        "desc": "일하는 스타일이 다릅니다. 출퇴근/겸업 규칙을 정하세요.",
        "color": Colors.blue,
      });
    }

    if (results.isEmpty) {
      results.add({
        "title": "🎉 천생연분",
        "desc": "모든 영역에서 가치관이 비슷합니다. 최고의 파트너입니다!",
        "color": Colors.green,
      });
    }

    setState(() {
      diagnosisResult = results;
    });

    // [추가] 결과가 나온 후, 화면을 맨 아래로 부드럽게 내리기
    // (0.1초 뒤에 실행해서 화면이 그려질 시간을 줌)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("정밀 진단 결과")),
      body: SingleChildScrollView(
        // [추가] 스크롤 컨트롤러 연결
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // [A] 내 점수
            const Text("나의 영역별 성향", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildScoreBar("💰 자원/돈", widget.myScores['money']!, 50),
            _buildScoreBar("⚖️ 권한", widget.myScores['power']!, 30),
            _buildScoreBar("❤️ 가치관", widget.myScores['value']!, 20),

            const Divider(height: 40, thickness: 2),

            // [B] 상대방 점수 입력
            const Text("상대방 점수 입력", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("상대방에게 테스트를 시키고 결과를 입력하세요", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            _buildInputRow("상대방의 '자원' 점수 (0~50)", _moneyCtrl),
            _buildInputRow("상대방의 '권한' 점수 (0~30)", _powerCtrl),
            _buildInputRow("상대방의 '가치' 점수 (0~20)", _valueCtrl),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeDetail,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              child: const Text("정밀 분석 시작"),
            ),

            const SizedBox(height: 30),

            // [C] 분석 결과 카드 (결과가 없으면 안 보임)
            if (diagnosisResult.isNotEmpty) 
              ...diagnosisResult.map((res) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: (res['color'] as Color).withOpacity(0.1),
                  border: Border.all(color: res['color']),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.report_problem_rounded, color: res['color']),
                        const SizedBox(width: 8),
                        Text(res['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: res['color'])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(res['desc'], style: const TextStyle(fontSize: 16)),
                  ],
                ),
              )),
              
            // [추가] 결과가 잘 보이도록 하단 여백 추가
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, double max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("${score.toInt()} / ${max.toInt()}점"),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: score / max,
            color: Colors.blueAccent,
            backgroundColor: Colors.grey[200],
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(String hint, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        ),
      ),
    );
  }
}