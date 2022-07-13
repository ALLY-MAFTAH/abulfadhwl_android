import 'package:abulfadhwl_android/models/album.dart';

class SongCategory {
  final int id;
  final String name;
  final String description;
  final List<Album> albums;

  SongCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.albums,
  });

  SongCategory.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['description'] != null),
        id = map['id'],
        name = map['name'],
        description = map['description'],
        albums = (map['albums'] as List)
            .map((album) => Album.fromMap(album))
            .toList();
}
