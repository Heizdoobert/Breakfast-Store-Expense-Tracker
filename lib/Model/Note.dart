class Note {
  int? id;
  String title;
  String content;
  String category;
  String priority;
  DateTime createdAt;
  DateTime? updatedAt;
  int? userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.userId,
  });

  // Chuyển đổi từ Map sang Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      userId: map['user_id'],
    );
  }

  // Chuyển đổi từ Note sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
    };
  }
}