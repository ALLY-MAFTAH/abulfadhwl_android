class Announcement {
  final int id;
  final String news;
  final DateTime date;

  Announcement({required this.id, required this.news, required this.date});

  Announcement.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['news'] != null),
        assert(map['date'] != null),
        id = map['id'],
        news = map['news'],
        // date = map['date'];
        date = DateTime.parse(map['date']);
}
