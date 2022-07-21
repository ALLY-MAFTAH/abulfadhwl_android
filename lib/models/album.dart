import 'package:abulfadhwl_android/models/song.dart';

class Album {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  final List<Song> songs;

  Album({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.songs,
  });

  Album.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['category_id'] != null),
        id = map['id'],
        name = map['name'],
        description = map['description'],
        categoryId = map['category_id'],
        songs =
            (map['songs'] as List).map((song) => Song.fromMap(song)).toList();
}

