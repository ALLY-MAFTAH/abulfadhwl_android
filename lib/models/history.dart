
class History {
  final int id;
  final int section;
  final String heading;
  final String content;

  History(
      {required this.id,
      required this.section,
      required this.heading,
      required this.content});

  History.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['section'] != null),
        assert(map['heading'] != null),
        assert(map['content'] != null),
        id = map['id'],
        section = map['section'],
        heading = map['heading'],
        content = map['content'];
}
