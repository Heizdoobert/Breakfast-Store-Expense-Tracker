class SavingPlan{
  final int? plan_id;
  final int? user_id;
  final String? goal;
  final double? target_amount;
  final double? current_amount;
  final DateTime? deadline;

  SavingPlan({
    this.plan_id,
    this.user_id,
    this.goal,
    this.target_amount,
    this.current_amount,
    this.deadline,
  });

  //mapping
 factory SavingPlan.fromMap(Map<String, dynamic> map){
   return SavingPlan(
     plan_id: map['plan_id'],
     user_id: map['user_id'],
     goal: map['goal'],
     target_amount: map['target_amount'],
     current_amount: map['current_amount'],
   );
 }

 //mapping->sql
 Map<String, dynamic> toMap(){
   return {
     'plan_id': plan_id,
     'user_id': user_id,
     'goal': goal,
     'target_amount': target_amount,
     'current_amount': current_amount,
     'deadline': deadline,
   };
 }
}