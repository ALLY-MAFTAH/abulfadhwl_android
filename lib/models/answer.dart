
class Answer {
  final int id;
  final String qn;
  final String ans;

  Answer({required this.id, required this.qn, required this.ans});

  Answer.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['qn'] != null),
        assert(map['ans'] != null),
        id = map['id'],
        qn = map['qn'],
        ans = map['ans'];
}
