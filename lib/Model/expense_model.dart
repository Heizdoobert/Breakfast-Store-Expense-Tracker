class Expense {
  final String id;
  final String groupId;
  final String userId;
  final double amount;
  final String? description;
  final DateTime createdAt;
  final String category;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    this.description,
    required this.createdAt,
    required this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'].toString(),
      groupId: json['group_id'].toString(),
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'amount': amount,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'category': category,
    };
  }

  Expense copyWith({
    String? id,
    String? groupId,
    String? userId,
    double? amount,
    String? description,
    DateTime? createdAt,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}
