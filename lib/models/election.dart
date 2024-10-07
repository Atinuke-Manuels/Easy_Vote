import 'package:cloud_firestore/cloud_firestore.dart';

class Election {
  final String id;
  final String title;
  final List<String> candidates;
  final DateTime startDate;
  final DateTime endDate;

  Election({
    required this.id,
    required this.title,
    required this.candidates,
    required this.startDate,
    required this.endDate,
  });

  factory Election.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Election(
      id: doc.id,
      title: data['title'],
      candidates: List<String>.from(data['candidates']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
    );
  }
}
