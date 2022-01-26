
class Link {
  final int id;
  final String url;
  final String title;
  final String type;
  final String icon;

  Link(
      {required this.id,
      required this.url,
      required this.title,
      required this.type,
      required this.icon});

  Link.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['type'] != null),
        assert(map['url'] != null),
        assert(map['icon'] != null),
        id = map['id'],
        url = map['url'],
        title = map['title'],
        type = map['type'],
        icon = map['icon'];
}
