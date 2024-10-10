import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import '../models/election.dart'; // For generating a random voter ID

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Public method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Public method to access Firestore instance
  FirebaseFirestore getFirestoreInstance() {
    return _db;
  }

  // Generate a random 6-digit voter ID
  String generateVoterId() {
    Random random = Random();
    int voterId = 100000 + random.nextInt(900000); // Generates a 6-digit number
    return voterId.toString();
  }

  // Sign up a new user
// Sign up a new user
  Future<Map<String, dynamic>?> signUp(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String voterId = generateVoterId(); // Generate unique voter ID

      // Save the user details to Firestore in the VotersRegister collection
      await _db.collection('VotersRegister').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'voterId': voterId,
      });

      // Return both userCredential and voterId
      return {
        'userCredential': userCredential,
        'voterId': voterId,
      };
    } catch (e) {
      // Handle error appropriately
      return null;
    }
  }

  // Sign in a user
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // Handle error appropriately, perhaps logging it or throwing a custom exception
      return null;
    }
  }

  // Fetch voter ID from Firestore
  Future<String?> fetchVoterId(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('VotersRegister').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.get('voterId');
      }
      return null;
    } catch (e) {
      // Handle error appropriately
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> addElection(Election election) async {
    try {
      // If the id is not set, generate a new document ID
      String docId = election.id.isEmpty
          ? _db.collection('Elections').doc().id
          : election.id;

      await _db.collection('Elections').doc(docId).set({
        'title': election.title,
        'candidates': election.candidates,
        'startDate': Timestamp.fromDate(election.startDate),
        'endDate': Timestamp.fromDate(election.endDate),
      });
      print('Election added successfully!');
    } catch (e) {
      print('Error adding election: $e');
    }
  }

  Future<void> updateElection(Election election) async {
    try {
      await _db.collection('Elections').doc(election.id).update({
        'title': election.title,
        'candidates': election.candidates,
        'startDate': Timestamp.fromDate(election.startDate),
        'endDate': Timestamp.fromDate(election.endDate),
      });
      print('Election updated successfully!');
    } catch (e) {
      print('Error updating election: $e');
    }
  }

  Future<void> deleteElection(String id) async {
    try {
      await _db.collection('Elections').doc(id).delete();
      print('Election deleted successfully!');
    } catch (e) {
      print('Error deleting election: $e');
    }
  }

  // Fetch elections
  Stream<List<Election>> fetchElections() {
    return _db.collection('Elections').snapshots().map((snapshot) {
      // print('Fetched elections: ${snapshot.docs.length}'); // Log the number of fetched elections
      return snapshot.docs.map((doc) => Election.fromFirestore(doc)).toList();
    });
  }

  Future<Election?> fetchElectionById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('Elections').doc(id).get();
      if (doc.exists) {
        return Election.fromFirestore(doc); // Ensure you have a fromFirestore method in your Election model
      } else {
        print('No election found with the provided ID.');
        return null;
      }
    } catch (e) {
      print('Error fetching election: $e');
      return null;
    }
  }


  // Cast vote
  Future<void> castVote(
      String voterId, String electionId, String candidateId) async {
    final voterRef = _db.collection('voters').doc(voterId);
    final voterSnapshot = await voterRef.get();

    // Check if the voter document exists
    if (!voterSnapshot.exists) {
      // If the document doesn't exist, create it with an empty map for votes
      await voterRef.set({
        'votes': {},
        // Initialize with an empty map to track votes by electionId
        'name': 'Unknown',
        // Default value, update with actual name if needed
      });
    }

    // Now re-fetch the voter document after ensuring it exists
    final updatedVoterSnapshot = await voterRef.get();

    // Check if the voter has already voted in this election
    final votes = updatedVoterSnapshot['votes'] as Map<String, dynamic>;
    if (votes[electionId] == null || votes[electionId] == false) {
      // Cast the vote if the voter hasn't voted in this election yet
      await _db.collection('votes').add({
        'voterId': voterId,
        'candidateId': candidateId,
        'electionId': electionId,
      });

      // Mark the voter as having voted in this election
      votes[electionId] = true;
      await voterRef.update({'votes': votes});
    } else {
      throw Exception('Voter has already voted in this election');
    }
  }

  // Fetch results
  Stream<Map<String, int>> getResults(String electionId) {
    return _db
        .collection('votes')
        .where('electionId', isEqualTo: electionId)
        .snapshots()
        .map((snapshot) {
      Map<String, int> results = {};
      snapshot.docs.forEach((doc) {
        String candidateId = doc['candidateId'];
        results[candidateId] = (results[candidateId] ?? 0) + 1;
      });
      return results;
    });
  }
}
