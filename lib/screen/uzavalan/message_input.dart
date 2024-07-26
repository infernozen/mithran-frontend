import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';

class MessageInput extends StatelessWidget {
  final ChatController chatController;
  final TextEditingController _controller = TextEditingController();

  MessageInput({required this.chatController});

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      chatController.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
