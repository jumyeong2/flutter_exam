// [전체 덮어쓰기]
class ConflictScenario {
  final String id;
  final String category; // 'money', 'power', 'value'
  final String questionText;
  final List<ScenarioOption> options;

  ConflictScenario({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
  });
}

class ScenarioOption {
  final String text;
  final double score;

  ScenarioOption({
    required this.text,
    required this.score,
  });
}