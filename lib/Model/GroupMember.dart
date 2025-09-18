import 'package:flutter/foundation.dart';

class GroupMember {
  final int? group_member_id;
  final int? group_id;
  final int? user_id;
  final DateTime? created_at;
  final DateTime? updated_at;

  GroupMember(
  {
    this.group_member_id,
    this.group_id,
    this.user_id,
    this.created_at,
    this.updated_at,
  });

  //mapping
  factory GroupMember.fromMap(Map<String, dynamic> map){
    return GroupMember(
      group_member_id: map['group_member_id'],
      group_id: map['group_id'],
      user_id: map['user_id'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap() {
    return {
      'group_member_id': group_member_id,
      'group_id': group_id,
      'user_id': user_id,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}