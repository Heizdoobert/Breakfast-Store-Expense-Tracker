
class Expense {
  final int? expenseId;
  final int? userId;
  final int? groupId;
  final String? title;
  final double? amount;
  final String? category;
  final DateTime? createdAt;

  Expense(
  {
    this.expenseId,
    this.userId,
    this.groupId,
    this.title,
    this.amount,
    this.category,
    this.createdAt,
  });

  //mapping
  factory Expense.fromMap(Map<String, dynamic> map){
    print('[Expense.fromMap] Map nhan duoc: $map');
    return Expense(
      expenseId: map['expenseId'],
      userId: map['userId'],
      groupId: map['groupId'],
      title: map['title'],
      amount: map['amount'] is int ? map['amount'].toDouble() : map['amount'],
      category: map['category'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap(){
    return {
      'expenseId': expenseId,
      'userId': userId,
      'groupId': groupId,
      'title': title,
      'amount': amount,
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}