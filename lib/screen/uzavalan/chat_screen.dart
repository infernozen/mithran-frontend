import 'package:flutter/material.dart';

// Message model
class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

// ChatController for managing chat logic
class ChatController {
  final List<Message> messages = [];

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      messages.add(Message(sender: 'User', text: text));
    }
  }
}

// ChatHeader widget to display the chat header
class ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 16.0),
          Text(
            'Chat Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// MessageList widget to display the list of messages
class MessageList extends StatelessWidget {
  final ChatController chatController;

  MessageList({required this.chatController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatController.messages.length,
      itemBuilder: (context, index) {
        final message = chatController.messages[index];
        return ListTile(
          title: Text(message.sender),
          subtitle: Text(message.text),
        );
      },
    );
  }
}

// ChatInputField widget for typing and sending messages
class ChatInputField extends StatelessWidget {
  final ChatController chatController;

  ChatInputField({required this.chatController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              chatController.sendMessage(textController.text);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}

// ChatScreen widget to display the chat interface
class ChatScreen extends StatelessWidget {
  final ChatController chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          ChatHeader(),
          Expanded(child: MessageList(chatController: chatController)),
          ChatInputField(chatController: chatController),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}
