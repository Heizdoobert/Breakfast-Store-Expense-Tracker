
class Expense {
  final int? expense_id;
  final int? user_id;
  final int? group_id;
  final String? title;
  final double? amount;
  final String? category;
  final DateTime? created_at;

  Expense(
  {
    this.expense_id,
    this.user_id,
    this.group_id,
    this.title,
    this.amount,
    this.category,
    this.created_at,
  });

  //mapping
  factory Expense.fromMap(Map<String, dynamic> map){
    return Expense(
      expense_id: map['expense_id'],
      user_id: map['user_id'],
      group_id: map['group_id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      created_at: map['created_at'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap(){
    return {
      'expense_id': expense_id,
      'user_id': user_id,
      'group_id': group_id,
      'title': title,
      'amount': amount,
      'category': category,
      'created_at': created_at,
    };
  }
}