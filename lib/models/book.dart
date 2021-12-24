
class Book {
  final int id;
  final int edition;
  final String  file;
  final String  title;
  final String  cover;
  final String  author;
  final String pubYear;
  final String  description;

  Book(
      {required this.id,
      required this.file,
      required this.title,
      required this.cover,
      required this.author,
      required this.edition,
      required this.pubYear,
      required this.description});

  Book.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['file'] != null),
        assert(map['title'] != null),
        assert(map['cover'] != null),
        assert(map['author'] != null),
        assert(map['edition'] != null),
        assert(map['pub_year'] != null),
        assert(map['description'] != null),
        id = map['id'],
        file = map['file'],
        title = map['title'],
        cover = map['cover'],
        author = map['author'],
        edition = map['edition'],
        pubYear = map['pub_year'],
        description = map['description'];
}
