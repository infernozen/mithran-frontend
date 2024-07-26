import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';

class MessageList extends StatelessWidget {
  final ChatController chatController;

  MessageList({required this.chatController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Message>>(
      valueListenable: chatController.messages,
      builder: (context, messages, _) {
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ChatBubble(
              text: message.text,
              isSentByUser: message.senderId == chatController.userId,
            );
          },
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;

  ChatBubble({required this.text, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSentByUser ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSentByUser ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class ChatController {
  ValueNotifier<List<Message>> messages = ValueNotifier<List<Message>>([]);
  final String userId;

  ChatController({required this.userId});

  void sendMessage(String text) {
    // Implement sending a message
    final newMessage = Message(text: text, senderId: userId);
    messages.value = [...messages.value, newMessage];
  }
}

class Message {
  final String text;
  final String senderId;

  Message({required this.text, required this.senderId});
}
