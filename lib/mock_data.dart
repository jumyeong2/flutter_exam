import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  ConflictScenario(
    id: "Q1",
    questionText: "공동창업자가 1년 뒤 퇴사를 선언한다면?",
    options: [
      ScenarioOption(text: "지분 전량 회수 (Bad Leaver)", score: 0.0),
      ScenarioOption(text: "근무 기간만큼 인정 (Vesting)", score: 5.0),
      ScenarioOption(text: "지분 모두 인정 (Good Leaver)", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q2",
    questionText: "투자금 1억이 들어왔습니다. 급여 책정은?",
    options: [
      ScenarioOption(text: "최저임금 미만 (헝그리 정신)", score: 0.0),
      ScenarioOption(text: "최소 생계비 (월 250만)", score: 5.0),
      ScenarioOption(text: "시장 연봉의 70% 수준", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q3",
    questionText: "제품 출시 여부를 두고 의견이 갈린다면?",
    options: [
      ScenarioOption(text: "CEO가 독단적으로 결정", score: 0.0),
      ScenarioOption(text: "만장일치 될 때까지 토론", score: 5.0),
      ScenarioOption(text: "분야별 전문가(CTO 등) 존중", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q4",
    questionText: "한 명은 '주 100시간' 일하고, 한 명은 '워라밸(9 to 6)'을 지킨다면?",
    options: [
      ScenarioOption(text: "용납 불가. 스타트업은 전쟁이다. (퇴출 고려)", score: 0.0),
      ScenarioOption(text: "핵심 업무 시간(Core Time)만 겹치면 OK", score: 5.0),
      ScenarioOption(text: "성과만 낸다면 출근 안 해도 상관없다.", score: 10.0)
    ] ,
  ),
  ConflictScenario(
    id: "Q5",
    questionText: "공동창업자가 생활비 때문에 '저녁에 알바(투잡)'를 하겠다고 합니다.",
    options: [
      ScenarioOption(text: "절대 불가. 사업에 100% 몰입해야 한다.", score: 0.0),
      ScenarioOption(text: "3개월 등 기한을 정해두고 한시적 허용", score: 5.0),
      ScenarioOption(text: "개인 사생활이므로 터치하지 않는다.", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q6",
    questionText: "공동창업자가 '실력은 좀 부족하지만 믿을만한 지인'을 팀장으로 추천했습니다.",
    options: [
      ScenarioOption(text: "반대. 채용은 오직 실력(Meritocracy) 기준이다.", score: 0.0),
      ScenarioOption(text: "일단 인턴으로 채용해보고 결정한다.", score: 5.0),
      ScenarioOption(text: "초기엔 신뢰가 중요하니 채용에 동의한다.", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q7",
    questionText: "대기업에서 50억 원에 회사를 팔라는 제안(M&A)이 왔습니다. 파시겠습니까?",
    options: [
      ScenarioOption(text: "당장 매각한다. (현금화/안전 제일)", score: 0.0),
      ScenarioOption(text: "조건을 보고 협상한다. (고용 승계 등)", score: 5.0),
      ScenarioOption(text: "거절한다. 우린 유니콘(1조)까지 간다.", score: 10.0),
    ],
  ),
  ConflictScenario(
    id: "Q8",
    questionText: "자금이 바닥났습니다. 대표이사 연대보증으로 대출을 받아야만 연명 가능합니다.",
    options: [
      ScenarioOption(text: "폐업한다. 빚지면서까지 사업 안 한다.", score: 0.0),
      ScenarioOption(text: "지분을 더 주는 조건으로 대표 혼자 보증", score: 5.0),
      ScenarioOption(text: "공동창업자 모두가 n분의 1로 보증 선다.", score: 10.0),
    ],
  ),
];