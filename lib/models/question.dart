
class Question {
  // int id;
  String qn;

  Question({ required this.qn});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      // id: map['id'],
      qn: map['qn'],
    );
  }

  static Map<String, dynamic> toMap(Question question) {
    final Map<String, dynamic> data = <String, dynamic>{
      // 'id': question.id,
      'qn': question.qn,
    };

    return data;
  }
}
