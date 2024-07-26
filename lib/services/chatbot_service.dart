import 'dart:convert';
import 'package:http/http.dart' as http;

// Model classes for request and response
class ChatRequest {
  final String userId;
  final String message;

  ChatRequest({required this.userId, required this.message});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'message': message,
      };
}

class ChatResponse {
  final String message;
  final bool isError;

  ChatResponse({required this.message, this.isError = false});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] ?? '',
      isError: json['is_error'] ?? false,
    );
  }
}

// ChatbotService class
class ChatbotService {
  final String baseUrl;
  final http.Client httpClient;

  ChatbotService({required this.baseUrl, http.Client? client})
      : httpClient = client ?? http.Client();

  // Send a message to the chatbot and receive a response
  Future<ChatResponse> sendMessage(String userId, String message) async {
    final url = Uri.parse('$baseUrl/chat');
    final request = ChatRequest(userId: userId, message: message);

    try {
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ChatResponse.fromJson(responseData);
      } else {
        // Handle non-200 responses
        return ChatResponse(
          message: 'Error: ${response.statusCode}',
          isError: true,
        );
      }
    } catch (e) {
      // Handle exceptions
      return ChatResponse(
        message: 'An error occurred: $e',
        isError: true,
      );
    }
  }

  // Example function to fetch chat history for a user
  Future<List<ChatResponse>> fetchChatHistory(String userId) async {
    final url = Uri.parse('$baseUrl/history?user_id=$userId');

    try {
      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => ChatResponse.fromJson(data)).toList();
      } else {
        // Handle non-200 responses
        return [
          ChatResponse(
            message: 'Error: ${response.statusCode}',
            isError: true,
          ),
        ];
      }
    } catch (e) {
      // Handle exceptions
      return [
        ChatResponse(
          message: 'An error occurred: $e',
          isError: true,
        ),
      ];
    }
  }

  // Example function to manage chatbot session
  Future<String> startSession(String userId) async {
    final url = Uri.parse('$baseUrl/start_session');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['session_id'] ?? '';
    } else {
      throw Exception('Failed to start session: ${response.statusCode}');
    }
  }

  Future<void> endSession(String sessionId) async {
    final url = Uri.parse('$baseUrl/end_session');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'session_id': sessionId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to end session: ${response.statusCode}');
    }
  }

  // Example function to handle different types of messages
  Future<ChatResponse> handleUserMessage(String userId, String message) async {
    // Start session if needed
    String sessionId = await startSession(userId);

    // Send user message
    final response = await sendMessage(userId, message);

    // End session if needed
    await endSession(sessionId);

    return response;
  }

  // Example function to provide suggestions based on user input
  Future<List<String>> getSuggestions(String userId, String input) async {
    final url = Uri.parse('$baseUrl/suggestions');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'input': input}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to get suggestions: ${response.statusCode}');
    }
  }

  // Utility function to handle common API errors
  void handleApiError(http.Response response) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Client error: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
