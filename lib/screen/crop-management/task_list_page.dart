import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_widgets.dart';

class TaskListPage extends StatelessWidget {
  final TaskController taskController;

  TaskListPage({Key? key, required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(taskController: taskController),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: taskController.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List tasks = snapshot.data as List;
            return TaskListWidget(tasks: tasks);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate<String> {
  final TaskController taskController;

  TaskSearchDelegate({required this.taskController});

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: taskController.fetchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final tasks = snapshot.data as List;
          final suggestions = tasks.where((task) {
            return task.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final task = suggestions[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text('${task.description} - Due: ${task.dueDate}'),
                onTap: () {
                  close(context, task.name);
                },
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = taskController.fetchTasks().then((tasks) {
      return tasks.where((task) {
        return task.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });

    return FutureBuilder(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final results = snapshot.data as List;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final task = results[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text('${task.description} - Due: ${task.dueDate}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(task: task),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Center(child: Text('No results found'));
        }
      },
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Due Date: ${task.dueDate}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Additional task details can be added here
          ],
        ),
      ),
    );
  }
}
