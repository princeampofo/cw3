import 'package:flutter/material.dart';

// Dialog widget for adding new tasks
class AddTaskDialog extends StatefulWidget {
  final Function(String, String) onAddTask;

  const AddTaskDialog({super.key, required this.onAddTask});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Medium';

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    String taskName = _taskController.text.trim();
    if (taskName.isNotEmpty) {
      widget.onAddTask(taskName, _selectedPriority);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Priority: '),
              SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedPriority,
                  isExpanded: true,
                  items: ['High', 'Medium', 'Low'].map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: priority == 'High'
                                ? Colors.red
                                : priority == 'Medium'
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(priority),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedPriority = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAddTask,
          child: Text('Add'),
        ),
      ],
    );
  }
}
