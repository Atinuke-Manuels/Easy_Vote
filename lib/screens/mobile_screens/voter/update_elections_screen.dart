import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_styles.dart';
import '../../../models/election.dart';
import '../../../services/firebase_service.dart';
import '../../../themes/theme_provider.dart'; // Import for date formatting

class UpdateElectionScreen extends StatefulWidget {
  final Election election;

  const UpdateElectionScreen({Key? key, required this.election})
      : super(key: key);

  @override
  _UpdateElectionScreenState createState() => _UpdateElectionScreenState();
}

class _UpdateElectionScreenState extends State<UpdateElectionScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  late TextEditingController _titleController;
  late TextEditingController _candidatesController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  TextEditingController _voterIdsController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.election.title);
    _candidatesController = TextEditingController(text: widget.election.candidates.join(', '));
    _startDate = widget.election.startDate;
    _endDate = widget.election.endDate;

    // Initialize the date controllers with formatted dates
    _startDateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy HH:mm').format(_startDate!));
    _endDateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy HH:mm').format(_endDate!));

    // Initialize voter IDs controller
    _voterIdsController = TextEditingController(
      text: widget.election.registeredVoters.join(', '),
    ); // Ensure existing voter IDs are loaded if they exist
  }


  @override
  void dispose() {
    _titleController.dispose();
    _candidatesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _updateElection() async {
    String title = _titleController.text.trim();
    List<String> candidates = _candidatesController.text.split(',').map((s) => s.trim()).toList();
    List<String> registeredVoters = _voterIdsController.text.split(',').map((s) => s.trim()).toList(); // Assuming _votersController is for registered voters

    // Validation checks
    if (title.isEmpty) {
      _showErrorDialog('Election title is required.');
      return;
    }

    if (candidates.length < 2) {
      _showErrorDialog('At least two candidates are required.');
      return;
    }

    if (registeredVoters.length < 2) {
      _showErrorDialog('At least two voters are required.');
      return;
    }

    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        _showErrorDialog('End date and time must be after the start date and time.');
        return;
      }
    } else {
      _showErrorDialog('Both start and end dates must be selected.');
      return;
    }

    Election updatedElection = Election(
      id: widget.election.id,
      title: title,
      candidates: candidates,
      startDate: _startDate!,
      endDate: _endDate!,
      creatorId: _firebaseService.currentUserId!,
      registeredVoters: registeredVoters, // Add registered voters
    );

    if (widget.election.id.isEmpty) {
      await _firebaseService.addElection(updatedElection);
    } else {
      await _firebaseService.updateElection(updatedElection);
    }

    Navigator.pop(context);
  }


// Helper function to display error messages
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Future<void> _selectStartDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _startDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          // Update the controller text after selection
          _startDateController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(_startDate!);
        });
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _endDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          // Update the controller text after selection
          _endDateController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(_endDate!);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Update Election', style: AppTextStyles.headingStyle(context),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top:40, right: MediaQuery.of(context).size.width* 0.025, left: MediaQuery.of(context).size.width* 0.025),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              reverse: false,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Election Title', labelStyle: AppTextStyles.hintTextStyle(context),),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: _candidatesController,
                    decoration: InputDecoration(
                        labelText: 'Candidates (comma-separated)', labelStyle: AppTextStyles.hintTextStyle(context),),
                  ),
                  SizedBox(height: 15,),
                  // Inside the build method, add a new text field
                  TextField(
                    controller: _voterIdsController,
                    decoration: InputDecoration(labelText: 'Voter IDs (comma-separated)', labelStyle: AppTextStyles.hintTextStyle(context),),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: _startDateController,
                    readOnly: true, // Make it read-only so users can't type in it
                    decoration: InputDecoration(
                      labelText: 'Start Date & Time',
                      labelStyle: AppTextStyles.hintTextStyle(context),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectStartDateTime,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: _endDateController,
                    readOnly: true, // Make it read-only so users can't type in it
                    decoration: InputDecoration(
                      labelText: 'End Date & Time',
                      labelStyle: AppTextStyles.hintTextStyle(context),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectEndDateTime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateElection,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                      foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0)), // Padding
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      elevation: WidgetStateProperty.all(5), // Elevation
                    ),
                    child: Text('Update Election', style: AppTextStyles.cardTextStyle(context)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}