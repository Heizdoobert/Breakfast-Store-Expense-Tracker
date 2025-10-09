///model nguoi dung
///tai day la lop trung gian de giao tiep giua service va database
///lop nay se dung de dua du lieu tu controller vao de giao tiep voi db
class User {
  //cac truong quan trong khong null
  final String id;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  //cac truong khong quan trong
  final String? userName;
  final String? fullName;

  User({
    required this.id,
    required this.email,
    required this.userName,
    required this.fullName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// tao tu supabase json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? 'no-email@example.com',
      role: json['role'] as String? ?? 'staff',
      userName: json['user_name'] as String?,
      fullName: json['full_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  ///chuyen san json de tao CRUD
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? role,
    String? email,
    String? userName,
    String? fullName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
