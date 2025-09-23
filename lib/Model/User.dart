class User {
  final int? user_id;
  final String? username;
  final String? email;
  final String? password_hash;
  final String? full_name;
  final String? role;
  final DateTime? created_at;
  final DateTime? updated_at;

  User({
    this.user_id,
    this.username,
    this.email,
    this.full_name,
    this.password_hash,
    this.role,
    this.created_at,
    this.updated_at,
  });

  //chuyen doi thanh map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id'],
      username: map['username'],
      email: map['email'],
      password_hash: map['password_hash'],
      full_name: map['full_name'],
      role: map['role'],
      created_at: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updated_at: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  get id => null;

  //chuyen tu map sang sqlite
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'email': email,
      'password_hash': password_hash,
      'full_name': full_name,
      'role': role,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }

  //validation logic
  bool get isValidUsername => username!.length >= 4;
  bool get isValidPassword => password_hash!.length >= 6;
  bool get isValidEmail => email!.contains('@');
  bool get isValidFullName => full_name!.isNotEmpty;

  //caculate dynamic
  int get accountAgeInDays => DateTime.now().difference(created_at!).inDays;
  bool get isNewUser => accountAgeInDays < 30;

  //make a copy
  User copyWith({
    int? user_id,
    String? username,
    String? email,
    String? password_hash,
    String? full_name,
    String? role,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return User(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
      email: email ?? this.email,
      password_hash: password_hash ?? this.password_hash,
      full_name: full_name ?? this.full_name,
      role: role ?? this.role,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.user_id == user_id &&
        other.username == username &&
        other.email == email &&
        other.password_hash == password_hash &&
        other.full_name == full_name &&
        other.role == role &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return user_id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password_hash.hashCode ^
        full_name.hashCode ^
        role.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }

  @override
  String toString() {
    return 'User('
        'user_id: $user_id, '
        'username: $username, '
        'email: $email, '
        'password_hash: $password_hash, '
        'full_name: $full_name, '
        'role: $role, '
        'created_at: $created_at, '
        'updated_at: $updated_at)';
  }
}

extension UserRole on User {
  bool isOwner() => role == 'owner';
  bool isManager() => role == 'manager';
  bool isStaff() => role == 'staff';
  bool isKitchen() => role == 'kitchen';
}
