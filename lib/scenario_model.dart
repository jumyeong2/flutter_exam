class ConflictScenario {
  final String id;
  final String questionText;
  final List<ScenarioOption> options;

  ConflictScenario({
    required this.id,
    required this.questionText,
    required this.options,
  });
}

class ScenarioOption {
  final String text;
  final double score; // 0.0 ~ 10.0

  ScenarioOption({
    required this.text,
    required this.score,
  });
}