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

  // [New] 에러 메시지 상태 변수 (null이면 에러 없음)
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

  // [핵심] 점수 유효성 검사 함수
  // return: 에러 메시지 (정상이면 null)
  String? _validateScore(String text, double maxScore) {
    if (text.trim().isEmpty) {
      return '값을 입력해주세요';
    }
    double? value = double.tryParse(text);
    if (value == null || value < 0 || value > maxScore) {
      return '양식에 맞게 입력해주세요 (0~${maxScore.toInt()})';
    }
    return null; // 통과
  }

  void _addPartner() {
    // 1. 초기화 (에러 상태 클리어)
    setState(() {
      _nameError = null;
      _equityError = null;
      _financeError = null;
      _powerError = null;
      _valueError = null;
    });

    // 2. 검증 (Validation)
    String name = _nameCtrl.text.trim();
    String? nameErr;
    if (name.isEmpty) nameErr = '이름을 입력해주세요';

    // 각 항목별 만점 기준: 지분30, 자금20, 권한30, 가치20
    String? equityErr = _validateScore(_equityCtrl.text, 30);
    String? financeErr = _validateScore(_financeCtrl.text, 20);
    String? powerErr = _validateScore(_powerCtrl.text, 30);
    String? valueErr = _validateScore(_valueCtrl.text, 20);

    // 3. 에러가 하나라도 있으면 상태 업데이트 후 중단
    if (nameErr != null || equityErr != null || financeErr != null || powerErr != null || valueErr != null) {
      setState(() {
        _nameError = nameErr;
        _equityError = equityErr;
        _financeError = financeErr;
        _powerError = powerErr;
        _valueError = valueErr;
      });
      return; // 실행 중단
    }

    // 4. 통과 시 데이터 추가
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

    // 입력창 초기화
    _nameCtrl.clear();
    _equityCtrl.clear();
    _financeCtrl.clear();
    _powerCtrl.clear();
    _valueCtrl.clear();
    
    FocusScope.of(context).unfocus(); // 키보드 내리기
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
            
            // 이름 입력 필드 (에러 메시지 연결)
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "파트너 이름",
                hintText: "예: 김철수",
                errorText: _nameError, // 에러 발생 시 표시
                filled: true, fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_add),
              ),
            ),
            const SizedBox(height: 15),

            // 점수 입력 필드들 (에러 메시지 연결)
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

            if (partnersList.isNotEmpty)
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

            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: _goToDetailAnalysis,
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: Text("총 ${partnersList.length + 1}명 비교 분석하기", style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
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

  // [수정] 에러 메시지를 받을 수 있도록 파라미터 추가
  Widget _buildInputRow(String hint, TextEditingController ctrl, IconData icon, String? errorText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // 에러 메시지 공간 확보를 위해 여백 조정
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: hint,
          errorText: errorText, // 여기에 에러 메시지가 들어감
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
      ),
    );
  }
}