import 'package:cloud_firestore/cloud_firestore.dart';

class Election {
  final String id;
  final String title;
  final List<String> candidates;
  final DateTime startDate;
  final DateTime endDate;
  String creatorId; // Add this field to track the creator
  final List<String> registeredVoters; // New field

  Election({
    required this.id,
    required this.title,
    required this.candidates,
    required this.startDate,
    required this.endDate,
    required this.creatorId, // Include this in constructor
    required this.registeredVoters, // Initialize the new field
  });

  factory Election.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Election(
      id: doc.id,
      title: data['title'],
      candidates: List<String>.from(data['candidates']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      creatorId: doc['creatorId'],
      registeredVoters: List<String>.from(data['registeredVoters'] ?? []), // Handle null
    );
  }

  // Convert election to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'candidates': candidates,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'registeredVoters': registeredVoters, // Ensure it's saved in Firestore
    };
  }
}