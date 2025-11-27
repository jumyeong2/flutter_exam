import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  // 👑 [EQUITY] 지분 및 소유권 (3문제) - 가장 중요!
  ConflictScenario(
    id: "Q1",
    category: "equity",
    questionText: "공동창업자가 1년 뒤 '힘들어서 못하겠다'며 퇴사를 선언한다면?",
    options: [
      ScenarioOption(text: "지분 전량 회수 (Bad Leaver)", score: 0.0),
      ScenarioOption(text: "근무 기간만큼 인정 (Vesting)", score: 5.0),
      ScenarioOption(text: "설립 공로 인정 (Good Leaver)", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q7",
    category: "equity",
    questionText: "대기업에서 50억 원 매각 제안이 왔습니다. 파시겠습니까?",
    options: [
      ScenarioOption(text: "당장 매각한다 (현금화)", score: 0.0),
      ScenarioOption(text: "조건을 보고 협상한다", score: 5.0),
      ScenarioOption(text: "거절한다 (유니콘 목표)", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q8",
    category: "equity",
    questionText: "자금이 바닥나서 대표이사 연대보증이 필요합니다.",
    options: [
      ScenarioOption(text: "폐업한다 (빚지기 싫음)", score: 0.0),
      ScenarioOption(text: "대표 혼자 보증 (지분 더 받음)", score: 5.0),
      ScenarioOption(text: "공동창업자 n분의 1 보증", score: 10.0),
    ],
  ),

  // 💰 [FINANCE] 자금 운용 (2문제)
  ConflictScenario(
    id: "Q2",
    category: "finance",
    questionText: "투자금 1억이 들어왔습니다. 급여 책정은?",
    options: [
      ScenarioOption(text: "최저임금 미만 (헝그리 정신)", score: 0.0),
      ScenarioOption(text: "최소 생계비 (월 250만)", score: 5.0),
      ScenarioOption(text: "시장 연봉의 70% 수준", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q9", category: "finance",
    questionText: "업무 효율을 위해 300만 원 상당의 고성능 장비가 필요하다면?",
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
    questionText: "제품 출시 여부를 두고 의견이 갈린다면?",
    options: [
      ScenarioOption(text: "CEO 독단 결정", score: 0.0),
      ScenarioOption(text: "만장일치 될 때까지 토론", score: 5.0),
      ScenarioOption(text: "해당 분야 전문가 존중", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q6",
    category: "power",
    questionText: "공동창업자가 '실력은 평범하지만, 믿을 수 있는 지인'을 채용하자고 한다면?",
    options: [
      ScenarioOption(text: "절대 반대 (실력 중심)", score: 0.0),
      ScenarioOption(text: "수습 기간을 두고 성과를 검증", score: 5.0),
      ScenarioOption(text: "찬성. 초기엔 신뢰와 팀워크가 우선", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q10",
    category: "power",
    questionText: "CTO인 초기 공동창업자의 역량이 성장에 방해가 됩니다.",
    options: [
      ScenarioOption(text: "해고하거나 내보낸다", score: 0.0),
      ScenarioOption(text: "C레벨 박탈 및 평직원 강등", score: 5.0),
      ScenarioOption(text: "외부 시니어 영입 후 배속", score: 10.0),
    ],
  ),

  // ❤️ [VALUE] 가치관 (2문제)
  ConflictScenario(
    id: "Q4",
    category: "value",
    questionText: "한 명은 워라밸을 지키고, 한 명은 밤샘을 합니다.",
    options: [
      ScenarioOption(text: "용납 불가 (스타트업은 전쟁)", score: 0.0),
      ScenarioOption(text: "코어타임만 지키면 OK", score: 5.0),
      ScenarioOption(text: "성과만 내면 상관없음", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q5",
    category: "value",
    questionText: "생활비 때문에 저녁에 투잡(알바)을 하겠다고 합니다.",
    options: [
      ScenarioOption(text: "절대 불가 (몰입 방해)", score: 0.0),
      ScenarioOption(text: "한시적 허용", score: 5.0),
      ScenarioOption(text: "사생활 터치 안 함", score: 10.0),
    ],
  ),
];
