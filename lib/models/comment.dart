class Comment {
  // int id;
  String fullName;
  String phone;
  String message;

  Comment(
      {
        // required this.id,
      required this.fullName,
      required this.phone,
      required this.message});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
        // id: map['id'],
        fullName: map['full_name'],
        phone: map['phone'],
        message: map['message']);
  }

  static Map<String, dynamic> toMap(Comment comment) {
    final Map<String, dynamic> data = <String, dynamic>{
      // 'id': comment.id,
      'full_name': comment.fullName,
      'phone': comment.phone,
      'message': comment.message
    };

    return data;
  }
}
