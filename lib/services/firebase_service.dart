import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/election.dart';
import '../models/vote.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign up voters
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Login voters
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Fetch elections
  Stream<List<Election>> fetchElections() {
    return _db.collection('elections').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Election.fromFirestore(doc.data(), doc.id)).toList());
  }

  // Cast vote
  Future<void> castVote(String voterId, String electionId, String candidateId) async {
    final voterRef = _db.collection('voters').doc(voterId);
    final voterSnapshot = await voterRef.get();

    if (!voterSnapshot['hasVoted']) {
      await _db.collection('votes').add({
        'voterId': voterId,
        'candidateId': candidateId,
        'electionId': electionId,
      });
      await voterRef.update({'hasVoted': true});
    }
  }

  // Fetch results
  Stream<Map<String, int>> getResults(String electionId) {
    return _db.collection('votes').where('electionId', isEqualTo: electionId).snapshots().map((snapshot) {
      Map<String, int> results = {};
      snapshot.docs.forEach((doc) {
        String candidateId = doc['candidateId'];
        results[candidateId] = (results[candidateId] ?? 0) + 1;
      });
      return results;
    });
  }
}
