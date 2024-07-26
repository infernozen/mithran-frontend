import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Message Model
class Message {
  final String text;
  final String senderId;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      senderId: json['senderId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Message(text: $text, senderId: $senderId, timestamp: $timestamp)';
  }
}

// Chatbot Service
class ChatbotService {
  final String _apiUrl = 'https://api.example.com/chatbot'; // Replace with your API endpoint

  Future<String> getResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      throw Exception('Error fetching chatbot response: $e');
    }
  }
}

// Chat Controller
class ChatController {
  final ValueNotifier<List<Message>> messages = ValueNotifier([]);
  final ChatbotService _chatbotService;
  final String userId;

  ChatController({
    required ChatbotService chatbotService,
    required this.userId,
  }) : _chatbotService = chatbotService;

  void sendMessage(String text) {
    final message = Message(
      text: text,
      senderId: userId,
      timestamp: DateTime.now(),
    );
    messages.value = [...messages.value, message];
    _getResponse(text);
  }

  void _getResponse(String userMessage) async {
    try {
      final botResponse = await _chatbotService.getResponse(userMessage);
      final message = Message(
        text: botResponse,
        senderId: 'bot',
        timestamp: DateTime.now(),
      );
      messages.value = [...messages.value, message];
    } catch (e) {
      final message = Message(
        text: 'Sorry, something went wrong.',
        senderId: 'bot',
        timestamp: DateTime.now(),
      );
      messages.value = [...messages.value, message];
    }
  }
}

// Chat Screen
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController _chatController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatController = ChatController(
      chatbotService: ChatbotService(),
      userId: 'user_123', // Replace with dynamic user ID if needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Message>>(
              valueListenable: _chatController.messages,
              builder: (context, messages, child) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message.senderId == _chatController.userId;
                    return ListTile(
                      title: Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          message.timestamp.toLocal().toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white60),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _chatController.sendMessage(text);
      _messageController.clear();
    }
  }
}

// Main function
void main() {
  runApp(MaterialApp(
    title: 'Chatbot App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ChatScreen(),
  ));
}
