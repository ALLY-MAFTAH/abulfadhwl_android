
class Slide {
  final int id;
  final String file;
  final int number;

  Slide({
    required this.id,
    required this.file,
    required this.number,
  });

  Slide.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['file'] != null),
        assert(map['number'] != null),
        id = map['id'],
        file = map['file'],
        number = map['number'];
}

