// Task Model for db
// Every task has an id, name, isCompleted, priority. By default, isCompleted is false and priority is 'Medium'.
class Task {
  int? id; 
  String name;  
  bool isCompleted; 
  String priority; 

  Task({
    this.id,
    required this.name,
    this.isCompleted = false, 
    this.priority = 'Medium', 
  });

  // Convert Task to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
    };
  }

  // Create Task from Map (from database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      isCompleted: map['isCompleted'] == 1,
      priority: map['priority'],
    );
  }

  // Modifying tasks with field changes (for marking complete, changing priority, etc.)
  Task copyWith({
    int? id,
    String? name,
    bool? isCompleted,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}