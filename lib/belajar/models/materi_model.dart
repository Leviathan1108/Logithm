class MateriContent {
  final int id;
  final String title;
  final Map<String, String> introduction;
  final Map<String, String> definition;
  final Map<String, String> analogy;
  final Map<String, String> visualization;

  MateriContent({
    required this.id,
    required this.title,
    required this.introduction,
    required this.definition,
    required this.analogy,
    required this.visualization,
  });
}