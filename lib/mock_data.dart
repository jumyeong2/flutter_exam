import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  // 👑 [EQUITY] 지분 및 소유권
  ConflictScenario(
    id: "Q1",
    category: "equity",
    questionText: "꼭 필요한 인재를 영입하려는데, 그는 우리와 똑같은 수준의 지분을 요구합니다. (우리는 이미 1년 고생함)",
    options: [
      ScenarioOption(
        text: "검증이 먼저다. 베스팅(조건부) 걸고 성과로 증명하면 지급",
        score: 5.0,
      ), // Owl (철저함)
      ScenarioOption(
        text: "사람이 전부다. 그만큼 필요하다면 동등한 파트너로 대우함",
        score: 10.0,
      ), // Dolphin (과감한 신뢰)
      ScenarioOption(
        text: "형평성이 깨지면 팀도 깨진다. 기존 멤버보다 적게 주는 건 원칙",
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
        text: "냉정하지만, 기여도가 줄면 지분도 회수하는 게 공정하다",
        score: 0.0,
      ), // Shark (기여도 중심)
      ScenarioOption(
        text: "우리는 장기전이다. 건강 회복이 우선이니 믿고 기다린다",
        score: 10.0,
      ), // Dolphin (동반자 의식)
      ScenarioOption(
        text: "일 줄이는 기간만큼 연봉 삭감이나 역할을 변경해 균형을 맞춘다",
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
        text: "리스크 털고 확실한 보상을 챙기는 게 현명한 선택이다",
        score: 0.0,
      ), // Shark (실리 추구)
      ScenarioOption(
        text: "우리의 잠재력은 더 크다. 지금 팔기엔 비전이 아깝다",
        score: 10.0,
      ), // Dolphin (미래 가치)
      ScenarioOption(
        text: "팀원 전체 투표를 통해, 모두가 납득하는 결정을 따른다",
        score: 5.0,
      ), // Owl (절차적 정당성)
    ],
  ),

  // 💰 [MONEY] 돈과 생존
  ConflictScenario(
    id: "Q4",
    category: "money",
    questionText:
        "경쟁사들이 법적으로 애매한(규제 미비) 영역을 파고들어 급성장 중입니다. 우리만 원칙 지키다 뒤처지고 있습니다.",
    options: [
      ScenarioOption(
        text: "일단 점유율부터 뺏고 보자. 법적 문제는 나중에 해결하면 된다",
        score: 0.0,
      ), // Shark (성장 우선)
      ScenarioOption(
        text: "신뢰가 무너지면 끝이다. 느리더라도 안전하고 올바른 길로 간다",
        score: 10.0,
      ), // Dolphin (브랜드/신뢰)
      ScenarioOption(
        text: "최소한의 방어 논리(법률 자문)만 준비해두고 조심스럽게 진입한다",
        score: 5.0,
      ), // Owl (리스크 관리)
    ],
  ),

  ConflictScenario(
    id: "Q5",
    category: "money",
    questionText:
        "런웨이(잔고)가 3개월 남았습니다. 당장 팀을 유지하려면 하던 개발을 멈추고 돈 되는 외주(SI)를 뛰어야 합니다.",
    options: [
      ScenarioOption(
        text: "외주 시작하면 본질 흐려진다. 팀을 축소해서라도 제품에 집중한다",
        score: 5.0,
      ), // Owl (선택과 집중)
      ScenarioOption(
        text: "당장 굶어 죽게 생겼다. 돈 되는 일이면 뭐든 다 해서 버틴다",
        score: 0.0,
      ), // Shark (생존 본능)
      ScenarioOption(
        text: "팀의 집중력이 중요하다. 어떻게든 투자를 더 구해보고 외주는 안 한다",
        score: 10.0,
      ), // Dolphin (비전 사수)
    ],
  ),

  // ⚖️ [POWER] 권한 및 리더십
  ConflictScenario(
    id: "Q6",
    category: "power",
    questionText: "회사가 커지면서 창업 멤버인 김 이사가 리더 역량을 못 보여주고 있습니다. 직원들의 불만이 나옵니다.",
    options: [
      ScenarioOption(
        text: "회사는 친목회가 아니다. 능력 없으면 실무자로 강등시킨다",
        score: 0.0,
      ), // Shark (능력 위주)
      ScenarioOption(
        text: "창업 멤버의 상징성은 중요하다. 그가 잘할 수 있는 다른 역할을 찾는다",
        score: 10.0,
      ), // Dolphin (사람 존중)
      ScenarioOption(
        text: "외부 전문가를 영입해 그 밑으로 배치하고, 보고 체계를 정리한다",
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
        text: "공과 사는 구분해야 한다. 실력 미달이면 절대 반대",
        score: 0.0,
      ), // Shark (채용 원칙)
      ScenarioOption(
        text: "초기 스타트업은 '믿을 수 있는 동료'가 스펙보다 중요하다. 찬성",
        score: 10.0,
      ), // Dolphin (팀워크/태도)
      ScenarioOption(
        text: "3개월 수습 기간과 명확한 목표(KPI)를 걸고, 통과 못 하면 내보낸다",
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
        text: "자신 있다. 자원이 없으면 성공도 없으니 조건을 수락한다",
        score: 0.0,
      ), // Shark (자신감)
      ScenarioOption(
        text: "경영권이 흔들리면 비전도 없다. 다른 투자자를 찾는다",
        score: 10.0,
      ), // Dolphin (주권 보호)
      ScenarioOption(
        text: "돈은 받되, 해임 조건(트리거)을 합리적인 수준으로 수정해서 계약한다",
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
        text: "정면 승부는 진다. 그들이 못 하는 틈새시장으로 타겟을 좁힌다",
        score: 5.0,
      ), // Owl (전략적 회피)
      ScenarioOption(
        text: "승산이 없다. 경쟁사가 안 하는 다른 아이템으로 빠르게 전환(피벗)한다",
        score: 0.0,
      ), // Shark (빠른 판단)
      ScenarioOption(
        text: "고객은 진정성을 알아줄 것이다. 우리만의 철학을 더 뾰족하게 다듬어 승부한다",
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
        text: "개인을 비난해선 해결 안 된다. 실수를 막지 못한 시스템부터 고친다",
        score: 5.0,
      ), // Owl (시스템/이성)
      ScenarioOption(
        text: "실수는 할 수 있지만, 공유하지 않고 숨긴 건 치명적이다. 책임을 묻는다",
        score: 0.0,
      ), // Shark (규율/원칙)
      ScenarioOption(
        text: "질책하면 앞으로 더 숨길 것이다. 심리적으로 위축되지 않게 감싸준다",
        score: 10.0,
      ), // Dolphin (문화/포용)
    ],
  ),
];
