import 'package:flutter/material.dart';
import 'result_detail_screen.dart'; // 새로 만들 파일 import

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

  @override
  void dispose() {
    _moneyCtrl.dispose();
    _powerCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  // [핵심] 다음 페이지로 데이터 넘기기
  void _goToDetailAnalysis() {
    FocusScope.of(context).unfocus(); // 키보드 내리기

    // 1. 입력된 상대방 점수 파싱 (없으면 0점 처리)
    double pMoney = double.tryParse(_moneyCtrl.text) ?? 0;
    double pPower = double.tryParse(_powerCtrl.text) ?? 0;
    double pValue = double.tryParse(_valueCtrl.text) ?? 0;

    // 2. 상대방 점수를 Map으로 묶음
    Map<String, double> partnerScores = {
      'money': pMoney,
      'power': pPower,
      'value': pValue,
    };

    // 3. 다음 페이지(상세 분석)로 이동하며 데이터 전달
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultDetailScreen(
          myScores: widget.myScores,
          partnerScores: partnerScores,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("진단 데이터 입력"), 
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [SECTION A] 내 점수 요약 (간단하게)
            const Text("나의 창업 성향 점수", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildScoreSummaryCard(),

            const SizedBox(height: 40),

            // [SECTION B] 상대방 입력
            const Text("공동창업자 점수 입력", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text("상대방에게 테스트 링크를 공유하고 결과를 입력해주세요.", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            
            _buildInputRow("상대방 '자원' 점수 (0~50)", _moneyCtrl, Icons.monetization_on_outlined),
            _buildInputRow("상대방 '권한' 점수 (0~30)", _powerCtrl, Icons.gavel_outlined),
            _buildInputRow("상대방 '가치' 점수 (0~20)", _valueCtrl, Icons.favorite_border),

            const SizedBox(height: 40),
            
            // [SECTION C] 분석 시작 버튼
            ElevatedButton.icon(
              onPressed: _goToDetailAnalysis, // 다음 페이지로 이동 함수 연결
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text("위험도(Risk) 정밀 분석 시작", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.blueAccent.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 20),
            const Text("※ 분석 버튼을 누르면 돌이킬 수 없는 결과가 공개됩니다.", textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // 내 점수 보여주는 카드 디자인
  Widget _buildScoreSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Column(
        children: [
          _buildScoreRow("💰 자원(돈)", widget.myScores['money']!, 50),
          const Divider(),
          _buildScoreRow("⚖️ 권한(리더십)", widget.myScores['power']!, 30),
          const Divider(),
          _buildScoreRow("❤️ 가치(태도)", widget.myScores['value']!, 20),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, double score, double max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          Text("${score.toInt()} / ${max.toInt()}점", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
        ],
      ),
    );
  }

  // 입력 필드 디자인
  Widget _buildInputRow(String hint, TextEditingController ctrl, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}