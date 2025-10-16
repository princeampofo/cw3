import 'package:flutter/material.dart';
import 'theme_service.dart';
import 'add_task_dialog.dart';
import 'database_service.dart';
import 'task_item.dart';
import 'task_model.dart';


// Main screen for displaying and managing tasks
class TaskListScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const TaskListScreen({super.key, required this.onThemeChanged});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadTasks();
  }

  // Load theme preference
  Future<void> _loadThemePreference() async {
    bool isDark = await _themeService.getThemePreference();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  // Toggle theme
  Future<void> _toggleTheme() async {
    bool newThemeValue = !_isDarkMode;
    await _themeService.saveThemePreference(newThemeValue);
    setState(() {
      _isDarkMode = newThemeValue;
    });
    widget.onThemeChanged(newThemeValue);
  }

  // Load all tasks from database
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    List<Task> tasks = await _taskService.getAllTasks();
    List<Task> sortedTasks = _taskService.sortTasksByPriority(tasks);

    setState(() {
      _tasks = sortedTasks;
      _isLoading = false;
    });
  }

  // Add a new task(reload tasks after adding to get updated list)
  Future<void> _addTask(String name, String priority) async {
    await _taskService.addTask(name, priority);
    await _loadTasks();
  }

  // Toggle task completion(reload tasks after toggling to get updated list)
  Future<void> _toggleTaskCompletion(Task task) async {
    await _taskService.toggleTaskCompletion(task);
    await _loadTasks(); 
  }

  // Delete a task(reload tasks after deleting to get updated list)
  Future<void> _deleteTask(int taskId) async {
    await _taskService.deleteTask(taskId);
    await _loadTasks();
  }

  // Update task priority (reload tasks after updating to get updated list)
  Future<void> _updateTaskPriority(Task task, String newPriority) async {
    await _taskService.updateTaskPriority(task, newPriority);
    await _loadTasks();
  }

  // Show add task dialog
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: _addTask,
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks yet!\nTap + to add a new task',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: _tasks[index],
                      onToggleComplete: _toggleTaskCompletion,
                      onDelete: _deleteTask,
                      onPriorityChanged: _updateTaskPriority,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
