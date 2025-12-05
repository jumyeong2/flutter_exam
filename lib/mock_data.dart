import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  // 👑 [EQUITY] 지분 및 소유권 (3문제) - 가장 중요!
 ConflictScenario(
  id: "Q1",
  category: "equity",
  questionText: "법인 설립을 앞두고 지분을 정하는 날입니다. \n"
      "공동창업자 E는 성격도 좋고, 당신이 시키는 개발 업무는 기한 맞춰 성실하게 해옵니다. \n"
      "하지만 딱 거기까지입니다. \n"
      "아이디어 제안이나 문제 해결을 위한 고민은 오직 당신의 몫이고, E는 수동적으로 업무만 처리합니다. \n"
      "E는 당연히 우리가 '공동대표'로서 5:5를 가져간다고 생각합니다. \n"
      "창업가가 아닌 '직원' 같은 E와의 지분 설정, 어떻게 하시겠습니까?",
  options: [
    ScenarioOption(
      // 0점: 냉정한 현실 자각 (Role adjustment)
      text: "💼 직급 조정: '넌 창업가 성향이 아냐.' 솔직하게 말하고, 지분을 대폭 낮추는 대신 월급을 더 주는 '초기 멤버' 대우로 변경합니다.",
      score: 0.0,
    ),
    ScenarioOption(
      // 5점: 안전장치 마련 (Vesting)
      text: "📉 성과 연동: 5:5는 인정하되, 주주간계약서에 까다로운 '성과 조건(KPI)'을 겁니다. 주도적인 성과를 못 내면 지분을 회수합니다.",
      score: 5.0,
    ),
    ScenarioOption(
      // 10점: 관계 유지 및 희망 (Investment in person)
      text: "🤝 동반 성장: 지금은 수동적이지만, 지분과 책임감(C-level 타이틀)을 주면 주도적으로 변할 것이라 믿고 5:5로 갑니다.",
      score: 10.0,
    ),
  ],
),

  ConflictScenario(
    id: "Q7", category: "equity",
    questionText: "초기 멤버가 근속 약속을 지키지 못하고 1년 만에 퇴사했습니다.",
    options: [
      ScenarioOption(text: "1년 기여는 짧으므로, 지분 회수하거나 최소 인정", score: 0.0),
      ScenarioOption(text: "근속 기간(1년)만큼은 인정 (Vesting)", score: 5.0),
      ScenarioOption(text: "약속한 지분 20% 모두 인정", score: 10.0),
    ],
  ),

  ConflictScenario(
    id: "Q8",
    category: "equity",
    questionText: "자금이 바닥나서 대표이사 연대보증이 필요합니다.",
    options: [
      ScenarioOption(text: "폐업 (빚지기 싫음)", score: 0.0),
      ScenarioOption(text: "대표 혼자 보증 (지분 더 받음)", score: 5.0),
      ScenarioOption(text: "공동창업자 n분의 1 보증", score: 10.0),
    ],
  ),

  // 💰 [FINANCE] 자금 운용 (2문제)
  ConflictScenario(
    id: "Q2", category: "finance",
    questionText: "공동창업자가 개인 사정(이사, 결혼 등)으로 월급 3개월 치 선지급을 요청했습니다.",
    options: [
      ScenarioOption(text: "거절. 공금은 공금", score: 0.0),
      ScenarioOption(text: "회사 자금 사정을 봐서 가능한 범위 내에서 대여", score: 5.0),
      ScenarioOption(text: "팀원의 안정이 회사의 안정", score: 10.0),
    ],
  ),

  ConflictScenario(
    id: "Q9", category: "finance",
    questionText: "업무 효율을 위해 300만 원 상당의 고성능 장비가 필요합니다.",
    options: [
      ScenarioOption(text: "사전 승인 필수. 비용 절감이 최우선", score: 0.0),
      ScenarioOption(text: "일정 한도 내 자율, 초과 시 상의", score: 5.0),
      ScenarioOption(text: "성과를 위해서라면 아낌없이 지원", score: 10.0),
    ],
  ),

  // ⚖️ [POWER] 권한 및 리더십 (3문제)
  ConflictScenario(
    id: "Q3",
    category: "power",
    questionText: "제품 출시 여부를 두고 의견이 갈립니다.",
    options: [
      ScenarioOption(text: "CEO 독단 결정", score: 0.0),
      ScenarioOption(text: "만장일치 될 때까지 토론", score: 5.0),
      ScenarioOption(text: "해당 분야 전문가 존중", score: 10.0),
    ],
  ),

  ConflictScenario(
    id: "Q6",
    category: "power",
    questionText: "공동창업자가 '실력은 평범하지만, 믿을 수 있는 지인'을 채용하자고 합니다.",
    options: [
      ScenarioOption(text: "절대 반대 (실력 중심)", score: 0.0),
      ScenarioOption(text: "수습 기간을 두고 성과를 검증", score: 5.0),
      ScenarioOption(text: "찬성. 초기엔 신뢰와 팀워크가 우선", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q10",
    category: "power",
    questionText: "초기 멤버인 CTO가 회사의 성장 속도를 따라오지 못하고 있습니다.",
    options: [
      ScenarioOption(text: "해고하거나 내보냄", score: 0.0),
      ScenarioOption(text: "C레벨 박탈 및 평직원 강등", score: 5.0),
      ScenarioOption(text: "외부 시니어 영입 후 배속", score: 10.0),
    ],
  ),

  // ❤️ [VALUE] 가치관 (2문제)
  ConflictScenario(
    id: "Q4", category: "value",
    questionText: "공동창업자가 큰 실수(서버 데이터 삭제 등)를 저지르고, 혼자 수습하다가 골든타임을 놓쳤습니다.",
    options: [
      ScenarioOption(text: "책임소재를 명확히 하고 규칙을 강화", score: 0.0),
      ScenarioOption(text: "개인보다 프로세스 문제로 보고 체계를 개선", score: 5.0),
      ScenarioOption(text: "왜 혼자 감당했는지 이해하고 신뢰를 다짐", score: 10.0),
    ],
  ),

  ConflictScenario(
    id: "Q5",
    category: "value",
    questionText: "생활비 때문에 저녁에 투잡(알바)을 하겠다고 합니다.",
    options: [
      ScenarioOption(text: "절대 불가 (몰입 방해)", score: 0.0),
      ScenarioOption(text: "기간 내 한시적 허용", score: 5.0),
      ScenarioOption(text: "사생활 터치 안 함", score: 10.0),
    ],
  ),
];


