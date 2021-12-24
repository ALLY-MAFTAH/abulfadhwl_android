class Comment {
  // int id;
  String fullName;
  String email;
  String message;

  Comment(
      {
        // required this.id,
      required this.fullName,
      required this.email,
      required this.message});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
        // id: map['id'],
        fullName: map['full_name'],
        email: map['email'],
        message: map['message']);
  }

  static Map<String, dynamic> toMap(Comment comment) {
    final Map<String, dynamic> data = <String, dynamic>{
      // 'id': comment.id,
      'full_name': comment.fullName,
      'email': comment.email,
      'message': comment.message
    };

    return data;
  }
}
