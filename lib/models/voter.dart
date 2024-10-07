class Voter {
  String id;
  String name;
  bool hasVoted;

  Voter({
    required this.id,
    required this.name,
    required this.hasVoted,
  });

  factory Voter.fromFirestore(Map<String, dynamic> data, String id) {
    return Voter(
      id: id,
      name: data['name'],
      hasVoted: data['hasVoted'],
    );
  }
}
