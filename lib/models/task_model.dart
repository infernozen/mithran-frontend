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
    this.isCompleted = false,
  });
}
