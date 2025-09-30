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
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      amount: json['amount'],
      isSettled: json['isSettled'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'isSettled': isSettled,
    };
  }
}