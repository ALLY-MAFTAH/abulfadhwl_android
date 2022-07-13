
class Song {
  final int id;
  final int albumId;
  final String title;
  final String description;
  final String file;

  Song(
      {required this.id,
      required this.albumId,
      required this.title,
      required this.description,
      required this.file,
      });

  Song.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['album_id'] != null),
        assert(map['file'] != null),
        assert(map['description'] !=null),
        id = map['id'],
        title = map['title'],
        albumId = map['album_id'],
        file = map['file'],
        description = map['description'];
}
