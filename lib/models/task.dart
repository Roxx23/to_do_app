import 'dart:convert';

enum Priority { low, medium, high }

class Task {
  final String id;
  String title;
  Priority priority;
  bool completed;

  /// Used for a subtle first-show animation.
  bool isNew;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.completed = false,
    this.isNew = false,
  });

  factory Task.create({required String title, required Priority priority}) {
    return Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      completed: false,
      isNew: true,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'priority': priority.name,
    'completed': completed,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as String,
    title: map['title'] as String,
    priority: Priority.values.firstWhere(
      (p) => p.name == map['priority'],
      orElse: () => Priority.low,
    ),
    completed: map['completed'] as bool? ?? false,
    isNew: false,
  );

  String toJson() => jsonEncode(toMap());
  factory Task.fromJson(String source) =>
      Task.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
