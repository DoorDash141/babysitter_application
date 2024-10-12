import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class AvailabilityPage extends StatefulWidget {
  final String babysitterName; // Parameter to hold babysitter's name

  const AvailabilityPage(
      {super.key,
      required this.babysitterName}); // Constructor to accept babysitter's name

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  Map<String, dynamic>?
      _currentAvailability; // To store the current saved availability
  bool _isLoading = true; // Loading state variable

  @override
  void initState() {
    super.initState();
    _fetchCurrentAvailability(); // Fetch current availability on page load
  }

  Future<void> _fetchCurrentAvailability() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('availability')
        .doc(widget.babysitterName)
        .get();

    setState(() {
      _isLoading = false; // Set loading to false after fetching data
      if (doc.exists) {
        // Store the current availability
        _currentAvailability = doc.get('availability').last;
      }
    });
  }

  Future<void> _saveAvailability() async {
    if (_selectedDate != null &&
        _selectedStartTime != null &&
        _selectedEndTime != null) {
      // Get the formatted date for storing availability
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Reference to the babysitter's document based on their name
      DocumentReference babysitterDoc = FirebaseFirestore.instance
          .collection('availability')
          .doc(widget.babysitterName);

      // Prepare new availability data
      Map<String, dynamic> newAvailability = {
        'date': formattedDate,
        'start_time': _selectedStartTime!.format(context),
        'end_time': _selectedEndTime!.format(context),
      };

      // Update Firestore with the new availability, replacing the old one
      await babysitterDoc.set(
          {
            'babysitter_name': widget.babysitterName,
            'availability': [
              newAvailability
            ], // Only keep the latest availability
            'timestamp': FieldValue.serverTimestamp(),
          },
          SetOptions(
              merge: true)); // Merge to keep document but replace availability

      // Update the current availability on the UI without reloading the page
      setState(() {
        _currentAvailability = newAvailability;
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Availability updated successfully')),
      );
    } else {
      // Error message if fields aren't selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
    }
  }

  // Function to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to select time (start or end)
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
    }
  }

  Widget _buildSelectableField(
      String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0), // Margin between each field
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the container
          border: Border.all(color: const Color(0xFF08a8e7)), // Border color
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: $value', // Include label in the text
              style: const TextStyle(fontSize: 16), // Removed fontFamily
            ),
            Icon(icon, color: const Color(0xFF08a8e7)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Availability'),
        backgroundColor: const Color(0xFFff7979), // AppBar color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Increased padding for better spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                if (_isLoading) ...[
                  const CircularProgressIndicator(), // Show loading indicator
                  const SizedBox(height: 20), // Space below loading indicator
                  const Text('Loading current availability...'),
                ] else if (_currentAvailability != null) ...[
                  const SizedBox(
                      height: 20), // Space above current availability
                  Text(
                    'Current Saved Availability',
                    style: const TextStyle(
                      fontSize: 22, // Larger font for title
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Space between title and content
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color for the container
                      border: Border.all(
                          color: const Color(0xFF08a8e7)), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${_currentAvailability!['date']}',
                            style: const TextStyle(
                                fontSize: 18)), // Removed fontFamily
                        const SizedBox(height: 8),
                        Text(
                            'Start Time: ${_currentAvailability!['start_time']}',
                            style: const TextStyle(
                                fontSize: 18)), // Removed fontFamily
                        const SizedBox(height: 8),
                        Text('End Time: ${_currentAvailability!['end_time']}',
                            style: const TextStyle(
                                fontSize: 18)), // Removed fontFamily
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          30), // Space between current availability and form
                ],
                _buildSelectableField(
                  'Select Date',
                  _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : 'No date selected',
                  Icons.calendar_today,
                  () => _selectDate(context),
                ),
                _buildSelectableField(
                  'Start Time',
                  _selectedStartTime != null
                      ? _selectedStartTime!.format(context)
                      : 'No time selected',
                  Icons.access_time,
                  () => _selectTime(context, true),
                ),
                _buildSelectableField(
                  'End Time',
                  _selectedEndTime != null
                      ? _selectedEndTime!.format(context)
                      : 'No time selected',
                  Icons.access_time,
                  () => _selectTime(context, false),
                ),
                const SizedBox(height: 30), // Space before the button
                ElevatedButton(
                  onPressed: _saveAvailability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF08a8e7), // Button background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Save Availability',
                    style: TextStyle(fontSize: 18), // Removed fontFamily
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
