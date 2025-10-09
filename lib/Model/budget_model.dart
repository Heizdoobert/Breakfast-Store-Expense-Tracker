class Budget {
  final String id;
  final String groupId;
  final double amount;
  final int month;
  final int year;

  Budget({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.month,
    required this.year,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'].toString(),
      groupId: json['groupId'].toString(),
      amount: (json['amount'] as num).toDouble(),
      month: json['month'] as int,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }

  Budget copyWith({
    String? id,
    String? groupId,
    double? amount,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
