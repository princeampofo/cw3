import 'package:flutter/material.dart';
import 'theme_service.dart';
import 'add_task_dialog.dart';


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

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
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

  // Show add task dialog
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(onAddTask: (name, priority) {
        // we will set up adding task later
      }),
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
      body: Center(
                  child: Text(
          'No tasks yet!\nTap + to add a new task',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
