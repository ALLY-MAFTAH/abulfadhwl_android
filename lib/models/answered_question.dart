class Answer {
  final int id;
  final String qn;
  final String textAns;
  final String audioAns;

  Answer({
    required this.id,
    required this.qn,
    required this.textAns,
    required this.audioAns,
  });

  Answer.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['qn'] != null),
        id = map['id'],
        qn = map['qn'],
        textAns = map['textAns'],
        audioAns = map['audioAns'];
}
