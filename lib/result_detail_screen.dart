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

    // Reduced animation scale for subtle effect
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
                            color: _accentBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.radar_outlined,
                            color: _accentBlue,
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
                                "총 $totalMembers명의 기준을 시각화했습니다. Gap이 큰 구간은 아이콘으로 강조해 드려요.",
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
                        _pill(icon: Icons.timelapse_outlined, label: "라운드 완료"),
                        const SizedBox(width: 8),
                        _pill(
                          icon: Icons.diversity_3_outlined,
                          label: "$totalMembers명 참여",
                        ),
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

            const SizedBox(height: 20),

            // 인원수에 따른 범례(Legend) 텍스트 변경
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cardBorder, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendIcon(
                    Colors.blueAccent,
                    totalMembers == 2 ? "나" : "나 포함 그룹",
                  ),
                  const SizedBox(width: 24),
                  _buildLegendIcon(
                    Colors.grey[700]!,
                    totalMembers == 2 ? "파트너" : "파트너 그룹",
                  ),
                ],
              ),
            ),

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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.assignment_turned_in_outlined,
                          color: _accentBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "이견도 기록될 때 힘이 됩니다",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "합의된 내용도, 이견이 있는 내용도 '주주간 계약서'로 명문화해야 안전합니다. 초기 구두 약속은 쉽게 변질되기 때문에, 오늘의 결과를 문서로 정리하세요.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, height: 1.5),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Icon(analysis['icon'], color: analysis['color']),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: analysis['color'].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      analysis['status'],
                      style: TextStyle(
                        color: analysis['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                  Color pinColor =
                      containsMe ? _accentBlue : Colors.grey[600]!;

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
          // 헤더 - 팀 회의 아이콘 (왼쪽 정렬)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.groups_rounded, color: accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _accentBlue,
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

                  Color avatarColor = isLeft ? _accentBlue : _accentMint;

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
                            child: Icon(Icons.person, color: Colors.white, size: 20),
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
                            child: Icon(Icons.person, color: Colors.white, size: 20),
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
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _accentBlue.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lightbulb_outline, size: 18, color: _accentBlue),
                ),
                const SizedBox(width: 10),
                const Text(
                  "행동 가이드",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1B1D29),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 행동 가이드 칩들
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: actionGuides
                  .map(
                    (text) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _accentBlue.withOpacity(0.4), width: 1),
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1B1D29),
                        ),
                      ),
                    ),
                  )
                  .toList(),
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
    String headline = "팀원들의 생각이 잘 맞습니다.";
    String desc = "현재 합의를 문서로 정리해보세요.";
    Color color = Colors.green;
    IconData icon = Icons.check_circle;

    int totalCount = allMembers.length;

    // 논의 주제와 행동 가이드 생성
    List<String> discussionTopics =
        _generateDiscussionTopics(category, riskPercent, totalCount);
    List<String> actionGuides =
        _generateActionGuides(category, riskPercent, totalCount);

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

      // [CASE A] 2명일 때
      if (totalCount == 2) {
        String partnerName = allMembers.firstWhere(
          (m) => m['isMe'] == false,
        )['name'];
        headline = "관점의 차이가 발견되었습니다.";
        desc = "아래 주제로 함께 논의해보세요.";
      }
      // [CASE B] 3명 이상일 때
      else {
        List<double> partnerScores = [];
        double myScore = 0;
        for (var m in allMembers) {
          var sMap = m['scores'];
          double s = (sMap is Map<String, double>)
              ? sMap[category]!
              : (sMap[category] as num).toDouble();
          if (m['isMe']) {
            myScore = s;
          } else {
            partnerScores.add(s);
          }
        }
        partnerScores.sort();
        double partnerSpread = partnerScores.isNotEmpty
            ? partnerScores.last - partnerScores.first
            : 0;
        double partnerSpreadPercent = (partnerSpread / maxScore) * 100;

        if (partnerSpreadPercent >= 30) {
          headline = "관점의 차이가 발견되었습니다.";
          desc = "아래 주제로 함께 논의해보세요.";
        } else {
          double avgPartnerScore =
              partnerScores.reduce((a, b) => a + b) / partnerScores.length;
          double distFromMe = (myScore - avgPartnerScore).abs();

          if (distFromMe > partnerSpread) {
            headline = "관점의 차이가 발견되었습니다.";
            desc = "아래 주제로 함께 논의해보세요.";
          } else {
            headline = "관점의 차이가 발견되었습니다.";
            desc = "아래 주제로 함께 논의해보세요.";
          }
        }
      }
    }
    // --- ⚠️ 주의 구간 ---
    else if (riskPercent >= 20) {
      status = "⚠️ 조율 필요";
      color = Colors.orange;
      icon = Icons.info_outline;

      headline = "조율이 필요한 부분이 있습니다.";
      desc = "함께 정리해보세요.";
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

  // 함께 논의해볼 주제 생성
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
          "지분 배분의 기준과 원칙",
          "향후 추가 투자 시 지분 희석 방안",
          "지분 이전 및 매각 조건",
        ];
      } else if (category == "finance") {
        topics = [
          "자금 조달 방식과 우선순위",
          "예산 배분 및 지출 승인 프로세스",
          "재무 투명성 확보 방안",
        ];
      } else if (category == "power") {
        topics = [
          "의사결정 권한과 책임 범위",
          "리더십 역할 분담",
          "갈등 상황 시 해결 절차",
        ];
      } else if (category == "value") {
        topics = [
          "팀의 핵심 가치와 원칙",
          "협업 방식과 커뮤니케이션 스타일",
          "서로의 기대치와 우선순위",
        ];
      }
    } else if (riskPercent >= 20) {
      // 주의 구간
      if (category == "equity") {
        topics = [
          "지분 관련 세부 조건 명확화",
          "향후 지분 변동 시나리오",
        ];
      } else if (category == "finance") {
        topics = [
          "자금 운용 원칙 재확인",
          "예산 관리 프로세스 점검",
        ];
      } else if (category == "power") {
        topics = [
          "의사결정 프로세스 개선",
          "역할과 책임 재정의",
        ];
      } else if (category == "value") {
        topics = [
          "팀 문화와 가치관 정리",
          "협업 방식 개선 방안",
        ];
      }
    } else {
      // 안정 구간
      topics = [
        "현재 합의사항 문서화",
        "향후 변경 시 고려사항",
      ];
    }

    return topics;
  }

  // 행동 가이드 생성
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
          "지분 배분 기준을 명확히 문서화하세요",
          "향후 지분 변동 시나리오를 미리 정해두세요",
          "법률 자문을 받아 계약서에 반영하세요",
          "지분 이전 및 매각 조건을 구체화하세요",
        ];
      } else if (category == "finance") {
        guides = [
          "자금 조달 및 운용 원칙을 명확히 정하세요",
          "예산 승인 프로세스를 문서로 정립하세요",
          "재무 투명성을 위한 정기 보고 체계를 구축하세요",
          "비상 자금 운용 방안을 사전에 합의하세요",
        ];
      } else if (category == "power") {
        guides = [
          "의사결정 권한과 책임 범위를 명확히 하세요",
          "갈등 해결 절차를 문서로 정립하세요",
          "리더십 역할을 구체적으로 분담하세요",
          "중재 메커니즘을 사전에 마련하세요",
        ];
      } else if (category == "value") {
        guides = [
          "팀의 핵심 가치를 함께 정의하고 문서화하세요",
          "서로의 기대치와 우선순위를 명확히 공유하세요",
          "협업 방식과 커뮤니케이션 스타일을 정하세요",
          "가치관 차이를 존중하는 방법을 찾으세요",
        ];
      }
    } else if (riskPercent >= 20) {
      // 주의 구간
      if (category == "equity") {
        guides = [
          "지분 관련 세부 조건을 문서로 정리하세요",
          "향후 지분 변동 가능성을 함께 검토하세요",
        ];
      } else if (category == "finance") {
        guides = [
          "자금 운용 원칙을 재확인하고 문서화하세요",
          "예산 관리 프로세스를 점검하고 개선하세요",
        ];
      } else if (category == "power") {
        guides = [
          "의사결정 프로세스를 개선하고 명확히 하세요",
          "역할과 책임을 재정의하고 공유하세요",
        ];
      } else if (category == "value") {
        guides = [
          "팀 문화와 가치관을 정리하고 공유하세요",
          "협업 방식을 점검하고 개선 방안을 모색하세요",
        ];
      }
    } else {
      // 안정 구간
      if (category == "equity") {
        guides = [
          "현재 지분 합의사항을 계약서에 명확히 기록하세요",
          "정기적으로 지분 관련 사항을 점검하세요",
        ];
      } else if (category == "finance") {
        guides = [
          "자금 운용 합의사항을 문서로 정리하세요",
          "재무 현황을 정기적으로 공유하세요",
        ];
      } else if (category == "power") {
        guides = [
          "의사결정 구조를 계약서에 명시하세요",
          "역할 분담을 정기적으로 점검하세요",
        ];
      } else if (category == "value") {
        guides = [
          "팀의 가치관과 원칙을 문서화하세요",
          "협업 방식을 정기적으로 점검하세요",
        ];
      }
    }

    return guides;
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _accentBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
