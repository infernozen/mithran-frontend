import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// ChatbotService class
class ChatbotService {
  final String _baseUrl;
  final String _apiKey;

  // Constructor
  ChatbotService(this._baseUrl, this._apiKey);

  // Method to get a response from the chatbot
  Future<String> getResponse(String userMessage) async {
    try {
      final response = await _sendRequest(userMessage);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      throw Exception('Error getting response: $e');
    }
  }

  // Private method to send a request to the chatbot API
  Future<http.Response> _sendRequest(String userMessage) async {
    final uri = Uri.parse('$_baseUrl/chat');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode({'message': userMessage});
    
    final response = await http.post(uri, headers: headers, body: body);
    return response;
  }
}

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
}

// Chat Controller
class ChatController {
  final ValueNotifier<List<Message>> messages = ValueNotifier([]);
  final ChatbotService _chatbotService;
  final String userId;

  ChatController(this._chatbotService, this.userId);

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
      final errorMessage = Message(
        text: 'Error: ${e.toString()}',
        senderId: 'bot',
        timestamp: DateTime.now(),
      );
      messages.value = [...messages.value, errorMessage];
    }
  }
}

// UI Widget for Chat Screen
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatController _chatController;
  
  @override
  void initState() {
    super.initState();
    final chatbotService = ChatbotService(
      'https://api.example.com',
      'your_api_key_here',
    );
    _chatController = ChatController(chatbotService, 'user_123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Message>>(
              valueListenable: _chatController.messages,
              builder: (context, messages, _) {
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(
                        message.text,
                        style: TextStyle(
                          color: message.senderId == 'bot'
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        message.timestamp.toLocal().toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      contentPadding: EdgeInsets.all(8),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
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
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      _controller.clear();
      _chatController.sendMessage(text);
    }
  }
}

// Error Handling and Logging Utility
import 'dart:developer';

class ErrorLogger {
  static void logError(String message, [dynamic error]) {
    log('Error: $message', level: Level.SEVERE, error: error);
  }
}

// Logging Levels for Error Logger
enum Level { INFO, WARNING, SEVERE }

class Level {
  static const int INFO = 200;
  static const int WARNING = 300;
  static const int SEVERE = 400;
}

// Main Function
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
