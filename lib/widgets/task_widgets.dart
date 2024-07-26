import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskToggle;
  final Function(Task) onTaskEdit;

  TaskListWidget({
    required this.tasks,
    required this.onTaskToggle,
    required this.onTaskEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TaskList(
          tasks: tasks,
          onTaskToggle: onTaskToggle,
          onTaskEdit: onTaskEdit,
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskToggle;
  final Function(Task) onTaskEdit;

  TaskList({
    required this.tasks,
    required this.onTaskToggle,
    required this.onTaskEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(
          task: task,
          onTaskToggle: onTaskToggle,
          onTaskEdit: onTaskEdit,
        );
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onTaskToggle;
  final Function(Task) onTaskEdit;

  TaskListItem({
    required this.task,
    required this.onTaskToggle,
    required this.onTaskEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        task.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${task.description} - Due: ${task.dueDate}',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          onTaskEdit(task);
        },
      ),
      onTap: () {
        onTaskToggle(task);
      },
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final newTask = Task(
                id: DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                dueDate: _dueDate,
                isCompleted: _isCompleted,
              );
              Navigator.pop(context, newTask);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text('Due Date: ${_dueDate.toLocal()}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _dueDate)
                      setState(() {
                        _dueDate = pickedDate;
                      });
                  },
                ),
              ],
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
          ],
        ),
      ),
    );
  }
}
