import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../models/user.dart';

// Define a custom exception for handling errors
class ChatbotRepositoryException implements Exception {
  final String message;
  ChatbotRepositoryException(this.message);

  @override
  String toString() => 'ChatbotRepositoryException: $message';
}

// Define the ChatbotRepository class
class ChatbotRepository {
  final String _baseUrl;
  final String _apiKey;

  // Constructor
  ChatbotRepository(this._baseUrl, this._apiKey);

  // Method to fetch a response from the chatbot service
  Future<String> fetchResponse(String userMessage) async {
    try {
      final response = await _sendRequest(userMessage);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw ChatbotRepositoryException('Failed to fetch response from chatbot');
      }
    } catch (e) {
      throw ChatbotRepositoryException('Error fetching response: $e');
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

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ChatbotRepositoryException('Failed to send request: $e');
    }
  }

  // Fetch predefined responses from a local or remote source
  Future<Map<String, String>> fetchPredefinedResponses() async {
    // Simulating fetching predefined responses from a file or remote server
    // Replace this with actual file or network operation
    return {
      'hello': 'Hello! How can I assist you today?',
      'how are you': 'I am just a bot, but I am here to help you!',
      'bye': 'Goodbye! Have a nice day!',
    };
  }

  // Fetch a response from predefined responses
  Future<String> fetchPredefinedResponse(String userMessage) async {
    try {
      final responses = await fetchPredefinedResponses();
      String normalizedMessage = userMessage.toLowerCase();

      if (responses.containsKey(normalizedMessage)) {
        return responses[normalizedMessage]!;
      } else {
        return 'I\'m not sure how to respond to that. Can you rephrase?';
      }
    } catch (e) {
      throw ChatbotRepositoryException('Error fetching predefined response: $e');
    }
  }

  // Analyze user message sentiment (simulated)
  Future<String> analyzeSentiment(String userMessage) async {
    // Simulated sentiment analysis logic
    // Replace this with actual sentiment analysis logic
    return userMessage.contains('happy') ? 'positive' : 'neutral';
  }

  // Handle different types of responses
  Future<String> handleResponse(String userMessage) async {
    try {
      // First try fetching predefined response
      final predefinedResponse = await fetchPredefinedResponse(userMessage);
      if (predefinedResponse != 'I\'m not sure how to respond to that. Can you rephrase?') {
        return predefinedResponse;
      }

      // If not found in predefined responses, get a response from chatbot service
      final chatbotResponse = await fetchResponse(userMessage);

      // Analyze sentiment of the chatbot response (optional)
      final sentiment = await analyzeSentiment(chatbotResponse);

      // Return response along with sentiment information
      return 'Sentiment: $sentiment\nResponse: $chatbotResponse';
    } catch (e) {
      throw ChatbotRepositoryException('Error handling response: $e');
    }
  }

  // Log interaction for debugging or analytics purposes
  void logInteraction(String userMessage, String response) {
    // Implement logging logic here
    // For example, saving logs to a file or sending to a logging service
    print('User Message: $userMessage');
    print('Bot Response: $response');
  }
}

// Define a ChatbotService class that uses ChatbotRepository
class ChatbotService {
  final ChatbotRepository _repository;

  // Constructor
  ChatbotService(this._repository);

  // Method to get a response from the chatbot service
  Future<String> getResponse(String userMessage) async {
    try {
      final response = await _repository.handleResponse(userMessage);
      _repository.logInteraction(userMessage, response);
      return response;
    } catch (e) {
      throw ChatbotRepositoryException('Error getting response: $e');
    }
  }
}

// Main function to demonstrate usage
void main() async {
  final baseUrl = 'https://api.example.com';
  final apiKey = 'your_api_key_here';
  
  final repository = ChatbotRepository(baseUrl, apiKey);
  final service = ChatbotService(repository);

  try {
    final userMessage = 'hello';
    final response = await service.getResponse(userMessage);
    print('Chatbot Response: $response');
  } catch (e) {
    print('Error: $e');
  }
}
