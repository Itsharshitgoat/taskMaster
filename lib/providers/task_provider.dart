import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/db_helper.dart';

// Represents an action for Undo/Redo stack
class TaskAction {
  final String type; // 'add', 'update', 'delete'
  final Task task;
  final Task? oldTask; // In case of update

  TaskAction({required this.type, required this.task, this.oldTask});
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final List<TaskAction> _undoStack = [];
  final List<TaskAction> _redoStack = [];

  List<Task> get tasks => _tasks;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Task> _filterSearch(List<Task> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    final list = _tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return true;
      return t.dueDate!.year == now.year && t.dueDate!.month == now.month && t.dueDate!.day == now.day;
    }).toList();
    return _filterSearch(list);
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    final list = _tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return false;
      final today = DateTime(now.year, now.month, now.day);
      final taskDate = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return taskDate.isAfter(today);
    }).toList();
    return _filterSearch(list);
  }

  List<Task> get completedTasks {
    final list = _tasks.where((t) => t.isCompleted).toList();
    return _filterSearch(list);
  }

  int get weeklyEfficiency {
    final now = DateTime.now();
    final last7Days = _tasks.where((t) => t.isCompleted && now.difference(t.createdAt).inDays <= 7).length;
    final previous7Days = _tasks.where((t) => t.isCompleted && now.difference(t.createdAt).inDays > 7 && now.difference(t.createdAt).inDays <= 14).length;

    if (previous7Days == 0) {
      return last7Days > 0 ? 100 : 0;
    }

    return (((last7Days - previous7Days) / previous7Days) * 100).round();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.readAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task, {bool saveAction = true}) async {
    await DatabaseHelper.instance.create(task);
    _tasks.insert(0, task);

    if (saveAction) {
      _undoStack.add(TaskAction(type: 'add', task: task));
      _redoStack.clear(); // Clear redo on new action
    }
    notifyListeners();
  }

  Future<void> updateTask(Task task, {bool saveAction = true, Task? oldTask}) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final old = _tasks[index];
      await DatabaseHelper.instance.update(task);
      _tasks[index] = task;

      if (saveAction) {
        _undoStack.add(TaskAction(type: 'update', task: task, oldTask: oldTask ?? old));
        _redoStack.clear();
      }
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id, {bool saveAction = true}) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      await DatabaseHelper.instance.delete(id);
      _tasks.removeAt(index);

      if (saveAction) {
        _undoStack.add(TaskAction(type: 'delete', task: task));
        _redoStack.clear();
      }
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask, oldTask: task);
    }
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  Future<void> undo() async {
    if (_undoStack.isEmpty) return;

    final action = _undoStack.removeLast();
    _redoStack.add(action);

    switch (action.type) {
      case 'add':
        await deleteTask(action.task.id, saveAction: false);
        break;
      case 'update':
        if (action.oldTask != null) {
          await updateTask(action.oldTask!, saveAction: false);
        }
        break;
      case 'delete':
        await addTask(action.task, saveAction: false);
        break;
    }
  }

  Future<void> redo() async {
    if (_redoStack.isEmpty) return;

    final action = _redoStack.removeLast();
    _undoStack.add(action);

    switch (action.type) {
      case 'add':
        await addTask(action.task, saveAction: false);
        break;
      case 'update':
        await updateTask(action.task, saveAction: false);
        break;
      case 'delete':
        await deleteTask(action.task.id, saveAction: false);
        break;
    }
  }
}
