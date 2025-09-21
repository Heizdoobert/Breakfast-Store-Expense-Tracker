// lib/Model/Note.dart
class Note {
  int? id;
  int? userId;
  String title;
  String content;
  String category;
  String priority;
  DateTime createdAt;
  DateTime updatedAt;
  int isCompleted;

  Note({
    this.id,
    this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = 0,
  });

  // Chuyển đổi từ Map sang Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isCompleted: map['is_completed'] ?? 0,
    );
  }

  // Chuyển đổi từ Note sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_completed': isCompleted,
    };
  }
}