import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  // 👑 [EQUITY] 지분 및 소유권
  ConflictScenario(
    id: "Q1",
    category: "equity",
    questionText: "꼭 필요한 인재를 영입하려는데, 그는 우리와 똑같은 수준의 지분을 요구합니다.",
    options: [
      ScenarioOption(
        text: "검증이 먼저임. 베스팅(조건부)을 걸어야 납득할 수 있음",
        score: 5.0,
      ), // Owl (철저함)
      ScenarioOption(
        text: "사람이 전부임. 그만큼 필요하다면 동등하게 대우하고 싶음",
        score: 10.0,
      ), // Dolphin (과감한 신뢰)
      ScenarioOption(
        text: "형평성이 중요함. 기존 멤버보다 많이 주는 건 반대함",
        score: 0.0,
      ), // Shark (원칙 고수)
    ],
  ),

  ConflictScenario(
    id: "Q2",
    category: "equity",
    questionText: "가장 친한 공동창업자가 번아웃이 와서, 당분간 일을 쉬거나 줄이겠다고 합니다.",
    options: [
      ScenarioOption(
        text: "냉정하지만, 기여도가 줄면 지분도 회수하는 게 맞다고 봄",
        score: 0.0,
      ), // Shark (기여도 중심)
      ScenarioOption(
        text: "우리는 장기전임. 건강 회복이 우선이니 믿고 기다리고 싶음",
        score: 10.0,
      ), // Dolphin (동반자 의식)
      ScenarioOption(
        text: "일 줄이는 기간만큼 연봉이나 역할을 조정하는 게 합리적임",
        score: 5.0,
      ), // Owl (합리적 조율)
    ],
  ),

  ConflictScenario(
    id: "Q3",
    category: "equity",
    questionText:
        "대기업에서 '적당한 가격'에 회사를 인수하겠다고 합니다. 대박은 아니지만, 빚 없이 안전하게 끝낼 수 있습니다.",
    options: [
      ScenarioOption(
        text: "리스크를 털고 확실한 보상을 챙기는 게 현명하다고 생각함",
        score: 0.0,
      ), // Shark (실리 추구)
      ScenarioOption(
        text: "우리의 잠재력은 더 큼. 지금 팔기엔 비전이 아까움",
        score: 10.0,
      ), // Dolphin (미래 가치)
      ScenarioOption(
        text: "내 의견보다 팀원 전체의 투표 결과를 따르는 게 맞음",
        score: 5.0,
      ), // Owl (절차적 정당성)
    ],
  ),

  // 💰 [MONEY] 돈과 생존 finance
  ConflictScenario(
    id: "Q4",
    category: "finance",
    questionText:
        "경쟁사들이 법적으로 애매한(규제 미비) 영역을 파고들어 급성장 중입니다. 우리만 원칙 지키다 뒤처지고 있습니다.",
    options: [
      ScenarioOption(
        text: "일단 점유율부터 뺏어야 함. 법적 문제는 나중 일임",
        score: 0.0,
      ), // Shark (성장 우선)
      ScenarioOption(
        text: "신뢰가 깨지면 끝임. 느리더라도 안전한 길로 가고 싶음",
        score: 10.0,
      ), // Dolphin (브랜드/신뢰)
      ScenarioOption(
        text: "최소한의 법적 방어 논리만 갖추고 조심스럽게 진입해야 함",
        score: 5.0,
      ), // Owl (리스크 관리)
    ],
  ),

  ConflictScenario(
    id: "Q5",
    category: "finance",
    questionText:
        "런웨이(잔고)가 3개월 남았습니다. 당장 팀을 유지하려면 하던 개발을 멈추고 돈 되는 외주(SI)를 뛰어야 합니다.",
    options: [
      ScenarioOption(
        text: "외주는 본질을 흐림. 차라리 팀을 줄여서라도 제품에 집중하고 싶음",
        score: 5.0,
      ), // Owl (선택과 집중)
      ScenarioOption(
        text: "생존이 최우선임. 돈 되는 일이면 뭐든 해서 버텨야 함",
        score: 0.0,
      ), // Shark (생존 본능)
      ScenarioOption(
        text: "팀의 몰입이 중요함. 어떻게든 투자를 더 구해보고 외주는 반대함",
        score: 10.0,
      ), // Dolphin (비전 사수)
    ],
  ),

  // ⚖️ [POWER] 권한 및 리더십
  ConflictScenario(
    id: "Q6",
    category: "power",
    questionText: "회사가 커지면서 초기 멤버가 리더 역량을 못 보여주고 있습니다. 직원들의 불만이 나옵니다.",
    options: [
      ScenarioOption(
        text: "능력 없으면 실무자로 내려와야 함",
        score: 0.0,
      ), // Shark (능력 위주)
      ScenarioOption(
        text: "그가 잘할 수 있는 다른 역할을 찾아줘야 함",
        score: 10.0,
      ), // Dolphin (사람 존중)
      ScenarioOption(
        text: "전문가를 영입해 그 밑으로 배치하고, 보고 체계를 정리하는 게 좋음",
        score: 5.0,
      ), // Owl (조직 구조화)
    ],
  ),

  ConflictScenario(
    id: "Q7",
    category: "power",
    questionText: "공동창업자가 '실력은 좀 평범한데, 내가 정말 믿는 지인'을 채용하자고 강력히 주장합니다.",
    options: [
      ScenarioOption(
        text: "공과 사는 구분해야 함. 실력 미달이면 절대 반대임",
        score: 0.0,
      ), // Shark (채용 원칙)
      ScenarioOption(
        text: "초기엔 '믿을 수 있는 동료'가 스펙보다 중요하다고 봄. 찬성함",
        score: 10.0,
      ), // Dolphin (팀워크/태도)
      ScenarioOption(
        text: "수습 기간과 명확한 목표(KPI)를 거는 조건으로만 찬성함",
        score: 5.0,
      ), // Owl (검증 시스템)
    ],
  ),

  ConflictScenario(
    id: "Q8",
    category: "power",
    questionText: "투자자가 큰돈을 주겠다는데, '실적이 안 나오면 대표를 해임할 수 있다'는 조건을 걸었습니다.",
    options: [
      ScenarioOption(
        text: "자신 있음. 자원이 없으면 성공도 없으니 감수해야 한다고 봄",
        score: 0.0,
      ), // Shark (자신감)
      ScenarioOption(
        text: "경영권이 흔들리면 비전도 없음. 다른 투자자를 찾는 게 맞음",
        score: 10.0,
      ), // Dolphin (주권 보호)
      ScenarioOption(
        text: "돈은 받되, 해임 조건(트리거)을 합리적인 수준으로 수정해야 함",
        score: 5.0,
      ), // Owl (협상)
    ],
  ),

  // ❤️ [VALUE] 가치관
  ConflictScenario(
    id: "Q9",
    category: "value",
    questionText:
        "자본력을 앞세운 경쟁사가 우리 핵심 기능을 똑같이 베꼈습니다. 우리는 자금이 부족해 마케팅으로 못 이깁니다.",
    options: [
      ScenarioOption(
        text: "정면 승부는 진다고 봄. 틈새시장으로 타겟을 좁혀야 함",
        score: 5.0,
      ), // Owl (전략적 회피)
      ScenarioOption(
        text: "승산이 없음. 경쟁사가 안 하는 다른 아이템으로 빨리 전환해야 함",
        score: 0.0,
      ), // Shark (빠른 판단)
      ScenarioOption(
        text: "고객은 진정성을 알아줄 거임. 우리 철학을 더 뾰족하게 다듬고 싶음",
        score: 10.0,
      ), // Dolphin (차별화된 가치)
    ],
  ),

  ConflictScenario(
    id: "Q10",
    category: "value",
    questionText: "공동창업자가 큰 실수(서버 데이터 삭제 등)를 저지르고, 혼자 수습하다가 골든타임을 놓쳤습니다.",
    options: [
      ScenarioOption(
        text: "개인 탓보단 시스템 문제임. 재발 방지 프로세스부터 만들어야 함",
        score: 5.0,
      ), // Owl (시스템/이성)
      ScenarioOption(
        text: "실수보다 '숨긴 것'이 더 치명적임. 책임을 확실히 물어야 함",
        score: 0.0,
      ), // Shark (규율/원칙)
      ScenarioOption(
        text: "질책하면 앞으로 더 숨길 거임. 위축되지 않게 감싸주는 게 먼저임",
        score: 10.0,
      ), // Dolphin (문화/포용)
    ],
  ),
];