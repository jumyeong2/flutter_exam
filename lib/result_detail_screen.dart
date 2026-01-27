import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'share_utils.dart';

class ResultDetailScreen extends StatefulWidget {
  final Map<String, double> myScores;
  final List<Map<String, dynamic>> partnersList;

  const ResultDetailScreen({
    super.key,
    required this.myScores,
    required this.partnersList,
  });

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accentBlue = Color(0xFF6B8AFF);
  static const Color _accentMint = Color(0xFF6ED3C1);
  static const Color _accentGray = Color(0xFF5A5A5A);
  static const Color _cardBorder = Color(0xFFD8E0FF);
  static const Color _softBlueBg = Colors.white;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Pulsing effect

    // Subtle animation scale for button
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 전체 멤버 리스트 생성
    List<Map<String, dynamic>> allMembers = [
      {"name": "나", "scores": widget.myScores, "isMe": true},
      ...widget.partnersList.map((p) => {...p, "isMe": false}),
    ];

    // 참여 인원 수 확인
    int totalMembers = allMembers.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text("팀 성향 분포도"),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: "URL 복사",
            onPressed: () => _copyUrl(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: "결과 공유",
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: _cardBorder, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _accentBlue.withOpacity(0.9),
                                _accentBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: _accentBlue.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "우리 팀은 한 방향을 보고 있을까요?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "총 $totalMembers명의 기준을 시각화했습니다. 관점 차이가 큰 부분은 합의를 통해 정리하세요.",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _pill(
                          icon: Icons.diversity_3_outlined,
                          label: "$totalMembers명 참여",
                        ),
                        const Spacer(),
                        _buildLegendIcon(_accentBlue, "나"),
                        const SizedBox(width: 16),
                        _buildLegendIcon(Colors.grey[700]!, "파트너"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4대 영역별 분포도 카드
            _buildDistributionCard("👑 지분(소유권)", "equity", 30, allMembers),
            _buildDistributionCard("💰 자금(운용)", "finance", 20, allMembers),
            _buildDistributionCard("⚖️ 권한(리더십)", "power", 30, allMembers),
            _buildDistributionCard("❤️ 가치(태도)", "value", 20, allMembers),

            const SizedBox(height: 40),

            // 하단 안내 메시지
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: _cardBorder, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _accentBlue.withOpacity(0.9),
                                _accentBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _accentBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "이견도 기록될 때 힘이 됩니다",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFF1B1D29),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "합의된 내용도, 이견이 있는 내용도 명문화해야 안전합니다.\n초기 구두 약속은 쉽게 변질되기 때문에, 오늘의 결과를 문서로 정리하세요.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Primary CTA Button
            ScaleTransition(
              scale: _scaleAnimation,
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(
                      'https://cosyncagreement.web.app',
                    );
                    try {
                      final launched = await launchUrl(
                        url,
                        mode: LaunchMode.platformDefault,
                      );
                      if (!launched && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("페이지를 열 수 없습니다.")),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("페이지를 열 수 없습니다.")),
                        );
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "우리 팀 합의 상태 점검하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[700]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: riskPercent >= 50 ? Colors.red.shade100 : _cardBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          // 이름표가 쌓일 공간 확보를 위해 상단 여백 (오버플로우 방지)
          const SizedBox(height: 50),

          // [시각화] 라인(Line) 위로 그룹 배치
          SizedBox(
            height: 110,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [
                          _accentBlue.withOpacity(0.45),
                          _accentMint.withOpacity(0.45),
                          _accentBlue.withOpacity(0.25),
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
                  Color pinColor = containsMe ? _accentBlue : Colors.grey[600]!;

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
                        Icon(Icons.fmd_good_rounded, color: pinColor, size: 30),
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
              Text("구조/효율", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("관계/신뢰", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: analysis['color'].withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: analysis['color'].withOpacity(0.4),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(analysis['icon'], size: 20, color: analysis['color']),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        analysis['headline'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: analysis['color'],
                          fontSize: 16,
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

          // 함께 논의해볼 주제 + 행동 가이드 (통합 카드)
          if ((analysis['discussionTopics'] as List<String>).isNotEmpty ||
              (analysis['actionGuides'] as List<String>).isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildQuestionCards(
              title: "함께 논의해볼 주제",
              icon: Icons.chat_bubble_outline,
              questions: analysis['discussionTopics'] as List<String>,
              actionGuides: analysis['actionGuides'] as List<String>,
              accent: _accentBlue,
              showCard: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionCards({
    required String title,
    required IconData icon,
    required List<String> questions,
    required List<String> actionGuides,
    required Color accent,
    bool showCard = true,
  }) {
    final content = Column(
      children: [
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        const SizedBox(height: 18),
        // 헤더 - 숫자 배지 + 타이틀
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _accentBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "1",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _accentBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1D29),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 메신저 스타일 카드들 - 중앙 정렬
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: questions.asMap().entries.map((entry) {
                int index = entry.key;
                String question = entry.value;
                bool isLeft = index % 2 == 0;

                Color avatarColor = isLeft ? _accentBlue : _accentGray;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 왼쪽 메시지
                      if (isLeft) ...[
                        // 사람 아바타
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                avatarColor.withOpacity(0.8),
                                avatarColor,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: avatarColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 말풍선
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                              bottomLeft: Radius.circular(4),
                            ),
                            border: Border.all(
                              color: avatarColor.withOpacity(0.25),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: avatarColor.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            question,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF1B1D29),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],

                      // 오른쪽 메시지
                      if (!isLeft) ...[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(4),
                            ),
                            border: Border.all(
                              color: avatarColor.withOpacity(0.25),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: avatarColor.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            question,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF1B1D29),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                avatarColor.withOpacity(0.8),
                                avatarColor,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: avatarColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // 행동 가이드 섹션
        if (actionGuides.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 20),

          // 행동 가이드 헤더
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _accentBlue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _accentBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "행동 가이드",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF1B1D29),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 행동 가이드 칩들
          Column(
            children: List.generate((actionGuides.length / 2).ceil(), (index) {
              final int firstIndex = index * 2;
              final int secondIndex = firstIndex + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _accentBlue.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _accentBlue.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            actionGuides[firstIndex],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1B1D29),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: secondIndex < actionGuides.length
                            ? Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _accentBlue.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _accentBlue.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  actionGuides[secondIndex],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1B1D29),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );

    if (!showCard) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _softBlueBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder, width: 1.5),
      ),
      child: content,
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
    String headline = "팀원들의 생각이 비슷해요.";
    String desc = "비슷한 생각을 문서로 기록해 두면, 향후 혼란을 예방할 수 있어요.";
    Color color = Colors.green;
    IconData icon = Icons.check_circle;

    int totalCount = allMembers.length;

    // 논의 주제와 행동 가이드 생성
    List<String> discussionTopics = _generateDiscussionTopics(
      category,
      riskPercent,
      totalCount,
    );
    List<String> actionGuides = _generateActionGuides(
      category,
      riskPercent,
      totalCount,
    );

    if (scores.isEmpty) {
      return {
        "status": status,
        "headline": headline,
        "desc": desc,
        "color": color,
        "icon": icon,
        "discussionTopics": discussionTopics,
        "actionGuides": actionGuides,
      };
    }

    // --- 🚨 고위험 구간 ---
    if (riskPercent >= 50) {
      status = "🚨 관점의 양극화";
      color = Colors.redAccent;
      icon = Icons.warning_amber_rounded;

      // 카테고리별 맞춤 메시지
      if (category == "equity") {
        headline = "지분 배분에 대한 생각 차이가 큽니다.";
        desc = "이견을 조율하지 않으면 향후 분쟁의 원인이 될 수 있어요. 지금 명확히 정리하세요.";
      } else if (category == "finance") {
        headline = "자금 운용 방식에 대한 이견이 있습니다.";
        desc = "재무 결정은 신뢰의 핵심입니다. 투명한 기준을 함께 만들어보세요.";
      } else if (category == "power") {
        headline = "의사결정 권한에 대한 관점이 다릅니다.";
        desc = "권한 분배가 불명확하면 갈등이 생기기 쉬워요. 역할과 책임을 구체화하세요.";
      } else if (category == "value") {
        headline = "팀 운영 가치관에 차이가 있습니다.";
        desc = "일하는 방식과 우선순위가 다르면 협업이 어려워요. 공통 원칙을 세워보세요.";
      } else {
        headline = "관점의 차이가 발견되었습니다.";
        desc = "아래 주제로 함께 논의하고, 명확한 합의를 만들어보세요.";
      }
    }
    // --- ⚠️ 주의 구간 ---
    else if (riskPercent >= 20) {
      status = "⚠️ 조율 필요";
      color = Colors.orange;
      icon = Icons.info_outline;

      // 카테고리별 맞춤 메시지
      if (category == "equity") {
        headline = "지분 배분에 대해 한 번 더 점검이 필요해요.";
        desc = "나중에 분쟁이 생기기 전에 지금 정리가 필요합니다.";
      } else if (category == "finance") {
        headline = "자금 관리 방식을 함께 확인해보세요.";
        desc = "나중에 재무 이슈가 생기기 전에 지금 정리가 필요합니다.";
      } else if (category == "power") {
        headline = "의사결정 방식을 명확히 할 필요가 있어요.";
        desc = "나중에 권한 갈등이 생기기 전에 지금 정리가 필요합니다.";
      } else if (category == "value") {
        headline = "협업 방식에 대해 이야기 나눠보세요.";
        desc = "나중에 협업 문제가 생기기 전에 지금 정리가 필요합니다.";
      } else {
        headline = "조율이 필요한 부분이 있습니다.";
        desc = "나중에 이슈가 생기기 전에 지금 정리가 필요합니다.";
      }
    }
    // --- ✅ 안전 구간 ---
    else {
      // 카테고리별 맞춤 메시지
      if (category == "equity") {
        headline = "지분 배분에 대한 생각이 비슷해요.";
        desc = "비슷한 생각을 계약서에 명시하면, 향후 분쟁을 예방할 수 있어요.";
      } else if (category == "finance") {
        headline = "자금 운용에 대한 생각이 비슷해요.";
        desc = "재무 투명성 확보를 위해 지금의 기준을 문서화해 두세요.";
      } else if (category == "power") {
        headline = "의사결정 방식에 대한 생각이 비슷해요.";
        desc = "권한과 책임을 명확히 문서화하면 업무가 더 효율적이에요.";
      } else if (category == "value") {
        headline = "팀 운영에 대한 가치관이 비슷해요.";
        desc = "좋은 팀 문화를 유지하려면 공통 가치를 정리해 두세요.";
      }
    }

    return {
      "status": status,
      "headline": headline,
      "desc": desc,
      "color": color,
      "icon": icon,
      "discussionTopics": discussionTopics,
      "actionGuides": actionGuides,
    };
  }

  // 함께 논의해볼 주제 생성 (Speech Bubbles - Insightful Topics)
  List<String> _generateDiscussionTopics(
    String category,
    double riskPercent,
    int totalCount,
  ) {
    List<String> topics = [];

    if (riskPercent >= 50) {
      // 고위험 구간
      if (category == "equity") {
        topics = [
          "기여도 변화에 따른 지분 조정 장치",
          "이탈 시 잔여 지분 처분(Call option) 기준",
          "추가 투자 유치 시 희석 방어 전략",
        ];
      } else if (category == "finance") {
        topics = [
          "개인 자금 투입 시 상환/전환 기준",
          "데스밸리(Runway) 대비 긴축 운영 시점",
          "자금 집행의 투명성 확보 원칙",
        ];
      } else if (category == "power") {
        topics = [
          "의견 대립 시 최종 의사결정권(Tie-breaker)",
          "경영권 방어를 위한 의결권 비중 설계",
          "리더십 위임과 회수 조건",
        ];
      } else if (category == "value") {
        topics = [
          "업무 몰입도와 워킹 타임(Working Time) 동기화",
          "건강한 충돌을 위한 피드백 프로토콜",
          "팀의 성공 정의와 우선순위 정렬",
        ];
      }
    } else if (riskPercent >= 20) {
      // 주의 구간
      if (category == "equity") {
        topics = ["지분 희석 시나리오 점검", "스톡옵션 풀(Pool) 규모와 부여 기준"];
      } else if (category == "finance") {
        topics = ["월간 자금 소진율(Burn Rate) 관리", "비용 집행의 전결 규정"];
      } else if (category == "power") {
        topics = ["C-Level 역할 정의(R&R) 미세 조정", "위임할 권한과 직접 챙길 권한의 구분"];
      } else if (category == "value") {
        topics = ["비동기 커뮤니케이션 룰 세팅", "상호 피드백 주기와 방식"];
      }
    } else {
      // 안정 구간
      topics = ["현재의 합의 내용을 SHA(주주간계약서)에 반영", "정기적인 지분/권한 재점검 주기 설정"];
    }

    return topics;
  }

  // 행동 가이드 생성 (Action Guides - Concrete Tools)
  List<String> _generateActionGuides(
    String category,
    double riskPercent,
    int totalCount,
  ) {
    List<String> guides = [];

    if (riskPercent >= 50) {
      // 고위험 구간
      if (category == "equity") {
        guides = [
          "4년 베스팅(Vesting) 및 클리프(Cliff) 설정",
          "주주간 계약서(SHA) 필수 작성",
          "태그얼롱(Tag-along) 및 드래그얼롱(Drag-along) 조항 검토",
        ];
      } else if (category == "finance") {
        guides = [
          "법인 카드 사용 및 지출 결재 규정 수립",
          "월간 현금 흐름표(Cash Flow) 공유 정례화",
          "가수금/대여금 처리 원칙 문서화",
        ];
      } else if (category == "power") {
        guides = [
          "C-Level 역할 정의(R&R) 및 위임전결 규정",
          "이사회 구성 및 의결 정족수 합의",
          "교착 상태 해결(Deadlock) 조항 마련",
        ];
      } else if (category == "value") {
        guides = [
          "그라운드 룰(Ground Rule) 및 코어 타임 설정",
          "정기 회고(Retrospective) 및 1on1 미팅",
          "갈등 해결을 위한 중재자(Advisor) 선임",
        ];
      }
    } else if (riskPercent >= 20) {
      // 주의 구간
      if (category == "equity") {
        guides = ["표준 주주간 계약서 검토 및 날인", "스톡옵션 운영 규정 초안 작성"];
      } else if (category == "finance") {
        guides = ["지출 품의서 및 영수증 증빙 룰셋팅", "분기별 예산 계획 수립"];
      } else if (category == "power") {
        guides = ["주간 업무 보고 및 의사결정 미팅 체계화", "직무 기술서(JD) 기반 R&R 명문화"];
      } else if (category == "value") {
        guides = ["팀 컬처덱(Culture Deck) v1.0 작성", "커뮤니케이션 가이드라인 공유"];
      }
    } else {
      // 안정 구간
      if (category == "equity") {
        guides = ["주주명부 현행화 및 관리", "투자 유치 대비 Cap Table 시뮬레이션"];
      } else if (category == "finance") {
        guides = ["재무/회계 관리 대시보드 구축", "정기 재무 리포팅 체계 유지"];
      } else if (category == "power") {
        guides = ["경영진 위임전결 규정 고도화", "성과 기반 보상 및 승진 체계 구상"];
      } else if (category == "value") {
        guides = ["온보딩 프로세스에 핵심 가치 반영", "조직 문화 만족도 정기 조사"];
      }
    }

    return guides;
  }

  void _copyUrl(BuildContext context) async {
    // 전체 멤버 리스트 생성
    List<Map<String, dynamic>> allMembers = [
      {"name": "나", "scores": widget.myScores, "isMe": true},
      ...widget.partnersList.map((p) => {...p, "isMe": false}),
    ];

    int totalMembers = allMembers.length;

    final shareUrl = ShareUtils.generateTeamShareUrl(
      widget.myScores,
      widget.partnersList,
    );

    String shareText = '👥 우리 팀 합의 상태 점검 결과\n\n';
    shareText += '총 $totalMembers명이 참여했습니다.\n\n';
    shareText += '💬 함께 확인하고 이야기해보세요.\n\n';
    shareText += '자세한 결과 보기:\n$shareUrl';

    await Clipboard.setData(ClipboardData(text: shareText));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL이 클립보드에 복사되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareResult(BuildContext context) async {
    // 전체 멤버 리스트 생성
    List<Map<String, dynamic>> allMembers = [
      {"name": "나", "scores": widget.myScores, "isMe": true},
      ...widget.partnersList.map((p) => {...p, "isMe": false}),
    ];

    int totalMembers = allMembers.length;

    final shareUrl = ShareUtils.generateTeamShareUrl(
      widget.myScores,
      widget.partnersList,
    );

    String shareText = '👥 우리 팀 합의 상태 점검 결과\n\n';
    shareText += '총 $totalMembers명이 참여했습니다.\n\n';
    shareText += '💬 함께 확인하고 이야기해보세요.\n\n';
    shareText += '자세한 결과 보기:\n$shareUrl';

    try {
      await Share.share(shareText, subject: '팀 합의 상태 점검 결과');
    } catch (e) {
      // 에러 발생 시 처리
    }
  }
}
