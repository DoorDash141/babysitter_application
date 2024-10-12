import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _notificationsEnabled = true;
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String _currentPasswordError = ''; // Error message for current password
  String _newPasswordError = ''; // Error message for new password
  String _confirmPasswordError = ''; // Error message for confirm new password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: const Color(0xFFff7979), // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align label and content to the left
          children: [
            // Security Settings label
            Text(
              'Security Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF08a8e7), // Title color
              ),
            ),
            const SizedBox(height: 16), // Space between label and options

            // Password Management Option
            ListTile(
              title: Text('Password Management'),
              subtitle: Text('Update your account password'),
              trailing:
                  Icon(Icons.arrow_forward, color: const Color(0xFF08a8e7)),
              onTap: () {
                setState(() {
                  _currentPasswordError = '';
                  _newPasswordError = '';
                  _confirmPasswordError = '';
                  _currentPassword = '';
                  _newPassword = '';
                  _confirmPassword = '';
                });
                _showChangePasswordDialog(context);
              },
            ),
            Divider(), // Separator

            // Notification Preferences Option
            Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF08a8e7), // Title color
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Manage Notifications'),
              subtitle: Text(
                  'Options for managing how and when you receive notifications.'),
              trailing: Switch(
                value: _notificationsEnabled,
                activeColor: const Color(0xFF08a8e7), // Switch active color
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            Divider(), // Separator

            // Help and Support section
            Text(
              'Help and Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF08a8e7), // Title color
              ),
            ),
            const SizedBox(height: 16),
            // Clickable ListTile for FAQs and Contact Support
            ListTile(
              title: Text("FAQs, Contact Forms, or Live Chat."),
              subtitle: Text(
                  'Find answers to frequently asked questions and contact support if you need further assistance.'),
              onTap: () {
                // Navigate to FAQs and Support Page
              },
            ),
            Divider(), // Separator

            // Legal section
            Text(
              'Terms and Conditions/Privacy Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF08a8e7), // Title color
              ),
            ),
            const SizedBox(height: 16),
            // Clickable ListTile for Terms and Privacy Policy
            ListTile(
              title: Text("App’s Legal Policies."),
              subtitle: Text(
                  'Review the terms and conditions and privacy policy to understand how your data is handled.'),
              onTap: () {
                // Navigate to Terms and Conditions & Privacy Policy Page
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the change password dialog
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your password must be at least 6 characters and should include a combination of numbers and letters.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter current password',
                      errorText: _currentPasswordError.isEmpty
                          ? null
                          : _currentPasswordError,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(
                                0xFF08a8e7)), // Change border color when focused
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentPassword = value;
                        _currentPasswordError = '';
                      });
                    },
                  ),
                  SizedBox(height: 8), // Space between fields
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      errorText:
                          _newPasswordError.isEmpty ? null : _newPasswordError,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(
                                0xFF08a8e7)), // Change border color when focused
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _newPassword = value;
                        _newPasswordError = '';
                      });
                    },
                  ),
                  SizedBox(height: 8), // Space between fields
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      errorText: _confirmPasswordError.isEmpty
                          ? null
                          : _confirmPasswordError,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(
                                0xFF08a8e7)), // Change border color when focused
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                        _confirmPasswordError = '';
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Validate new password length
                    if (_newPassword.length < 6) {
                      setState(() {
                        _newPasswordError =
                            'New password must be at least 6 characters';
                      });
                      return;
                    }

                    // Validate new password confirmation
                    if (_newPassword != _confirmPassword) {
                      setState(() {
                        _confirmPasswordError = 'New password does not match';
                      });
                      return;
                    }

                    try {
                      User? user = _auth.currentUser;

                      // Re-authenticate the user
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user!.email!,
                        password: _currentPassword,
                      );

                      await user.reauthenticateWithCredential(credential);

                      // Update the password
                      await user.updatePassword(_newPassword);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Password changed successfully')),
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      setState(() {
                        _currentPasswordError = 'Current password is incorrect';
                      });
                    }
                  },
                  child: Text('Change',
                      style: TextStyle(
                          color:
                              const Color(0xFF08a8e7))), // Change button color
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog on cancel
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
