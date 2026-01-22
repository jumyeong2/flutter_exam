import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'share_utils.dart';

// 1. 열거형 정의
enum FounderType { shark, owl, dolphin }

// 2. 프로필 데이터 클래스
class FounderProfile {
  final FounderType type;
  final String name; // 유형 이름
  final String animal; // 이모지
  final String slogan; // 한 줄 요약
  final String desc; // 상세 설명
  final List<String> pros; // 장점
  final List<String> cons; // 단점

  FounderProfile({
    required this.type,
    required this.name,
    required this.animal,
    required this.slogan,
    required this.desc,
    required this.pros,
    required this.cons,
  });
}

// 3. 데이터 인스턴스 (Shark, Owl, Dolphin)
final sharkProfile = FounderProfile(
  type: FounderType.shark,
  name: "냉철한 승부사",
  animal: "🦈",
  slogan: "생존과 효율이 최우선",
  desc:
      "당신은 회사의 생존을 위해 감정을 배제하고 냉정한 판단을 내리는 '샤크' 유형입니다.\n리스크를 관리하고 명확한 룰을 세우는 데 탁월합니다.",
  pros: ["위기 상황에서의 빠른 결단력", "명확한 역할과 책임 구분", "투자자가 선호하는 리스크 관리"],
  cons: ["팀원의 감정을 놓칠 수 있음", "지나친 효율 추구로 인한 갈등", "차가워 보일 수 있음"],
);

final owlProfile = FounderProfile(
  type: FounderType.owl,
  name: "지혜로운 조율자",
  animal: "🦉",
  slogan: "데이터와 논리의 균형",
  desc:
      "당신은 감정과 효율 사이에서 최적의 균형을 찾는 '올빼미' 유형입니다.\n객관적인 근거와 시장 표준을 중요하게 생각하며 합리적인 중재를 이끌어냅니다.",
  pros: ["데이터 기반의 객관적 판단", "갈등 상황에서의 뛰어난 중재", "안정적인 조직 운영"],
  cons: ["결정이 다소 늦어질 수 있음", "강한 카리스마 부족", "지나친 신중함"],
);

final dolphinProfile = FounderProfile(
  type: FounderType.dolphin,
  name: "진심의 리더",
  animal: "🐬",
  slogan: "사람과 비전이 먼저",
  desc:
      "당신은 팀의 신뢰와 비전을 가장 중요하게 여기는 '돌고래' 유형입니다.\n단기적 이익보다 함께하는 사람들과의 가치를 지키며 팀을 이끕니다.",
  pros: ["강력한 팀 결속력 구축", "위기를 버티게 하는 동기부여", "건강한 사내 문화 형성"],
  cons: ["수익성보다 이상을 좇을 위험", "냉정한 피드백의 어려움", "속도 저하 우려"],
);

// 4. 점수 계산 및 유형 판별 로직 클래스
class FounderTypeCalculator {
  // 점수에 따른 프로필 반환 함수
  static FounderProfile getProfileByScore(double totalScore) {
    // 총점 범위: 0 ~ 120점 (12문항 * 10점 만점)

    if (totalScore <= 40) {
      // 0 ~ 40점: Shark (현실/생존 중심)
      return sharkProfile;
    } else if (totalScore < 80) {
      // 41 ~ 79점: Owl (균형/논리 중심)
      // 정확히 중간(모두 5점 선택 시 60점)을 포함하는 구간
      return owlProfile;
    } else {
      // 80 ~ 120점: Dolphin (관계/이상 중심)
      return dolphinProfile;
    }
  }

  // (선택사항) 점수 구간에 대한 설명을 보고 싶을 때 사용
  static String getScoreRangeDescription(FounderType type) {
    switch (type) {
      case FounderType.shark:
        return "총점 0~40점 구간 (현실주의 성향 강함)";
      case FounderType.owl:
        return "총점 41~79점 구간 (밸런스 성향 강함)";
      case FounderType.dolphin:
        return "총점 80~120점 구간 (이상주의 성향 강함)";
    }
  }
}

class ResultScreen2 extends StatelessWidget {
  final Map<String, double> myScores;

  const ResultScreen2({super.key, required this.myScores});

  @override
  Widget build(BuildContext context) {
    // 1. 총점 계산
    double totalScore = myScores.values.fold(0, (sum, score) => sum + score);

    // 2. 유형 판별
    FounderProfile profile = FounderTypeCalculator.getProfileByScore(
      totalScore,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB), // 연한 배경색
      appBar: AppBar(
        title: const Text(
          "나의 창업가 유형",
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined, color: Color(0xFF111827)),
            tooltip: "URL 복사",
            onPressed: () => _copyUrl(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF111827)),
            tooltip: "결과 공유",
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 3. 동물 이모지와 이름 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(profile.animal, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.slogan,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3B82F6), // 메인 포인트 컬러
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    profile.desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. 장점 섹션
            _buildInfoCard(
              title: "이런 점이 좋아요 👍",
              items: profile.pros,
              icon: Icons.thumb_up_alt_outlined,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),

            // 5. 단점(주의할 점) 섹션
            _buildInfoCard(
              title: "이건 조심하세요 ⚠️",
              items: profile.cons,
              icon: Icons.warning_amber_rounded,
              color: Colors.orangeAccent,
            ),

            const SizedBox(height: 40),

            // 6. 하단 버튼 (확인 완료 + 테스트 다시 하기)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "확인 완료",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // 처음 페이지로 돌아가기
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF3B82F6),
                        side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "테스트 다시 하기",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyUrl(BuildContext context) async {
    // 유형 정보 가져오기
    double totalScore = myScores.values.fold(0, (sum, score) => sum + score);
    FounderProfile profile = FounderTypeCalculator.getProfileByScore(totalScore);
    
    final shareUrl = ShareUtils.generateProfileShareUrl(myScores);
    final shareText = '''${profile.animal} 나의 창업가 유형: ${profile.name}

${profile.slogan}

${profile.desc}

자세한 결과 보기:
$shareUrl''';
    
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
    // 유형 정보 가져오기
    double totalScore = myScores.values.fold(0, (sum, score) => sum + score);
    FounderProfile profile = FounderTypeCalculator.getProfileByScore(totalScore);
    
    final shareUrl = ShareUtils.generateProfileShareUrl(myScores);
    final shareText = '''${profile.animal} 나의 창업가 유형: ${profile.name}

${profile.slogan}

${profile.desc}

자세한 결과 보기:
$shareUrl''';
    
    try {
      await Share.share(
        shareText,
        subject: '나의 창업가 유형 결과',
      );
    } catch (e) {
      // 에러 발생 시 처리
    }
  }

  Widget _buildInfoCard({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF424242),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
