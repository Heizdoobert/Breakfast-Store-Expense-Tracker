class Budget{
  final int? budget_id;
  final int? user_id;
  final int? group_id;
  final String? category;
  final double? limit_amount;
  final DateTime? start_date;
  final DateTime? end_date;
  final DateTime? created_at;

  Budget({
    this.budget_id,
    this.user_id,
    this.group_id,
    this.category,
    this.limit_amount,
    this.start_date,
    this.end_date,
    this.created_at,
  });

  //mapping
  factory Budget.fromMap(Map<String, dynamic> map){
    return Budget(
      budget_id: map['budget_id'],
      user_id: map['user_id'],
      group_id: map['group_id'],
      category: map['category'],
      limit_amount: map['limit_amount'],
      start_date: map['start_date'],
      end_date: map['end_date'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap(){
    return {
      'budget_id': budget_id,
      'user_id': user_id,
      'group_id': group_id,
      'category': category,
      'limit_amount': limit_amount,
      'start_date': start_date,
      'end_date': end_date,
    };
  }
}