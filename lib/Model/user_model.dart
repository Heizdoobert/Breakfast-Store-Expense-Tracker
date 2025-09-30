class User {
  final String id;
  final String email;
  final String userName;
  final String passwordHash;
  final String fullName;
  final String role;
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
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
      passwordHash: json['passwordHash'],
      fullName: json['fullName'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
