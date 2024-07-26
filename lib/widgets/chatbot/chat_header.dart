import 'package:flutter/material.dart';

// A class representing the chat header with various functionalities
class ChatHeader extends StatelessWidget {
  final String avatarUrl; // URL for the avatar image
  final String title; // Title of the chat header
  final VoidCallback? onAvatarTap; // Callback when avatar is tapped
  final VoidCallback? onTitleTap; // Callback when title is tapped

  // Constructor for the ChatHeader widget
  ChatHeader({
    this.avatarUrl = 'assets/images/chatbot_avatar.png',
    this.title = 'Chatbot',
    this.onAvatarTap,
    this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        border: Border(bottom: BorderSide(color: Colors.blueGrey[300]!)), // Bottom border
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              backgroundImage: AssetImage(avatarUrl),
              radius: 24, // Radius of the avatar
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: onTitleTap,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
    );
  }

  // Shows additional options for the chat header
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('View Profile'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _viewProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _openSettings();
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _showHelp();
              },
            ),
          ],
        );
      },
    );
  }

  // View profile action
  void _viewProfile() {
    // Implement your logic to view the profile
    print('View profile tapped');
  }

  // Open settings action
  void _openSettings() {
    // Implement your logic to open settings
    print('Settings tapped');
  }

  // Show help action
  void _showHelp() {
    // Implement your logic to show help
    print('Help tapped');
  }
}
