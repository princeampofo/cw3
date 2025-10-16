import 'package:flutter/foundation.dart';
import 'task_model.dart';
import 'database_helper.dart';

// Service layer to handle task-related operations
class TaskService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Add a new task
  Future<Task> addTask(String name, String priority) async {
    Task newTask = Task(
      name: name,
      priority: priority,
      isCompleted: false,
    );
    
    int id = await _databaseHelper.insertTask(newTask);
    debugPrint('Inserted task with id: $id');
    return newTask.copyWith(id: id);
  }

  // Get all tasks from database
  Future<List<Task>> getAllTasks() async {
    debugPrint('Fetching all tasks from database');
    return await _databaseHelper.getAllTasks();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(Task task) async {
    Task updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    debugPrint('Toggling task completion for task id: ${task.id}');
    await _databaseHelper.updateTask(updatedTask);
  }

  // Update task priority
  Future<void> updateTaskPriority(Task task, String newPriority) async {
    Task updatedTask = task.copyWith(priority: newPriority);
    debugPrint('Updating task priority for task id: ${task.id} to $newPriority');
    await _databaseHelper.updateTask(updatedTask);
  }

  // Delete a task
  Future<void> deleteTask(int taskId) async {
    debugPrint('Deleting task with id: $taskId');
    await _databaseHelper.deleteTask(taskId);
  }

  // Sort tasks by priority (High > Medium > Low)
  List<Task> sortTasksByPriority(List<Task> tasks) {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) {
      int priorityA = _getPriorityValue(a.priority);
      int priorityB = _getPriorityValue(b.priority);
      return priorityB.compareTo(priorityA); // Descending order
    });
    debugPrint('Sorted tasks by priority');
    return sortedTasks;
  }

  // Helper method to convert priority string to numeric value
  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
        return 1;
      default:
        return 2;
    }
  }
}
