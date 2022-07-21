class Song {
  final int id;
  final int albumId;
  final String title;
  final double size;
  final String duration;
  final String file;

  Song({
    required this.id,
    required this.albumId,
    required this.title,
    required this.size,
    required this.duration,
    required this.file,
  });

  Song.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['album_id'] != null),
        assert(map['duration'] != null),
        assert(map['size'] != null),
        assert(map['file'] != null),
        id = map['id'],
        title = map['title'],
        albumId = map['album_id'],
        file = map['file'],
        duration = map['duration'],
        size = map['size'];
}