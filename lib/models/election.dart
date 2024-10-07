import 'package:cloud_firestore/cloud_firestore.dart';

class Election {
  String id;
  String title;
  List<String> candidates;
  DateTime startTime;
  DateTime endTime;

  Election({
    required this.id,
    required this.title,
    required this.candidates,
    required this.startTime,
    required this.endTime,
  });

  factory Election.fromFirestore(Map<String, dynamic> data, String id) {
    return Election(
      id: id,
      title: data['title'],
      candidates: List<String>.from(data['candidates']),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
    );
  }
}
