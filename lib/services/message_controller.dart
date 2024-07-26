import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';

class MessageController extends ChangeNotifier {
  final MessageService _messageService;
  List<Message> _messages = [];
  bool _isLoading = false;
  String _errorMessage = '';

  MessageController(this._messageService);

  // Getter for messages
  List<Message> get messages => _messages;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for error message
  String get errorMessage => _errorMessage;

  // Fetch messages
  Future<void> fetchMessages() async {
    _setLoading(true);
    try {
      _messages = await _messageService.getMessages();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch messages: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Send a new message
  Future<void> sendMessage(Message message) async {
    _setLoading(true);
    try {
      await _messageService.sendMessage(message);
      // Optionally refresh messages after sending
      await fetchMessages();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Delete a message
  Future<void> deleteMessage(String messageId) async {
    _setLoading(true);
    try {
      await _messageService.deleteMessage(messageId);
      // Optionally refresh messages after deletion
      await fetchMessages();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to delete message: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Example of a method to handle search/filter functionality
  void searchMessages(String query) {
    notifyListeners();
  }
}
