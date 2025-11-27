import 'package:flutter/material.dart';
import 'result_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, double> myScores;

  const ResultScreen({super.key, required this.myScores});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 입력 컨트롤러
  final _nameCtrl = TextEditingController();
  final _equityCtrl = TextEditingController();
  final _financeCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();

  // 에러 메시지 상태 변수
  String? _nameError;
  String? _equityError;
  String? _financeError;
  String? _powerError;
  String? _valueError;

  List<Map<String, dynamic>> partnersList = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _equityCtrl.dispose();
    _financeCtrl.dispose();
    _powerCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  // 점수 유효성 검사 함수
  String? _validateScore(String text, double maxScore) {
    if (text.trim().isEmpty) {
      return '값을 입력해주세요';
    }
    double? value = double.tryParse(text);
    if (value == null || value < 0 || value > maxScore) {
      return '양식에 맞게 입력해주세요 (0~${maxScore.toInt()})';
    }
    return null;
  }

  void _addPartner() {
    setState(() {
      _nameError = null;
      _equityError = null;
      _financeError = null;
      _powerError = null;
      _valueError = null;
    });

    String name = _nameCtrl.text.trim();
    String? nameErr;
    if (name.isEmpty) nameErr = '이름을 입력해주세요';

    String? equityErr = _validateScore(_equityCtrl.text, 30);
    String? financeErr = _validateScore(_financeCtrl.text, 20);
    String? powerErr = _validateScore(_powerCtrl.text, 30);
    String? valueErr = _validateScore(_valueCtrl.text, 20);

    if (nameErr != null || equityErr != null || financeErr != null || powerErr != null || valueErr != null) {
      setState(() {
        _nameError = nameErr;
        _equityError = equityErr;
        _financeError = financeErr;
        _powerError = powerErr;
        _valueError = valueErr;
      });
      return;
    }

    setState(() {
      partnersList.add({
        "name": name,
        "scores": {
          "equity": double.parse(_equityCtrl.text),
          "finance": double.parse(_financeCtrl.text),
          "power": double.parse(_powerCtrl.text),
          "value": double.parse(_valueCtrl.text),
        }
      });
    });

    _nameCtrl.clear();
    _equityCtrl.clear();
    _financeCtrl.clear();
    _powerCtrl.clear();
    _valueCtrl.clear();
    
    FocusScope.of(context).unfocus();
  }

  void _goToDetailAnalysis() {
    if (partnersList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("최소 1명 이상의 파트너를 추가해주세요.")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultDetailScreen(
          myScores: widget.myScores,
          partnersList: partnersList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("공동창업자 데이터 입력"), elevation: 0, centerTitle: true),
      
      // [1] 스크롤 영역 (내용물)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        // 키보드가 올라왔을 때 하단 여백 확보를 위해 padding 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("나의 점수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildScoreSummaryCard(),
            
            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("파트너 추가", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("현재 ${partnersList.length}명 대기중", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "파트너 이름",
                hintText: "예: 김철수",
                errorText: _nameError,
                filled: true, fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_add),
              ),
            ),
            const SizedBox(height: 15),

            _buildInputRow("지분 점수 (0~30)", _equityCtrl, Icons.pie_chart_outline, _equityError),
            _buildInputRow("자금 점수 (0~20)", _financeCtrl, Icons.attach_money, _financeError),
            _buildInputRow("권한 점수 (0~30)", _powerCtrl, Icons.gavel_outlined, _powerError),
            _buildInputRow("가치 점수 (0~20)", _valueCtrl, Icons.favorite_border, _valueError),

            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _addPartner,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("이 파트너 리스트에 담기"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.blueAccent),
              ),
            ),

            const SizedBox(height: 20),

            // 추가된 파트너 칩
            if (partnersList.isNotEmpty) ...[
              Wrap(
                spacing: 8.0, runSpacing: 4.0,
                children: partnersList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Map user = entry.value;
                  return Chip(
                    avatar: CircleAvatar(child: Text("${idx + 1}")),
                    label: Text(user['name']),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        partnersList.removeAt(idx);
                      });
                    },
                  );
                }).toList(),
              ),
              // 하단 버튼에 가려지지 않도록 여백 추가
              const SizedBox(height: 80), 
            ]
          ],
        ),
      ),

      // [2] 하단 고정 버튼 영역 (핵심 수정 부분)
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3), // 위쪽으로 그림자
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _goToDetailAnalysis,
            icon: const Icon(Icons.analytics, color: Colors.white),
            label: Text("총 ${partnersList.length + 1}명 비교 분석하기", style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _miniScore("👑 지분", widget.myScores['equity']!, 30),
          _miniScore("💰 자금", widget.myScores['finance']!, 20),
          _miniScore("⚖️ 권한", widget.myScores['power']!, 30),
          _miniScore("❤️ 가치", widget.myScores['value']!, 20),
        ],
      ),
    );
  }

  Widget _miniScore(String label, double score, double max) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text("${score.toInt()}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      ],
    );
  }

  Widget _buildInputRow(String hint, TextEditingController ctrl, IconData icon, String? errorText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: hint,
          errorText: errorText,
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
      ),
    );
  }
}