import '../models/message.dart';

// Custom exception for the repository
class MessageRepositoryException implements Exception {
  final String message;
  MessageRepositoryException(this.message);

  @override
  String toString() => 'MessageRepositoryException: $message';
}

// MessageRepository class definition
class MessageRepository {
  // In-memory storage for messages
  final List<Message> _messages = [];
  
  // Lock for thread-safe operations
  final _lock = Object();

  // Fetch all messages
  List<Message> fetchMessages() {
    try {
      _lock;
      return List.unmodifiable(_messages);
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages: $e');
    }
  }

  // Add a new message to the storage
  void addMessage(Message message) {
    try {
      _lock;
      if (message == null) {
        throw ArgumentError('Message cannot be null');
      }
      _messages.add(message);
    } catch (e) {
      throw MessageRepositoryException('Error adding message: $e');
    }
  }

  // Fetch messages by a specific sender
  List<Message> fetchMessagesBySender(String senderId) {
    try {
      _lock;
      if (senderId == null || senderId.isEmpty) {
        throw ArgumentError('Sender ID cannot be null or empty');
      }
      return List.unmodifiable(_messages.where((message) => message.senderId == senderId).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by sender: $e');
    }
  }

  // Fetch messages within a time range
  List<Message> fetchMessagesByTimeRange(DateTime start, DateTime end) {
    try {
      _lock;
      if (start == null || end == null) {
        throw ArgumentError('Start and end dates cannot be null');
      }
      if (start.isAfter(end)) {
        throw ArgumentError('Start date cannot be after end date');
      }
      return List.unmodifiable(_messages.where((message) => message.timestamp.isAfter(start) && message.timestamp.isBefore(end)).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by time range: $e');
    }
  }

  // Fetch messages by content keyword
  List<Message> fetchMessagesByKeyword(String keyword) {
    try {
      _lock;
      if (keyword == null || keyword.isEmpty) {
        throw ArgumentError('Keyword cannot be null or empty');
      }
      return List.unmodifiable(_messages.where((message) => message.text.contains(keyword)).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by keyword: $e');
    }
  }

  // Update a message by ID
  void updateMessage(String messageId, String newText) {
    try {
      _lock;
      if (messageId == null || newText == null) {
        throw ArgumentError('Message ID and new text cannot be null');
      }
      final index = _messages.indexWhere((message) => message.id == messageId);
      if (index == -1) {
        throw ArgumentError('Message with ID $messageId not found');
      }
      _messages[index] = _messages[index].copyWith(text: newText);
    } catch (e) {
      throw MessageRepositoryException('Error updating message: $e');
    }
  }

  // Delete a message by ID
  void deleteMessage(String messageId) {
    try {
      _lock;
      if (messageId == null) {
        throw ArgumentError('Message ID cannot be null');
      }
      final index = _messages.indexWhere((message) => message.id == messageId);
      if (index == -1) {
        throw ArgumentError('Message with ID $messageId not found');
      }
      _messages.removeAt(index);
    } catch (e) {
      throw MessageRepositoryException('Error deleting message: $e');
    }
  }

  // Delete messages by sender
  void deleteMessagesBySender(String senderId) {
    try {
      _lock;
      if (senderId == null || senderId.isEmpty) {
        throw ArgumentError('Sender ID cannot be null or empty');
      }
      _messages.removeWhere((message) => message.senderId == senderId);
    } catch (e) {
      throw MessageRepositoryException('Error deleting messages by sender: $e');
    }
  }

  // Delete all messages
  void deleteAllMessages() {
    try {
      _lock;
      _messages.clear();
    } catch (e) {
      throw MessageRepositoryException('Error deleting all messages: $e');
    }
  }

  // Get message count
  int getMessageCount() {
    try {
      _lock;
      return _messages.length;
    } catch (e) {
      throw MessageRepositoryException('Error getting message count: $e');
    }
  }

  // Fetch messages by type
  List<Message> fetchMessagesByType(MessageType type) {
    try {
      _lock;
      if (type == null) {
        throw ArgumentError('Message type cannot be null');
      }
      return List.unmodifiable(_messages.where((message) => message.type == type).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by type: $e');
    }
  }

  // Fetch messages by status
  List<Message> fetchMessagesByStatus(MessageStatus status) {
    try {
      _lock;
      if (status == null) {
        throw ArgumentError('Message status cannot be null');
      }
      return List.unmodifiable(_messages.where((message) => message.status == status).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by status: $e');
    }
  }

  // Sort messages by timestamp
  List<Message> sortMessagesByTimestamp({bool ascending = true}) {
    try {
      _lock;
      final sortedMessages = List<Message>.from(_messages);
      sortedMessages.sort((a, b) => ascending ? a.timestamp.compareTo(b.timestamp) : b.timestamp.compareTo(a.timestamp));
      return List.unmodifiable(sortedMessages);
    } catch (e) {
      throw MessageRepositoryException('Error sorting messages by timestamp: $e');
    }
  }

  // Fetch messages by a specific receiver
  List<Message> fetchMessagesByReceiver(String receiverId) {
    try {
      _lock;
      if (receiverId == null || receiverId.isEmpty) {
        throw ArgumentError('Receiver ID cannot be null or empty');
      }
      return List.unmodifiable(_messages.where((message) => message.receiverId == receiverId).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by receiver: $e');
    }
  }

  // Fetch messages within a specific chat session
  List<Message> fetchMessagesBySession(String sessionId) {
    try {
      _lock;
      if (sessionId == null || sessionId.isEmpty) {
        throw ArgumentError('Session ID cannot be null or empty');
      }
      return List.unmodifiable(_messages.where((message) => message.sessionId == sessionId).toList());
    } catch (e) {
      throw MessageRepositoryException('Error fetching messages by session: $e');
    }
  }
}
