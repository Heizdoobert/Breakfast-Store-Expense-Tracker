class User {
  final int? userId;
  final String? userName;
  final String? email;
  final String? passwordHash;
  final String? fullName;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.userId,
    required this.userName,
    this.email,
    this.fullName,
    required this.passwordHash,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  //chuyen doi thanh map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['id'],
      userName: map['userName'],
      email: map['email'],
      passwordHash: map['passwordHash'],
      fullName: map['fullName'],
      role: map['role'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  int? get id => userId;

  //chuyen tu map sang sqlite
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  //validation logic
  bool get isValidUsername => userName!.length >= 4;
  bool get isValidPassword => passwordHash!.length >= 6;
  bool get isValidEmail => email!.contains('@');
  bool get isValidFullName => fullName!.isNotEmpty;

  bool get isOwner => role == 'owner';
  bool get isKitchen => role == 'kitchen';
  bool get isManager => role == 'manager';
  bool get isStaff => role == 'staff';

  //caculate dynamic
  int get accountAgeInDays => DateTime.now().difference(createdAt!).inDays;
  bool get isNewUser => accountAgeInDays < 30;

  //make a copy
  User copyWith({
    int? userId,
    String? userName,
    String? email,
    String? passwordHash,
    String? fullName,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.userId == userId &&
        other.userName == userName &&
        other.email == email &&
        other.passwordHash == passwordHash &&
        other.fullName == fullName &&
        other.role == role &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        passwordHash.hashCode ^
        fullName.hashCode ^
        role.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'User('
        'userId: $userId, '
        'userName: $userName, '
        'email: $email, '
        'passwordHash: $passwordHash, '
        'fullName: $fullName, '
        'role: $role, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}


//se phat trien role sau
