class Expense {
  final String id;
  final String groupId;
  final String userId;
  final double amount;
  final String? description;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'].toString(),
      groupId: json['group_id'].toString(),
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'group_id': groupId,
      'user_id': userId,
      'amount': amount,
      'description': description,
    };
  }

  Expense copyWith({
    String? id,
    String? groupId,
    String? userId,
    double? amount,
    String? description,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}