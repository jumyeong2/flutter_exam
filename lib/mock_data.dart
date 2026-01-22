import 'scenario_model.dart';

final List<ConflictScenario> sampleQuestions = [
  // 👑 [EQUITY] 지분 및 소유권
  ConflictScenario(
    id: "Q1",
    category: "equity",
    questionText: "꼭 필요한 인재를 영입하려는데,\n그는 우리와 똑같은 수준의 지분을 요구합니다.",
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
    questionText: "가장 친한 공동창업자가 번아웃이 와서,\n당분간 일을 쉬거나 줄이겠다고 합니다.",
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
  questionText: "도메인/상표 같은 핵심 자산이 개인 명의로 등록돼 있습니다.\n회사 명의로 이전할 때 기준을 정해야 합니다.",
  options: [
    ScenarioOption(
      text: "지금 당장 이전해야 함. 비용이 들더라도 바로 정리해야 함",
      score: 0.0,
    ), // Shark (리스크 제거/단호)
    ScenarioOption(
      text: "이전하되 합의 문서부터. 비용·절차·퇴사 시 처리까지 조항으로 정리하고 진행해야 함",
      score: 5.0,
    ), // Owl (프로세스/문서화)
    ScenarioOption(
      text: "당장 급한 건 아님. 상황 안정되면 천천히 정리해도 됨",
      score: 10.0,
    ), // Dolphin (관계/신뢰 우선)
  ],
),

  // 💰 [MONEY] 돈과 생존 finance
  ConflictScenario(
    id: "Q4",
    category: "finance",
    questionText:
        "서버비/마케팅비 등 당장 결제할 돈이 부족합니다.\n한 명이 '개인 카드/대출로 막자'고 제안합니다.",
    options: [
      ScenarioOption(
        text: "필요하면 개인 돈으로라도 막아야 함. 일단 살고 보자는 입장임",
        score: 0.0,
      ), // Shark (생존/즉시 실행)
      ScenarioOption(
        text: "가능은 하되, 한도·상환 우선순위·내부 차용증을 먼저 합의하고 진행해야 함",
        score: 5.0,
      ), // Owl (리스크 통제/계약화)
      ScenarioOption(
        text: "개인 보증/대출은 절대 반대임. 관계가 깨질 확률이 커서 다른 방법을 찾고 싶음",
        score: 10.0,
      ), // Dolphin (관계/안전 우선)
    ],
  ),


  ConflictScenario(
    id: "Q5",
    category: "finance",
    questionText:
        "런웨이(잔고)가 3개월 남았습니다.\n당장 팀을 유지하려면 하던 개발을 멈추고 돈 되는 외주(SI)를 뛰어야 합니다.",
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
  // ⚖️ [POWER] 권한 및 리더십
  // ✅ Q6 (power) 초기 친화 대체: 2인 50:50 교착 타이브레이커
  ConflictScenario(
    id: "Q6",
    category: "power",
    questionText:
        "중요한 결정(피벗/가격 등)에서 의견이 50:50으로 갈립니다.\n해결할 원칙을 정해야 합니다.",
    options: [
      ScenarioOption(
        text: "한 명에게 최종 결정권을 주는 게 현실적이라고 봄",
        score: 0.0,
      ), // Shark (결정 속도/권한 부여)
      ScenarioOption(
        text: "사전에 범위별 룰을 정하자. 예: 투자/채용은 만장일치, 제품은 대표권 등",
        score: 5.0,
      ), // Owl (권한 매트릭스/규칙)
      ScenarioOption(
        text: "외부 멘토/자문을 끼고 중재로 풀자. 한 명이 밀어붙이는 구조는 위험하다고 봄",
        score: 10.0,
      ), // Dolphin (관계/중재 선호)
    ],
  ),

  ConflictScenario(
    id: "Q7",
    category: "power",
    questionText: "공동창업자가 '실력은 좀 평범한데,\n내가 정말 믿는 지인'을 채용하자고 강력히 주장합니다.",
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

// ✅ Q8 (power) 중립 대체: 대외 약속/커뮤니케이션 권한(대표 편향 없음)
ConflictScenario(
  id: "Q8",
  category: "power",
  questionText:
      "한 공동창업자가 팀과 상의 없이\n외부에 중요한 약속을 먼저 해버렸습니다.",
  options: [
    ScenarioOption(
      text: "재발 방지가 우선임. 외부 커뮤니케이션/약속은 한 명만 담당",
      score: 0.0,
    ), // Shark (통제/속도)
    ScenarioOption(
      text: "기준을 룰로 만들자. 가격/일정/범위는 '사전 합의' 없이는 말할 수 없도록 함",
      score: 5.0,
    ), // Owl (규칙/가드레일)
    ScenarioOption(
      text: "통제보다, 외부에 말하기 전 '10분 확인(메신저 공유)' 같은 최소 공유 룰만 정함",
      score: 10.0,
    ), // Dolphin (신뢰/팀워크)
  ],
),

  // ❤️ [VALUE] 가치관
  ConflictScenario(
    id: "Q9",
    category: "value",
    questionText:
        "자본력을 앞세운 경쟁사가 우리 핵심 기능을 똑같이 베꼈습니다.\n우리는 자금이 부족해 마케팅으로 못 이깁니다.",
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
    questionText: "공동창업자가 큰 실수(서버 데이터 삭제 등)를 저지르고,\n혼자 수습하다가 골든타임을 놓쳤습니다.",
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