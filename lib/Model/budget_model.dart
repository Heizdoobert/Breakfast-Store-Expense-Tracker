class Budget {
  final String id;
  final String groupId;
  final String amount;
  final String month;
  final String year;

  Budget({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.month,
    required this.year,
  });

  factory Budget.fromJson(Map<String, dynamic> json){
    return Budget(
      id: json['id'],
      groupId: json['groupId'],
      amount: json['amount'],
      month: json['month'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'groupId': groupId,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }
}