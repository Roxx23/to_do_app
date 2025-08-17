import 'package:flutter/foundation.dart';
import '../../data/task_storage.dart';
import '../../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStorage _storage = TaskStorage();

  final List<Task> _tasks = [];
  final Set<Priority> _activePriorities = {
    Priority.low,
    Priority.medium,
    Priority.high,
  };
  bool _showCompleted = true;

  // Bumps whenever a bulk change occurs, used for list cross-fade keys.
  int _version = 0;

  List<Task> get tasks => List.unmodifiable(_tasks);
  Set<Priority> get activePriorities => _activePriorities;
  bool get showCompleted => _showCompleted;
  int get version => _version;

  Future<void> loadTasks() async {
    final loaded = await _storage.readTasks();
    _tasks
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storage.writeTasks(_tasks);
  }

  bool isTaskVisible(Task t) {
    if (!_activePriorities.contains(t.priority)) return false;
    if (!_showCompleted && t.completed) return false;
    return true;
  }

  void togglePriority(Priority p) {
    if (_activePriorities.contains(p)) {
      _activePriorities.remove(p);
    } else {
      _activePriorities.add(p);
    }
    notifyListeners();
  }

  void setShowCompleted(bool value) {
    _showCompleted = value;
    notifyListeners();
  }

  Future<void> addTask(String title, Priority p) async {
    final task = Task.create(title: title, priority: p);
    _tasks.insert(0, task);
    notifyListeners();

    // Turn off 'isNew' after first frame so future rebuilds don't animate again
    Future.delayed(const Duration(milliseconds: 450), () {
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _tasks[idx].isNew = false;
        notifyListeners();
      }
    });

    await _persist();
  }

  Future<void> toggleCompleted(String id, bool value) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].completed = value;
    notifyListeners();
    await _persist();
  }

  Future<void> clearCompleted() async {
    _tasks.removeWhere((t) => t.completed);
    _version++; // trigger list cross-fade
    notifyListeners();
    await _persist();
  }

  int get completedCount => _tasks.where((t) => t.completed).length;
}
