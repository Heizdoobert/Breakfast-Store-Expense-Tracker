// Path: lib/Model/group_model.dart

import 'package:equatable/equatable.dart'; // Thêm equatable để tốt hơn (tùy chọn)

class Group extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Nhóm không tên',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Group copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt];
}
