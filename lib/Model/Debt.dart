class Debt{
  final int? debt_id;
  final int? user_id;
  final String? lender;
  final double? amount;
  final String? due_date;
  final String? status;

  Debt({
    this.debt_id,
    this.user_id,
    this.lender,
    this.amount,
    this.due_date,
    this.status,
  });

  //mapping
  factory Debt.fromMap(Map<String, dynamic> map){
    return Debt(
      debt_id: map['debt_id'],
      user_id: map['user_id'],
      lender: map['lender'],
      amount: map['amount'],
      due_date: map['due_date'],
      status: map['status'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap(){
    return {
      'debt_id': debt_id,
      'user_id': user_id,
      'lender': lender,
      'amount': amount,
      'due_date': due_date,
      'status': status,
    };
  }
}