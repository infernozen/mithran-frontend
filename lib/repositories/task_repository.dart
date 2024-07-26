import '../models/task_model.dart';

// Custom exception for the repository
class TaskRepositoryException implements Exception {
  final String message;
  TaskRepositoryException(this.message);

  @override
  String toString() => 'TaskRepositoryException: $message';
}

// TaskRepository class definition
class TaskRepository {
  // Simulated database connection or API client
  final _databaseClient = DatabaseClient();

  // Fetch a list of tasks
  Future<List<Task>> fetchTasks() async {
    try {
      // Replace with actual database or API call
      final response = await _databaseClient.get('tasks');
      if (response.statusCode == 200) {
        final List<dynamic> taskData = response.body['tasks'];
        return taskData.map((data) => Task.fromJson(data)).toList();
      } else {
        throw TaskRepositoryException('Failed to fetch tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error fetching tasks: $e');
    }
  }

  // Fetch a task by ID
  Future<Task> fetchTaskById(String id) async {
    try {
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }

      final response = await _databaseClient.get('tasks/$id');
      if (response.statusCode == 200) {
        return Task.fromJson(response.body);
      } else {
        throw TaskRepositoryException('Task with ID $id not found: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error fetching task by ID: $e');
    }
  }

  // Save a new task to the repository
  Future<void> saveTask(Task task) async {
    try {
      if (task == null || task.id == null || task.id.isEmpty) {
        throw ArgumentError('Task and its ID cannot be null or empty');
      }

      final response = await _databaseClient.post(
        'tasks',
        body: task.toJson(),
      );
      if (response.statusCode != 201) {
        throw TaskRepositoryException('Failed to save task: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error saving task: $e');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      if (task == null || task.id == null || task.id.isEmpty) {
        throw ArgumentError('Task and its ID cannot be null or empty');
      }

      final response = await _databaseClient.put(
        'tasks/${task.id}',
        body: task.toJson(),
      );
      if (response.statusCode != 200) {
        throw TaskRepositoryException('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error updating task: $e');
    }
  }

  // Delete a task by ID
  Future<void> deleteTask(String id) async {
    try {
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }

      final response = await _databaseClient.delete('tasks/$id');
      if (response.statusCode != 204) {
        throw TaskRepositoryException('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error deleting task: $e');
    }
  }

  // Fetch tasks by a specific attribute (e.g., due date)
  Future<List<Task>> fetchTasksByAttribute(String attribute, dynamic value) async {
    try {
      if (attribute == null || value == null) {
        throw ArgumentError('Attribute and value cannot be null');
      }

      final response = await _databaseClient.get('tasks?${attribute}=$value');
      if (response.statusCode == 200) {
        final List<dynamic> taskData = response.body['tasks'];
        return taskData.map((data) => Task.fromJson(data)).toList();
      } else {
        throw TaskRepositoryException('Failed to fetch tasks by attribute: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error fetching tasks by attribute: $e');
    }
  }

  // Fetch tasks within a date range
  Future<List<Task>> fetchTasksInDateRange(DateTime startDate, DateTime endDate) async {
    try {
      if (startDate == null || endDate == null || startDate.isAfter(endDate)) {
        throw ArgumentError('Invalid date range');
      }

      final response = await _databaseClient.get(
        'tasks?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> taskData = response.body['tasks'];
        return taskData.map((data) => Task.fromJson(data)).toList();
      } else {
        throw TaskRepositoryException('Failed to fetch tasks in date range: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error fetching tasks in date range: $e');
    }
  }

  // Search tasks by keyword in description
  Future<List<Task>> searchTasks(String keyword) async {
    try {
      if (keyword == null || keyword.isEmpty) {
        throw ArgumentError('Keyword cannot be null or empty');
      }

      final response = await _databaseClient.get('tasks/search?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> taskData = response.body['tasks'];
        return taskData.map((data) => Task.fromJson(data)).toList();
      } else {
        throw TaskRepositoryException('Failed to search tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw TaskRepositoryException('Error searching tasks: $e');
    }
  }
}

// Simulated database client for demonstration
class DatabaseClient {
  Future<Response> get(String endpoint) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {'tasks': []}, // Placeholder for task data
    );
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 201,
      body: {},
    );
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {},
    );
  }

  Future<Response> delete(String endpoint) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 204,
      body: {},
    );
  }
}

// Simulated Response class for demonstration
class Response {
  final int statusCode;
  final Map<String, dynamic> body;

  Response({
    required this.statusCode,
    required this.body,
  });
}
