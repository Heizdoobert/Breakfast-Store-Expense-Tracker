class Expense {
  final String id;
  final String groupId;
  final String userId;
  final double amount;
  final String description;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json){
    return Expense(
      id: json['id'],
      groupId: json['groupId'],
      userId: json['userId'],
      amount: json['amount'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}