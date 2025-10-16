import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'theme_service.dart';
import 'database_service.dart';
import 'task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;

  // test all database service methods
  Future<void> _testDatabaseService() async {
    TaskService taskService = TaskService();
    // Add a new task
    Task task1 = await taskService.addTask('Test Task 1', 'High');
    Task task2 = await taskService.addTask('Test Task 2', 'Low');
    // Get all tasks
    List<Task> tasks = await taskService.getAllTasks();
    debugPrint('All Tasks: $tasks');
    // Toggle completion
    await taskService.toggleTaskCompletion(task1);
    // Update priority
    await taskService.updateTaskPriority(task2, 'Medium');
    // Delete a task
    await taskService.deleteTask(task1.id!);
    // Get all tasks again
    tasks = await taskService.getAllTasks();
    debugPrint('All Tasks after operations: $tasks');
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _testDatabaseService(); // Call the test function
  }

  // Load saved theme preferences
  Future<void> _loadTheme() async {
    bool isDark = await _themeService.getThemePreference();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  // Handle theme change
  void _handleThemeChange(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TaskListScreen(onThemeChanged: _handleThemeChange),
    );
  }
}
