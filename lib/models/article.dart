class Article {
  final int id;
  final int number;
  final String title;
  final String description;
  final String pubYear;
  final String file;

  Article({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.pubYear,
    required this.file,
  });

  Article.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['number'] != null),
        assert(map['title'] != null),
        assert(map['pub_year'] != null),
        assert(map['file'] != null),
        id = map['id'],
        number = map['number'],
        title = map['title'],
        description = map['description'],
        pubYear = map['pub_year'],
        file = map['file'];
}
