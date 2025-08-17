import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static const _key = 'tasks_v1';

  Future<List<Task>> readTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map(Task.fromJson).toList();
  }

  Future<void> writeTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList(_key, encoded);
  }
}
