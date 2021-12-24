
class Article {
  final int id;
  final String title;
  final String pubYear;
  final String file;
  final String cover;

  Article({
    required this.id,
    required this.title,
    required this.pubYear,
    required this.file,
    required this.cover,
  });

  Article.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['pub_year'] != null),
        assert(map['file'] != null),
        assert(map['cover'] != null),
        
        id = map['id'],
        title = map['title'],
        pubYear = map['pub_year'],
        file = map['file'],
        cover = map['cover'];
}
