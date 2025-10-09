class Debt {
  final String id;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final bool isSettled;

  Debt({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.isSettled,
  });

  factory Debt.fromJson(Map<String, dynamic> json){
    return Debt(
      id: json['id'].toString(),
      fromUserId: json['from_user_id'] as String,
      toUserId: json['to_user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      isSettled: json['is_settled'] as bool,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'amount': amount,
      'is_settled': isSettled,
    };
  }

  Debt copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    double? amount,
    bool? isSettled,
  }) {
    return Debt(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      amount: amount ?? this.amount,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}