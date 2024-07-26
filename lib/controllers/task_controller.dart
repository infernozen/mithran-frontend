import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, isCompleted: $isCompleted)';
  }
}

// Task Service
class TaskService {
  final String _baseUrl = 'https://api.example.com/tasks'; // Replace with your API endpoint

  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<Task> getTaskById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(task.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${task.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(task.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
}

// Task Controller
class TaskController {
  final TaskService _taskService;

  TaskController(this._taskService);

  Future<List<Task>> fetchTasks() async {
    try {
      return await _taskService.getTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }

  Future<Task> fetchTaskById(String id) async {
    try {
      return await _taskService.getTaskById(id);
    } catch (e) {
      print('Error fetching task by ID: $e');
      rethrow;
    }
  }

  Future<void> createTask(Task task) async {
    try {
      await _taskService.createTask(task);
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskService.deleteTask(id);
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}

// Task Widget
class TaskWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title: ${task.title}', style: Theme.of(context).textTheme.headline6),
          Text('Description: ${task.description}', style: Theme.of(context).textTheme.bodyText1),
          Text('Due Date: ${task.dueDate}', style: Theme.of(context).textTheme.bodyText1),
          Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}', style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onEdit,
            child: Text('Edit Task'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onDelete,
            child: Text('Delete Task'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
        ],
      ),
    );
  }
}

// Task Edit Form
class TaskEditForm extends StatefulWidget {
  final Task task;
  final TaskController taskController;

  const TaskEditForm({
    Key? key,
    required this.task,
    required this.taskController,
  }) : super(key: key);

  @override
  _TaskEditFormState createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDateController = TextEditingController(text: widget.task.dueDate.toLocal().toString());
    _isCompleted = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            controller: _dueDateController,
            decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD HH:MM:SS)'),
            keyboardType: TextInputType.datetime,
          ),
          Row(
            children: [
              Text('Completed'),
              Checkbox(
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveTask,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _saveTask() async {
    final task = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: DateTime.parse(_dueDateController.text),
      isCompleted: _isCompleted,
    );

    try {
      await widget.taskController.updateTask(task);
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to update task');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Task List Screen
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController _taskController = TaskController(TaskService());
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _tasksFuture = _taskController.fetchTasks();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskWidget(
                  task: task,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskEditForm(
                          task: task,
                          taskController: _taskController,
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    try {
                      await _taskController.deleteTask(task.id);
                      setState(() {
                        _tasksFuture = _taskController.fetchTasks();
                      });
                    } catch (e) {
                      _showError('Failed to delete task');
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Main function
void main() {
  runApp(MaterialApp(
    title: 'Task Management App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: TaskListScreen(),
  ));
}
