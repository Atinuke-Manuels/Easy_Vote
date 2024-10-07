class Vote {
  String voterId;
  String candidateId;
  String electionId;

  Vote({
    required this.voterId,
    required this.candidateId,
    required this.electionId,
  });

  factory Vote.fromFirestore(Map<String, dynamic> data, String id) {
    return Vote(
      voterId: data['voterId'],
      candidateId: data['candidateId'],
      electionId: data['electionId'],
    );
  }
}
