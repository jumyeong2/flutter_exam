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

  // 메인 컬러
  final Color _mainColor = const Color(0xFF64B5F6);

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
    if (_nameCtrl.text.trim().isEmpty) return false;
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
        SnackBar(
          content: const Text("이름과 점수(범위 내)를 정확히 입력해주세요."),
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
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

    _nameCtrl.clear();
    _equityCtrl.clear();
    _financeCtrl.clear();
    _powerCtrl.clear();
    _valueCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _goToDetailAnalysis() {
    if (partnersList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("최소 1명 이상의 파트너를 추가해주세요.")),
      );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("데이터 입력"), 
        elevation: 0, 
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // [핵심] Spacer 제거하고 자연스러운 흐름으로 배치
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [1] 내 점수 요약
              Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                color: Colors.grey[50], 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _slimScore("지분", widget.myScores['equity']!, Colors.purple[300]!),
                    _slimScore("자금", widget.myScores['finance']!, Colors.teal[300]!),
                    _slimScore("권한", widget.myScores['power']!, Colors.orange[300]!),
                    _slimScore("가치", widget.myScores['value']!, Colors.pink[300]!),
                  ],
                ),
              ),

              // 안내 문구 (왼쪽 정렬)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      "점수는 우열이 아닌 '성향'의 차이를 의미합니다.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15), // 간격 줄임 (위로 올리기 위해)

              // [2] 파트너 입력 폼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("파트너 정보 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    
                    _compactTextField(label: "이름", hint: "예: 김철수", controller: _nameCtrl, icon: Icons.person_outline),
                    const SizedBox(height: 10),
                    
                    Row(
                      children: [
                        Expanded(child: _compactScoreField("지분 (0~30)", _equityCtrl)),
                        const SizedBox(width: 10),
                        Expanded(child: _compactScoreField("자금 (0~20)", _financeCtrl)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _compactScoreField("권한 (0~30)", _powerCtrl)),
                        const SizedBox(width: 10),
                        Expanded(child: _compactScoreField("가치 (0~20)", _valueCtrl)),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // 리스트 담기 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _addPartner,
                        icon: Icon(Icons.add, color: _mainColor),
                        label: Text("리스트에 담기", style: TextStyle(color: _mainColor, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _mainColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // 버튼 사이 간격

              // [3] 대기 명단 (있을 때만 표시)
              if (partnersList.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text("분석 대기 (${partnersList.length}명)", style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 40, 
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: partnersList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Chip(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[300]!),
                        avatar: CircleAvatar(
                          radius: 10,
                          backgroundColor: _mainColor.withOpacity(0.2),
                          child: Text("${index + 1}", style: TextStyle(fontSize: 10, color: _mainColor, fontWeight: FontWeight.bold)),
                        ),
                        label: Text(partnersList[index]['name'], style: const TextStyle(fontSize: 12)),
                        onDeleted: () => setState(() => partnersList.removeAt(index)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // [4] 분석 시작 버튼 (이제 바로 아래에 붙음)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: _goToDetailAnalysis,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    "총 ${partnersList.length + 1}명 분석 시작",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 30), // 하단 여백 조금
            ],
          ),
        ),
      ),
    );
  }

  // 상단 내 점수 요약 (Slim)
  Widget _slimScore(String label, double score, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(score.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
      ],
    );
  }

  // 컴팩트한 입력 필드
  Widget _compactTextField({required String label, required String hint, required TextEditingController controller, required IconData icon}) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 18, color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _mainColor)),
        ),
      ),
    );
  }

  // 점수 입력 필드
  Widget _compactScoreField(String hint, TextEditingController controller) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _mainColor)),
        ),
      ),
    );
  }
}