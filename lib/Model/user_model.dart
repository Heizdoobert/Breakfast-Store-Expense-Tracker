class User {
  final String? id;
  final String? email;
  final String? userName;
  final String? passwordHash;
  final String? fullName;
  final String? role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.userName,
    required this.passwordHash,
    required this.fullName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// tao tu supabase json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? 'Khong email',
      userName: json['userName'] ?? 'Khong userName',
      passwordHash: json['passwordHash'] ?? 'Khong passwordHash',
      fullName: json['fullName'] ?? 'Khong fullName',
      role: json['role'] ?? 'Khong role',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  ///chuyen san json de tao CRUD
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
