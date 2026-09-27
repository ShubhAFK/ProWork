enum GoalPriority {
  low,
  medium,
  high,
  urgent,
}

class GoalCheckItem {
  final String id;
  final String title;
  final bool isCompleted;

  GoalCheckItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  GoalCheckItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return GoalCheckItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory GoalCheckItem.fromJson(Map<String, dynamic> json) {
    return GoalCheckItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final GoalPriority priority;
  final List<GoalCheckItem> checklist;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    this.priority = GoalPriority.high,
    List<GoalCheckItem>? checklist,
  }) : checklist = checklist ?? [];

  double get completionRatio {
    if (checklist.isEmpty) return 0.0;
    final done = checklist.where((item) => item.isCompleted).length;
    return done / checklist.length;
  }

  int get completedCount => checklist.where((item) => item.isCompleted).length;
  int get totalChecklistItems => checklist.length;

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
    GoalPriority? priority,
    List<GoalCheckItem>? checklist,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      priority: priority ?? this.priority,
      checklist: checklist ?? List.from(this.checklist),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.toIso8601String(),
      'priority': priority.name,
      'checklist': checklist.map((i) => i.toJson()).toList(),
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      targetDate: DateTime.parse(json['targetDate'] as String),
      priority: GoalPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => GoalPriority.high,
      ),
      checklist: (json['checklist'] as List<dynamic>?)
              ?.map((i) => GoalCheckItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
