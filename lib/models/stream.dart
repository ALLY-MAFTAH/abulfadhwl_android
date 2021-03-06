
class Stream {
  final int id;
  final String url;
  final String title;
  final String timetable;
  final String description;
  final int status;

  Stream(
      {required this.id,
      required this.url,
      required this.title,
      required this.timetable,
      required this.status,
      required this.description});

  Stream.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['timetable'] != null),
        assert(map['url'] != null),
        assert(map['title'] != null),
        assert(map['status'] != null),
        assert(map['description'] != null),
        id = map['id'],
        timetable = map['timetable'],
        url = map['url'],
        title = map['title'],
        status= map['status'],
        description = map['description'];
}
