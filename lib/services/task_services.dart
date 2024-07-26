import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepository;

  // Constructor to inject the repository dependency
  TaskService(this._taskRepository);

  // Cache for storing fetched tasks
  List<Task>? _cachedTasks;

  // Fetch tasks with optional caching
  Future<List<Task>> getTasks({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedTasks != null) {
      return _cachedTasks!;
    }

    try {
      final tasks = await _taskRepository.fetchTasks();
      _cachedTasks = tasks;
      return tasks;
    } catch (e) {
      // Handle errors appropriately
      handleError(e);
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _taskRepository.createTask(task);
      // Optionally refresh the cache
      _cachedTasks = null; // Clear cache to force refresh on next fetch
    } catch (e) {
      handleError(e);
      throw Exception('Error adding task: $e');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      // Optionally refresh the cache
      _cachedTasks = null; // Clear cache to force refresh on next fetch
    } catch (e) {
      handleError(e);
      throw Exception('Error updating task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      // Optionally refresh the cache
      _cachedTasks = null; // Clear cache to force refresh on next fetch
    } catch (e) {
      handleError(e);
      throw Exception('Error deleting task: $e');
    }
  }

  // Utility method to handle errors
  void handleError(Exception e) {
    // Implement error handling, e.g., logging or user notifications
    print('Error: $e');
  }

  // Logging for requests and responses
  void logRequest(String method, String endpoint, {Map<String, dynamic>? data}) {
    print('Request Method: $method');
    print('Request Endpoint: $endpoint');
    if (data != null) {
      print('Request Data: ${data}');
    }
  }

  void logResponse(int statusCode, String responseBody) {
    print('Response Status Code: $statusCode');
    print('Response Body: $responseBody');
  }
}

// Example TaskRepository class
class TaskRepository {
  final String baseUrl = 'https://api.example.com/tasks';

  // Fetch tasks
  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> taskData = jsonDecode(response.body);
      return taskData.map((data) => Task.fromJson(data)).toList();
    } else {
      throw HttpException('Failed to fetch tasks: ${response.statusCode}');
    }
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode != 201) {
      throw HttpException('Failed to create task: ${response.statusCode}');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/${task.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode != 200) {
      throw HttpException('Failed to update task: ${response.statusCode}');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/$taskId');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw HttpException('Failed to delete task: ${response.statusCode}');
    }
  }
}

// Example Task model
class Task {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
