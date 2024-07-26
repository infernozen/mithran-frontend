import 'package:flutter/material.dart';

// A class representing a chat bubble
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final bool isImageMessage; // Indicates if the message contains an image
  final String? imageUrl; // URL for image messages

  // Constructor for the ChatBubble widget
  ChatBubble({
    required this.text,
    required this.isSentByUser,
    this.isImageMessage = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: isImageMessage ? _buildImageMessage() : _buildTextMessage(),
      ),
    );
  }

  // Builds a text message bubble
  Widget _buildTextMessage() {
    return Text(
      text,
      style: TextStyle(
        color: isSentByUser ? Colors.white : Colors.black,
        fontSize: 16,
      ),
    );
  }

  // Builds an image message bubble
  Widget _buildImageMessage() {
    return imageUrl != null
        ? Image.network(
            imageUrl!,
            width: 200, // Adjust as needed
            height: 200, // Adjust as needed
            fit: BoxFit.cover,
          )
        : Container(); // Return an empty container if no image URL is provided
  }
}
