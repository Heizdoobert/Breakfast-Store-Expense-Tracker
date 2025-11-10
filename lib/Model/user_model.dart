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
  //cac truong khong quan trong (có thể null)
  final String? userName;
  final String? fullName;

  // SỬA ĐỔI 2: Bỏ 'required' cho các trường nullable
  User({
    required this.id,
    required this.email,
    this.userName, // Bỏ required
    this.fullName, // Bỏ required
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// tao tu supabase json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? 'no-email@example.com',
      // SỬA ĐỔI 3: Đảm bảo role không bao giờ null trong model
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

  ///chuyen sang json de tao CRUD
  Map<String, dynamic> toJson() {
    // SỬA ĐỔI 1 (QUAN TRỌNG NHẤT): Sử dụng snake_case để gửi dữ liệu lên Supabase
    return {
      // 'id' thường không cần gửi khi cập nhật, nhưng để đây cũng không sao
      // 'email' và 'role' cũng có thể được cập nhật ở đây
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'role': role,
      // created_at và updated_at thường do CSDL tự quản lý, không cần gửi lên
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
