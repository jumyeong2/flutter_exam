import 'package:flutter/material.dart';
import 'result_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, double> myScores;

  const ResultScreen({super.key, required this.myScores});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _nameCtrl = TextEditingController();
  final _equityCtrl = TextEditingController();
  final _financeCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();

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

  // 유효성 검사
  bool _validateInputs() {
    if (_nameCtrl.text.isEmpty) return false;
    if (!_isValidScore(_equityCtrl.text, 30)) return false;
    if (!_isValidScore(_financeCtrl.text, 20)) return false;
    if (!_isValidScore(_powerCtrl.text, 30)) return false;
    if (!_isValidScore(_valueCtrl.text, 20)) return false;
    return true;
  }

  bool _isValidScore(String text, double max) {
    double? val = double.tryParse(text);
    return val != null && val >= 0 && val <= max;
  }

  void _addPartner() {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이름과 점수(범위 내)를 모두 입력해주세요."), duration: Duration(seconds: 1)),
      );
      return;
    }

    setState(() {
      partnersList.add({
        "name": _nameCtrl.text.trim(),
        "scores": {
          "equity": double.parse(_equityCtrl.text),
          "finance": double.parse(_financeCtrl.text),
          "power": double.parse(_powerCtrl.text),
          "value": double.parse(_valueCtrl.text),
        }
      });
    });

    // 입력 초기화
    _nameCtrl.clear();
    _equityCtrl.clear();
    _financeCtrl.clear();
    _powerCtrl.clear();
    _valueCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _goToDetailAnalysis() {
    if (partnersList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("파트너를 최소 1명 추가해주세요.")));
      return;
    }
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ResultDetailScreen(
          myScores: widget.myScores, 
          partnersList: partnersList
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("데이터 입력"), 
        elevation: 0, 
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // [1] 내 점수 요약 (슬림 버전)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("내 점수:", style: TextStyle(fontWeight: FontWeight.bold)),
                      _slimScore("지분", widget.myScores['equity']!),
                      _slimScore("자금", widget.myScores['finance']!),
                      _slimScore("권한", widget.myScores['power']!),
                      _slimScore("가치", widget.myScores['value']!),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 [추가됨] 점수 의미 설명 멘트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              color: Colors.grey[200],
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "점수의 높고 낮음은 우열이 아닌 '성향'의 차이를 의미합니다.",
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // [2] 메인 입력 영역 (스크롤 가능)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 파트너 입력 카드
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("파트너 정보 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 10),
                            
                            // 이름 입력
                            TextField(
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                labelText: "이름",
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // 점수 입력 (2x2 그리드)
                            Row(
                              children: [
                                Expanded(child: _compactInput("지분(0~30)", _equityCtrl)),
                                const SizedBox(width: 10),
                                Expanded(child: _compactInput("자금(0~20)", _financeCtrl)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: _compactInput("권한(0~30)", _powerCtrl)),
                                const SizedBox(width: 10),
                                Expanded(child: _compactInput("가치(0~20)", _valueCtrl)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // 추가 버튼
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _addPartner,
                                icon: const Icon(Icons.add),
                                label: const Text("리스트에 추가"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 추가된 파트너 리스트 (Chips)
                    if (partnersList.isNotEmpty)
                      const Text("추가된 파트너 (탭해서 삭제)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: partnersList.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Map user = entry.value;
                        return Chip(
                          backgroundColor: Colors.white,
                          elevation: 1,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text("${idx + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                          label: Text(user['name']),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              partnersList.removeAt(idx);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    // 하단 여백 확보 (스크롤 시 잘림 방지)
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // [3] 하단 고정 분석 버튼
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, -2))],
              ),
              child: ElevatedButton(
                onPressed: _goToDetailAnalysis,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "총 ${partnersList.length + 1}명 분석하기",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상단 내 점수 요약 위젯
  Widget _slimScore(String label, double score) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 4),
        Text(score.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        const SizedBox(width: 8),
      ],
    );
  }

  // 2x2 그리드용 입력 필드
  Widget _compactInput(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        isDense: true,
      ),
    );
  }
}