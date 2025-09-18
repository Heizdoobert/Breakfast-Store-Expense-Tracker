class User{
  final int? user_id;
  final String? username;
  final String? email;
  final String? password_hash;
  final String? full_name;
  final String? role;
  final DateTime? created_at;
  final DateTime? updated_at;

  User(
  {
    this.user_id,
    this.username,
    this.email,
    this.password_hash,
    this.full_name,
    this.role,
    this.created_at,
    this.updated_at,
  });

  //chuyen doi thanh map
  factory User.fromMap(Map<String, dynamic> map){
   return User(
       user_id: map['user_id'],
       username: map['username'],
       email: map['email'],
       password_hash: map['password_hash'],
       full_name: map['full_name'],
       role: map['role'],
       created_at: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
       updated_at: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
   );
  }

  //chuyen tu map sang sqlite
  Map<String, dynamic> toMap(){
    return {
      'user_id': user_id,
      'username': username,
      'email': email,
      'password_hash': password_hash,
      'full_name': full_name,
      'role': role,
    };
  }
}

extension UserRole on User {
  bool isOwner() => role == 'owner';
  bool isManager() => role == 'manager';
  bool isStaff() => role == 'staff';
  bool isKitchen() => role == 'kitchen';
}