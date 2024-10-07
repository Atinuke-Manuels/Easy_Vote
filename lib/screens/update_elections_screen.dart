import 'package:flutter/material.dart';
import '../models/election.dart';
import '../services/firebase_service.dart';

class UpdateElectionScreen extends StatefulWidget {
  final Election election;

  const UpdateElectionScreen({Key? key, required this.election}) : super(key: key);

  @override
  _UpdateElectionScreenState createState() => _UpdateElectionScreenState();
}

class _UpdateElectionScreenState extends State<UpdateElectionScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  late TextEditingController _titleController;
  late TextEditingController _candidatesController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.election.title);
    _candidatesController = TextEditingController(text: widget.election.candidates.join(', '));
    _startDate = widget.election.startDate;
    _endDate = widget.election.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _candidatesController.dispose();
    super.dispose();
  }

  Future<void> _updateElection() async {
    List<String> candidates = _candidatesController.text.split(',').map((s) => s.trim()).toList();

    Election updatedElection = Election(
      id: widget.election.id,
      title: _titleController.text,
      candidates: candidates,
      startDate: _startDate!,
      endDate: _endDate!,
    );

    // Check if the election exists
    if (widget.election.id.isEmpty) {
      // If no ID exists, create a new election
      await _firebaseService.addElection(updatedElection);
    } else {
      // If an ID exists, update the existing election
      await _firebaseService.updateElection(updatedElection);
    }

    Navigator.pop(context); // Go back after updating
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Election')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Election Title'),
            ),
            TextField(
              controller: _candidatesController,
              decoration: const InputDecoration(labelText: 'Candidates (comma-separated)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Date: ${_startDate?.toLocal().toString().split(' ')[0] ?? ''}'),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _startDate) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  child: const Text('Pick Start Date'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Date: ${_endDate?.toLocal().toString().split(' ')[0] ?? ''}'),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _endDate) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  child: const Text('Pick End Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateElection,
              child: const Text('Update Election'),
            ),
          ],
        ),
      ),
    );
  }
}
