import 'package:flutter/material.dart';
import 'task_model.dart';

// Widget to display a single task item
class TaskItem extends StatelessWidget {
  final Task task;
  final Function(Task) onToggleComplete;
  final Function(int) onDelete;
  final Function(Task, String) onPriorityChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onPriorityChanged,
  });

  // Get color based on priority
  Color _getPriorityColor() {
    switch (task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            onToggleComplete(task);
          },
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.flag,
              size: 16,
              color: _getPriorityColor(),
            ),
            SizedBox(width: 4),
            Text(
              task.priority,
              style: TextStyle(color: _getPriorityColor()),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Priority dropdown
            DropdownButton<String>(
              value: task.priority,
              underline: SizedBox(),
              items: ['High', 'Medium', 'Low'].map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (String? newPriority) {
                if (newPriority != null) {
                  onPriorityChanged(task, newPriority);
                }
              },
            ),
            // Delete button
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onDelete(task.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
