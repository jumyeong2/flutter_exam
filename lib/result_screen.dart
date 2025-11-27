import 'package:flutter/material.dart';
import 'result_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, double> myScores;

  const ResultScreen({super.key, required this.myScores});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // [수정] 4개 입력 컨트롤러
  final _equityCtrl = TextEditingController();
  final _financeCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();

  @override
  void dispose() {
    _equityCtrl.dispose();
    _financeCtrl.dispose();
    _powerCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  void _goToDetailAnalysis() {
    FocusScope.of(context).unfocus();

    // [수정] 4개 데이터 파싱
    Map<String, double> partnerScores = {
      'equity': double.tryParse(_equityCtrl.text) ?? 0,
      'finance': double.tryParse(_financeCtrl.text) ?? 0,
      'power': double.tryParse(_powerCtrl.text) ?? 0,
      'value': double.tryParse(_valueCtrl.text) ?? 0,
    };

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
            const Text(
              "나의 창업 성향 점수",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildScoreSummaryCard(),

            const SizedBox(height: 40),

            const Text(
              "공동창업자 점수 입력",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "상대방에게 테스트 링크를 공유하고 결과를 입력해주세요.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // [수정] 4개 입력 필드 (만점 기준: 지분30 / 자금20 / 권한30 / 가치20)
            _buildInputRow(
              "상대방 '지분' 점수 (0~30)",
              _equityCtrl,
              Icons.pie_chart_outline,
            ),
            _buildInputRow(
              "상대방 '자금' 점수 (0~20)",
              _financeCtrl,
              Icons.attach_money,
            ),
            _buildInputRow(
              "상대방 '권한' 점수 (0~30)",
              _powerCtrl,
              Icons.gavel_outlined,
            ),
            _buildInputRow(
              "상대방 '가치' 점수 (0~20)",
              _valueCtrl,
              Icons.favorite_border,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _goToDetailAnalysis,
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text(
                "위험도(Risk) 정밀 분석 시작",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.blueAccent.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          // [수정] 4개 항목 표시 (만점 기준 반영)
          _buildScoreRow("👑 지분(소유권)", widget.myScores['equity'] ?? 0, 30),
          const Divider(),
          _buildScoreRow("💰 자금(운용)", widget.myScores['finance'] ?? 0, 20),
          const Divider(),
          _buildScoreRow("⚖️ 권한(리더십)", widget.myScores['power'] ?? 0, 30),
          const Divider(),
          _buildScoreRow("❤️ 가치(태도)", widget.myScores['value'] ?? 0, 20),
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
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            "${score.toInt()} / ${max.toInt()}점",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(
    String hint,
    TextEditingController ctrl,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
