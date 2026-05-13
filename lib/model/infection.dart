class Infection {
  final String id;
  final String name;
  final String type;
  final String img;
  final List<String> symptoms;
  final String treatment;
  final String causingAgent;

  const Infection({
    required this.id,
    required this.name,
    required this.type,
    required this.img,
    required this.symptoms,
    required this.treatment,
    required this.causingAgent,
  });
}
