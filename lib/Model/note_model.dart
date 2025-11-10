// G:/Project/Breakfast-Store-Expense-Tracker/lib/Model/note_model.dart.

class Note {
  final int id;
  final String userId;
  final String? title;
  final String content;
  // SỬA ĐỔI 1: Giả sử category và priority trong CSDL là số (int)
  final int category;
  final int priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.userId,
    this.title, // `title` có thể null nên không cần `required`
    required this.content,
    required this.category,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // Updated to use snake_case for Supabase compatibility
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      userId: json['user_id'] as String,

      // SỬA ĐỔI 2: Xử lý an toàn cho các trường có thể null
      title: json['title'] as String?, // Cho phép giá trị null
      content: json['content'] as String? ??
          '', // Nếu content là null, trả về chuỗi rỗng

      // SỬA ĐỔI 3 (QUAN TRỌNG NHẤT): Sửa kiểu dữ liệu để khớp với CSDL
      // Ép kiểu 'category' và 'priority' thành int, nếu null thì gán giá trị mặc định (ví dụ: 0)
      category: json['category'] as int? ?? 0,
      priority: json['priority'] as int? ?? 0,

      isCompleted:
          json['is_completed'] as bool? ?? false, // Xử lý an toàn cho bool

      // Xử lý an toàn cho DateTime, phòng trường hợp CSDL trả về null
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  // Phương thức toJson không cần sửa nếu bạn không có ý định gửi category/priority dạng số lên server
  // Nhưng để đồng bộ, nên sửa cả toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category, // Gửi đi dưới dạng int
      'priority': priority, // Gửi đi dưới dạng int
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
