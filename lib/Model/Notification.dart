class Notification{
  final int? notification_id;
  final int? user_id;
  final String? message;
  final String? type;
  final bool? is_read;
  final DateTime? created_at;

  Notification({
    this.notification_id,
    this.user_id,
    this.message,
    this.type,
    this.is_read,
    this.created_at,
  });

  //mapping
  factory Notification.fromMap(Map<String, dynamic> map){
    return Notification(
      notification_id: map['notification_id'],
      user_id: map['user_id'],
      message: map['message'],
      type: map['type'],
      is_read: map['is_read'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap() {
    return {
      'notification_id': notification_id,
      'user_id': user_id,
      'message': message,
      'type': type,
      'is_read': is_read,
    };
  }
}