class SavingPlan {
  final String id;
  final String groupId;
  final String targetAmount;
  final double savedAmount;
  final DateTime deadline;

  SavingPlan({
    required this.id,
    required this.groupId,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  factory SavingPlan.fromJson(Map<String, dynamic> json) {
    return SavingPlan(
      id: json['id'],
      groupId: json['groupId'],
      targetAmount: json['targetAmount'],
      savedAmount: json['savedAmount'],
      deadline: DateTime.parse(json['deadline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
    };
  }
}
