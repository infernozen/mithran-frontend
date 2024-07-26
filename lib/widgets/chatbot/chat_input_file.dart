import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';

// A widget that provides a text input field for sending messages in the chat
class ChatInputField extends StatefulWidget {
  final ChatController chatController;

  ChatInputField({required this.chatController});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    // Add listener to the text controller to manage state
    _textController.addListener(() {
      setState(() {
        _isComposing = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    widget.chatController.sendMessage(text);
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: null, // Allow multi-line input
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            color: _isComposing ? Colors.blue : Colors.grey,
            onPressed: _isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );
  }
}

// A widget representing the message input area, including additional features
class MessageInput extends StatelessWidget {
  final ChatController chatController;

  MessageInput({required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildInputField(),
          _buildSendButton(),
        ],
      ),
    );
  }

  // Builds the text input field for message input
  Widget _buildInputField() {
    return TextField(
      onChanged: (text) {
        // Handle changes to the text field
      },
      decoration: InputDecoration(
        hintText: 'Type a message...',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }

  // Builds the send button next to the text input field
  Widget _buildSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () {
        // Handle the send button action
        // This should ideally call a method in the chatController to send the message
      },
    );
  }
}

// Widget to handle additional actions like attachments or emoji picker
class ChatInputToolbar extends StatelessWidget {
  final ChatController chatController;

  ChatInputToolbar({required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: <Widget>[
          _buildAttachmentButton(),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
              onChanged: (text) {
                // Handle text changes
              },
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(width: 8.0),
          _buildSendButton(),
        ],
      ),
    );
  }

  // Builds the attachment button
  Widget _buildAttachmentButton() {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () {
        // Handle attachment button press
      },
    );
  }

  // Builds the send button
  Widget _buildSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () {
        // Handle send button press
        // This should ideally call a method in the chatController to send the message
      },
    );
  }
}
