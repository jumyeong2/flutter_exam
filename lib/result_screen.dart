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
  final Color _mainColor = const Color(0xFF3B82F6);

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
        },
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("최소 1명 이상의 파트너를 추가해주세요.")));
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        title: const Text(
          "팀 데이터 입력",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInputGuide(context),
            icon: const Icon(
              Icons.download_done_outlined,
              color: Color(0xFF111827),
            ),
            tooltip: "입력 가이드",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // 전체 목적 설명 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF60A5FA),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.map_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "3단계로 팀 궁합을 확인하세요",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStepItem("1", "내 점수 확인", "테스트로 계산된 나의 성향"),
                        const SizedBox(height: 10),
                        _buildStepItem("2", "파트너 점수 입력", "함께 할 팀원의 점수 추가"),
                        const SizedBox(height: 10),
                        _buildStepItem("3", "궁합 분석 시작", "누구와 맞고, 어디서 부딪힐지 확인"),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _scoreSummaryCard(),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE6ECF7)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF60A5FA),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.group_add_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "파트너 정보 입력",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "파트너도 같은 테스트를 했나요?",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "있으면 그대로 입력 | 없으면 추측해서 입력",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _compactTextField(
                          label: "파트너 이름",
                          hint: "예: 김철수",
                          controller: _nameCtrl,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _compactScoreField(
                                "지분 (0~30)",
                                _equityCtrl,
                                Icons.workspace_premium_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _compactScoreField(
                                "자금 (0~20)",
                                _financeCtrl,
                                Icons.savings_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _compactScoreField(
                                "권한 (0~30)",
                                _powerCtrl,
                                Icons.gavel_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _compactScoreField(
                                "가치 (0~20)",
                                _valueCtrl,
                                Icons.favorite_border,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addPartner,
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: _mainColor,
                            ),
                            label: Text(
                              "리스트에 담기",
                              style: TextStyle(
                                color: _mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              side: BorderSide(
                                color: _mainColor.withOpacity(0.6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // [3] 대기 명단 (있을 때만 표시)
              if (partnersList.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "분석 대기 (${partnersList.length}명)",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                        side: BorderSide(color: const Color(0xFFE6ECF7)),
                        avatar: CircleAvatar(
                          radius: 10,
                          backgroundColor: _mainColor.withOpacity(0.2),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 10,
                              color: _mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        label: Text(
                          partnersList[index]['name'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        onDeleted: () =>
                            setState(() => partnersList.removeAt(index)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "최종 분석 준비 완료",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "총 ${partnersList.length + 1}명의 기준을 한 번에 비교합니다.",
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FilledButton.icon(
                  onPressed: _goToDetailAnalysis,
                  icon: const Icon(Icons.auto_graph_rounded),
                  label: Text("총 ${partnersList.length + 1}명 분석 시작"),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreSummaryCard() {
    final entries = <(String, double, Color, IconData, int)>[
      (
        "지분",
        widget.myScores['equity']!,
        const Color(0xFFEC4899),
        Icons.workspace_premium_outlined,
        30,
      ),
      (
        "자금",
        widget.myScores['finance']!,
        const Color(0xFFF59E0B),
        Icons.savings_outlined,
        20,
      ),
      (
        "권한",
        widget.myScores['power']!,
        const Color(0xFF10B981),
        Icons.gavel_outlined,
        30,
      ),
      (
        "가치",
        widget.myScores['value']!,
        const Color(0xFF8B5CF6),
        Icons.favorite_border,
        20,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.equalizer_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "나의 성향 스냅샷",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "내가 중요하게 생각하는 영역을 확인하세요",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "높은 점수 = 관계/신뢰 중시 | 낮은 점수 = 구조/효율 중시",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              children: entries
                  .map(
                    (item) => _scoreBadge(
                      item.$1,
                      item.$2,
                      item.$3,
                      item.$4,
                      item.$5.toDouble(),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBadge(
    String label,
    double value,
    Color color,
    IconData icon,
    double max,
  ) {
    final percent = (value / max).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${value.toStringAsFixed(0)} / ${max.toStringAsFixed(0)}",
            style: TextStyle(color: color, fontSize: 13),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF7B88A1)),
      ),
    );
  }

  // 점수 입력 필드
  Widget _compactScoreField(
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF7B88A1)),
      ),
    );
  }

  void _showInputGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.tune),
                SizedBox(width: 8),
                Text("입력 가이드", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text("• 각 카테고리의 최대 점수를 넘지 않도록 입력해주세요."),
            const SizedBox(height: 6),
            const Text("• 측정 대상이 모호하면 바로 직전 라운드에서 논의된 기준을 참고하세요."),
            const SizedBox(height: 6),
            const Text("• 입력한 데이터는 기기에만 저장됩니다."),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _mainColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _mainColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
